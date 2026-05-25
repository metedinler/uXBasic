#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
UXBc Step 4 audit.

Checks:
- CLI message language options
- i18n files
- layer logging/hook files
- TYPE/CLASS/FFI contract modules
- current diagnostic-only backend surfaces
- Copilot missing work list

This script does not modify compiler sources.
"""

from __future__ import annotations

import json
import re
from pathlib import Path
from typing import Dict, Any, List


def find_root(start: Path) -> Path:
    p = start.resolve()
    for c in [p] + list(p.parents):
        if (c / "uxb" / "src").is_dir():
            return c
    raise SystemExit("UXBc root not found")


def read(path: Path) -> str:
    if not path.exists():
        return ""
    return path.read_text(encoding="utf-8", errors="ignore")


def has_any(text: str, needles: List[str]) -> bool:
    low = text.lower()
    return any(n.lower() in low for n in needles)


def main() -> int:
    root = find_root(Path("."))
    out = root / "uxb" / "dist" / "step4"
    out.mkdir(parents=True, exist_ok=True)

    main_entry = read(root / "uxb" / "src" / "main_program_entry.fbs") + "\n" + read(root / "uxb" / "src" / "main_program_entry_part2.fbs")
    cap = read(root / "uxb" / "src" / "codegen" / "x64" / "mir_x64_capability.fbs")
    main_bas = read(root / "uxb" / "src" / "main.bas")

    files = {
        "compiler_message_bus": root / "uxb/src/runtime/compiler_message_bus.fbs",
        "layer_event_contract": root / "uxb/src/runtime/layer_event_contract.fbs",
        "type_class_ffi_backend_contract": root / "uxb/src/semantic/type_class_ffi_backend_contract.fbs",
        "mir_x64_type_class_ffi_contract": root / "uxb/src/codegen/x64/mir_x64_type_class_ffi_contract.fbs",
        "mir_x64_type_class_ffi_emit_helpers": root / "uxb/src/codegen/x64/mir_x64_type_class_ffi_emit_helpers.fbs",
        "tr_i18n": root / "uxb/i18n/tr.json",
        "en_i18n": root / "uxb/i18n/en.json",
        "diagnostics": root / "uxb/src/runtime/diagnostics.fbs",
        "error_localization": root / "uxb/src/runtime/error_localization.fbs",
        "hook_trace": root / "uxb/src/runtime/hook_trace.fbs",
        "ffi_signer": root / "uxb/src/runtime/ffi_signer.fbs",
        "ffi_call_backend_x64": root / "uxb/src/codegen/x64/ffi_call_backend.fbs",
        "inline_backend_x64": root / "uxb/src/codegen/x64/inline_backend.fbs",
    }

    checks: List[Dict[str, Any]] = []
    for name, path in files.items():
        checks.append({
            "name": name,
            "kind": "file_exists",
            "path": str(path.relative_to(root)).replace("\\", "/"),
            "status": "PASS" if path.exists() else "MISSING",
        })

    cli_language_present = has_any(main_entry, ["--message-lang", "--language", "--dil", "--locale", "--lang"])
    checks.append({
        "name": "cli_message_language_option",
        "kind": "cli",
        "status": "PASS" if cli_language_present else "MISSING",
        "detail": "Expected --message-lang/--language/--dil."
    })

    log_options_present = has_any(main_entry, ["--log-out", "--debug-log-out", "--hook-trace", "--trace-json"])
    checks.append({
        "name": "cli_log_trace_options",
        "kind": "cli",
        "status": "PASS" if log_options_present else "MISSING",
    })

    include_contracts = {
        "compiler_message_bus": "compiler_message_bus.fbs" in main_bas,
        "layer_event_contract": "layer_event_contract.fbs" in main_bas,
        "type_class_ffi_backend_contract": "type_class_ffi_backend_contract.fbs" in main_bas,
        "mir_x64_type_class_ffi_contract": "mir_x64_type_class_ffi_contract.fbs" in main_bas,
        "mir_x64_type_class_ffi_emit_helpers": "mir_x64_type_class_ffi_emit_helpers.fbs" in main_bas,
    }
    for k, v in include_contracts.items():
        checks.append({
            "name": "include_" + k,
            "kind": "include",
            "status": "PASS" if v else "MISSING",
        })

    diagnostic_surfaces = []
    for s in ["CALL_DLL", "CALL_API", "IMPORT", "INLINE", "CLASS_DECL", "METHOD_DECL", "CTOR", "DTOR", "DELETE", "NEW", "LOAD_FIELD", "STORE_FIELD"]:
        if s in cap:
            # crude status: supported if in Return 1 case not diagnostic, needs manual review
            diagnostic_surfaces.append(s)

    report = {
        "schema_version": "uxb-step4-type-class-ffi-audit-1",
        "producer": "UXBc",
        "checks": checks,
        "diagnostic_surfaces_seen_in_mir_x64_capability": diagnostic_surfaces,
        "summary": {
            "pass": sum(1 for c in checks if c["status"] == "PASS"),
            "missing": sum(1 for c in checks if c["status"] == "MISSING"),
        }
    }

    (out / "step4_type_class_ffi_audit.json").write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")

    md = ["# UXBc Step 4 TYPE / CLASS / FFI Audit", ""]
    md.append(f"- PASS: `{report['summary']['pass']}`")
    md.append(f"- MISSING: `{report['summary']['missing']}`")
    md.append("")
    md.append("## Checks")
    md.append("")
    md.append("| name | kind | status | path/detail |")
    md.append("|---|---|---|---|")
    for c in checks:
        md.append(f"| {c['name']} | {c['kind']} | {c['status']} | `{c.get('path', c.get('detail',''))}` |")
    md.append("")
    md.append("## MIR x64 capability içinde görülen Step 4 yüzeyleri")
    md.append("")
    for s in diagnostic_surfaces:
        md.append(f"- `{s}`")
    (out / "step4_type_class_ffi_audit.md").write_text("\n".join(md), encoding="utf-8")

    missing = [c for c in checks if c["status"] == "MISSING"]
    cop = ["# Copilot Step 4 Missing Work", ""]
    cop.append("Copilot, sadece aşağıdaki eksikleri kapat. Yeni mimari icat etme.")
    cop.append("")
    for c in missing:
        cop.append(f"- `{c['name']}`: {c.get('detail','')} {c.get('path','')}")
    cop.append("")
    cop.append("## Öncelik")
    cop.append("")
    cop.append("1. CLI dil anahtarları: --message-lang / --language / --dil")
    cop.append("2. Contract dosyalarını include zincirine bağla")
    cop.append("3. Layer event loglarını ana katman giriş/çıkışlarına ekle")
    cop.append("4. TYPE field emit: LOAD_FIELD / STORE_FIELD")
    cop.append("5. CLASS direct method/THIS/NEW/DELETE/CTOR/DTOR")
    cop.append("6. FFI: CALL_DLL / CALL_API / IMPORT / INLINE guarded")
    (out / "copilot_step4_missing_work.md").write_text("\n".join(cop), encoding="utf-8")

    print("STEP4_AUDIT=" + str(out / "step4_type_class_ffi_audit.md"))
    print("COPILOT_MISSING=" + str(out / "copilot_step4_missing_work.md"))
    print("MISSING_COUNT=" + str(len(missing)))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
