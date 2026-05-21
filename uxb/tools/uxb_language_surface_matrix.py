#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""uXBasiC language-surface coverage matrix (report-only)."""
from __future__ import annotations

import csv
import json
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Tuple

LAYER_PATHS = {
    "lexer": ["uxb/src/parser/lexer", "uxb/src/parser/token_kinds.fbs"],
    "parser": ["uxb/src/parser"],
    "ast": ["uxb/src/parser/ast.fbs", "uxb/src/parser/ast_contract.fbs"],
    "semantic": ["uxb/src/semantic"],
    "hir": ["uxb/src/semantic/hir.fbs"],
    "mir": ["uxb/src/semantic/mir.fbs", "uxb/src/semantic/mir_model.fbs", "uxb/src/semantic/mir_lower_expr.fbs", "uxb/src/semantic/mir_lower_stmt.fbs"],
    "ast_interpreter": ["uxb/src/runtime/memory_exec.fbs"],
    "mir_interpreter": ["uxb/src/semantic/mir_evaluator.fbs"],
    "x64_ast": ["uxb/src/codegen/x64/code_generator.fbs"],
    "x64_mir": ["uxb/src/codegen/x64/mir_x64_codegen.fbs", "uxb/src/codegen/x64/mir_x64_capability.fbs"],
    "runtime": ["uxb/src/runtime", "uxb/runtime_ext"],
    "tests": ["tests", "uxb/tests"],
    "docs": ["uxb/docs", "docs", "README.md"],
}

LAYER_ORDER = list(LAYER_PATHS.keys())
ALLOWED_EXTS = {".fbs", ".bas", ".bi", ".py", ".md", ".txt", ".json", ".bat", ".ps1", ".uxb", ".expect"}
SKIP_DIRS = {
    ".git",
    ".venv",
    "venv",
    "node_modules",
    "build",
    "dist",
    "artifacts",
    "tmp",
    "tmp_bucket",
    "archive",
    "logs",
    "release",
}
MAX_FILES_PER_LAYER = 500


@dataclass(frozen=True)
class SurfaceItem:
    category: str
    name: str
    patterns: Tuple[str, ...]


def find_repo_root(start: Path) -> Path:
    p = start.resolve()
    for c in [p] + list(p.parents):
        if (c / "uxb" / "src").is_dir():
            return c
    raise SystemExit("Cannot find repo root containing uxb/src")


def read_text_safe(path: Path) -> str:
    for enc in ("utf-8", "cp1254", "latin-1"):
        try:
            return path.read_text(encoding=enc, errors="ignore")
        except Exception:
            pass
    return ""


def iter_files(repo: Path, specs: List[str]) -> List[Path]:
    files: List[Path] = []
    for spec in specs:
        p = repo / spec
        if p.is_file():
            files.append(p)
        elif p.is_dir():
            for q in p.rglob("*"):
                if not q.is_file():
                    continue
                if any(part.lower() in SKIP_DIRS for part in q.parts):
                    continue
                if q.suffix.lower() not in ALLOWED_EXTS:
                    continue
                files.append(q)
                if len(files) >= MAX_FILES_PER_LAYER:
                    break
        if len(files) >= MAX_FILES_PER_LAYER:
            break
    return files


def extract_keywords(repo: Path) -> List[str]:
    out = set()
    candidates = [
        repo / "uxb/src/parser/lexer/lexer_keyword_table.fbs",
        repo / "uxb/src/parser/lexer_keyword_table.fbs",
        repo / "uxb/src/parser/token_kinds.fbs",
    ]
    for path in candidates:
        if not path.exists():
            continue
        txt = read_text_safe(path)
        for m in re.finditer(r'"([A-Za-z_][A-Za-z0-9_]*)"', txt):
            kw = m.group(1).upper()
            if len(kw) > 1:
                out.add(kw)
        for m in re.finditer(r"\b(?:TK|TOKEN)_([A-Z][A-Z0-9_]*)\b", txt):
            kw = m.group(1).upper()
            if kw not in {"EOF", "IDENT", "NUMBER", "STRING", "NEWLINE", "UNKNOWN"}:
                out.add(kw)
    return sorted(out)


