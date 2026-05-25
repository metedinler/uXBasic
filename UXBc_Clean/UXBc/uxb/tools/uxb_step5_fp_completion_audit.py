#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
UXBc Step 5 FP completion audit.

Checks:
- FP runtime source files
- FP contract modules
- include wiring
- MIR x64 forbidden native FP patterns
- test files
- Copilot missing work list
"""

from __future__ import annotations

import json
import re
from pathlib import Path
from typing import List, Dict, Any


def find_root(start: Path) -> Path:
    p = start.resolve()
    for c in [p] + list(p.parents):
        if (c / "uxb" / "src").is_dir():
            return c
    raise SystemExit("UXBc root not found")


def read(p: Path) -> str:
    if not p.exists():
        return ""
    return p.read_text(encoding="utf-8", errors="ignore")


def main() -> int:
    root = find_root(Path("."))
    out = root / "uxb/dist/step5"
    out.mkdir(parents=True, exist_ok=True)

    files = {
        "extfp_type_policy": root / "uxb/src/semantic/extfp_type_policy.fbs",
        "extfp_runtime_status": root / "uxb/src/runtime/extfp_runtime_status.fbs",
        "extfp_lowering_contract": root / "uxb/src/semantic/extfp_lowering_contract.fbs",
        "x64_extfp_call_emit": root / "uxb/src/codegen/x64/x64_extfp_call_emit.fbs",
        "mir_x64_extfp_emit_contract": root / "uxb/src/codegen/x64/mir_x64_extfp_emit_contract.fbs",
        "mir_x64_extfp_emit_helpers": root / "uxb/src/codegen/x64/mir_x64_extfp_emit_helpers.fbs",
        "fp80_runtime": root / "uxb/runtime_ext/fp80/uxb_fp80_fb.bas",
        "fp128_runtime": root / "uxb/runtime_ext/fp128/uxb_fp128_quad.c",
        "bigfp_runtime": root / "uxb/runtime_ext/bigfp/uxb_bigfp_mpfr.c",
        "fp_runtime_build": root / "uxb/runtime_ext/build_fp_runtime_all.bat",
    }

    main_bas = read(root / "uxb/src/main.bas")
    mir_codegen = read(root / "uxb/src/codegen/x64/mir_x64_codegen.fbs")

    checks: List[Dict[str, Any]] = []
    for name, path in files.items():
        checks.append({
            "name": name,
            "kind": "file_exists",
            "status": "PASS" if path.exists() else "MISSING",
            "path": str(path.relative_to(root)).replace("\\", "/"),
        })

    include_needles = [
        "extfp_lowering_contract.fbs",
        "mir_x64_extfp_emit_contract.fbs",
        "mir_x64_extfp_emit_helpers.fbs",
    ]
    for n in include_needles:
        checks.append({
            "name": "include_" + n,
            "kind": "include",
            "status": "PASS" if n in main_bas else "MISSING",
            "path": "uxb/src/main.bas",
        })

    helper_needles = [
        "MIRX64EmitExtFpCallFromString",
        "MIRX64EmitExtFpCallBinary",
        "MIRX64EmitExtFpCallToString",
    ]
    helpers_text = read(files["mir_x64_extfp_emit_helpers"])
    for n in helper_needles:
        checks.append({
            "name": "helper_" + n,
            "kind": "helper",
            "status": "PASS" if n in helpers_text else "MISSING",
        })

    call_needles = ["uxb_f80_add", "uxb_f128_add", "uxb_bigf_add", "uxb_bigd_add", "uxb_ball_add"]
    all_text = "\n".join(read(p) for p in files.values())
    for n in call_needles:
        checks.append({
            "name": "runtime_symbol_" + n,
            "kind": "runtime_symbol",
            "status": "PASS" if n in all_text else "MISSING_OR_PENDING",
        })

    native_fp_lines = []
    for i, line in enumerate(mir_codegen.splitlines(), 1):
        low = line.lower()
        if any(x in low for x in [" fld", "fstp", "fadd", "fsub", "fmul", "fdiv", "addsd", "subsd", "mulsd", "divsd"]):
            native_fp_lines.append({"line": i, "text": line})
    checks.append({
        "name": "native_fp_instruction_review",
        "kind": "asm_pattern",
        "status": "PASS" if not native_fp_lines else "REVIEW",
        "count": len(native_fp_lines),
    })

    tests = [
        root / "uxb/tests/step5/f80_assignment_binary_print.bas",
        root / "uxb/tests/step5/f128_assignment_binary_print.bas",
        root / "uxb/tests/step5/bigf_bigd_ball_policy.bas",
        root / "uxb/tests/step5/extfp_native_forbidden_probe.bas",
    ]
    for t in tests:
        checks.append({
            "name": "test_" + t.name,
            "kind": "test_file",
            "status": "PASS" if t.exists() else "MISSING",
            "path": str(t.relative_to(root)).replace("\\", "/"),
        })

    missing = [c for c in checks if c["status"] not in ("PASS",)]
    report = {
        "schema_version": "uxb-step5-fp-completion-audit-1",
        "checks": checks,
        "native_fp_lines": native_fp_lines,
        "summary": {
            "pass": sum(1 for c in checks if c["status"] == "PASS"),
            "not_pass": len(missing),
        },
    }
    (out / "step5_fp_completion_audit.json").write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")

    md = ["# UXBc Step 5 FP Completion Audit", ""]
    md.append(f"- PASS: `{report['summary']['pass']}`")
    md.append(f"- NOT_PASS: `{report['summary']['not_pass']}`")
    md.append("")
    md.append("| name | kind | status | path/count |")
    md.append("|---|---|---|---|")
    for c in checks:
        md.append(f"| {c['name']} | {c['kind']} | {c['status']} | `{c.get('path', c.get('count',''))}` |")
    (out / "step5_fp_completion_audit.md").write_text("\n".join(md), encoding="utf-8")

    cop = ["# Copilot Step 5 Missing Work", ""]
    cop.append("Copilot, sadece aşağıdaki eksikleri kapat. Yeni mimari icat etme.")
    cop.append("")
    for c in missing:
        cop.append(f"- `{c['name']}` status={c['status']} kind={c['kind']} path={c.get('path','')}")
    cop.append("")
    cop.append("## Öncelik")
    cop.append("")
    cop.append("1. Include zinciri")
    cop.append("2. F80/F128 runtime call lowering")
    cop.append("3. F80/F128 PRINT lowering")
    cop.append("4. BIGF/BIGD/BALL handle runtime contract")
    cop.append("5. Native FP forbidden audit")
    (out / "copilot_step5_missing_work.md").write_text("\n".join(cop), encoding="utf-8")

    print("STEP5_AUDIT=" + str(out / "step5_fp_completion_audit.md"))
    print("COPILOT_MISSING=" + str(out / "copilot_step5_missing_work.md"))
    print("NOT_PASS=" + str(len(missing)))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
