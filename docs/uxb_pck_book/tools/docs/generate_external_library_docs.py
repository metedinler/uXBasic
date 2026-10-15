#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""uXBasic dış kütüphane belgelerini libsx wrapper dosyalarından üretir."""
from pathlib import Path
import argparse, re

SIG_RE = re.compile(r'^\s*(?:Public\s+|Private\s+)?(Function|Sub)\s+(.+?)\s*$', re.I|re.M)
NS_RE = re.compile(r'^\s*NAMESPACE\s+(\w+)', re.I|re.M)
CALL_RE = re.compile(r'CALL\s*\(\s*DLL\s*,\s*([^,\)]+)\s*,\s*([^,\)]+)', re.I)

def clean(s): return re.sub(r'\s+', ' ', s.strip())

def parse_signature(kind, rest):
    ret=''; mret=re.search(r'\s+AS\s+([A-Za-z0-9_]+)\s*$', rest, re.I)
    rest2=rest.strip()
    if mret: ret=mret.group(1).upper(); rest2=rest[:mret.start()].strip()
    m=re.match(r'([A-Za-z_][A-Za-z0-9_]*)\s*\((.*)\)\s*$', rest2)
    if not m: return None
    name=m.group(1); raw=m.group(2).strip(); params=[]
    if raw:
        for part in [x.strip() for x in raw.split(',') if x.strip()]:
            mp=re.match(r'(?:BYVAL\s+|BYREF\s+)?([A-Za-z_][A-Za-z0-9_]*)\s+AS\s+([A-Za-z0-9_]+)', part, re.I)
            params.append({'name':mp.group(1), 'type':mp.group(2).upper(), 'raw':part} if mp else {'name':part.split()[0], 'type':'?', 'raw':part})
    return {'kind':kind.upper(), 'name':name, 'params':params, 'return':ret, 'signature':clean(kind.upper()+' '+rest.strip())}

def extract_functions(path):
    text=path.read_text(encoding='utf-8', errors='replace'); ns=NS_RE.findall(text); funs=[]; ms=list(SIG_RE.finditer(text))
    for i,m in enumerate(ms):
        sig=parse_signature(m.group(1), m.group(2))
        if not sig: continue
        body=text[m.end():(ms[i+1].start() if i+1<len(ms) else len(text))]
        call=CALL_RE.search(body); sig['dll']=call.group(1).strip().strip('"') if call else ''; sig['native']=call.group(2).strip().strip('"') if call else ''
        funs.append(sig)
    return ns[0] if ns else '', funs

def category_for_module(module_id):
    m=module_id.lower()
    if 'stats' in m: return 'istatistik, hipotez testi ve veri analizi'
    if 'tensor' in m: return 'tensor, çok boyutlu dizi ve temel lineer cebir'
    if 'matrix' in m: return 'matris ve OpenBLAS destekli sayısal hesap'
    if 'mathcore' in m: return 'tipli buffer, ham bellek ve temel matematik çekirdeği'
    if 'aimath' in m or 'nn' in m: return 'yapay zekâ, aktivasyon, eğitim ve sinir ağı yardımcıları'
    if 'onnx' in m: return 'ONNX Runtime model oturumu ve inference'
    if 'llama' in m: return 'yerel LLM, prompt çalıştırma ve düşük bellek profili'
    if 'dataframe' in m: return 'DuckDB tabanlı tablo, SQL ve veri çerçevesi işlemleri'
    if 'dataset' in m: return 'eğitim veri kümesi, batch, ölçekleme ve CSV akışı'
    if 'graph' in m: return 'graf, kenar, yol, bileşen ve ağ ölçümleri'
    if 'collections' in m: return 'liste, yığın, kuyruk, sözlük, set ve ağaç koleksiyonları'
    return 'dış kütüphane wrapper yüzeyi'

def purpose(name, mod):
    n=name.lower()
    if 'version' in n: return 'Modülün veya bağlı dış runtime bileşeninin sürüm bilgisini döndürür.'
    if 'backend' in n: return 'Modülün hangi dış hesaplama arka ucuna bağlandığını bildirir.'
    if 'create' in n or 'new' in n: return 'Yeni handle/nesne/tampon/oturum oluşturur.'
    if 'free' in n or 'clear' in n: return 'Dış runtime tarafından ayrılmış kaynakları serbest bırakır veya temizler.'
    if 'load' in n or 'open' in n: return 'Dosyadan veya dış kaynaktan veri/oturum açar.'
    if 'save' in n or 'write' in n or 'tocsv' in n or 'toparquet' in n: return 'Veriyi dış dosyaya yazar veya rapor çıktısı üretir.'
    if 'set' in n: return 'Handle içine değer, seçenek, parametre veya hücre yazar.'
    if 'get' in n: return 'Handle içinden değer, hücre, tensor elemanı veya metin okur.'
    if 'count' in n or 'rows' in n or 'cols' in n or 'dim' in n or 'rank' in n: return 'Boyut, satır/sütun, eksen veya eleman sayısı bilgisini döndürür.'
    if 'mean' in n or 'variance' in n or 'stddev' in n or 'sum' in n or 'median' in n: return 'Sayısal veri üzerinde özet istatistik üretir.'
    if 'run' in n or 'session' in n: return 'Model oturumu veya inference çalışma adımında kullanılır.'
    if 'prompt' in n: return 'Yerel dil modeli prompt çalıştırma yüzeyidir.'
    return 'Dış kütüphane wrapper yüzeyinde özel bir işlem yürütür.'