def extract_builtin_functions(repo: Path) -> List[str]:
    out = set()
    scopes = [repo / "uxb/src/runtime", repo / "uxb/src/codegen"]
    patt = re.compile(r"\b(?:Case\s+\")([A-Z][A-Z0-9_]*)\"|Function\s+([A-Za-z_][A-Za-z0-9_]*)", re.IGNORECASE)
    for scope in scopes:
        if not scope.exists():
            continue
        for p in scope.rglob("*"):
            if not p.is_file() or p.suffix.lower() not in ALLOWED_EXTS:
                continue
            txt = read_text_safe(p)
            for m in patt.finditer(txt):
                val = (m.group(1) or m.group(2) or "").upper()
                if not val:
                    continue
                if val.startswith("UXB"):
                    continue
                if len(val) > 1 and any(ch.isalpha() for ch in val):
                    out.add(val)
    return sorted(out)


def base_items(repo: Path) -> List[SurfaceItem]:
    items: List[SurfaceItem] = []

    keywords = extract_keywords(repo)
    for kw in keywords:
        items.append(SurfaceItem("statements", kw, (kw, f"TK_{kw}", f"TOKEN_{kw}")))

    for fn in extract_builtin_functions(repo):
        items.append(SurfaceItem("builtin_functions", fn, (fn,)))

    operators = [
        "+", "-", "*", "/", "MOD", "=", "<>", "<", ">", "<=", ">=", "AND", "OR", "XOR", "NOT", "SHL", "SHR",
    ]
    for op in operators:
        items.append(SurfaceItem("operators", op, (op,)))

    primitive_types = ["I8", "U8", "I16", "U16", "I32", "U32", "I64", "U64", "F32", "F64", "BOOLEAN", "STRING"]
    for t in primitive_types:
        items.append(SurfaceItem("primitive_types", t, (t,)))

    hp_types = ["F80", "F128", "BIGF", "BIGD", "BALL"]
    for t in hp_types:
        items.append(SurfaceItem("high_precision_types", t, (t,)))

    structures = ["ARRAY", "TYPE", "CLASS", "INTERFACE", "LIST", "DICT", "SET"]
    for t in structures:
        items.append(SurfaceItem("data_structures", t, (t,)))

    ffi_forms = ["DECLARE", "CALL API", "CALL DLL", "IMPORT", "CDECL", "STDCALL"]
    for t in ffi_forms:
        items.append(SurfaceItem("ffi_forms", t, (t, t.replace(" ", "_"))))

    inline_forms = ["INLINE", "ASM", "END ASM"]
    for t in inline_forms:
        items.append(SurfaceItem("inline_forms", t, (t,)))

    memory_ops = ["VARPTR", "PEEK", "POKE", "ALLOC", "FREE", "MEMCPY"]
    for t in memory_ops:
        items.append(SurfaceItem("memory_operations", t, (t,)))

    file_io = ["OPEN", "CLOSE", "PRINT #", "INPUT #", "GET", "PUT", "EOF", "LOF"]
    for t in file_io:
        items.append(SurfaceItem("file_io", t, (t,)))

    console_io = ["PRINT", "INPUT", "LOCATE", "CLS", "COLOR"]
    for t in console_io:
        items.append(SurfaceItem("console_io", t, (t,)))

    oop = ["NEW", "DELETE", "THIS", "SUPER", "PROPERTY", "OPERATOR", "ABSTRACT", "FINAL", "MIXIN"]
    for t in oop:
        items.append(SurfaceItem("oop_features", t, (t,)))

    error_flow = ["TRY", "CATCH", "THROW", "ON ERROR", "DIAGNOSTIC"]
    for t in error_flow:
        items.append(SurfaceItem("error_flow", t, (t, t.replace(" ", "_"))))

    event_thread_pipe = ["THREAD", "MUTEX", "PIPE", "EVENT", "SLOT"]
    for t in event_thread_pipe:
        items.append(SurfaceItem("event_thread_pipe_slot", t, (t,)))

    uniq: Dict[Tuple[str, str], SurfaceItem] = {}
    for i in items:
        uniq[(i.category, i.name)] = i
    return list(uniq.values())


