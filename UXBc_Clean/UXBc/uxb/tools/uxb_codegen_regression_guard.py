#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
MIR x64 codegen regression guard.

Purpose:
- detect accidental deletion of working emit paths,
- especially old inline MIRX64EmitRuntimeSupport removal,
- ensure new runtime-backed helper path exists before accepting deletion.

Does not modify source files.
"""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Dict, Any, List


def read(p: Path) -> str:
    if not p.exists():
        return ""
    return p.read_text(encoding="utf-8", errors="ignore")


def find_root(start: Path) -> Path:
    p = start.resolve()
    for c in [p] + list(p.parents):
        if (c / "uxb" / "src").is_dir():
            return c
    raise SystemExit("UXBc root not found")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=".")
    ap.add_argument("--current", default="uxb/src/codegen/x64/mir_x64_codegen.fbs")
    ap.add_argument("--old", default="", help="optional old mir_x64_codegen file")
    args = ap.parse_args()

    root = find_root(Path(args.root))
    current_path = root / args.current
    current = read(current_path)

    helper_files = [
        root / "uxb/src/codegen/x64/mir_x64_runtime_emit_helpers.fbs",
        root / "uxb/src/codegen/x64/mir_x64_runtime_call_contract.fbs",
        root / "uxb/src/codegen/x64/mir_x64_extfp_emit_helpers.fbs",
        root / "uxb/src/codegen/x64/mir_x64_extfp_emit_contract.fbs",
    ]
    helpers = "\n".join(read(p) for p in helper_files)

    checks = []
    def add(name: str, ok: bool, detail: str):
        checks.append({"name": name, "status": "PASS" if ok else "FAIL", "detail": detail})

    old_inline_present = "MIRX64EmitRuntimeSupport" in current
    new_print_helper = "MIRX64EmitRuntimePrintI64" in current or "MIRX64EmitRuntimePrintI64" in helpers
    new_cstr_helper = "MIRX64EmitRuntimePrintCStr" in current or "MIRX64EmitRuntimePrintCStr" in helpers
    new_input_helper = "MIRX64EmitRuntimeInputI64" in current or "MIRX64EmitRuntimeInputI64" in helpers

    add("runtime_support_replaced_or_present", old_inline_present or (new_print_helper and new_cstr_helper and new_input_helper),
        "Old inline runtime support may be removed only if runtime print/input helpers exist.")

    add("print_i64_helper", new_print_helper, "MIRX64EmitRuntimePrintI64 must exist for numeric print.")
    add("print_cstr_helper", new_cstr_helper, "MIRX64EmitRuntimePrintCStr must exist for string print.")
    add("input_i64_helper", new_input_helper, "MIRX64EmitRuntimeInputI64 must exist for INPUT.")

    direct_printf = any(x in current for x in ["call printf", "call sprintf", "call scanf"])
    runtime_backed = any(x in current for x in ["MIRX64EmitRuntimePrintI64", "MIRX64EmitRuntimePrintCStr", "MIRX64EmitRuntimeInputI64"])
    add("no_mixed_runtime_model", not (direct_printf and runtime_backed),
        "Do not mix old direct printf model with runtime-backed helper model in same emitter unless explicitly isolated.")

    forbidden_extfp_native = []
    for i, line in enumerate(current.splitlines(), 1):
        low = line.lower()
        if any(x in low for x in ["fld", "fstp", "fadd", "fsub", "fmul", "fdiv", "addsd", "subsd", "mulsd", "divsd"]):
            forbidden_extfp_native.append({"line": i, "text": line})
    add("native_fp_instruction_review", len(forbidden_extfp_native) == 0,
        "Native FP instructions in MIR x64 codegen must be reviewed; F64 may be allowed but EXTFP cannot use them.")

    out_dir = root / "uxb/dist/step5"
    out_dir.mkdir(parents=True, exist_ok=True)
    report = {
        "schema_version": "uxb-codegen-regression-guard-1",
        "current": str(current_path),
        "checks": checks,
        "forbidden_fp_lines": forbidden_extfp_native,
        "summary": {
            "pass": sum(1 for c in checks if c["status"] == "PASS"),
            "fail": sum(1 for c in checks if c["status"] == "FAIL"),
        }
    }
    (out_dir / "codegen_regression_guard.json").write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")

    md = ["# Codegen Regression Guard", ""]
    md.append(f"- PASS: `{report['summary']['pass']}`")
    md.append(f"- FAIL: `{report['summary']['fail']}`")
    md.append("")
    md.append("| check | status | detail |")
    md.append("|---|---|---|")
    for c in checks:
        md.append(f"| {c['name']} | {c['status']} | {c['detail']} |")
    if forbidden_extfp_native:
        md.append("")
        md.append("## Native FP instruction review")
        for item in forbidden_extfp_native:
            md.append(f"- line {item['line']}: `{item['text']}`")
    (out_dir / "codegen_regression_guard.md").write_text("\n".join(md), encoding="utf-8")

    print("CODEGEN_REGRESSION_GUARD=" + str(out_dir / "codegen_regression_guard.md"))
    print("FAIL_COUNT=" + str(report["summary"]["fail"]))
    return 0 if report["summary"]["fail"] == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
