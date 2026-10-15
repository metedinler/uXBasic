#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""uXBasic resmî teknik kitabı için kaynak yüzeyi ve otomatik ekler üretir.

Bu araç derleyici kaynaklarını değiştirmez. Sadece kitap ekleri üretir:
- docs_build/book_source_surface.json
- docs_build/generated/keyword_surface.md
- docs_build/generated/statement_dispatch_surface.md
- docs_build/generated/runtime_service_surface.md
- docs_build/generated/cli_option_surface.md
- docs_build/generated/project_pack_examples.md
"""
from pathlib import Path
import argparse, re, json, csv


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="ignore")


def write(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


def extract_keywords(root: Path):
    p = root / "src/parser/lexer/lexer_keyword_table.fbs"
    groups, flat = [], []
    if not p.exists():
        return [], []
    text = read(p)
    for m in re.finditer(r'Case\s+(.+?)\n\s*Return\s+1', text, flags=re.I|re.S):
        kws = [s.upper() for s in re.findall(r'"([^"]+)"', m.group(1))]
        if kws:
            groups.append(kws)
            flat.extend(kws)
    return sorted(set(flat)), groups


def extract_statement_dispatch(root: Path):
    p = root / "src/parser/parser/parser_stmt_registry.fbs"
    if not p.exists():
        return []
    return sorted(set(re.findall(r'AddStatementDispatchEntry\s+"([^"]+)"', read(p))))


def extract_runtime_services(root: Path):
    p = root / "src/runtime/services/runtime_service_ids.fbs"
    if not p.exists():
        return []
    return sorted(set(re.findall(r'Const\s+(RT_[A-Z0-9_]+)\s+As\s+String', read(p))))


def extract_cli_options(root: Path):
    p = root / "src/cli/cli_registry_adim41.fbs"
    if not p.exists():
        return []
    return sorted(set(re.findall(r'"(--[A-Za-z0-9_-]+)"', read(p))))


def extract_project_packs(root: Path):
    p = root / "xtestx/project_packs/_expected/project_pack_manifest.json"
    if not p.exists():
        return []
    data = json.loads(read(p))
    return data.get("tests", [])


def md_table(rows, headers):
    out = ["| " + " | ".join(headers) + " |", "|" + "|".join(["---"]*len(headers)) + "|"]
    for row in rows:
        safe = [str(x).replace("\n", "<br>").replace("|", "\\|") for x in row]
        out.append("| " + " | ".join(safe) + " |")
    return "\n".join(out) + "\n"


def emit_keyword_md(outdir: Path, keywords, groups):
    rows = []
    for i, g in enumerate(groups, 1):
        rows.append((i, ", ".join(f"`{x}`" for x in g), len(g)))
    text = "# Otomatik Keyword Yüzeyi\n\n"
    text += "Bu ek, `src/parser/lexer/lexer_keyword_table.fbs` dosyasından üretilir. Kitabın ana bölümlerinde görev ve örnekler elle yazılır; bu otomatik ek kaynak yüzeyinin eksiksiz kontrolü içindir.\n\n"
    text += f"Toplam benzersiz keyword: **{len(keywords)}**\n\n"
    text += md_table(rows, ["Grup", "Keywordler", "Sayı"])
    write(outdir / "keyword_surface.md", text)


def emit_simple_list(outdir: Path, filename: str, title: str, intro: str, items):
    rows = [(i, f"`{x}`") for i, x in enumerate(items, 1)]
    text = f"# {title}\n\n{intro}\n\nToplam: **{len(items)}**\n\n" + md_table(rows, ["No", "Ad"])
    write(outdir / filename, text)


def emit_project_pack_examples(root: Path, outdir: Path, packs):
    text = "# Project Pack Örnek Haritası\n\n"
    text += "Bu ek, kitabın örnek havuzudur. Her pack bir dil ailesini temsil eder. Kitapta örnek seçilirken önce bu dosyadaki çalışan kaynaklara bakılır.\n\n"
    for t in packs:
        pack = t.get("package") or t.get("id") or "pack"
        note = t.get("note", "")
        phase = t.get("phase", "")
        entry = t.get("entry", "")
        expected = t.get("expected_stdout_lines", [])
        text += f"## {pack}\n\n"
        text += f"Görev: {note}\n\n"
        text += f"Katman: `{phase}`\n\n"
        text += f"Kaynak: `{entry}`\n\n"
        src_file = root / "xtestx" / entry if entry.startswith("project_packs/") else root / entry
        if src_file.exists():
            src = read(src_file).strip()
            if len(src) > 2200:
                src = src[:2200].rstrip() + "\n' ... örnek kısaltıldı ..."
            lang = "basic" if src_file.suffix.lower() in {".bas", ".uxb", ".uxbh"} else "text"
            text += f"```{lang}\n{src}\n```\n\n"
        if expected:
            text += "Beklenen çıktı:\n\n```text\n" + "\n".join(expected) + "\n```\n\n"
    write(outdir / "project_pack_examples.md", text)


def main():
    ap = argparse.ArgumentParser(description="uXBasic kitap kaynak yüzeyi ve otomatik ek üretici")
    ap.add_argument("--root", default=".", help="uXBasic kökü")
    ap.add_argument("--out", default="docs_build/book_source_surface.json", help="çıktı JSON")
    ap.add_argument("--generated-dir", default="docs_build/generated", help="üretilen markdown ekleri")
    ns = ap.parse_args()
    root = Path(ns.root).resolve()
    out_json = (root / ns.out).resolve()
    gen = (root / ns.generated_dir).resolve()

    keywords, keyword_groups = extract_keywords(root)
    statement_dispatch = extract_statement_dispatch(root)
    runtime_services = extract_runtime_services(root)
    cli_options = extract_cli_options(root)
    project_packs = extract_project_packs(root)

    result = {
        "keywords": keywords,
        "keyword_groups": keyword_groups,
        "statement_dispatch": statement_dispatch,
        "runtime_services": runtime_services,
        "cli_options": cli_options,
        "project_packs": project_packs,
    }
    out_json.parent.mkdir(parents=True, exist_ok=True)
    out_json.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    emit_keyword_md(gen, keywords, keyword_groups)
    emit_simple_list(gen, "statement_dispatch_surface.md", "Otomatik Statement Dispatch Yüzeyi", "Bu ek, parser statement registry içindeki dispatch girişlerinden üretilir.", statement_dispatch)
    emit_simple_list(gen, "runtime_service_surface.md", "Otomatik Runtime Service Yüzeyi", "Bu ek, runtime service id sabitlerinden üretilir.", runtime_services)
    emit_simple_list(gen, "cli_option_surface.md", "Otomatik CLI Option Yüzeyi", "Bu ek, ADIM41 CLI registry içindeki uzun seçeneklerden üretilir.", cli_options)
    emit_project_pack_examples(root, gen, project_packs)

    print(f"OK: kaynak yüzeyi yazıldı: {out_json}")
    print(f"OK: markdown ekleri yazıldı: {gen}")


if __name__ == "__main__":
    main()
