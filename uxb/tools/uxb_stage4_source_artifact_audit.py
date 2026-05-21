#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
uXBasiC Stage-4 workspace/test/artifact audit tool.
Default mode is dry-run. No file is moved unless --apply is supplied.

Canonical decisions:
- uxb/src is canonical source tree.
- root tests/ is canonical test tree.
- uxb/tests may be moved back to root tests/.
- root src/ may be retired only if byte-for-byte duplicate of uxb/src.
"""
from __future__ import annotations
import argparse, csv, datetime as _dt, hashlib, json, shutil
from pathlib import Path
from typing import Dict, List, Tuple, Any

SAFE_TEST_SOURCE_EXTS = {".bas", ".bi", ".fbs", ".expect", ".uxb", ".txt", ".md"}
GENERATED_EXTS_DEFAULT = {".exe", ".obj", ".o", ".asm", ".nasm", ".lst", ".log", ".tmp", ".bak", ".pdb", ".ilk"}
GENERATED_EXTS_AGGRESSIVE = GENERATED_EXTS_DEFAULT | {".json", ".csv", ".xml", ".html"}
GENERATED_DIR_NAMES = {"out", "out_h8a", "diag", "diag_out", "diagnostics", "x64build", "interop", "build", "dist", ".pytest_cache", "__pycache__"}

def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()

def rel(root: Path, path: Path) -> str:
    return str(path.relative_to(root)).replace("\\", "/")

def find_repo_root(start: Path) -> Path:
    p = start.resolve()
    for c in [p] + list(p.parents):
        if (c / "uxb" / "src").is_dir():
            return c
    raise SystemExit("Cannot find repo root containing uxb/src")

def compare_trees(left: Path, right: Path) -> Dict[str, Any]:
    result = {"left_exists": left.is_dir(), "right_exists": right.is_dir(), "same": False,
              "left_file_count": 0, "right_file_count": 0, "different": [], "left_only": [], "right_only": []}
    if not left.is_dir() or not right.is_dir():
        return result
    left_files = sorted([p for p in left.rglob("*") if p.is_file()])
    right_files = sorted([p for p in right.rglob("*") if p.is_file()])
    result["left_file_count"], result["right_file_count"] = len(left_files), len(right_files)
    left_map = {rel(left, p): p for p in left_files}
    right_map = {rel(right, p): p for p in right_files}
    result["left_only"] = sorted(set(left_map) - set(right_map))
    result["right_only"] = sorted(set(right_map) - set(left_map))
    for k in sorted(set(left_map) & set(right_map)):
        lp, rp = left_map[k], right_map[k]
        if lp.stat().st_size != rp.stat().st_size or sha256_file(lp) != sha256_file(rp):
            result["different"].append(k)
    result["same"] = not result["left_only"] and not result["right_only"] and not result["different"]
    return result

def is_generated_path(path: Path, aggressive: bool) -> bool:
    lower_parts = [part.lower() for part in path.parts]
    if any(part in GENERATED_DIR_NAMES or part.startswith("diag_") or part.startswith("out_") for part in lower_parts):
        return True
    ext_set = GENERATED_EXTS_AGGRESSIVE if aggressive else GENERATED_EXTS_DEFAULT
    return path.suffix.lower() in ext_set

def plan_move(actions: List[Dict[str, Any]], kind: str, source: Path, target: Path, reason: str) -> None:
    actions.append({"kind": kind, "source": str(source), "target": str(target), "reason": reason})

def ensure_parent(path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)

def unique_target(path: Path) -> Path:
    if not path.exists():
        return path
    stem, suffix, parent = path.stem, path.suffix, path.parent
    for i in range(1, 10000):
        candidate = parent / f"{stem}__dup{i}{suffix}"
        if not candidate.exists():
            return candidate
    raise RuntimeError(f"Cannot create unique target for {path}")

def write_reports(repo: Path, report: Dict[str, Any], stamp: str) -> Tuple[Path, Path]:
    dist = repo / "uxb" / "dist"
    dist.mkdir(parents=True, exist_ok=True)
    json_path = dist / f"stage4_workspace_report_{stamp}.json"
    md_path = dist / f"stage4_workspace_report_{stamp}.md"
    json_path.write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")
    lines = ["# uXBasiC Stage-4 Workspace Audit", "",
             f"- dry_run: `{report['dry_run']}`",
             f"- canonical_source: `{report['canonical_source']}`",
             f"- canonical_tests: `{report['canonical_tests']}`",
             f"- root_src_duplicate: `{report['root_src_duplicate']}`",
             f"- action_count: `{len(report['actions'])}`", "",
             "## Actions", "",
             "| # | kind | source | target | reason |",
             "|---:|---|---|---|---|"]
    for i, a in enumerate(report["actions"], 1):
        lines.append(f"| {i} | {a['kind']} | `{a['source']}` | `{a['target']}` | {a['reason']} |")
    md_path.write_text("\n".join(lines), encoding="utf-8")
    return json_path, md_path

def apply_actions(actions: List[Dict[str, Any]], retired_root: Path) -> Tuple[Path, Path]:
    retired_root.mkdir(parents=True, exist_ok=True)
    manifest_path = retired_root / "RETIRE_MANIFEST.csv"
    undo_path = retired_root / "UNDO_RESTORE_STAGE4.bat"
    rows, undo_lines = [], ["@echo off", "setlocal", "echo Restoring Stage-4 moved files..."]
    for a in actions:
        src, dst = Path(a["source"]), Path(a["target"])
        if not src.exists():
            a["status"] = "missing_source"
            continue
        ensure_parent(dst)
        dst = unique_target(dst)
        shutil.move(str(src), str(dst))
        a["target"], a["status"] = str(dst), "moved"
        rows.append([a["kind"], str(src), str(dst), a["reason"]])
        undo_lines.append(f'if exist "{dst}" move /Y "{dst}" "{src}"')
    with manifest_path.open("w", newline="", encoding="utf-8") as f:
        w = csv.writer(f); w.writerow(["kind", "source", "target", "reason"]); w.writerows(rows)
    undo_lines += ["echo Done.", "endlocal"]
    undo_path.write_text("\n".join(undo_lines), encoding="utf-8")
    return manifest_path, undo_path

def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--repo-root", default=".")
    ap.add_argument("--apply", action="store_true")
    ap.add_argument("--move-tests-to-root", action="store_true")
    ap.add_argument("--move-root-src-duplicate", action="store_true")
    ap.add_argument("--aggressive-artifacts", action="store_true")
    args = ap.parse_args()
    repo = find_repo_root(Path(args.repo_root))
    stamp = _dt.datetime.now().strftime("%Y%m%d_%H%M%S")
    retired_root = repo / "uxb" / "artifacts" / "stage4_retired" / stamp
    canonical_src, root_src = repo / "uxb" / "src", repo / "src"
    root_tests, uxb_tests = repo / "tests", repo / "uxb" / "tests"
    src_cmp = compare_trees(root_src, canonical_src)
    actions: List[Dict[str, Any]] = []
    if args.move_root_src_duplicate and src_cmp["same"]:
        plan_move(actions, "retire_duplicate_root_src", root_src, retired_root / "root_src_duplicate", "root src is byte-for-byte duplicate of uxb/src")
    if uxb_tests.is_dir():
        for p in sorted(uxb_tests.rglob("*")):
            if p.is_dir(): continue
            rel_test = p.relative_to(uxb_tests)
            if is_generated_path(p, args.aggressive_artifacts):
                plan_move(actions, "retire_test_artifact", p, retired_root / "test_artifacts" / rel_test, "generated test artifact")
            elif args.move_tests_to_root and p.suffix.lower() in SAFE_TEST_SOURCE_EXTS:
                plan_move(actions, "move_test_source_to_root", p, root_tests / rel_test, "test source should live under root tests/")
    report = {"schema_version": "uxb-stage4-workspace-audit-1", "producer": "uXBasiC",
              "dry_run": not args.apply, "repo_root": str(repo), "canonical_source": "uxb/src",
              "canonical_tests": "tests", "root_src_duplicate": bool(src_cmp["same"]),
              "root_src_compare": src_cmp, "move_tests_to_root_requested": bool(args.move_tests_to_root),
              "move_root_src_duplicate_requested": bool(args.move_root_src_duplicate),
              "aggressive_artifacts": bool(args.aggressive_artifacts), "actions": actions}
    json_path, md_path = write_reports(repo, report, stamp)
    if args.apply and actions:
        manifest, undo = apply_actions(actions, retired_root)
        report["manifest"], report["undo_script"] = str(manifest), str(undo)
        json_path.write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"STAGE4_REPORT_JSON={json_path}")
    print(f"STAGE4_REPORT_MD={md_path}")
    print(f"ACTION_COUNT={len(actions)}")
    print(f"DRY_RUN={not args.apply}")
    return 0
if __name__ == "__main__":
    raise SystemExit(main())
