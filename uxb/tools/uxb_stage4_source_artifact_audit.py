#!/usr/bin/env python3
"""Stage 4 static source/test/artifact separation audit for uXBasiC."""

from __future__ import annotations

import argparse
import csv
import json
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, Iterable, List, Tuple


SOURCE_EXTENSIONS = {".fbs", ".bas", ".bi", ".py", ".ps1", ".md"}


@dataclass
class Finding:
    check_id: str
    severity: str
    passed: bool
    message: str
    evidence: str


def _count_files(root: Path, exts: Iterable[str] | None = None) -> int:
    if not root.exists() or not root.is_dir():
        return 0

    ext_set = set(exts or [])
    total = 0
    for p in root.rglob("*"):
        if not p.is_file():
            continue
        if ext_set and p.suffix.lower() not in ext_set:
            continue
        total += 1
    return total


def _list_source_files_under(root: Path, limit: int = 20) -> List[Path]:
    if not root.exists() or not root.is_dir():
        return []

    hits: List[Path] = []
    for p in root.rglob("*"):
        if not p.is_file():
            continue
        if p.suffix.lower() in SOURCE_EXTENSIONS:
            hits.append(p)
            if len(hits) >= limit:
                break
    return hits


def _rel(path: Path, base: Path) -> str:
    try:
        return str(path.relative_to(base)).replace("\\", "/")
    except ValueError:
        return str(path).replace("\\", "/")


def run_audit(workspace_root: Path, uxb_root: Path) -> Tuple[List[Finding], Dict[str, object]]:
    findings: List[Finding] = []

    root_src = workspace_root / "src"
    root_tests = workspace_root / "tests"
    root_artifacts = workspace_root / "artifacts"
    root_build = workspace_root / "build"
    root_dist = workspace_root / "dist"

    uxb_src = uxb_root / "src"
    uxb_tests = uxb_root / "tests"
    uxb_dist = uxb_root / "dist"

    required_artifact_dirs = [
        root_artifacts / "archive",
        root_artifacts / "logs",
        root_artifacts / "release-drop",
        root_artifacts / "tmp_bucket",
    ]

    findings.append(
        Finding(
            check_id="canonical_uxb_src",
            severity="error",
            passed=uxb_src.is_dir(),
            message="Kanonik compiler kaynak dizini uxb/src bulunmali.",
            evidence=_rel(uxb_src, workspace_root),
        )
    )

    findings.append(
        Finding(
            check_id="root_src_presence",
            severity="warning",
            passed=root_src.is_dir(),
            message="Workspace kokunde src dizini bulunuyor (overlay veya gecis izi olabilir).",
            evidence=_rel(root_src, workspace_root),
        )
    )

    findings.append(
        Finding(
            check_id="root_tests_presence",
            severity="warning",
            passed=root_tests.is_dir(),
            message="Parca 4 hedefi icin root tests dizini beklenir.",
            evidence=_rel(root_tests, workspace_root),
        )
    )

    findings.append(
        Finding(
            check_id="uxb_tests_presence",
            severity="warning",
            passed=uxb_tests.is_dir(),
            message="Gecis bitene kadar uxb/tests korunmali.",
            evidence=_rel(uxb_tests, workspace_root),
        )
    )

    findings.append(
        Finding(
            check_id="artifacts_root_presence",
            severity="warning",
            passed=root_artifacts.is_dir(),
            message="Artifact ayrimi icin root artifacts dizini bulunmali.",
            evidence=_rel(root_artifacts, workspace_root),
        )
    )

    for req in required_artifact_dirs:
        findings.append(
            Finding(
                check_id=f"artifact_subdir_{req.name}",
                severity="warning",
                passed=req.is_dir(),
                message=f"Zorunlu artifacts alt dizini: {req.name}",
                evidence=_rel(req, workspace_root),
            )
        )

    source_like_under_build = _list_source_files_under(root_build)
    source_like_under_dist = _list_source_files_under(root_dist)

    findings.append(
        Finding(
            check_id="build_contains_source_like_files",
            severity="warning",
            passed=len(source_like_under_build) == 0,
            message="Build altinda kaynak benzeri dosyalar birikmemeli (artifact karisimi riski).",
            evidence=", ".join(_rel(p, workspace_root) for p in source_like_under_build[:8])
            if source_like_under_build
            else "none",
        )
    )

    findings.append(
        Finding(
            check_id="dist_contains_source_like_files",
            severity="warning",
            passed=len(source_like_under_dist) == 0,
            message="Dist altinda kaynak benzeri dosyalar birikmemeli (artifact karisimi riski).",
            evidence=", ".join(_rel(p, workspace_root) for p in source_like_under_dist[:8])
            if source_like_under_dist
            else "none",
        )
    )

    summary: Dict[str, object] = {
        "workspace_root": _rel(workspace_root, workspace_root),
        "uxb_root": _rel(uxb_root, workspace_root),
        "root_src_exists": root_src.is_dir(),
        "uxb_src_exists": uxb_src.is_dir(),
        "root_tests_exists": root_tests.is_dir(),
        "uxb_tests_exists": uxb_tests.is_dir(),
        "root_tests_file_count": _count_files(root_tests),
        "uxb_tests_file_count": _count_files(uxb_tests),
        "root_artifacts_exists": root_artifacts.is_dir(),
        "required_artifact_dirs_present": sum(1 for p in required_artifact_dirs if p.is_dir()),
        "required_artifact_dirs_total": len(required_artifact_dirs),
        "root_build_file_count": _count_files(root_build),
        "root_dist_file_count": _count_files(root_dist),
        "uxb_dist_file_count": _count_files(uxb_dist),
    }

    return findings, summary


