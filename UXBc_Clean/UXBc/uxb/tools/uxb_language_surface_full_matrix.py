#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from __future__ import annotations
import csv,json,re
from pathlib import Path
from typing import Iterable,List,Dict,Any
LAYER_SPECS={
"lexer":["uxb/src/parser/lexer","uxb/src/parser/token_kinds.fbs","uxb/src/parser/lexer.fbs"],
"parser":["uxb/src/parser/parser","uxb/src/parser/parser.fbs"],"ast":["uxb/src/parser/ast.fbs","uxb/src/parser/ast_contract.fbs"],"semantic":["uxb/src/semantic"],"hir":["uxb/src/semantic/hir.fbs"],"mir":["uxb/src/semantic/mir.fbs","uxb/src/semantic/mir_model.fbs","uxb/src/semantic/mir_lower_expr.fbs","uxb/src/semantic/mir_lower_stmt.fbs"],"ast_interpreter":["uxb/src/runtime/memory_exec.fbs","uxb/src/runtime/exec"],"mir_interpreter":["uxb/src/semantic/mir_evaluator.fbs","uxb/src/semantic/mir_evaluator"],"x64_ast":["uxb/src/codegen/x64/code_generator.fbs","uxb/src/codegen/x64/stmt_emitters","uxb/src/codegen/x64/helpers","uxb/src/codegen/x64/x64_extfp_call_emit.fbs"],"x64_mir":["uxb/src/codegen/x64/mir_x64_codegen.fbs","uxb/src/codegen/x64/mir_x64_capability.fbs","uxb/src/codegen/x64/mir_x64_arrays.fbs","uxb/src/codegen/x64/mir_x64_builtins.fbs","uxb/src/codegen/x64/mir_x64_fp64.fbs","uxb/src/codegen/x64/mir_x64_field_synthetic.fbs"],"runtime":["uxb/src/runtime","uxb/runtime_ext"],"ffi":["uxb/src/codegen/x64/ffi_call_backend.fbs","uxb/src/codegen/x86/ffi_call_backend.fbs","uxb/src/build/interop_manifest.fbs","uxb/src/runtime/exec/exec_ffi_runtime.fbs"],"js_transpiler":["uxb/src/codegen/js","uxb/tools/uxb_json_to_js.py","uxb/tools/uxb_browser_build.py"],"wasm_emitter":["uxb/src/codegen/wasm","uxb/tools/uxb_json_to_wasm.py"],"browser_runtime":["uxb/runtime/browser"],"tests":["uxb/tests","tests"],"docs":["uxb/docs","docs","README.md"]}
STATIC_OPERATORS=["=","+","-","*","/","\\","%","**","&","|","^","~","!","@","==","<>","!=","<",">","<=",">=","<<",">>","+=","-=","*=","/=","\\=","%=","&=","|=","^=","<<=",">>=","AND","OR","XOR","NOT","MOD","SHL","SHR","ROL","ROR","IS","IN"]
STATIC_TYPE_SEEDS=["BOOLEAN","BYTE","STRING","I8","U8","I16","U16","I32","U32","I64","U64","F32","F64","F80","F128","BIGF","BIGD","BALL","PTR","LPTR","STRPTR","OBJECT"]
STATIC_DATA_STRUCTURES=["ARRAY","LIST","DICT","SET","TYPE","CLASS","INTERFACE","MODULE","NAMESPACE"]
STATIC_FFI=["DECLARE","CALL","CALL DLL","CALL API","IMPORT","INLINE","CDECL","STDCALL","WIN64_ABI","CODEPTR","VARPTR","SADD"]

def root(start=Path('.')):
 p=start.resolve()
 for c in [p]+list(p.parents):
  if (c/'uxb/src').is_dir(): return c
 raise SystemExit('UXBc root not found')
def rd(p):
 try: return p.read_text(encoding='utf-8',errors='ignore')
 except Exception:
  try: return p.read_text(encoding='cp1254',errors='ignore')
  except Exception: return ''
def files(r,specs):
 out=[]
 for spec in specs:
  p=r/spec
  if p.is_file(): out.append(p)
  elif p.is_dir():
   for q in p.rglob('*'):
    if q.is_file() and q.suffix.lower() in {'.fbs','.bas','.bi','.c','.h','.py','.ts','.js','.json','.md','.txt','.bat','.uxb','.expect'}: out.append(q)
 return out
