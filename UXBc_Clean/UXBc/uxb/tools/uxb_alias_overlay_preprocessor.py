#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Apply keyword alias overlay before parser/lexer.
Keeps compiler core unchanged by rewriting source to a temp file.

Supported alias spec formats:
1) CSV: alias,canonical
2) ALIAS command script lines:
    ALIAS PARALLEL AS PARALEL
    ALIAS PARALLEL = PARALEL
    ALIAS PARALLEL PARALEL
"""

from __future__ import annotations

import argparse
import csv
import re
from pathlib import Path
from typing import Dict, Optional, Tuple


def find_root(start: Path) -> Path:
    p = start.resolve()
    for c in [p] + list(p.parents):
        if (c / "uxb" / "src").is_dir():
            return c
    raise SystemExit("UXBc root not found")


IDENT_RE = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")


def _first_ident(text: str) -> str:
    m = re.search(r"\b([A-Za-z_][A-Za-z0-9_]*)\b", text)
    if not m:
        return ""
    return m.group(1)


def parse_alias_stmt_line(line: str) -> Optional[Tuple[str, str]]:
    raw = line.strip()
    if not raw:
        return None
    if raw.startswith("#"):
        return None

    comment_pos = raw.find("'")
    if comment_pos >= 0:
        raw = raw[:comment_pos].strip()
        if not raw:
            return None

    if not raw.upper().startswith("ALIAS "):
        return None

    rest = raw[6:].strip()
    if not rest:
        return None

    alias = _first_ident(rest)
    if not alias or not IDENT_RE.match(alias):
        return None

    tail = rest[len(alias):].strip()
    if tail.startswith("="):
        tail = tail[1:].strip()
    elif tail.upper().startswith("AS "):
        tail = tail[2:].strip()

    canonical = _first_ident(tail)
    if not canonical or not IDENT_RE.match(canonical):
        return None

    return (alias.upper(), canonical.upper())


def load_aliases_csv(path: Path) -> Dict[str, str]:
    out: Dict[str, str] = {}
    with path.open("r", encoding="utf-8", errors="ignore", newline="") as f:
        for row in csv.DictReader(f):
            a = (row.get("alias") or "").strip().upper()
            c = (row.get("canonical") or "").strip().upper()
            if a and c:
                out[a] = c
    return out


def load_aliases_alias_script(path: Path) -> Dict[str, str]:
    out: Dict[str, str] = {}
    text = path.read_text(encoding="utf-8", errors="ignore")
    for line in text.splitlines():
        parsed = parse_alias_stmt_line(line)
        if not parsed:
            continue
        alias, canonical = parsed
        out[alias] = canonical
    return out


def load_aliases(path: Path) -> Dict[str, str]:
    if not path.exists():
        return {}
    if path.suffix.lower() == ".csv":
        return load_aliases_csv(path)
    return load_aliases_alias_script(path)


def default_alias_spec(root: Path) -> Path:
    candidate_script = root / "uxb" / "manifests" / "keyword_alias_overlay.uxalias"
    candidate_csv = root / "uxb" / "manifests" / "keyword_alias_overlay.csv"
    if candidate_script.exists():
        return candidate_script
    return candidate_csv


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
    ap.add_argument("--alias-spec", default="", help="Alias specification file (.csv or .uxalias)")
    # Backward compatibility for existing scripts.
    ap.add_argument("--alias-csv", default="", help=argparse.SUPPRESS)
    args = ap.parse_args()

    root = find_root(Path("."))
    src = Path(args.source)
    if not src.is_absolute():
        src = (root / src).resolve()
    dst = Path(args.out)
    if not dst.is_absolute():
        dst = (root / dst).resolve()

    alias_spec_arg = args.alias_spec.strip() if args.alias_spec else ""
    alias_csv_arg = args.alias_csv.strip() if args.alias_csv else ""
    alias_spec = Path(alias_spec_arg or alias_csv_arg) if (alias_spec_arg or alias_csv_arg) else default_alias_spec(root)
    if not alias_spec.is_absolute():
        alias_spec = (root / alias_spec).resolve()

    aliases = load_aliases(alias_spec)
    if not aliases:
        raise SystemExit("Alias spec empty or missing: " + str(alias_spec))

    replaced_lines = apply_overlay(src, dst, aliases)
    print("ALIAS_OVERLAY_SOURCE=" + str(src))
    print("ALIAS_OVERLAY_OUTPUT=" + str(dst))
    print("ALIAS_REPLACED_LINES=" + str(replaced_lines))
    print("ALIAS_COUNT=" + str(len(aliases)))
    print("ALIAS_SPEC=" + str(alias_spec))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
