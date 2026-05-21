#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""uXBasiC keyword/layer coverage matrix. Report-only tool."""
from __future__ import annotations
import csv, json, re
from pathlib import Path
from typing import Dict, List, Tuple, Any

LAYER_PATHS = {
    "lexer": ["uxb/src/parser/lexer", "uxb/src/parser/lexer.fbs", "uxb/src/parser/token_kinds.fbs"],
    "parser": ["uxb/src/parser/parser", "uxb/src/parser/parser.fbs"],
    "ast": ["uxb/src/parser/ast.fbs", "uxb/src/parser/ast_contract.fbs"],
    "semantic": ["uxb/src/semantic"],
    "hir": ["uxb/src/semantic/hir.fbs"],
    "mir": ["uxb/src/semantic/mir.fbs", "uxb/src/semantic/mir_model.fbs", "uxb/src/semantic/mir_lower_expr.fbs", "uxb/src/semantic/mir_lower_stmt.fbs"],
    "interpreter_ast": ["uxb/src/runtime/memory_exec.fbs", "uxb/src/runtime/exec"],
    "interpreter_mir": ["uxb/src/semantic/mir_evaluator.fbs", "uxb/src/semantic/mir_evaluator"],
    "x64_codegen_ast": ["uxb/src/codegen/x64/code_generator.fbs", "uxb/src/codegen/x64/stmt_emitters", "uxb/src/codegen/x64/helpers"],
    "x64_codegen_mir": ["uxb/src/codegen/x64/mir_x64_codegen.fbs", "uxb/src/codegen/x64/mir_x64_capability.fbs"],
    "x86_codegen": ["uxb/src/codegen/x86"],
    "runtime": ["uxb/src/runtime"],
    "ffi": ["uxb/src/codegen/x64/ffi_call_backend.fbs", "uxb/src/codegen/x86/ffi_call_backend.fbs", "uxb/src/build/interop_manifest.fbs"],
    "tests": ["tests", "uxb/tests"],
    "docs": ["uxb/docs", "docs", "README.md"],
}
def find_repo_root(start: Path) -> Path:
    p = start.resolve()
    for c in [p] + list(p.parents):
        if (c / "uxb" / "src").is_dir(): return c
    raise SystemExit("Cannot find repo root containing uxb/src")
def read_text_safe(path: Path) -> str:
    for enc in ("utf-8", "cp1254", "latin-1"):
        try: return path.read_text(encoding=enc, errors="ignore")
        except Exception: pass
    return ""
def iter_files(repo: Path, specs: List[str]) -> List[Path]:
    files = []
    allowed = {".fbs",".bas",".bi",".py",".md",".txt",".json",".bat",".uxb",".expect"}
    for spec in specs:
        p = repo / spec
        if p.is_file(): files.append(p)
        elif p.is_dir():
            files += [q for q in p.rglob("*") if q.is_file() and q.suffix.lower() in allowed]
    return files
def extract_keywords(repo: Path) -> List[Dict[str, str]]:
    candidates = [repo/"uxb/src/parser/lexer/lexer_keyword_table.fbs", repo/"uxb/src/parser/lexer_keyword_table.fbs", repo/"uxb/src/parser/token_kinds.fbs"]
    found: Dict[str, Dict[str,str]] = {}
    for path in candidates:
        if not path.exists(): continue
        text = read_text_safe(path)
        for m in re.finditer(r'"([A-Za-z_][A-Za-z0-9_]*)"\s*,?\s*(TK_[A-Za-z0-9_]+|TOKEN_[A-Za-z0-9_]+)?', text):
            kw, token = m.group(1).upper(), (m.group(2) or "").upper()
            if len(kw) < 2: continue
            found.setdefault(kw, {"keyword": kw, "token": token, "source": str(path.relative_to(repo)).replace("\\","/")})
            if token and not found[kw].get("token"): found[kw]["token"] = token
        for m in re.finditer(r'\b(TK|TOKEN)_([A-Z][A-Z0-9_]*)\b', text):
            kw = m.group(2).upper()
            if kw in {"EOF","IDENT","NUMBER","STRING","NEWLINE","UNKNOWN"}: continue
            found.setdefault(kw, {"keyword": kw, "token": m.group(0).upper(), "source": str(path.relative_to(repo)).replace("\\","/")})
    return [found[k] for k in sorted(found)]