def _overall_status(findings: List[Finding]) -> str:
    has_error = any((not f.passed) and f.severity == "error" for f in findings)
    has_warning = any((not f.passed) and f.severity == "warning" for f in findings)
    if has_error:
        return "error"
    if has_warning:
        return "warning"
    return "ok"


def write_json(path: Path, payload: Dict[str, object]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")


def write_csv(path: Path, findings: List[Finding]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["check_id", "severity", "passed", "message", "evidence"])
        for item in findings:
            w.writerow([item.check_id, item.severity, "true" if item.passed else "false", item.message, item.evidence])


def write_md(path: Path, payload: Dict[str, object], findings: List[Finding]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    lines: List[str] = []
    lines.append("# uXBasiC Stage 4 Source/Artifact Audit")
    lines.append("")
    lines.append(f"- status: {payload['status']}")
    lines.append(f"- generated_at_utc: {payload['generated_at_utc']}")
    lines.append("")
    lines.append("## Summary")
    lines.append("")
    summary = payload["summary"]
    for k, v in summary.items():
        lines.append(f"- {k}: {v}")
    lines.append("")
    lines.append("## Findings")
    lines.append("")
    lines.append("| check_id | severity | passed | message | evidence |")
    lines.append("|---|---|---|---|---|")
    for item in findings:
        lines.append(
            "| "
            + item.check_id
            + " | "
            + item.severity
            + " | "
            + ("true" if item.passed else "false")
            + " | "
            + item.message.replace("|", "/")
            + " | "
            + item.evidence.replace("|", "/")
            + " |"
        )

    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def parse_args() -> argparse.Namespace:
    script_path = Path(__file__).resolve()
    uxb_root = script_path.parents[1]
    workspace_root = script_path.parents[2]

    parser = argparse.ArgumentParser(description="uXBasiC Stage 4 static source/artifact audit")
    parser.add_argument("--workspace-root", default=str(workspace_root), help="Workspace root path")
    parser.add_argument("--uxb-root", default=str(uxb_root), help="uXB root path")
    parser.add_argument(
        "--out-json",
        default=str(uxb_root / "dist" / "uxb_stage4_source_artifact_audit.json"),
        help="JSON output path",
    )
    parser.add_argument(
        "--out-csv",
        default=str(uxb_root / "dist" / "uxb_stage4_source_artifact_audit.csv"),
        help="CSV output path",
    )
    parser.add_argument(
        "--out-md",
        default=str(uxb_root / "dist" / "uxb_stage4_source_artifact_audit.md"),
        help="Markdown output path",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()

    workspace_root = Path(args.workspace_root).resolve()
    uxb_root = Path(args.uxb_root).resolve()

    findings, summary = run_audit(workspace_root, uxb_root)

    payload: Dict[str, object] = {
        "schema_version": "uxb-stage4-source-artifact-audit-1",
        "producer": "uXBasiC",
        "kind": "stage4_source_artifact_audit",
        "generated_at_utc": datetime.now(timezone.utc).isoformat(),
        "status": _overall_status(findings),
        "summary": summary,
        "findings": [
            {
                "check_id": item.check_id,
                "severity": item.severity,
                "passed": item.passed,
                "message": item.message,
                "evidence": item.evidence,
            }
            for item in findings
        ],
    }

    out_json = Path(args.out_json)
    out_csv = Path(args.out_csv)
    out_md = Path(args.out_md)

    write_json(out_json, payload)
    write_csv(out_csv, findings)
    write_md(out_md, payload, findings)

    print("Stage 4 statik audit tamamlandi")
    print(f"status: {payload['status']}")
    print(f"json: {out_json}")
    print(f"csv: {out_csv}")
    print(f"md: {out_md}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
