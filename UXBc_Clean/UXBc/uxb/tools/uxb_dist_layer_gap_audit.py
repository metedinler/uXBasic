#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Audit dist CSV coverage across layers and emit a compact gap report.
"""

from __future__ import annotations

import csv
import json
import sys
from collections import Counter, defaultdict
from pathlib import Path
from typing import Dict, List

TOOL_DIR = Path(__file__).resolve().parent
if str(TOOL_DIR) not in sys.path:
    sys.path.insert(0, str(TOOL_DIR))

from uxb_layer_status_policy import CANONICAL_SET


BAD_OBSERVED_STATUSES = {
    "missing",
    "diagnostic_only",
    "partial",
    "policy_only",
    "blocked",
    "pending",
    "unsupported",
}


def find_root(start: Path) -> Path:
    p = start.resolve()
    for c in [p] + list(p.parents):
        if (c / "uxb" / "src").is_dir():
            return c
    raise SystemExit("UXBc root not found")


def norm(v: str) -> str:
    return (v or "").strip().lower()


def read_csv_rows(path: Path) -> List[Dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8", errors="ignore", newline="") as f:
        return list(csv.DictReader(f))


def audit_surface_matrix(path: Path) -> Dict[str, object]:
    rows = read_csv_rows(path)
    if not rows:
        return {"path": str(path), "row_count": 0, "layer_missing": {}, "sample_items": {}}

    base_layers = [
        "lexer", "parser", "ast", "semantic", "hir", "mir",
        "ast_interpreter", "mir_interpreter", "x64_ast", "x64_mir", "runtime", "ffi",
        "js_transpiler", "wasm_emitter", "browser_runtime", "tests", "docs",
    ]
    core_layers = [x for x in base_layers if x in rows[0]]
    layer_missing: Dict[str, int] = {k: 0 for k in core_layers}
    sample_items: Dict[str, List[str]] = {k: [] for k in core_layers}

    for r in rows:
        item = r.get("name") or r.get("token") or r.get("kind") or "(unknown)"
        for layer in core_layers:
            st = norm(r.get(layer, ""))
            if st in BAD_OBSERVED_STATUSES:
                layer_missing[layer] += 1
                if len(sample_items[layer]) < 8:
                    sample_items[layer].append(f"{item}:{st}")

    return {
        "path": str(path),
        "row_count": len(rows),
        "layer_missing": layer_missing,
        "sample_items": sample_items,
    }


def audit_keyword_layer_matrix(path: Path) -> Dict[str, object]:
    rows = read_csv_rows(path)
    if not rows:
        return {"path": str(path), "row_count": 0, "unknown_keywords": [], "ast_mir_mismatch": []}

    unknown_keywords = []
    ast_mir_mismatch = []

    invalid_decision = []
    decision_columns = [c for c in rows[0].keys() if c.startswith("decision_")] if rows else []

    for r in rows:
        kw = (r.get("keyword") or "").strip()
        cat = norm(r.get("category", ""))
        if cat == "unknown":
            unknown_keywords.append(kw)

        ast_col = "decision_interpreter_ast" if "decision_interpreter_ast" in decision_columns else "interpreter_ast"
        mir_col = "decision_interpreter_mir" if "decision_interpreter_mir" in decision_columns else "interpreter_mir"
        ast_i = norm(r.get(ast_col, ""))
        mir_i = norm(r.get(mir_col, ""))
        if ast_i != mir_i:
            # Only flag if one is clearly weaker than the other.
            ast_bad = ast_i in BAD_OBSERVED_STATUSES
            mir_bad = mir_i in BAD_OBSERVED_STATUSES
            if ast_bad != mir_bad:
                ast_mir_mismatch.append({
                    "keyword": kw,
                    "ast": ast_i,
                    "mir": mir_i,
                })

        for c in decision_columns:
            st = (r.get(c) or "").strip().upper()
            if st not in CANONICAL_SET and len(invalid_decision) < 50:
                invalid_decision.append({"keyword": kw, "column": c, "status": st})

    return {
        "path": str(path),
        "row_count": len(rows),
        "unknown_keyword_count": len(unknown_keywords),
        "unknown_keywords_sample": sorted(set([k for k in unknown_keywords if k]))[:40],
        "ast_mir_mismatch_count": len(ast_mir_mismatch),
        "ast_mir_mismatch_sample": ast_mir_mismatch[:40],
        "decision_column_count": len(decision_columns),
        "decision_columns": decision_columns,
        "invalid_decision_count": len(invalid_decision),
        "invalid_decision_sample": invalid_decision[:40],
    }


def audit_expected_runner(path: Path) -> Dict[str, object]:
    rows = read_csv_rows(path)
    if not rows:
        return {"path": str(path), "row_count": 0}

    broken_layer_ctr = Counter()
    actual_ctr = Counter()
    accepted_no = 0

    for r in rows:
        actual = (r.get("actual_status") or "").strip()
        broken = (r.get("broken_layer") or "").strip()
        accepted = (r.get("accepted") or "").strip().upper()
        if actual:
            actual_ctr[actual] += 1
        if broken:
            broken_layer_ctr[broken] += 1
        if accepted == "NO":
            accepted_no += 1

    return {
        "path": str(path),
        "row_count": len(rows),
        "accepted_no_count": accepted_no,
        "actual_status_counts": dict(actual_ctr),
        "broken_layer_counts": dict(broken_layer_ctr),
    }


def main() -> int:
    root = find_root(Path("."))
    dist = root / "uxb" / "dist"
    out_dir = dist / "step7"
    out_dir.mkdir(parents=True, exist_ok=True)

    surf = audit_surface_matrix(dist / "surface" / "language_surface_full_matrix.csv")
    kw = audit_keyword_layer_matrix(dist / "keyword_layer_matrix.csv")
    exp = audit_expected_runner(dist / "step6" / "expected_runner.csv")

    kw_decision_cols = set(kw.get("decision_columns", []))
    js_wasm = {
        "js_transpiler_column_present": "decision_js_transpiler" in kw_decision_cols,
        "wasm_column_present": "decision_wasm_emitter" in kw_decision_cols,
        "browser_runtime_column_present": "decision_browser_runtime" in kw_decision_cols,
        "invalid_decision_count": kw.get("invalid_decision_count", 0),
        "note": "Keyword matrix decision columns are used as architecture contract when present.",
    }

    report = {
        "schema_version": "uxb-dist-layer-gap-audit-1",
        "surface_matrix": surf,
        "keyword_layer_matrix": kw,
        "expected_runner": exp,
        "js_wasm_matrix_coverage": js_wasm,
    }

    json_path = out_dir / "dist_layer_gap_audit.json"
    md_path = out_dir / "dist_layer_gap_audit.md"
    json_path.write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")

    md: List[str] = ["# UXBc Dist Layer Gap Audit", ""]
    md.append("## Surface Matrix")
    md.append(f"- rows: `{surf.get('row_count', 0)}`")
    md.append("- layer missing/partial/diagnostic counts:")
    for k, v in sorted(surf.get("layer_missing", {}).items(), key=lambda kv: (-kv[1], kv[0])):
        md.append(f"  - {k}: `{v}`")

    md.append("")
    md.append("## Keyword Layer Matrix")
    md.append(f"- rows: `{kw.get('row_count', 0)}`")
    md.append(f"- unknown keyword count: `{kw.get('unknown_keyword_count', 0)}`")
    sample_unknown = kw.get("unknown_keywords_sample", [])
    if sample_unknown:
        md.append(f"- unknown sample: `{', '.join(sample_unknown[:20])}`")
    md.append(f"- AST/MIR interpreter mismatch count: `{kw.get('ast_mir_mismatch_count', 0)}`")
    md.append(f"- decision column count: `{kw.get('decision_column_count', 0)}`")
    md.append(f"- invalid decision count: `{kw.get('invalid_decision_count', 0)}`")

    md.append("")
    md.append("## Step6 Expected Runner")
    md.append(f"- rows: `{exp.get('row_count', 0)}`")
    md.append(f"- accepted NO count: `{exp.get('accepted_no_count', 0)}`")
    md.append("- actual status counts:")
    for k, v in sorted(exp.get("actual_status_counts", {}).items(), key=lambda kv: (-kv[1], kv[0])):
        md.append(f"  - {k}: `{v}`")

    md.append("")
    md.append("## JS/WASM Coverage Schema")
    md.append(f"- js_transpiler_column_present: `{js_wasm['js_transpiler_column_present']}`")
    md.append(f"- wasm_column_present: `{js_wasm['wasm_column_present']}`")
    md.append(f"- note: {js_wasm['note']}")

    md_path.write_text("\n".join(md), encoding="utf-8")

    print("DIST_LAYER_GAP_AUDIT=" + str(md_path))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
