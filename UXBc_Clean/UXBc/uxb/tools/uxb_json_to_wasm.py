#!/usr/bin/env python3
# -*- coding: utf-8 -*-
'''
uXBasic MIR JSON -> WAT/WASM manifest generator.

Compiles pure numeric compute functions to WAT. Browser/API/graphics/file/AI/OOP
operations remain JS host calls/fallbacks. That is the correct browser split:
WASM compute core + JS host runtime.

External tools supported:
  - wat2wasm (WABT) to compile WAT -> WASM
  - wasm-opt (Binaryen) optional optimization
'''
from __future__ import annotations

import argparse, json, pathlib, subprocess, re
from typing import Any, Dict, List, Tuple

NUM = re.compile(r"^[-+]?(?:\d+(?:\.\d*)?|\.\d+)$")

WASM_SAFE_OPS = {
    "NOP", "LOAD_CONST", "CONST", "LOADI", "LOAD", "LOAD_VAR", "STORE", "STORE_VAR", "ASSIGN",
    "ADD", "SUB", "MUL", "DIV", "IDIV", "MOD", "EQ", "NE", "LT", "LE", "GT", "GE", "AND", "OR", "XOR", "NOT",
    "RET", "RETURN",
}

def load_json(path: str) -> Dict[str, Any]:
    with open(path, "r", encoding="utf-8-sig") as f:
        return json.load(f)

def functions_of(mir: Dict[str, Any]) -> List[Dict[str, Any]]:
    if isinstance(mir.get("functions"), list):
        return mir["functions"]
    if isinstance(mir.get("module"), dict) and isinstance(mir["module"].get("functions"), list):
        return mir["module"]["functions"]
    if isinstance(mir.get("mir"), dict) and isinstance(mir["mir"].get("functions"), list):
        return mir["mir"]["functions"]
    return []

def blocks_of(fn: Dict[str, Any]) -> List[Dict[str, Any]]:
    return fn.get("blocks") or []

def instrs_of(block: Dict[str, Any]) -> List[Dict[str, Any]]:
    return block.get("instructions") or []

def operands(ins: Dict[str, Any]) -> List[str]:
    if isinstance(ins.get("operands"), list):
        return [str(x) for x in ins["operands"]]
    out = []
    for i in range(16):
        k = f"operand{i}"
        if k in ins:
            out.append(str(ins[k]))
    return out

def safe_name(name: str) -> str:
    s = re.sub(r"[^A-Za-z0-9_$]", "_", str(name or "fn"))
    if not s:
        s = "fn"
    if s[0].isdigit():
        s = "_" + s
    return s

def is_num(s: str) -> bool:
    return bool(NUM.match(str(s)))

def collect_locals(fn: Dict[str, Any]) -> List[str]:
    names = set(str(x) for x in fn.get("locals", []) if str(x))
    params = set(str(x) for x in fn.get("params", []) if str(x))
    for b in blocks_of(fn):
        for ins in instrs_of(b):
            r = str(ins.get("result") or ins.get("target") or "")
            if r and r not in params:
                names.add(r)
            for o in operands(ins):
                if o and not is_num(o) and not (o.startswith('"') and o.endswith('"')) and o not in params:
                    if re.match(r"^[A-Za-z_][A-Za-z0-9_.$]*$", o):
                        names.add(o)
    return sorted(names)

def wat_push_operand(token: str, local_names: set, param_names: set) -> List[str]:
    if is_num(token):
        return [f"    i32.const {int(float(token))}"]
    if token in local_names or token in param_names:
        return [f"    local.get ${safe_name(token)}"]
    return ["    i32.const 0"]

def analyze_fn_wasm_compat(fn: Dict[str, Any]) -> List[str]:
    issues: List[str] = []
    for b in blocks_of(fn):
        for ins in instrs_of(b):
            op = str(ins.get("opcode") or ins.get("op") or "").upper()
            if not op:
                continue
            if op in {"JMP", "JZ", "JNZ", "GOTO", "JMP_IF_ZERO", "JMP_IF_NOT_ZERO"}:
                issues.append(f"control-flow opcode {op}")
                continue
            if op not in WASM_SAFE_OPS:
                issues.append(f"unsupported opcode {op}")
    return issues