def param_desc(p):
    n=p['name']; t=p['type']; low=n.lower()
    if t=='U64' or low in ('h','df','ds','g','t','m','s','session'): return f'`{n}`: `{t}` handle/pointer değeri.'
    if t=='STRING': return f'`{n}`: `{t}` metin, yol, ad veya sorgu parametresi.'
    if t=='F64': return f'`{n}`: `{t}` ondalık ölçüm/katsayı/eşik değeri.'
    return f'`{n}`: `{t}` parametresi.'

def call_expr(f):
    args=[]
    for p in f['params']:
        t=p['type']; low=p['name'].lower()
        args.append('"demo"' if t=='STRING' else '1.25' if t=='F64' else 'h' if t=='U64' else '1')
    return f"{f['name']}({', '.join(args)})"

def make_doc(mid, rel, ns, funs):
    inc=f'libsx/{rel.parent.name}/{rel.name}'; out=[f'# Dış Kütüphane Referansı: `{mid}`','',f'`{mid}` modülü {category_for_module(mid)} alanında kullanılır. Bu belge `{inc}` wrapper dosyasındaki fonksiyon imzalarından üretilmiştir.','', '## Kullanım başlangıcı','','```basic',f'INCLUDE "{inc}"']
    if ns: out.append(f'USING {ns}')
    out += ['PRINT "DIS_KUTUPHANE_BASLADI"','```','','## Fonksiyon tablosu','','| Fonksiyon | Tür | Dönüş | Görev |','|---|---|---|---|']
    for f in funs: out.append(f"| `{f['name']}` | `{f['kind']}` | `{f['return'] or '-'}` | {purpose(f['name'], mid)} |")
    out += ['','## Ayrıntılı fonksiyon anlatımı','']
    if not funs: out.append('Bu wrapper dosyası placeholder durumundadır; bu baskıda dış fonksiyon imzası taşımaz.')
    for i,f in enumerate(funs,1):
        out += [f"### {i}. `{f['name']}`",'',f"**İmza:** `{f['signature']}`",'',f"**Görev:** {purpose(f['name'], mid)}",'']
        out.append('**Parametreler:**')
        if f['params']:
            for p in f['params']: out.append('- '+param_desc(p))
        else: out.append('- Parametre almaz.')
        out += ['', f"**Dönen değer:** `{f['return'] or 'SUB'}`.", '']
        if f.get('dll') or f.get('native'): out += [f"**Dış rota:** `{f.get('dll') or 'wrapper sabiti'}` / `{f.get('native') or 'native sembol'}`", '']
        out += ['**Kullanım iskeleti:**','```basic',f'INCLUDE "{inc}"']
        if ns: out.append(f'USING {ns}')
        if f['kind']=='SUB': out.append(call_expr(f))
        elif f['return']=='U64': out += ['DIM h AS U64', 'h = '+call_expr(f), 'PRINT h']
        elif f['return']=='F64': out += ['DIM sonuc AS F64', 'sonuc = '+call_expr(f), 'PRINT sonuc']
        elif f['return']=='STRING': out += ['DIM metin AS STRING', 'metin = '+call_expr(f), 'PRINT metin']
        else: out += ['DIM durum AS I32', 'durum = '+call_expr(f), 'PRINT durum']
        out += ['```','']
    return '\n'.join(out)+'\n'

