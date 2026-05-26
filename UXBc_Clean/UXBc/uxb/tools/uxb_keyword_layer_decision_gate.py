#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Gate for canonical keyword layer decision statuses."""
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


def find_root(start: Path) -> Path:
    p = start.resolve()
    for c in [p] + list(p.parents):
        if (c / "uxb" / "src").is_dir():
            return c
    raise SystemExit("UXBc root not found")


def read_rows(path: Path) -> List[Dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8", errors="ignore", newline="") as f:
        return list(csv.DictReader(f))


def main() -> int:
    root = find_root(Path("."))
    dist = root / "uxb" / "dist"
    out = dist / "step6"
    out.mkdir(parents=True, exist_ok=True)

    matrix_csv = dist / "keyword_layer_matrix.csv"
    rows = read_rows(matrix_csv)
    blockers: List[str] = []
    warnings: List[str] = []

    if not rows:
        blockers.append("keyword_layer_matrix.csv not found or empty")

    decision_columns: List[str] = []
    if rows:
        decision_columns = [c for c in rows[0].keys() if c.startswith("decision_")]
        if not decision_columns:
            blockers.append("decision_* columns are missing in keyword_layer_matrix.csv")

    invalid_samples: Dict[str, List[str]] = defaultdict(list)
    by_layer_status: Dict[str, Counter] = {c: Counter() for c in decision_columns}

    for r in rows:
        kw = (r.get("keyword") or "").strip() or "(unknown)"
        for c in decision_columns:
            status = (r.get(c) or "").strip().upper()
            by_layer_status[c][status] += 1
            if status not in CANONICAL_SET and len(invalid_samples[c]) < 10:
                invalid_samples[c].append(f"{kw}:{status or '<empty>'}")

    for c, samples in invalid_samples.items():
        if samples:
            blockers.append(f"{c} contains invalid statuses: {', '.join(samples)}")

    for required in ("decision_js_transpiler", "decision_wasm_emitter", "decision_browser_runtime"):
        if required not in decision_columns:
            blockers.append(f"missing required decision column: {required}")

    for c, ctr in by_layer_status.items():
        total = sum(ctr.values())
        if total == 0:
            continue
        removed = ctr.get("REMOVED_OR_RESERVED", 0)
        if removed / total > 0.7:
            warnings.append(f"{c} has high REMOVED_OR_RESERVED ratio: {removed}/{total}")

    status = "PASS" if not blockers else "BLOCKED"

    report = {
        "schema_version": "uxb-keyword-decision-gate-1",
        "status": status,
        "blockers": blockers,
        "warnings": warnings,
        "row_count": len(rows),
        "decision_columns": decision_columns,
        "layer_status_counts": {k: dict(v) for k, v in by_layer_status.items()},
    }

    (out / "keyword_decision_gate.json").write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")

    md = ["# UXBc Keyword Decision Gate", "", f"- status: `{status}`", f"- row_count: `{len(rows)}`", ""]
    md.append("## Blockers")
    if blockers:
        for b in blockers:
            md.append(f"- {b}")
    else:
        md.append("- none")

    md.append("")
    md.append("## Warnings")
    if warnings:
        for w in warnings:
            md.append(f"- {w}")
    else:
        md.append("- none")

    md.append("")
    md.append("## Decision Columns")
    for c in decision_columns:
        md.append(f"- {c}")

    md.append("")
    md.append("## Counts")
    md.append("| layer | counts |")
    md.append("|---|---|")
    for c in decision_columns:
        md.append(f"| {c} | `{dict(by_layer_status.get(c, {}))}` |")

    (out / "keyword_decision_gate.md").write_text("\n".join(md), encoding="utf-8")

    print("KEYWORD_DECISION_GATE=" + str(out / "keyword_decision_gate.md"))
    print("STATUS=" + status)
    print("BLOCKER_COUNT=" + str(len(blockers)))
    return 0 if status == "PASS" else 2


if __name__ == "__main__":
    raise SystemExit(main())
