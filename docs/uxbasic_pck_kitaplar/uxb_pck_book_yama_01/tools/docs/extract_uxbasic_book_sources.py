#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""uXBasic kaynak yüzeyinden kitap ekleri için keyword/statement/runtime/CLI listesi çıkarır."""
from pathlib import Path
import argparse, re, json


def read(path):
    return path.read_text(encoding="utf-8", errors="ignore")


def main():
    ap = argparse.ArgumentParser(description="uXBasic kitap kaynak yüzeyi çıkarıcı")
    ap.add_argument("--root", default=".", help="uXBasic kökü")
    ap.add_argument("--out", default="docs_build/book_source_surface.json", help="çıktı JSON")
    ns = ap.parse_args()
    root = Path(ns.root).resolve()
    result = {}

    kw_file = root / "src/parser/lexer/lexer_keyword_table.fbs"
    if kw_file.exists():
        text = read(kw_file)
        kw = []
        for m in re.finditer(r'Case\s+(.+?)\n\s*Return\s+1', text, flags=re.I|re.S):
            kw += [s.upper() for s in re.findall(r'"([^"]+)"', m.group(1))]
        result["keywords"] = sorted(set(kw))

    stmt_file = root / "src/parser/parser/parser_stmt_registry.fbs"
    if stmt_file.exists():
        result["statement_dispatch"] = sorted(set(re.findall(r'AddStatementDispatchEntry\s+"([^"]+)"', read(stmt_file))))

    rt_file = root / "src/runtime/services/runtime_service_ids.fbs"
    if rt_file.exists():
        result["runtime_services"] = sorted(set(re.findall(r'Const\s+(RT_[A-Z0-9_]+)\s+As\s+String', read(rt_file))))

    cli_file = root / "src/cli/cli_registry_adim41.fbs"
    if cli_file.exists():
        result["cli_options"] = sorted(set(re.findall(r'"(--[A-Za-z0-9_-]+)"', read(cli_file))))

    out = root / ns.out
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"OK: kaynak yüzeyi yazıldı: {out}")

if __name__ == "__main__":
    main()
