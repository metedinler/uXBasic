#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
UXBc release gate.

Aggregates prior step audit, matrix, expected runner, layer gate and optional existing audits.
"""

from __future__ import annotations

import argparse, json, subprocess, time
from pathlib import Path
from typing import Dict, Any, List


def find_root(start: Path) -> Path:
    p = start.resolve()
    for c in [p] + list(p.parents):
        if (c / "uxb" / "src").is_dir():
            return c
    raise SystemExit("UXBc root not found")


def run(root: Path, name: str, cmd: str, timeout: int = 240) -> Dict[str, Any]:
    started = time.time()
    try:
        p = subprocess.run(cmd, cwd=str(root), shell=True, capture_output=True, text=True, timeout=timeout, errors="replace")
        output = (p.stdout or "") + ("\n" if p.stdout and p.stderr else "") + (p.stderr or "")
        rc = p.returncode
    except subprocess.TimeoutExpired as exc:
        output = (exc.stdout or "") + "\n" + (exc.stderr or "") + f"\nTIMEOUT after {timeout}s"
        rc = -777
    except Exception as exc:
        output = f"RUNNER_EXCEPTION: {exc}"
        rc = -999
    return {
        "name": name,
        "cmd": cmd,
        "returncode": rc,
        "duration_sec": round(time.time() - started, 3),
        "output_tail": output[-4000:],
    }


def read_json(path: Path) -> Dict[str, Any]:
    if not path.exists():
        return {}
    try:
        return json.loads(path.read_text(encoding="utf-8", errors="ignore"))
    except Exception:
        return {}


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=".")
    ap.add_argument("--full", action="store_true")
    ap.add_argument("--max-tests", type=int, default=40)
    ap.add_argument("--ids", default="")
    ap.add_argument("--id-range", default="")
    ap.add_argument("--name-contains", default="")
    ap.add_argument("--manifest", default="")
    ap.add_argument("--alias-layer", action="store_true")
    ap.add_argument("--alias-spec", default="")
    args = ap.parse_args()

    root = find_root(Path(args.root))
    out = root / "uxb/dist/step6"
    log_dir = out / "logs"
    out.mkdir(parents=True, exist_ok=True)
    log_dir.mkdir(parents=True, exist_ok=True)

    expected_cmd = f"python uxb\\tools\\uxb_expected_runner.py --max-tests {args.max_tests}" + (" --full" if args.full else "")
    if args.ids:
        expected_cmd += f" --ids \"{args.ids}\""
    if args.id_range:
        expected_cmd += f" --id-range \"{args.id_range}\""
    if args.name_contains:
        expected_cmd += f" --name-contains \"{args.name_contains}\""
    if args.manifest:
        expected_cmd += f" --manifest \"{args.manifest}\""
    if args.alias_layer:
        expected_cmd += " --alias-layer"
        if args.alias_spec:
            expected_cmd += f" --alias-spec \"{args.alias_spec}\""

    commands = [
        ("workspace_clean_guard", "uxb\\compiler\\scripts\\run_workspace_clean_guard.bat"),
        ("prior_step_gap_audit", "python uxb\\tools\\uxb_prior_step_gap_audit.py"),
        ("language_surface_full_matrix", "uxb\\compiler\\scripts\\run_language_surface_full_matrix.bat"),
        ("keyword_layer_matrix", "uxb\\compiler\\scripts\\run_keyword_layer_matrix.bat"),
        ("test_matrix_linker", "python uxb\\tools\\uxb_test_matrix_linker.py"),
        ("expected_runner", expected_cmd),
        ("layer_gate", "python uxb\\tools\\uxb_layer_gate.py"),
    ]

    # Optional audits if present
    optional = [
        ("step4_audit", "uxb\\compiler\\scripts\\run_step4_type_class_ffi_audit.bat"),
        ("step5_audit", "uxb\\compiler\\scripts\\run_step5_fp_completion_audit.bat"),
    ]
    for name, cmd in optional:
        first = cmd.split()[0]
        if (root / first).exists():
            commands.append((name, cmd))

    runs = []
    for name, cmd in commands:
        if "\\" in cmd.split()[0] and not (root / cmd.split()[0]).exists() and not cmd.startswith("python"):
            runs.append({"name": name, "cmd": cmd, "returncode": 2, "duration_sec": 0, "output_tail": "script missing"})
            continue
        r = run(root, name, cmd, timeout=600 if name == "expected_runner" else 240)
        (log_dir / f"{name}.log").write_text(r["output_tail"], encoding="utf-8", errors="ignore")
        r["log"] = str((log_dir / f"{name}.log").relative_to(root)).replace("\\", "/")
        runs.append(r)

    expected = read_json(out / "expected_runner.json")
    layer = read_json(out / "layer_gate.json")
    prior = read_json(out / "prior_step_gap_audit.json")
    keyword_decision = read_json(out / "keyword_decision_gate.json")

    blockers = []
    warnings = []
    for r in runs:
        if r["returncode"] in (0,):
            continue
        if r["name"] == "workspace_clean_guard" and r["returncode"] == 2:
            warnings.append(f"{r['name']} returned {r['returncode']} (script missing)")
            continue
        blockers.append(f"{r['name']} returned {r['returncode']}")
    if expected.get("not_accepted", 0):
        blockers.append(f"expected_runner not_accepted={expected.get('not_accepted')}")
    if layer.get("status") == "HAS_BLOCKERS":
        blockers.append("layer_gate has blockers")
    if keyword_decision.get("status") == "BLOCKED":
        blockers.append("keyword_decision_gate has blockers")
    if prior.get("summary", {}).get("missing", 0):
        warnings.append(f"prior_step_gap_audit missing={prior.get('summary', {}).get('missing')}")

    status = "PASS" if not blockers else "BLOCKED"

    report = {
        "schema_version": "uxb-release-gate-1",
        "status": status,
        "blockers": blockers,
        "warnings": warnings,
        "runs": runs,
        "expected_summary": {
            "test_count": expected.get("test_count"),
            "accepted": expected.get("accepted"),
            "not_accepted": expected.get("not_accepted"),
        },
        "layer_summary": layer.get("layer_counts", {}),
        "keyword_decision_summary": {
            "status": keyword_decision.get("status"),
            "blocker_count": len(keyword_decision.get("blockers", []) or []),
        },
        "prior_step_summary": prior.get("summary", {}),
    }
    (out / "release_gate.json").write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")

    md = ["# UXBc Release Gate", "", f"- status: `{status}`", ""]
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
    md.append("## Runs")
    md.append("| name | rc | seconds | log |")
    md.append("|---|---:|---:|---|")
    for r in runs:
        md.append(f"| {r['name']} | {r['returncode']} | {r['duration_sec']} | `{r.get('log','')}` |")
    md.append("")
    md.append("## Summaries")
    md.append(f"- expected_runner: `{report['expected_summary']}`")
    md.append(f"- layer_gate: `{report['layer_summary']}`")
    md.append(f"- keyword_decision_gate: `{report['keyword_decision_summary']}`")
    md.append(f"- prior_step_gap: `{report['prior_step_summary']}`")
    (out / "release_gate.md").write_text("\n".join(md), encoding="utf-8")

    # Copilot missing work
    cop = ["# Copilot Step 6 Missing Work", ""]
    if blockers:
        cop.append("Aşağıdaki blokajları kapat:")
        for b in blockers:
            cop.append(f"- {b}")
    else:
        cop.append("Release gate PASS. Şimdi test manifestini genişlet ve full moda al.")
    if warnings:
        cop.append("")
        cop.append("Uyarılar (bloklayıcı değil):")
        for w in warnings:
            cop.append(f"- {w}")
    cop.append("")
    cop.append("## Zorunlu görev")
    cop.append("- `uxb/tests/expected/uxb_expected_tests.csv` dosyasını üret/güncelle.")
    cop.append("- `test_matrix_link.csv` içindeki otomatik sınıflandırmayı insan gözüyle düzelt.")
    cop.append("- Her test için `broken_layer` boş kalmayacak.")
    cop.append("- Duplicate testleri kanonik teste bağla.")
    (out / "copilot_step6_missing_work.md").write_text("\n".join(cop), encoding="utf-8")

    print("RELEASE_GATE=" + str(out / "release_gate.md"))
    print("STATUS=" + status)
    print("BLOCKER_COUNT=" + str(len(blockers)))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
