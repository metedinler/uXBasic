#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Apply keyword alias overlay before parser/lexer.
Keeps compiler core unchanged by rewriting source to a temp file.
"""

from __future__ import annotations

import argparse
import csv
import re
from pathlib import Path
from typing import Dict


def find_root(start: Path) -> Path:
    p = start.resolve()
    for c in [p] + list(p.parents):
        if (c / "uxb" / "src").is_dir():
            return c
    raise SystemExit("UXBc root not found")


def load_aliases(path: Path) -> Dict[str, str]:
    out: Dict[str, str] = {}
    if not path.exists():
        return out
    with path.open("r", encoding="utf-8", errors="ignore", newline="") as f:
        for row in csv.DictReader(f):
            a = (row.get("alias") or "").strip().upper()
            c = (row.get("canonical") or "").strip().upper()
            if a and c:
                out[a] = c
    return out


def replace_tokens_line(line: str, aliases: Dict[str, str]) -> str:
    # keep string literals and comments untouched
    comment_pos = line.find("'")
    if comment_pos >= 0:
        code = line[:comment_pos]
        comment = line[comment_pos:]
    else:
        code = line
        comment = ""

    parts = re.split(r"(\"(?:[^\"\\]|\\.)*\")", code)
    for i, part in enumerate(parts):
        if i % 2 == 1:
            continue
        def repl(m: re.Match[str]) -> str:
            tok = m.group(0)
            up = tok.upper()
            return aliases.get(up, tok)
        parts[i] = re.sub(r"\b[A-Za-z_][A-Za-z0-9_]*\b", repl, part)

    return "".join(parts) + comment


def apply_overlay(src: Path, dst: Path, aliases: Dict[str, str]) -> int:
    text = src.read_text(encoding="utf-8", errors="ignore")
    lines = text.splitlines(keepends=True)
    replaced = 0
    out_lines = []
    for ln in lines:
        new_ln = replace_tokens_line(ln, aliases)
        if new_ln != ln:
            replaced += 1
        out_lines.append(new_ln)
    dst.parent.mkdir(parents=True, exist_ok=True)
    dst.write_text("".join(out_lines), encoding="utf-8")
    return replaced


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--source", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--alias-csv", default="uxb/manifests/keyword_alias_overlay.csv")
    args = ap.parse_args()

    root = find_root(Path("."))
    src = Path(args.source)
    if not src.is_absolute():
        src = (root / src).resolve()
    dst = Path(args.out)
    if not dst.is_absolute():
        dst = (root / dst).resolve()

    alias_csv = Path(args.alias_csv)
    if not alias_csv.is_absolute():
        alias_csv = (root / alias_csv).resolve()

    aliases = load_aliases(alias_csv)
    if not aliases:
        raise SystemExit("Alias CSV empty or missing: " + str(alias_csv))

    replaced_lines = apply_overlay(src, dst, aliases)
    print("ALIAS_OVERLAY_SOURCE=" + str(src))
    print("ALIAS_OVERLAY_OUTPUT=" + str(dst))
    print("ALIAS_REPLACED_LINES=" + str(replaced_lines))
    print("ALIAS_COUNT=" + str(len(aliases)))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
