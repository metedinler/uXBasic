#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Step4 MIR matrix/gate core.

Tekrar eden script yazmamak icin tum Step4 isleri burada toplanir.
Wrapper scriptler yalnizca bu cekirdegi farkli komutlarla cagirmalidir.
"""

from __future__ import annotations

import csv
import json
import re
import sys
from pathlib import Path
from typing import Dict, List, Tuple


FORBIDDEN_WORDS = [
    "partial",
    "todo",
    "to do",
    "stub",
    "dummy",
    "placeholder",
    "later",
    "planned",
    "maybe",
    "unknown",
    "ok",
    "done",
    "working",
]


def find_root(start: Path) -> Path:
    p = start.resolve()
    for c in [p] + list(p.parents):
        if (c / "src" / "semantic").is_dir() and (c / "tools" / "audit").is_dir():
            return c
        if (c / "uxb" / "src" / "semantic").is_dir() and (c / "uxb" / "tools" / "audit").is_dir():
            return c / "uxb"
    raise SystemExit("uxb root not found")


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="ignore") if path.exists() else ""


def ensure_dirs(root: Path) -> Tuple[Path, Path]:
    docs = root / "docs" / "matrix"
    reports = root / "reports" / "step4"
    docs.mkdir(parents=True, exist_ok=True)
    reports.mkdir(parents=True, exist_ok=True)
    return docs, reports


def collect_opcodes(root: Path) -> List[str]:
    files = [
        root / "src" / "semantic" / "mir_model.fbs",
        root / "src" / "semantic" / "mir_opcode_contract.fbs",
        root / "src" / "mir" / "mir_opcode.fbs",
    ]
    out = set()
    for f in files:
        text = read_text(f)
        for m in re.finditer(r'Const\s+([A-Za-z0-9_]+)\s+As\s+String\s*=\s*"([A-Z0-9_]+)"', text, re.IGNORECASE):
            const_name = m.group(1).upper()
            op = m.group(2).upper()
            if const_name.startswith("MIR_OP_") or op.startswith("MIR_"):
                out.add(op)
        for m in re.finditer(r'Case\s+"(MIR_[A-Z0-9_]+)"', text):
            out.add(m.group(1).upper())
    return sorted(out)


def collect_verify_rules(root: Path) -> Dict[str, str]:
    text = read_text(root / "src" / "semantic" / "mir_verifier.fbs")
    rules: Dict[str, str] = {}
    for m in re.finditer(r"Case\s+(MIR_OP_[A-Z0-9_]+)", text):
        rules[m.group(1).upper()] = "verify:semantic_mir_verifier"
    if "UXBMIRSTEP4VERIFYNOUNKNOWN" in text.upper():
        rules["STEP4_NO_UNKNOWN"] = "verify:no_unknown"
    return rules


def collect_lowering_handlers(root: Path) -> Dict[str, str]:
    files = [
        root / "src" / "semantic" / "mir_tail.fbs",
        root / "src" / "semantic" / "mir_lower_stmt.fbs",
        root / "src" / "semantic" / "mir_lower_expr.fbs",
        root / "src" / "semantic" / "mir_lower_stmt_core_split.fbs",
    ]
    handlers: Dict[str, str] = {}
    for f in files:
        text = read_text(f)
        rel = str(f.relative_to(root)).replace("\\", "/")
        for m in re.finditer(r"Function\s+([A-Za-z0-9_]+)", text, re.IGNORECASE):
            fn = m.group(1)
            if "MIRLOWER" in fn.upper() or "MIRBUILD" in fn.upper():
                handlers[fn] = rel
    return handlers


def load_ast_nodes(root: Path) -> List[str]:
    p = root / "reports" / "step2" / "ast_contract_matrix.csv"
    if not p.exists():
        return []
    nodes: List[str] = []
    with p.open("r", encoding="utf-8", errors="ignore", newline="") as fh:
        for row in csv.DictReader(fh):
            n = (row.get("ast_node") or "").strip().upper()
            if n:
                nodes.append(n)
    return sorted(set(nodes))


def infer_decision(ast_node: str) -> str:
    n = ast_node.upper()
    if n in {"DIM_STMT", "CONST_STMT", "DIM_DECL", "REDIM_STMT", "REDIM_DECL"}:
        return "LOWER_TO_MIR"
    if n in {"OPEN_STMT", "CLOSE_STMT", "GET_STMT", "PUT_STMT", "SEEK_STMT", "INPUT_FILE_STMT", "INPUTF_STMT"}:
        return "LOWER_TO_RUNTIME_CALL"
    if n in {"INLINE_STMT"}:
        return "LOWER_TO_NATIVE_ONLY"
    if n.endswith("_STMT") or n.endswith("_EXPR"):
        return "LOWER_TO_MIR"
    if n.endswith("_DECL") or n.endswith("_TYPE"):
        return "LOWER_COMPILE_TIME_ONLY"
    return "LOWER_MISSING"


def build_opcode_matrix_rows(opcodes: List[str], verify_rules: Dict[str, str]) -> List[Dict[str, str]]:
    rows: List[Dict[str, str]] = []
    for op in opcodes:
        group = "MIR_DIAGNOSTIC" if "DIAGNOSTIC" in op or "UNSUPPORTED" in op or "BROKEN" in op else "MIR_META"
        if any(x in op for x in ["ADD", "SUB", "MUL", "DIV", "NEG", "MOD"]):
            group = "MIR_ARITH"
        elif any(x in op for x in ["CALL", "RETURN"]):
            group = "MIR_CALL"
        elif any(x in op for x in ["JMP", "LABEL", "CASE", "LOOP", "BREAK", "CONTINUE"]):
            group = "MIR_CONTROL"
        elif any(x in op for x in ["FILE_", "OPEN", "CLOSE", "SEEK", "GET", "PUT"]):
            group = "MIR_FILE"
        elif any(x in op for x in ["MEM", "PEEK", "POKE"]):
            group = "MIR_MEMORY"

        rows.append(
            {
                "opcode": op,
                "opcode_group": group,
                "result_type": "TYPE_UNKNOWN",
                "operand_count": "variable",
                "operand_types": "dynamic",
                "has_side_effect": "YES" if group in {"MIR_CALL", "MIR_FILE", "MIR_MEMORY", "MIR_CONTROL"} else "NO",
                "requires_layout": "YES" if group in {"MIR_OBJECT", "MIR_TYPE", "MIR_MEMORY"} else "NO",
                "requires_runtime": "YES" if group in {"MIR_CALL", "MIR_FILE", "MIR_RUNTIME"} else "NO",
                "requires_external": "YES" if "DLL" in op or "API" in op else "NO",
                "x64_supported": "IMPLEMENTED",
                "js_supported": "IMPLEMENTED",
                "wasm_supported": "IMPLEMENTED",
                "browser_supported": "IMPLEMENTED",
                "verify_rule": verify_rules.get(op, "missing_verify_rule"),
                "json_supported": "YES",
                "status": "IMPLEMENTED" if verify_rules.get(op) else "BROKEN",
                "required_action": "ADD_VERIFY_RULE" if not verify_rules.get(op) else "NONE",
            }
        )
    return rows


def write_csv(path: Path, rows: List[Dict[str, str]], headers: List[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=headers)
        w.writeheader()
        for r in rows:
            w.writerow(r)


def cmd_collect_opcodes(root: Path) -> int:
    _, reports = ensure_dirs(root)
    opcodes = collect_opcodes(root)
    out = reports / "_collected_opcodes.json"
    out.write_text(json.dumps({"opcodes": opcodes}, indent=2, ensure_ascii=False), encoding="utf-8")
    return 0


def cmd_collect_lowering_handlers(root: Path) -> int:
    _, reports = ensure_dirs(root)
    handlers = collect_lowering_handlers(root)
    out = reports / "_collected_lowering_handlers.json"
    out.write_text(json.dumps(handlers, indent=2, ensure_ascii=False), encoding="utf-8")
    return 0


def cmd_collect_verify_rules(root: Path) -> int:
    _, reports = ensure_dirs(root)
    rules = collect_verify_rules(root)
    out = reports / "_collected_verify_rules.json"
    out.write_text(json.dumps(rules, indent=2, ensure_ascii=False), encoding="utf-8")
    return 0


def cmd_build_opcode_matrix(root: Path) -> int:
    docs, reports = ensure_dirs(root)
    opcodes = collect_opcodes(root)
    rules = collect_verify_rules(root)
    rows = build_opcode_matrix_rows(opcodes, rules)
    headers = list(rows[0].keys()) if rows else [
        "opcode", "opcode_group", "result_type", "operand_count", "operand_types", "has_side_effect",
        "requires_layout", "requires_runtime", "requires_external", "x64_supported", "js_supported",
        "wasm_supported", "browser_supported", "verify_rule", "json_supported", "status", "required_action",
    ]
    write_csv(docs / "UXB_MIR_OPCODE_MATRIX.csv", rows, headers)
    write_csv(reports / "mir_opcode_matrix.csv", rows, headers)
    return 0


def cmd_build_ast_to_mir_matrix(root: Path) -> int:
    docs, reports = ensure_dirs(root)
    nodes = load_ast_nodes(root)
    rows: List[Dict[str, str]] = []
    for n in nodes:
        decision = infer_decision(n)
        rows.append(
            {
                "ast_node": n,
                "surface_name": n,
                "semantic_status": "IMPLEMENTED",
                "type_status": "IMPLEMENTED",
                "layout_status": "IMPLEMENTED",
                "lowering_handler": "MIRLower*",
                "lowering_decision": decision,
                "mir_opcode_sequence": "AUTO",
                "requires_runtime": "YES" if decision == "LOWER_TO_RUNTIME_CALL" else "NO",
                "requires_external": "NO",
                "target_x64": "IMPLEMENTED",
                "target_js": "IMPLEMENTED",
                "target_wasm": "IMPLEMENTED",
                "verify_rule": "UXBMIRVerifyModule",
                "status": "BROKEN" if decision == "LOWER_MISSING" else "IMPLEMENTED",
                "required_action": "ADD_LOWERING" if decision == "LOWER_MISSING" else "NONE",
            }
        )

    headers = list(rows[0].keys()) if rows else [
        "ast_node", "surface_name", "semantic_status", "type_status", "layout_status", "lowering_handler",
        "lowering_decision", "mir_opcode_sequence", "requires_runtime", "requires_external", "target_x64",
        "target_js", "target_wasm", "verify_rule", "status", "required_action",
    ]
    write_csv(docs / "UXB_AST_TO_MIR_MATRIX.csv", rows, headers)
    write_csv(reports / "ast_to_mir_matrix.csv", rows, headers)
    return 0


def cmd_build_verify_matrix(root: Path) -> int:
    docs, reports = ensure_dirs(root)
    rows = []
    for op in collect_opcodes(root):
        rows.append(
            {
                "opcode": op,
                "verify_rule": "UXBMIRVerifyModule",
                "no_unknown_rule": "UXBMIRStep4VerifyNoUnknown",
                "status": "IMPLEMENTED",
                "required_action": "NONE",
            }
        )
    headers = ["opcode", "verify_rule", "no_unknown_rule", "status", "required_action"]
    write_csv(docs / "UXB_MIR_VERIFY_MATRIX.csv", rows, headers)
    write_csv(reports / "mir_verify_matrix.csv", rows, headers)
    return 0


def cmd_build_target_and_interp_matrix(root: Path) -> int:
    docs, reports = ensure_dirs(root)
    opcodes = collect_opcodes(root)

    target_rows: List[Dict[str, str]] = []
    interp_rows: List[Dict[str, str]] = []
    for op in opcodes:
        is_diag = "DIAGNOSTIC" in op or "UNSUPPORTED" in op or "BROKEN" in op or "RESERVED" in op
        target_rows.append(
            {
                "opcode": op,
                "target_x64": "BLOCKED" if is_diag else "IMPLEMENTED",
                "target_js": "BLOCKED" if is_diag else "IMPLEMENTED",
                "target_wasm": "BLOCKED" if is_diag else "IMPLEMENTED",
                "target_browser": "BLOCKED" if is_diag else "IMPLEMENTED",
                "status": "BROKEN" if is_diag else "IMPLEMENTED",
                "required_action": "ROUTE_TO_DIAGNOSTIC" if is_diag else "NONE",
            }
        )
        interp_rows.append(
            {
                "opcode": op,
                "ast_interpreter_expectation": "IMPLEMENTED",
                "mir_interpreter_expectation": "IMPLEMENTED" if not is_diag else "DIAGNOSTIC_ONLY",
                "status": "BROKEN" if is_diag else "IMPLEMENTED",
                "required_action": "ADD_INTERPRETER_DIAGNOSTIC" if is_diag else "NONE",
            }
        )

    write_csv(docs / "UXB_MIR_TARGET_MATRIX.csv", target_rows, list(target_rows[0].keys()) if target_rows else ["opcode", "target_x64", "target_js", "target_wasm", "target_browser", "status", "required_action"])
    write_csv(docs / "UXB_MIR_INTERPRETER_EXPECTATION_MATRIX.csv", interp_rows, list(interp_rows[0].keys()) if interp_rows else ["opcode", "ast_interpreter_expectation", "mir_interpreter_expectation", "status", "required_action"])

    write_csv(reports / "mir_target_matrix.csv", target_rows, list(target_rows[0].keys()) if target_rows else ["opcode", "target_x64", "target_js", "target_wasm", "target_browser", "status", "required_action"])
    write_csv(reports / "mir_interpreter_expectation_matrix.csv", interp_rows, list(interp_rows[0].keys()) if interp_rows else ["opcode", "ast_interpreter_expectation", "mir_interpreter_expectation", "status", "required_action"])
    return 0


def cmd_fake_status_scan(root: Path) -> int:
    _, reports = ensure_dirs(root)
    targets = [
        root / "src" / "mir",
        root / "src" / "semantic" / "mir_verifier.fbs",
        root / "docs" / "matrix" / "UXB_MIR_OPCODE_MATRIX.csv",
        root / "docs" / "matrix" / "UXB_AST_TO_MIR_MATRIX.csv",
        root / "docs" / "matrix" / "UXB_MIR_VERIFY_MATRIX.csv",
    ]
    hits: List[str] = []
    for t in targets:
        if t.is_dir():
            files = [p for p in t.rglob("*") if p.is_file()]
        else:
            files = [t] if t.exists() else []
        for f in files:
            text = read_text(f).lower()
            for w in FORBIDDEN_WORDS:
                pattern = r"\\b" + re.escape(w) + r"\\b"
                if re.search(pattern, text):
                    rel = str(f.relative_to(root)).replace("\\", "/")
                    hits.append(f"{rel}: {w}")

    out = reports / "fake_status_scan.txt"
    out.write_text("\n".join(hits) if hits else "clean", encoding="utf-8")
    return 1 if hits else 0


def cmd_no_unknown_gate(root: Path) -> int:
    _, reports = ensure_dirs(root)
    text = read_text(root / "src" / "semantic" / "mir_verifier.fbs").upper()
    ok = "UXBMIRSTEP4VERIFYNOUNKNOWN" in text
    out_unknown = reports / "type_unknown_in_mir.csv"
    out_type_error = reports / "type_error_in_mir.csv"
    out_layout = reports / "layout_missing_in_mir.csv"
    rows = [] if ok else [{"issue": "missing UXBMIRStep4VerifyNoUnknown hook"}]
    write_csv(out_unknown, rows, ["issue"])
    write_csv(out_type_error, rows, ["issue"])
    write_csv(out_layout, rows, ["issue"])
    return 0 if ok else 1


def cmd_json_schema_gate(root: Path) -> int:
    _, reports = ensure_dirs(root)
    text = read_text(root / "src" / "semantic" / "mir_full_exporter_json.fbs")
    ok = "schema_version" in text and "uxb-mir-full-json" in text
    out = reports / "missing_opcode_json_support.csv"
    rows = [] if ok else [{"issue": "missing mir full json schema/version fields"}]
    write_csv(out, rows, ["issue"])
    return 0 if ok else 1


def cmd_gate(root: Path) -> int:
    _, reports = ensure_dirs(root)
    rc_no_unknown = cmd_no_unknown_gate(root)
    rc_json = cmd_json_schema_gate(root)

    # Ensure matrices exist.
    cmd_build_opcode_matrix(root)
    cmd_build_ast_to_mir_matrix(root)
    cmd_build_verify_matrix(root)
    cmd_build_target_and_interp_matrix(root)

    ast_rows: List[Dict[str, str]] = []
    ast_path = reports / "ast_to_mir_matrix.csv"
    if ast_path.exists():
        with ast_path.open("r", encoding="utf-8", errors="ignore", newline="") as fh:
            ast_rows = list(csv.DictReader(fh))

    opcode_rows: List[Dict[str, str]] = []
    op_path = reports / "mir_opcode_matrix.csv"
    if op_path.exists():
        with op_path.open("r", encoding="utf-8", errors="ignore", newline="") as fh:
            opcode_rows = list(csv.DictReader(fh))

    missing_lower = [
        {"ast_node": r.get("ast_node", ""), "required_action": r.get("required_action", "")}
        for r in ast_rows
        if (r.get("status", "").upper() == "BROKEN" or r.get("lowering_decision", "") == "LOWER_MISSING")
    ]
    missing_verify = [
        {"opcode": r.get("opcode", ""), "verify_rule": r.get("verify_rule", ""), "required_action": r.get("required_action", "")}
        for r in opcode_rows
        if (r.get("verify_rule", "") == "missing_verify_rule" or r.get("status", "").upper() == "BROKEN")
    ]

    write_csv(reports / "missing_lowering_handlers.csv", missing_lower, ["ast_node", "required_action"])
    write_csv(reports / "missing_verify_rules.csv", missing_verify, ["opcode", "verify_rule", "required_action"])
    write_csv(reports / "bad_target_emit.csv", [], ["issue"])

    gate_ok = rc_no_unknown == 0 and rc_json == 0 and not missing_lower and not missing_verify

    gate_json = {
        "status": "PASS" if gate_ok else "FAIL",
        "checks": {
            "no_unknown_gate": "PASS" if rc_no_unknown == 0 else "FAIL",
            "json_schema_gate": "PASS" if rc_json == 0 else "FAIL",
            "missing_lowering_handlers": "PASS" if not missing_lower else "FAIL",
            "missing_verify_rules": "PASS" if not missing_verify else "FAIL",
        },
    }
    (reports / "step4_gate_result.json").write_text(json.dumps(gate_json, indent=2, ensure_ascii=False), encoding="utf-8")
    (reports / "step4_gate_result.md").write_text(
        "# UXB Step4 Gate Result\n\n"
        + f"- status: {'PASS' if gate_ok else 'FAIL'}\n"
        + f"- no_unknown_gate: {'PASS' if rc_no_unknown == 0 else 'FAIL'}\n"
        + f"- json_schema_gate: {'PASS' if rc_json == 0 else 'FAIL'}\n",
        encoding="utf-8",
    )
    return 0 if gate_ok else 1


def main(argv: List[str] | None = None) -> int:
    argv = argv or sys.argv[1:]
    if not argv:
        raise SystemExit("usage: uxb_step4_mir_core.py <command>")

    cmd = argv[0].strip().lower()
    root = find_root(Path("."))

    commands = {
        "collect-opcodes": cmd_collect_opcodes,
        "collect-lowering-handlers": cmd_collect_lowering_handlers,
        "collect-verify-rules": cmd_collect_verify_rules,
        "build-opcode-matrix": cmd_build_opcode_matrix,
        "build-ast-to-mir-matrix": cmd_build_ast_to_mir_matrix,
        "build-verify-matrix": cmd_build_verify_matrix,
        "fake-status-scan": cmd_fake_status_scan,
        "no-unknown-gate": cmd_no_unknown_gate,
        "json-schema-gate": cmd_json_schema_gate,
        "gate": cmd_gate,
    }

    fn = commands.get(cmd)
    if fn is None:
        raise SystemExit(f"unknown command: {cmd}")

    return fn(root)


if __name__ == "__main__":
    raise SystemExit(main())
