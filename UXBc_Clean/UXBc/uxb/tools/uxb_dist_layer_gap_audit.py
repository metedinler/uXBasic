#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Audit dist CSV coverage across layers and emit a compact gap report.
"""

from __future__ import annotations

import csv
import json
from collections import Counter, defaultdict
from pathlib import Path
from typing import Dict, List


BAD_STATUSES = {
    "missing",
    "diagnostic_only",
    "partial",
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

    core_layers = [
        "lexer", "parser", "ast", "semantic", "hir", "mir",
        "ast_interpreter", "mir_interpreter", "x64_ast", "x64_mir", "runtime", "ffi", "tests", "docs"
    ]
    layer_missing: Dict[str, int] = {k: 0 for k in core_layers}
    sample_items: Dict[str, List[str]] = {k: [] for k in core_layers}

    for r in rows:
        item = r.get("name") or r.get("token") or r.get("kind") or "(unknown)"
        for layer in core_layers:
            st = norm(r.get(layer, ""))
            if st in BAD_STATUSES:
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

    for r in rows:
        kw = (r.get("keyword") or "").strip()
        cat = norm(r.get("category", ""))
        if cat == "unknown":
            unknown_keywords.append(kw)

        ast_i = norm(r.get("interpreter_ast", ""))
        mir_i = norm(r.get("interpreter_mir", ""))
        if ast_i != mir_i:
            # Only flag if one is clearly weaker than the other.
            ast_bad = ast_i in BAD_STATUSES
            mir_bad = mir_i in BAD_STATUSES
            if ast_bad != mir_bad:
                ast_mir_mismatch.append({
                    "keyword": kw,
                    "ast": ast_i,
                    "mir": mir_i,
                })

    return {
        "path": str(path),
        "row_count": len(rows),
        "unknown_keyword_count": len(unknown_keywords),
        "unknown_keywords_sample": sorted(set([k for k in unknown_keywords if k]))[:40],
        "ast_mir_mismatch_count": len(ast_mir_mismatch),
        "ast_mir_mismatch_sample": ast_mir_mismatch[:40],
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

    js_wasm = {
        "js_transpiler_column_present": False,
        "wasm_column_present": False,
        "note": "Dist core matrices do not have dedicated js_transpiler/wasm columns; coverage is not proven by matrix schema.",
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