def extract_keywords(r):
 found={}
 for p in [r/'uxb/src/parser/lexer/lexer_keyword_table.fbs',r/'uxb/src/parser/token_kinds.fbs']:
  if not p.exists(): continue
  t=rd(p)
  for m in re.finditer(r'"([A-Za-z_][A-Za-z0-9_]*)"\s*,?\s*(TK_[A-Za-z0-9_]+|TOKEN_[A-Za-z0-9_]+)?',t):
   kw=m.group(1).upper(); found.setdefault(kw,{'name':kw,'token':(m.group(2) or '').upper(),'kind':'keyword','category':'keyword'})
  for m in re.finditer(r'\b(TK|TOKEN)_([A-Z][A-Z0-9_]*)\b',t):
   kw=m.group(2).upper()
   if kw not in {'EOF','IDENT','NUMBER','STRING','NEWLINE','UNKNOWN','OP'}: found.setdefault(kw,{'name':kw,'token':m.group(0).upper(),'kind':'keyword','category':'keyword'})
 return [found[k] for k in sorted(found)]
def extract_mir_ops(r):
 ops={}; p=r/'uxb/src/semantic/mir_model.fbs'; t=rd(p)
 for m in re.finditer(r'Const\s+(MIR_OP_[A-Za-z0-9_]+)\s+As\s+String\s*=\s*"([A-Za-z0-9_]+)"',t,re.I): ops[m.group(2).upper()]={'name':m.group(2).upper(),'token':m.group(1),'kind':'mir_opcode','category':'mir'}
 for p in [r/'uxb/src/codegen/x64/mir_x64_capability.fbs',r/'uxb/src/codegen/x64/mir_x64_codegen.fbs']:
  t=rd(p)
  for m in re.finditer(r'"([A-Z][A-Z0-9_]{1,})"',t):
   s=m.group(1).upper()
   if '_' in s or s in {'ADD','SUB','MUL','DIV','MOD','NEG','CALL','RET','JMP','JZ','JNZ','LABEL'}: ops.setdefault(s,{'name':s,'token':'','kind':'mir_opcode','category':'mir'})
 return [ops[k] for k in sorted(ops)]
def extract_builtins(r):
 names={}; pats=r'\b(ABS|SGN|INT|FIX|CINT|CLNG|CSNG|CDBL|LEN|ASC|VAL|STR|CHR|SPACE|MID|LEFT|RIGHT|INSTR|LCASE|UCASE|LTRIM|RTRIM|SIN|COS|TAN|ATN|EXP|LOG|SQR|SQRT|RND|TIMER|GETKEY|INKEY|EOF|LOF|SIZEOF|OFFSETOF)\b'
 for spec in ['uxb/src/runtime/exec/exec_eval_builtin_categories.fbs','uxb/src/codegen/x64/helpers/x64_codegen_builtin_support_helpers.fbs','uxb/src/codegen/x64/mir_x64_builtins.fbs']:
  t=rd(r/spec)
  for m in re.finditer(pats,t,re.I): names[m.group(1).upper()]={'name':m.group(1).upper(),'token':'','kind':'builtin_function','category':'function'}
 return [names[k] for k in sorted(names)]
def items(r):
 seen=set(); out=[]
 def add(it):
  k=(it['kind'],it['name'])
  if k not in seen: seen.add(k); out.append(it)
 for lst in [extract_keywords(r),extract_mir_ops(r),extract_builtins(r),[{'name':op,'token':'','kind':'operator','category':'operator'} for op in STATIC_OPERATORS],[{'name':t,'token':'','kind':'type','category':'type'} for t in STATIC_TYPE_SEEDS],[{'name':d,'token':'','kind':'data_structure','category':'data_structure'} for d in STATIC_DATA_STRUCTURES],[{'name':f,'token':'','kind':'ffi_surface','category':'ffi'} for f in STATIC_FFI]]:
  for it in lst: add(it)
 return sorted(out,key=lambda x:(x['category'],x['kind'],x['name']))
def index_layers(r):
 idx={}
 for layer,spec in LAYER_SPECS.items():
  layer_files=files(r,spec); combined=[]; evid=[]
  for p in layer_files:
   t=rd(p); combined.append(t); evid.append((p,t))
  idx[layer]={'text':'\n'.join(combined).lower(),'files':evid}
 return idx
def patterns_for(name,token):
 if re.match(r'^[A-Za-z_][A-Za-z0-9_]*$',name): pats=[r'\b'+re.escape(name.lower())+r'\b']
 else: pats=[re.escape(name.lower())]
 if token: pats.append(r'\b'+re.escape(token.lower())+r'\b')
 return pats