def emit_function(fn: Dict[str, Any], diagnostics: List[str]) -> str:
    name = safe_name(fn.get("name", "main"))
    params = [str(x) for x in fn.get("params", [])]
    param_names = set(params)
    locals_ = collect_locals(fn)
    local_names = set(x for x in locals_ if x not in param_names)
    sig = " ".join(f"(param ${safe_name(p)} i32)" for p in params)
    result_sig = "(result i32)"
    lines = [f"  (func ${name} {sig} {result_sig}".rstrip()]
    for l in sorted(local_names):
        lines.append(f"    (local ${safe_name(l)} i32)")

    returned = False
    for b in blocks_of(fn):
        for ins in instrs_of(b):
            op = str(ins.get("opcode") or ins.get("op") or "").upper()
            ops = operands(ins)
            res = str(ins.get("result") or ins.get("target") or "")
            if op in {"ADD","SUB","MUL","DIV","IDIV","MOD","EQ","NE","LT","LE","GT","GE","AND","OR"} and len(ops) >= 2:
                lines.extend(wat_push_operand(ops[0], local_names, param_names))
                lines.extend(wat_push_operand(ops[1], local_names, param_names))
                watop = {
                    "ADD":"i32.add","SUB":"i32.sub","MUL":"i32.mul","DIV":"i32.div_s","IDIV":"i32.div_s","MOD":"i32.rem_s",
                    "EQ":"i32.eq","NE":"i32.ne","LT":"i32.lt_s","LE":"i32.le_s","GT":"i32.gt_s","GE":"i32.ge_s",
                    "AND":"i32.and","OR":"i32.or"
                }[op]
                lines.append(f"    {watop}")
                if res:
                    lines.append(f"    local.set ${safe_name(res)}")
            elif op in {"XOR"} and len(ops) >= 2:
                lines.extend(wat_push_operand(ops[0], local_names, param_names))
                lines.extend(wat_push_operand(ops[1], local_names, param_names))
                lines.append("    i32.xor")
                if res:
                    lines.append(f"    local.set ${safe_name(res)}")
            elif op in {"NOT"} and ops:
                lines.extend(wat_push_operand(ops[0], local_names, param_names))
                lines.append("    i32.const -1")
                lines.append("    i32.xor")
                if res:
                    lines.append(f"    local.set ${safe_name(res)}")
            elif op in {"LOAD_CONST","CONST","LOADI"} and ops:
                target = res or (ops[0] if len(ops) > 1 else "")
                value = ops[1] if len(ops) > 1 else ops[0]
                if target:
                    lines.extend(wat_push_operand(value, local_names, param_names))
                    lines.append(f"    local.set ${safe_name(target)}")
            elif op in {"LOAD", "LOAD_VAR"} and ops:
                target = res
                if target:
                    lines.extend(wat_push_operand(ops[0], local_names, param_names))
                    lines.append(f"    local.set ${safe_name(target)}")
            elif op in {"STORE","STORE_VAR","ASSIGN"} and len(ops) >= 2:
                target = ops[0]
                value = ops[1]
                lines.extend(wat_push_operand(value, local_names, param_names))
                lines.append(f"    local.set ${safe_name(target)}")
            elif op in {"RET","RETURN"}:
                value = ops[0] if ops else (res if res else "0")
                lines.extend(wat_push_operand(value, local_names, param_names))
                lines.append("    return")
                returned = True
            elif op in {"NOP","JMP","JZ","JNZ"}:
                diagnostics.append(f"{name}: control-flow opcode {op} JS fallback önerilir")
            elif op:
                diagnostics.append(f"{name}: WASM native olmayan opcode {op} JS/host fallback")

    if not returned:
        lines.append("    i32.const 0")
    lines.append("  )")
    lines.append(f"  (export \"{name}\" (func ${name}))")
    lines.append(f"  (export \"{name.upper()}\" (func ${name}))")
    return "\n".join(lines)

def emit_wat(mir: Dict[str, Any]) -> Tuple[str, Dict[str, Any]]:
    diagnostics: List[str] = []
    exports = []
    parts = ["(module", '  (import "ux" "print_i32" (func $ux_print_i32 (param i32)))']
    for fn in functions_of(mir):
        if not fn.get("name"):
            continue
        issues = analyze_fn_wasm_compat(fn)
        if issues:
            fname = safe_name(fn.get("name"))
            diagnostics.append(f"{fname}: JS fallback ({'; '.join(sorted(set(issues)))})")
            continue
        parts.append(emit_function(fn, diagnostics))
        exports.append({"name": safe_name(fn.get("name")), "kind": "function", "params": ["i32"] * len(fn.get("params", [])), "result": "i32"})
    parts.append(")")
    manifest = {
        "format": "uxb-wasm-manifest-v2",
        "exports": exports,
        "imports": [{"module": "ux", "name": "print_i32", "kind": "host"}],
        "diagnostics": diagnostics,
        "external_tools": {
            "wat2wasm": "WABT optional tool for WAT->WASM",
            "wasm-opt": "Binaryen optional optimizer"
        }
    }
    return "\n".join(parts) + "\n", manifest

def run_tool(cmd: List[str]) -> Dict[str, Any]:
    try:
        p = subprocess.run(cmd, capture_output=True, text=True)
        return {"cmd": cmd, "returncode": p.returncode, "stdout": p.stdout, "stderr": p.stderr}
    except FileNotFoundError:
        return {"cmd": cmd, "returncode": 127, "stdout": "", "stderr": "tool not found"}
    except OSError as e:
        return {"cmd": cmd, "returncode": 126, "stdout": "", "stderr": str(e)}

def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--mir-json", required=True)
    ap.add_argument("--wat-out", required=True)
    ap.add_argument("--manifest-out", required=True)
    ap.add_argument("--wasm-out", default="")
    ap.add_argument("--wat2wasm", default="wat2wasm")
    ap.add_argument("--wasm-opt", default="")
    args = ap.parse_args()

    mir = load_json(args.mir_json)
    wat, manifest = emit_wat(mir)
    wat_path = pathlib.Path(args.wat_out)
    wat_path.parent.mkdir(parents=True, exist_ok=True)
    wat_path.write_text(wat, encoding="utf-8")

    if args.wasm_out:
        wasm_path = pathlib.Path(args.wasm_out)
        wasm_path.parent.mkdir(parents=True, exist_ok=True)
        res = run_tool([args.wat2wasm, str(wat_path), "-o", str(wasm_path)])
        manifest["wat2wasm_result"] = res
        manifest["module"] = wasm_path.name if res["returncode"] == 0 else ""
        if res["returncode"] == 0 and args.wasm_opt:
            opt_res = run_tool([args.wasm_opt, "-O2", str(wasm_path), "-o", str(wasm_path)])
            manifest["wasm_opt_result"] = opt_res
    else:
        manifest["module"] = ""

    manifest["wat"] = pathlib.Path(args.wat_out).name
    mpath = pathlib.Path(args.manifest_out)
    mpath.parent.mkdir(parents=True, exist_ok=True)
    mpath.write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding="utf-8")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