def status_for_layer(keyword: str, token: str, files: List[Path]) -> Tuple[str, List[str]]:
    kw_re = re.compile(r'\b' + re.escape(keyword) + r'\b', re.IGNORECASE)
    tok_re = re.compile(r'\b' + re.escape(token) + r'\b') if token else None
    evidence, diagnostic_hits, normal_hits = [], 0, 0
    for f in files:
        text = read_text_safe(f)
        hit = bool(kw_re.search(text)) or (bool(tok_re.search(text)) if tok_re else False)
        if hit:
            evidence.append(str(f).replace("\\","/"))
            sample = text.lower()
            if any(x in sample for x in ["not supported", "unsupported", "diagnostic", "not yet"]):
                diagnostic_hits += 1
            else:
                normal_hits += 1
        if len(evidence) >= 8: break
    if normal_hits > 1: return "implemented", evidence
    if normal_hits == 1: return "partial", evidence
    if diagnostic_hits > 0: return "diagnostic_only", evidence
    return "missing", evidence
def main() -> int:
    repo = find_repo_root(Path("."))
    keywords, layers = extract_keywords(repo), list(LAYER_PATHS.keys())
    layer_files = {layer: iter_files(repo, specs) for layer, specs in LAYER_PATHS.items()}
    items, summary = [], {"by_layer": {layer: {} for layer in layers}}
    for kw in keywords:
        item = {"keyword": kw["keyword"], "token": kw.get("token",""), "source": kw.get("source",""), "category": "unknown", "layers": {}, "evidence": {}}
        for layer in layers:
            st, ev = status_for_layer(item["keyword"], item["token"], layer_files[layer])
            item["layers"][layer] = st
            if ev: item["evidence"][layer] = ev
            summary["by_layer"][layer][st] = summary["by_layer"][layer].get(st, 0) + 1
        items.append(item)
    matrix = {"schema_version": "uxb-keyword-layer-matrix-1", "producer": "uXBasiC", "keyword_count": len(items), "layers": layers, "summary": summary, "keywords": items}
    dist = repo / "uxb" / "dist"; dist.mkdir(parents=True, exist_ok=True)
    (dist/"keyword_layer_matrix.json").write_text(json.dumps(matrix, indent=2, ensure_ascii=False), encoding="utf-8")
    with (dist/"keyword_layer_matrix.csv").open("w", newline="", encoding="utf-8") as f:
        w = csv.writer(f); w.writerow(["keyword","token","category"] + layers)
        for item in items: w.writerow([item["keyword"], item.get("token",""), item.get("category","")] + [item["layers"].get(layer,"") for layer in layers])
    lines = ["# uXBasiC Keyword Layer Matrix", "", f"- keyword_count: `{len(items)}`", "", "## Summary"]
    for layer, counts in summary["by_layer"].items(): lines.append(f"- **{layer}**: {counts}")
    lines += ["", "## Matrix", "", "| keyword | token | " + " | ".join(layers) + " |", "|---|---|" + "|".join(["---"] * len(layers)) + "|"]
    for item in items: lines.append("| " + item["keyword"] + " | " + item.get("token","") + " | " + " | ".join(item["layers"].get(layer,"") for layer in layers) + " |")
    (dist/"keyword_layer_matrix.md").write_text("\n".join(lines), encoding="utf-8")
    print("KEYWORD_COUNT=" + str(len(items)))
    print("OUT_JSON=uxb/dist/keyword_layer_matrix.json")
    return 0
if __name__ == "__main__":
    raise SystemExit(main())