def compile_patterns(patterns: Tuple[str, ...]) -> List[re.Pattern]:
    regs: List[re.Pattern] = []
    for p in patterns:
        if not p:
            continue
        if p in {"+", "-", "*", "/", "=", "<>", "<", ">", "<=", ">="}:
            regs.append(re.compile(re.escape(p)))
        elif " " in p or "#" in p:
            regs.append(re.compile(re.escape(p), re.IGNORECASE))
        else:
            regs.append(re.compile(r"\b" + re.escape(p) + r"\b", re.IGNORECASE))
    return regs


def layer_status(item: SurfaceItem, files_with_text: List[Tuple[Path, str]]) -> Tuple[str, List[str]]:
    regs = compile_patterns(item.patterns)
    evidence: List[str] = []
    implemented_hits = 0
    diagnostic_hits = 0
    for f, txt in files_with_text:
        matched = any(r.search(txt) for r in regs)
        if not matched:
            continue
        evidence.append(str(f).replace("\\", "/"))
        lower = txt.lower()
        if any(k in lower for k in ("not supported", "unsupported", "diagnostic", "not yet")):
            diagnostic_hits += 1
        else:
            implemented_hits += 1
        if len(evidence) >= 6:
            break

    if implemented_hits >= 2:
        return "implemented", evidence
    if implemented_hits == 1:
        return "partial", evidence
    if diagnostic_hits > 0:
        return "diagnostic_only", evidence
    return "missing", evidence


def to_markdown(matrix: Dict) -> str:
    lines = [
        "# uXBasiC Language Surface Matrix",
        "",
        f"- item_count: `{matrix['item_count']}`",
        "",
        "## Summary",
    ]

    for layer, counts in matrix["summary"]["by_layer"].items():
        lines.append(f"- **{layer}**: {counts}")

    lines += ["", "## Matrix", "", "| category | item | " + " | ".join(LAYER_ORDER) + " |", "|---|---|" + "|".join(["---"] * len(LAYER_ORDER)) + "|"]

    for item in matrix["items"]:
        row = [item["category"], item["name"]] + [item["layers"].get(layer, "") for layer in LAYER_ORDER]
        lines.append("| " + " | ".join(row) + " |")

    return "\n".join(lines)


def main() -> int:
    repo = find_repo_root(Path("."))
    layer_files = {layer: iter_files(repo, specs) for layer, specs in LAYER_PATHS.items()}
    layer_file_texts = {
        layer: [(p, read_text_safe(p)) for p in files]
        for layer, files in layer_files.items()
    }

    items = base_items(repo)
    result_items = []
    summary = {"by_layer": {layer: {} for layer in LAYER_ORDER}}

    for item in sorted(items, key=lambda x: (x.category, x.name)):
        row = {
            "category": item.category,
            "name": item.name,
            "patterns": list(item.patterns),
            "layers": {},
            "evidence": {},
        }
        for layer in LAYER_ORDER:
            st, ev = layer_status(item, layer_file_texts[layer])
            row["layers"][layer] = st
            if ev:
                row["evidence"][layer] = ev
            summary["by_layer"][layer][st] = summary["by_layer"][layer].get(st, 0) + 1
        result_items.append(row)

    matrix = {
        "schema_version": "uxb-language-surface-matrix-1",
        "producer": "uXBasiC",
        "item_count": len(result_items),
        "layers": LAYER_ORDER,
        "summary": summary,
        "items": result_items,
    }

    dist = repo / "uxb" / "dist"
    dist.mkdir(parents=True, exist_ok=True)

    (dist / "language_surface_matrix.json").write_text(json.dumps(matrix, indent=2, ensure_ascii=False), encoding="utf-8")

    with (dist / "language_surface_matrix.csv").open("w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["category", "item"] + LAYER_ORDER)
        for item in result_items:
            w.writerow([item["category"], item["name"]] + [item["layers"].get(layer, "") for layer in LAYER_ORDER])

    (dist / "language_surface_matrix.md").write_text(to_markdown(matrix), encoding="utf-8")

    print("ITEM_COUNT=" + str(len(result_items)))
    print("OUT_JSON=uxb/dist/language_surface_matrix.json")
    print("OUT_CSV=uxb/dist/language_surface_matrix.csv")
    print("OUT_MD=uxb/dist/language_surface_matrix.md")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