def make_example(mid, rel, ns, funs, idx):
    inc=f'libsx/{rel.parent.name}/{rel.name}'; lines=[f"' {mid} uzun örnek {idx:02d}", f"' Amaç: dış kütüphane kullanımını REM satırlarıyla açıklamak"]
    comments=[
        f"REM {mid}: INCLUDE wrapper yüzeyini programa bağlar.",
        "REM Wrapper fonksiyon BASIC tarafında okunabilir ad sağlar; ağır iş native DLL tarafına iner.",
        "REM Handle U64 değeri dış nesnenin kimliğidir; Free çağrısıyla kapanmalıdır.",
        "REM Pointer ve dosya yolu alan fonksiyonlarda tip ve yol doğruluğu programcının sorumluluğudur.",
        "REM AST katmanı sözdizimini, MIR katmanı çağrı akışını, runtime katmanı DLL rotasını taşır.",
        "REM Bu örnek öğretim amaçlıdır; gerçek DLL yoksa runtime çağrısı hata verebilir ama belge akışı korunur.",
    ]
    for i in range(1,76): lines.append(f"{comments[(i-1)%len(comments)]} [{i:03d}]")
    lines += [f'INCLUDE "{inc}"']
    if ns: lines.append(f'USING {ns}')
    lines += ['PRINT "BASLA"','DIM h AS U64 = 0','DIM durum AS I32 = 0','DIM sonuc AS F64 = 0.0','DIM metin AS STRING = "demo"']
    part=(idx-1)*max(1,len(funs)//5); selected=(funs[part:part+12] or funs[:12])
    for f in selected:
        lines.append(f"REM {f['name']}: {purpose(f['name'], mid)}")
        ce=call_expr(f)
        if f['kind']=='SUB': lines.append(ce)
        elif f['return']=='U64': lines += [f'h = {ce}', 'PRINT h']
        elif f['return']=='F64': lines += [f'sonuc = {ce}', 'PRINT sonuc']
        elif f['return']=='STRING': lines += [f'metin = {ce}', 'PRINT metin']
        else: lines += [f'durum = {ce}', 'PRINT durum']
    lines.append('PRINT "BITTI"')
    return '\n'.join(lines)+'\n'

def update_order(root, docs):
    order=root/'docs_src/.uxb_book_order.txt'
    old=[]
    if order.exists(): old=[x.strip() for x in order.read_text(encoding='utf-8').splitlines() if x.strip()]
    add=['33_dis_kutuphaneler_ana_bolum.md'] + [f'external_libraries/{d}' for d in docs] + ['34_dis_kutuphane_terminal_rehberi.md','35_dis_kutuphane_ornekleri_ve_kalite_kapisi.md']
    merged=[]
    for x in old:
        if x not in add: merged.append(x)
    # insert after 32 if found, else append
    pos=len(merged)
    for i,x in enumerate(merged):
        if x.startswith('32_'): pos=i+1
    merged=merged[:pos]+add+merged[pos:]
    order.parent.mkdir(parents=True, exist_ok=True); order.write_text('\n'.join(merged)+'\n', encoding='utf-8')

def main():
    ap=argparse.ArgumentParser(); ap.add_argument('--root', default='.'); ap.add_argument('--update-order', action='store_true')
    ns=ap.parse_args(); root=Path(ns.root).resolve(); libsx=root/'libsx'
    infos=[]
    for p in sorted(libsx.glob('*/*.bas')):
        rel=p.relative_to(root); mid=rel.stem.lower() if rel.parent.name.lower()==rel.stem.lower() else (rel.parent.name.lower()+'_'+rel.stem.lower().replace('placeholder','placeholder'))
        mid=mid.replace('uxllamax_uxllamax_','uxllamax_')
        nsname,funs=extract_functions(p); infos.append({'id':mid,'rel':rel,'ns':nsname,'funs':funs})
    ddir=root/'docs_src/external_libraries'; edir=root/'docs_examples/external_libraries'; ddir.mkdir(parents=True, exist_ok=True); edir.mkdir(parents=True, exist_ok=True)
    docs=[]
    for info in infos:
        doc=f"{info['id']}.md"; docs.append(doc)
        (ddir/doc).write_text(make_doc(info['id'], info['rel'], info['ns'], info['funs']), encoding='utf-8')
        exdir=edir/info['id']; exdir.mkdir(parents=True, exist_ok=True)
        for i in range(1,6): (exdir/f"{info['id']}_ornek_{i:02d}.uxb").write_text(make_example(info['id'], info['rel'], info['ns'], info['funs'], i), encoding='utf-8')
    # master docs
    total=sum(len(x['funs']) for x in infos)
    master=['# Dış Kütüphaneler Ana Bölümü','',f'Bu bölüm `libsx` wrapper yüzeyinden üretilmiştir. Toplam `{len(infos)}` wrapper dosyası ve `{total}` fonksiyon/sub ayrıntılı olarak belgelenir.','','| Modül | Fonksiyon | Görev |','|---|---:|---|']
    for info in infos: master.append(f"| `{info['id']}` | {len(info['funs'])} | {category_for_module(info['id'])} |")
    (root/'docs_src/33_dis_kutuphaneler_ana_bolum.md').write_text('\n'.join(master)+'\n', encoding='utf-8')
    (root/'docs_src/34_dis_kutuphane_terminal_rehberi.md').write_text('# Dış Kütüphane Terminal Rehberi\n\n```powershell\n.\\compiler\\scripts\\build_all_runtime_ext_dlls.bat\n.\\compiler\\scripts\\build_imported_library_runtimes.bat\n.\\tools\\docs\\run_external_library_examples.ps1 -Root . -Backend AST\n.\\tools\\docs\\run_external_library_examples.ps1 -Root . -Backend MIR\npython .\\tools\\docs\\generate_external_library_docs.py --root . --update-order\npython .\\tools\\docs\\build_uxbasic_pck_book.py --root . --include-generated\n```\n', encoding='utf-8')
    (root/'docs_src/35_dis_kutuphane_ornekleri_ve_kalite_kapisi.md').write_text('# Dış Kütüphane Örnekleri ve Kalite Kapısı\n\nHer modül için beş uzun REM açıklamalı `.uxb` örneği `docs_examples/external_libraries` altında üretilir. Örnekler AST/MIR sözdizimi ve runtime rota eğitimi için kullanılır.\n', encoding='utf-8')
    if ns.update_order: update_order(root, docs)
    print(f'OK: {len(infos)} dış kütüphane belgesi üretildi; toplam fonksiyon: {total}')
if __name__=='__main__': main()
