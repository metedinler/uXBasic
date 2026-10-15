#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""uXBasic resmî teknik kitabını docs_src parçalarından tek Markdown dosyasına üretir."""
from pathlib import Path
import argparse


def read_order(src: Path):
    order_file = src / ".uxb_book_order.txt"
    if order_file.exists():
        return [line.strip() for line in order_file.read_text(encoding="utf-8").splitlines() if line.strip() and not line.strip().startswith("#")]
    return [p.relative_to(src).as_posix() for p in sorted(src.rglob("*.md"))]


def read_part(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="ignore").strip()


def build(root: Path, out: Path, include_generated: bool = False):
    src = root / "docs_src"
    if not src.exists():
        raise SystemExit(f"docs_src bulunamadı: {src}")
    parts = []
    for rel in read_order(src):
        p = src / rel
        if not p.exists():
            parts.append(f"\n<!-- UYARI: bulunamayan belge parçası: {rel} -->\n")
            continue
        text = read_part(p)
        if text:
            parts.append(text)

    if include_generated:
        gen_dir = root / "docs_build" / "generated"
        if gen_dir.exists():
            for p in sorted(gen_dir.glob("*.md")):
                text = read_part(p)
                if text:
                    parts.append(text)

    out.parent.mkdir(parents=True, exist_ok=True)
    header = "<!-- Bu dosya tools/docs/build_uxbasic_pck_book.py ile üretildi. Kaynak parçalar docs_src içindedir. -->\n\n"
    out.write_text(header + "\n\n---\n\n".join(parts) + "\n", encoding="utf-8")
    print(f"OK: kitap üretildi: {out}")


def main():
    ap = argparse.ArgumentParser(description="uXBasic resmî teknik kitabını üretir")
    ap.add_argument("--root", default=".", help="uXBasic kök klasörü")
    ap.add_argument("--out", default="docs_build/uxbasic_resmi_teknik_kitap_12_06_1.md", help="çıktı Markdown dosyası")
    ap.add_argument("--include-generated", action="store_true", help="docs_build/generated içindeki otomatik ekleri kitabın sonuna ekle")
    ns = ap.parse_args()
    root = Path(ns.root).resolve()
    out = (root / ns.out).resolve()
    build(root, out, ns.include_generated)

if __name__ == "__main__":
    main()
