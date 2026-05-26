#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import argparse, json, pathlib, pandas as pd

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--language-surface-csv", required=True)
    ap.add_argument("--keyword-layer-csv", required=True)
    ap.add_argument("--out-dir", required=True)
    args=ap.parse_args()
    out=pathlib.Path(args.out_dir); out.mkdir(parents=True, exist_ok=True)
    lang=pd.read_csv(args.language_surface_csv).fillna("")
    kw=pd.read_csv(args.keyword_layer_csv).fillna("")
    summary={
        "language_surface_rows": len(lang),
        "keyword_rows": len(kw),
        "language_categories": lang["category"].value_counts().to_dict() if "category" in lang else {},
        "keyword_status_counts": {c: kw[c].value_counts().to_dict() for c in kw.columns if c not in ("keyword","token","category")}
    }
    (out/"browser_surface_summary.json").write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    md=["# uXBasic Browser Target Surface Summary", "", f"- Language surface rows: {len(lang)}", f"- Keyword rows: {len(kw)}", "", "## Categories"]
    for k,v in summary["language_categories"].items():
        md.append(f"- {k}: {v}")
    (out/"browser_surface_summary.md").write_text("\n".join(md)+"\n", encoding="utf-8")
if __name__=="__main__":
    main()
