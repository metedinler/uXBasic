#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
UXBc project output manager.

Creates classified per-project output directories and prevents compiler/test outputs
from being written into uxb/src.

This tool does not compile by itself. It gives other runners a stable output layout.
"""

from __future__ import annotations

import argparse
import datetime as dt
import json
import shutil
from pathlib import Path
from typing import Dict, Any


CLASS_DIRS = [
    "source",
    "ast_interpreter",
    "mir_interpreter",
    "x64_ast_asm",
    "mir_x64_asm",
    "json",
    "logs",
    "diagnostics",
    "reports",
    "artifacts",
]


def bi_text(tr: str, en: str) -> str:
    return f"TR: {tr} | EN: {en}"


def find_root(start: Path) -> Path:
    p = start.resolve()
    for c in [p] + list(p.parents):
        if (c / "uxb" / "src").is_dir():
            return c
    raise SystemExit(bi_text("UXBc kok dizini bulunamadi", "UXBc root not found"))


def make_run(root: Path, project: str, run_id: str | None = None) -> Dict[str, Any]:
    if not project:
        project = "default"
    if not run_id:
        run_id = dt.datetime.now().strftime("%Y%m%d_%H%M%S")

    base = root / "uxb" / "_work" / "projects" / project / "runs" / run_id
    dirs = {name: base / name for name in CLASS_DIRS}
    for d in dirs.values():
        d.mkdir(parents=True, exist_ok=True)

    info = {
        "schema_version": "uxb-project-output-layout-1",
        "project": project,
        "run_id": run_id,
        "base": str(base),
        "dirs": {k: str(v) for k, v in dirs.items()},
    }
    (base / "layout.json").write_text(json.dumps(info, indent=2, ensure_ascii=False), encoding="utf-8")
    return info


def copy_source_to_run(root: Path, source: Path, layout: Dict[str, Any]) -> None:
    if not source.exists():
        return
    dst = Path(layout["dirs"]["source"]) / source.name
    shutil.copy2(source, dst)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=".")
    ap.add_argument("--project", default="default")
    ap.add_argument("--run-id", default="")
    ap.add_argument("--source", default="")
    args = ap.parse_args()

    root = find_root(Path(args.root))
    layout = make_run(root, args.project, args.run_id or None)

    if args.source:
        copy_source_to_run(root, root / args.source, layout)

    print("[INFO] " + bi_text("Proje cikti duzeni olusturuldu", "Project output layout created"))
    print("[INFO] " + bi_text("Varsayilan dil Turkce, ikinci dil Ingilizce", "Default language is Turkish, second language is English"))
    print("UXB_PROJECT_RUN_BASE=" + layout["base"])
    print("UXB_PROJECT_LAYOUT_JSON=" + str(Path(layout["base"]) / "layout.json"))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
