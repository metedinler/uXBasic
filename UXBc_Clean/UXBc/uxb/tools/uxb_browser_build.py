#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
uXBasic Browser Build Orchestrator.

Use case A: You already have MIR JSON:
  python tools/uxb_browser_build.py --mir-json dist/mir/program.mir.json --out-dir dist/browser/program --mode hybrid

Use case B: You have compiler exe + .bas:
  python tools/uxb_browser_build.py --compiler .\src\main_64.exe --source tests\browser\01_print.bas --out-dir dist/browser/01_print --mode js

External tools supported:
  - Node.js for syntax/run sanity checks
  - WABT wat2wasm for WAT -> WASM
  - Binaryen wasm-opt for optional optimization
"""
from __future__ import annotations

import argparse, json, pathlib, shutil, subprocess, os, sys

def run(cmd, cwd=None):
    try:
        p = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True)
        return {"cmd": cmd, "returncode": p.returncode, "stdout": p.stdout, "stderr": p.stderr}
    except FileNotFoundError:
        return {"cmd": cmd, "returncode": 127, "stdout": "", "stderr": "tool not found"}

def copy_runtime(uxb_root: pathlib.Path, out_dir: pathlib.Path):
    src = uxb_root / "runtime" / "browser"
    if not src.exists():
        raise SystemExit(f"runtime/browser bulunamadı: {src}")
    out_dir.mkdir(parents=True, exist_ok=True)
    for item in src.iterdir():
        if item.is_file():
            shutil.copy2(item, out_dir / item.name)

def produce_mir_json(compiler: str, source: str, mir_json: pathlib.Path):
    mir_json.parent.mkdir(parents=True, exist_ok=True)
    cmd = [compiler, source, "--mir-full-json-out", str(mir_json)]
    return run(cmd)

def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--uxb-root", default=".")
    ap.add_argument("--compiler", default="")
    ap.add_argument("--source", default="")
    ap.add_argument("--mir-json", default="")
    ap.add_argument("--out-dir", required=True)
    ap.add_argument("--mode", choices=["js","wasm","hybrid"], default="hybrid")
    ap.add_argument("--wat2wasm", default="wat2wasm")
    ap.add_argument("--wasm-opt", default="")
    ap.add_argument("--node", default="node")
    ap.add_argument("--no-node-check", action="store_true")
    args = ap.parse_args()

    uxb_root = pathlib.Path(args.uxb_root).resolve()
    out_dir = pathlib.Path(args.out_dir).resolve()
    tools = uxb_root / "tools"
    out_dir.mkdir(parents=True, exist_ok=True)

    report = {"mode": args.mode, "out_dir": str(out_dir), "steps": []}

    if args.mir_json:
        mir_json = pathlib.Path(args.mir_json).resolve()
    else:
        if not args.compiler or not args.source:
            raise SystemExit("--mir-json yoksa --compiler ve --source verilmelidir")
        mir_json = out_dir / "program.mir.json"
        res = produce_mir_json(args.compiler, args.source, mir_json)
        report["steps"].append({"produce_mir_json": res})
        if res["returncode"] != 0:
            (out_dir / "browser_build_report.json").write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8")
            return res["returncode"]

    copy_runtime(uxb_root, out_dir)
    shutil.copy2(mir_json, out_dir / mir_json.name)

    wasm_manifest = ""
    if args.mode in ("wasm","hybrid"):
        wat = out_dir / "program.wat"
        wasm = out_dir / "program.wasm"
        manifest = out_dir / "wasm_manifest.json"
        cmd = [sys.executable, str(tools / "uxb_json_to_wasm.py"), "--mir-json", str(mir_json), "--wat-out", str(wat), "--manifest-out", str(manifest), "--wasm-out", str(wasm), "--wat2wasm", args.wat2wasm]
        if args.wasm_opt:
            cmd += ["--wasm-opt", args.wasm_opt]
        res = run(cmd)
        report["steps"].append({"json_to_wasm": res})
        wasm_manifest = str(manifest)

    if args.mode in ("js","hybrid"):
        js = out_dir / "game.js"
        cmd = [sys.executable, str(tools / "uxb_json_to_js.py"), "--mir-json", str(mir_json), "--out", str(js)]
        if wasm_manifest:
            cmd += ["--wasm-manifest", wasm_manifest]
        res = run(cmd)
        report["steps"].append({"json_to_js": res})
    else:
        (out_dir / "game.js").write_text('import { ux } from "./ux_runtime.js"; import { loadUxWasmFromManifest } from "./ux_wasm_bridge.js"; await loadUxWasmFromManifest("./wasm_manifest.json"); ux.print("WASM loaded");\n', encoding="utf-8")

    if not args.no_node_check:
        res = run([args.node, "--check", str(out_dir / "game.js")])
        report["steps"].append({"node_check": res})

    (out_dir / "browser_build_report.json").write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