def layer_status(layer,layerdata,name,token):
 pats=patterns_for(name,token); txt=layerdata['text']
 found=any(re.search(p,txt) for p in pats)
 if not found: return 'missing',[]
 ev=[]
 for p,t in layerdata['files']:
  low=t.lower()
  if any(re.search(pat,low) for pat in pats): ev.append(str(p).replace('\\','/'))
  if len(ev)>=8: break
 window=txt
 diag=any(x in window for x in ['not supported','unsupported','not implemented','diagnostic only','requires runtime','pending'])
 policy=any(x in window for x in ['policy','runtime family','storage_bytes','externalfloat'])
 if diag and layer not in ('lexer','parser','tests'): return 'diagnostic_only',ev
 if policy and layer in ('semantic','runtime','x64_ast','x64_mir'): return 'policy_only',ev
 if len(ev)>=2: return 'implemented',ev
 return 'partial',ev
def main():
 r=root(); outdir=r/'uxb/dist/surface'; outdir.mkdir(parents=True,exist_ok=True)
 idx=index_layers(r); rows=[]; summary={l:{} for l in LAYER_SPECS}
 for it in items(r):
  row={**it,'layers':{},'evidence':{}}
  for layer,data in idx.items():
   st,ev=layer_status(layer,data,it['name'],it.get('token',''))
   row['layers'][layer]=st
   if ev: row['evidence'][layer]=[str(Path(e).relative_to(r)).replace('\\','/') if str(e).startswith(str(r)) else e for e in ev]
   summary[layer][st]=summary[layer].get(st,0)+1
  rows.append(row)
 report={'schema_version':'uxb-language-surface-full-matrix-1','producer':'uXBasiC','item_count':len(rows),'layers':list(LAYER_SPECS),'summary':summary,'items':rows}
 (outdir/'language_surface_full_matrix.json').write_text(json.dumps(report,indent=2,ensure_ascii=False),encoding='utf-8')
 with (outdir/'language_surface_full_matrix.csv').open('w',newline='',encoding='utf-8') as f:
  wr=csv.writer(f); layers=list(LAYER_SPECS); wr.writerow(['category','kind','name','token']+layers)
  for row in rows: wr.writerow([row['category'],row['kind'],row['name'],row.get('token','')]+[row['layers'][l] for l in layers])
 md=['# uXBasiC Full Language Surface Matrix','',f'- item_count: `{len(rows)}`','','## Layer summary']
 for layer,cnt in summary.items(): md.append(f'- **{layer}**: `{cnt}`')
 priority=[row for row in rows if row['category'] in {'keyword','operator','type','data_structure','ffi'} and row['layers'].get('mir') in {'missing','diagnostic_only'}]
 md+=['','## Priority gaps for Copilot Step 2']
 for row in priority[:120]: md.append(f"- `{row['category']}/{row['name']}`: MIR={row['layers'].get('mir')} x64_mir={row['layers'].get('x64_mir')} semantic={row['layers'].get('semantic')}")
 layers=list(LAYER_SPECS); md+=['','## Matrix','| category | kind | name | '+' | '.join(layers)+' |','|---|---|---|'+'|'.join(['---']*len(layers))+'|']
 for row in rows: md.append('| '+row['category']+' | '+row['kind']+' | `'+row['name']+'` | '+' | '.join(row['layers'][l] for l in layers)+' |')
 (outdir/'language_surface_full_matrix.md').write_text('\n'.join(md),encoding='utf-8')
 cp=['# Copilot Step 2 Targets','','Copilot sadece burada görülen eksik sınıflara kod yazacak; yeni mimari icat etmeyecek.','','## Öncelik','1. MIR lowering missing olan keyword/operator/type öğelerini kapat.','2. x64_mir missing olan ama MIR var olan öğeler için emitter ekle.','3. runtime isteyen öğelerde sahte native yazma; runtime helper veya diagnostic ekle.','']
 for row in priority[:80]: cp.append(f"- {row['category']}::{row['name']} => semantic={row['layers'].get('semantic')} mir={row['layers'].get('mir')} x64_mir={row['layers'].get('x64_mir')}")
 (outdir/'copilot_step2_targets.md').write_text('\n'.join(cp),encoding='utf-8')
 print('OUT_JSON=uxb/dist/surface/language_surface_full_matrix.json'); print('OUT_MD=uxb/dist/surface/language_surface_full_matrix.md'); print('OUT_CSV=uxb/dist/surface/language_surface_full_matrix.csv'); print('ITEM_COUNT='+str(len(rows)))
if __name__=='__main__': main()
