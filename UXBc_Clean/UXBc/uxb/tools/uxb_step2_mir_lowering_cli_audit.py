#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
UXBc Step 2 audit:
- MIR opcode/lowering contract report
- CLI pipeline audit
- Copilot Step 4 lowering targets

This script does not modify compiler sources.
"""

from __future__ import annotations

import json
import re
import csv
from pathlib import Path
from typing import Dict, List, Any


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


def extract_cli_options(text: str) -> List[str]:
    return sorted(set(re.findall(r'--[A-Za-z0-9_\-]+', text)))


def extract_known_opcodes(repo: Path) -> List[str]:
    files = [
        repo / "uxb/src/semantic/mir_opcode_contract.fbs",
        repo / "uxb/src/semantic/mir_verifier.fbs",
        repo / "uxb/src/semantic/mir_full_exporter_json.fbs",
        repo / "uxb/src/codegen/x64/mir_x64_capability.fbs",
    ]
    ops = set()
    for f in files:
        text = read(f)
        for m in re.finditer(r'"([A-Z][A-Z0-9_]+)"', text):
            s = m.group(1)
            if len(s) >= 2 and not s.startswith("UXB"):
                ops.add(s)
    return sorted(ops)


def extract_surface_matrix(repo: Path) -> Dict[str, Any]:
    json_path = repo / "uxb/dist/surface/language_surface_full_matrix.json"
    if json_path.exists():
        try:
            return json.loads(read(json_path))
        except Exception:
            pass
    return {}


def main() -> int:
    repo = find_root(Path("."))
    out = repo / "uxb/dist/step2"
    out.mkdir(parents=True, exist_ok=True)

    main_bas = read(repo / "uxb/src/main.bas")
    entry = read(repo / "uxb/src/main_program_entry.fbs")
    switch_text = main_bas + "\n" + entry

    cli_options = extract_cli_options(switch_text)
    required_cli = [
        "--execmem",
        "--interpreter-backend",
        "--emit-x64-nasm",
        "--emit-x64-nasm-out",
        "--build-x64",
        "--codegen-source",
        "--enable-mir-x64-experimental",
        "--ast-json-out",
        "--ast-full-json-out",
        "--hir-json-out",
        "--hir-full-json-out",
        "--mir-module-json-out",
        "--mir-full-json-out",
        "--mir-verify-json-out",
        "--artifact-report-json-out",
        "--x64-codegen-policy-json-out",
        "--console-mode",
        "--program-output-json-out",
    ]

    cli = {
        "schema_version": "uxb-step2-cli-pipeline-audit-1",
        "producer": "uXBasiC",
        "found_option_count": len(cli_options),
        "found_options": cli_options,
        "required_options": required_cli,
        "missing_required_options": [o for o in required_cli if o not in cli_options],
        "pipeline_expectation": {
            "ast_interpreter": "--execmem --interpreter-backend AST",
            "mir_interpreter": "--execmem --interpreter-backend MIR",
            "x64_ast_asm": "--emit-x64-nasm --codegen-source AST",
            "x64_mir_asm": "--emit-x64-nasm --codegen-source MIR --enable-mir-x64-experimental",
            "x64_ast_exe": "--build-x64 --codegen-source AST",
            "x64_mir_exe": "--build-x64 --codegen-source MIR --enable-mir-x64-experimental",
            "x86": "legacy/secondary backend; must be reported but not primary target"
        }
    }
    (out / "cli_pipeline_audit.json").write_text(json.dumps(cli, indent=2, ensure_ascii=False), encoding="utf-8")

    cli_md = ["# Step 2 CLI Pipeline Audit", ""]
    cli_md.append(f"- found_option_count: `{len(cli_options)}`")
    cli_md.append("")
    cli_md.append("## Missing required options")
    cli_md.append("")
    if cli["missing_required_options"]:
        for o in cli["missing_required_options"]:
            cli_md.append(f"- `{o}`")
    else:
        cli_md.append("- none")
    cli_md.append("")
    cli_md.append("## Found options")
    cli_md.append("")
    for o in cli_options:
        cli_md.append(f"- `{o}`")
    (out / "cli_pipeline_audit.md").write_text("\n".join(cli_md), encoding="utf-8")

    opcodes = extract_known_opcodes(repo)
    contract = {
        "schema_version": "uxb-step2-mir-opcode-contract-report-1",
        "producer": "uXBasiC",
        "opcode_count": len(opcodes),
        "opcodes": opcodes,
        "contract_files": [
            "uxb/src/semantic/mir_opcode_contract.fbs",
            "uxb/src/semantic/mir_lowering_contract.fbs",
        ]
    }
    (out / "mir_opcode_contract_report.json").write_text(json.dumps(contract, indent=2, ensure_ascii=False), encoding="utf-8")
    md = ["# MIR Opcode Contract Report", "", f"- opcode_count: `{len(opcodes)}`", ""]
    for op in opcodes:
        md.append(f"- `{op}`")
    (out / "mir_opcode_contract_report.md").write_text("\n".join(md), encoding="utf-8")

    surface = extract_surface_matrix(repo)
    targets: List[Dict[str, Any]] = []
    if surface and isinstance(surface.get("items"), list):
        for item in surface["items"]:
            layers = item.get("layers", {})
            mir_status = str(layers.get("mir", "")).lower()
            x64_mir_status = str(layers.get("x64_mir", "")).lower()
            if mir_status in {"missing", "diagnostic_only", "unknown", ""} or x64_mir_status in {"missing", "diagnostic_only", "unknown", ""}:
                targets.append({
                    "name": item.get("name") or item.get("surface") or item.get("keyword") or "",
                    "kind": item.get("kind", ""),
                    "mir": mir_status,
                    "x64_mir": x64_mir_status,
                })
    else:
        targets.append({
            "name": "RUN_LANGUAGE_SURFACE_MATRIX_FIRST",
            "kind": "meta",
            "mir": "unknown",
            "x64_mir": "unknown",
        })

    target_md = [
        "# Copilot Step 4 MIR Lowering Targets",
        "",
        "Copilot, bu dosya otomatik üretildi.",
        "Yeni mimari icat etme. Sadece burada görülen eksikleri tamamla.",
        "",
        "## Kurallar",
        "",
        "1. Parser/AST/Semantic zaten destekliyorsa MIR lowering ekle.",
        "2. MIR lowering varsa x64_mir emit ekle.",
        "3. Runtime isteyen öğelerde sahte native kod yazma; runtime call veya diagnostic ver.",
        "4. x64 AST codegen'i bozma.",
        "5. x86 hattını silme; sadece secondary/legacy olarak raporla.",
        "",
        "## Targets",
        "",
        "| name | kind | mir | x64_mir |",
        "|---|---|---|---|",
    ]
    for t in targets[:300]:
        target_md.append(f"| {t['name']} | {t['kind']} | {t['mir']} | {t['x64_mir']} |")
    (out / "copilot_step4_mir_lowering_targets.md").write_text("\n".join(target_md), encoding="utf-8")

    print("STEP2_OUT=" + str(out))
    print("CLI_MISSING=" + str(len(cli["missing_required_options"])))
    print("OPCODE_COUNT=" + str(len(opcodes)))
    print("TARGET_COUNT=" + str(len(targets)))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
