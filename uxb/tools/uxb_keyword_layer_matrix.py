#!/usr/bin/env python3
"""Generate uXBasiC keyword layer coverage matrix from code reality."""

from __future__ import annotations

import argparse
import csv
import json
import re
from collections import Counter
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, Iterable, List, Sequence, Set, Tuple


TOKEN_RE = re.compile(r"[A-Za-z_][A-Za-z0-9_]*")


@dataclass
class LayerCorpus:
    file_count: int
    token_counts: Counter
    diagnostic_tokens: Set[str]


def _read_text(path: Path) -> str:
    try:
        return path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        return path.read_text(encoding="latin-1", errors="ignore")


def _collect_files(dirs: Sequence[Path], suffixes: Iterable[str]) -> List[Path]:
    suffix_set = {s.lower() for s in suffixes}
    files: List[Path] = []
    for d in dirs:
        if not d.exists() or not d.is_dir():
            continue
        for p in d.rglob("*"):
            if p.is_file() and p.suffix.lower() in suffix_set:
                files.append(p)
    return files


def _extract_keywords_from_lexer(lexer_path: Path) -> Set[str]:
    if not lexer_path.exists():
        return set()

    text = _read_text(lexer_path)

    block_match = re.search(
        r"Private\s+Function\s+IsKeyword\s*\(.*?End\s+Function",
        text,
        flags=re.IGNORECASE | re.DOTALL,
    )
    if block_match:
        text = block_match.group(0)

    keywords: Set[str] = set()
    for line in text.splitlines():
        if "Case" not in line:
            continue
        for kw in re.findall(r'"([^"]+)"', line):
            clean = kw.strip()
            if not clean:
                continue
            if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", clean):
                continue
            keywords.add(clean.upper())

    return keywords


def _extract_keywords_from_token_kinds(token_kinds_path: Path) -> Set[str]:
    if not token_kinds_path.exists():
        return set()

    text = _read_text(token_kinds_path)
    raw = set(re.findall(r'"([^"]+)"', text))

    ignored = {
        "IDENT",
        "NUMBER",
        "STRING",
        "KEYWORD",
        "OP",
        "EOL",
        "EOF",
        "TRUE",
        "FALSE",
    }

    out: Set[str] = set()
    for item in raw:
        clean = item.strip()
        if not clean:
            continue
        if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", clean):
            continue
        up = clean.upper()
        if up in ignored:
            continue
        if len(up) <= 1:
            continue
        out.add(up)

    return out


def _build_layer_corpus(files: Sequence[Path]) -> LayerCorpus:
    token_counts: Counter = Counter()
    diagnostic_tokens: Set[str] = set()

    for p in files:
        text = _read_text(p)
        lower_text = text.lower()
        token_counts.update(tok.lower() for tok in TOKEN_RE.findall(lower_text))

        for line in lower_text.splitlines():
            if (
                "unsupported" in line
                or "not supported" in line
                or "diagnostic" in line
                or "todo" in line
                or "missing" in line
            ):
                diagnostic_tokens.update(tok.lower() for tok in TOKEN_RE.findall(line))

    return LayerCorpus(file_count=len(files), token_counts=token_counts, diagnostic_tokens=diagnostic_tokens)


def _status_for_layer(
    layer: str,
    keyword: str,
    keyword_hits: int,
    lexer_hits: int,
    layer_file_count: int,
    diagnostic_tokens: Set[str],
) -> str:
    kw = keyword.lower()

    if layer_file_count == 0:
        return "unknown"

    if keyword_hits == 0:
        if layer == "parser" and lexer_hits > 0:
            return "recognized_only"
        if layer in {"docs", "tests"}:
            return "missing"
        return "missing"

    if layer in {"docs", "tests"}:
        return "partial"

    if kw in diagnostic_tokens:
        return "diagnostic_only"

    return "implemented"


def _is_missing(status: str) -> bool:
    return status in {"missing", "recognized_only", "unknown"}


def _to_rel(path: Path, root: Path) -> str:
    try:
        return str(path.relative_to(root)).replace("\\", "/")
    except ValueError:
        return str(path).replace("\\", "/")


def _write_json(path: Path, payload: Dict[str, object]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2), encoding="utf-8")


def _write_csv(path: Path, layers: Sequence[str], rows: Sequence[Dict[str, object]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        header = ["keyword"]
        for layer in layers:
            header.append(f"{layer}_status")
            header.append(f"{layer}_hits")
        w.writerow(header)

        for row in rows:
            out = [row["keyword"]]
            statuses: Dict[str, str] = row["layer_status"]  # type: ignore[assignment]
            hits: Dict[str, int] = row["layer_hits"]  # type: ignore[assignment]
            for layer in layers:
                out.append(statuses[layer])
                out.append(hits[layer])
            w.writerow(out)


def _write_md(path: Path, payload: Dict[str, object], layers: Sequence[str], rows: Sequence[Dict[str, object]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    lines: List[str] = []

    lines.append("# uXBasiC Keyword Layer Matrix")
    lines.append("")
    lines.append(f"- status: {payload['status']}")
    lines.append(f"- keyword_count: {payload['summary']['keyword_count']}")
    lines.append(f"- generated_at_utc: {payload['generated_at_utc']}")
    lines.append("")

    lines.append("## Layer Summary")
    lines.append("")
    summary = payload["summary"]
    for name in [
        "implemented_by_layer",
        "missing_by_layer",
        "parser_only_keywords",
        "lexer_only_keywords",
        "semantic_missing_keywords",
        "mir_missing_keywords",
        "x64_missing_keywords",
    ]:
        lines.append(f"- {name}: {summary[name]}")
    lines.append("")

    lines.append("## Keyword Status Table")
    lines.append("")
    header = ["keyword"] + list(layers)
    lines.append("| " + " | ".join(header) + " |")
    lines.append("|" + "|".join(["---"] * len(header)) + "|")

    for row in rows:
        statuses: Dict[str, str] = row["layer_status"]  # type: ignore[assignment]
        cells = [row["keyword"]] + [statuses[layer] for layer in layers]
        lines.append("| " + " | ".join(str(c).replace("|", "/") for c in cells) + " |")

    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def parse_args() -> argparse.Namespace:
    script_path = Path(__file__).resolve()
    uxb_root = script_path.parents[1]
    workspace_root = script_path.parents[2]

    parser = argparse.ArgumentParser(description="uXBasiC keyword layer matrix generator")
    parser.add_argument("--workspace-root", default=str(workspace_root), help="Workspace root")
    parser.add_argument("--uxb-root", default=str(uxb_root), help="uXB root")
    parser.add_argument(
        "--out-json",
        default=str(uxb_root / "dist" / "keyword_layer_matrix.json"),
        help="JSON output path",
    )
    parser.add_argument(
        "--out-csv",
        default=str(uxb_root / "dist" / "keyword_layer_matrix.csv"),
        help="CSV output path",
    )
    parser.add_argument(
        "--out-md",
        default=str(uxb_root / "dist" / "keyword_layer_matrix.md"),
        help="Markdown output path",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()

    workspace_root = Path(args.workspace_root).resolve()
    uxb_root = Path(args.uxb_root).resolve()

    lexer_table = uxb_root / "src" / "parser" / "lexer" / "lexer_keyword_table.fbs"
    token_kinds = uxb_root / "src" / "parser" / "token_kinds.fbs"

    keywords = _extract_keywords_from_lexer(lexer_table)
    keywords.update(_extract_keywords_from_token_kinds(token_kinds))

    keywords = {k.upper().strip() for k in keywords if k.strip()}
    sorted_keywords = sorted(keywords)

    layer_files: Dict[str, List[Path]] = {}

    layer_files["lexer"] = _collect_files(
        [uxb_root / "src" / "parser" / "lexer"],
        [".fbs", ".bas", ".bi"],
    )
    layer_files["parser"] = _collect_files(
        [uxb_root / "src" / "parser" / "parser", uxb_root / "src" / "parser"],
        [".fbs", ".bas", ".bi"],
    )
    layer_files["ast"] = _collect_files(
        [uxb_root / "src" / "parser"],
        [".fbs", ".bas", ".bi"],
    )
    layer_files["semantic"] = _collect_files([uxb_root / "src" / "semantic"], [".fbs", ".bas", ".bi"])
    layer_files["hir"] = [p for p in layer_files["semantic"] if "hir" in p.name.lower()]
    layer_files["mir"] = [p for p in layer_files["semantic"] if "mir" in p.name.lower()]

    runtime_exec_files = _collect_files([uxb_root / "src" / "runtime"], [".fbs", ".bas", ".bi"])
    layer_files["interpreter_mir"] = [p for p in runtime_exec_files if "mir" in p.name.lower()]
    layer_files["interpreter_ast"] = [p for p in runtime_exec_files if p not in layer_files["interpreter_mir"]]

    x64_files = _collect_files([uxb_root / "src" / "codegen" / "x64"], [".fbs", ".bas", ".bi"])
    layer_files["x64_codegen_mir"] = [p for p in x64_files if "mir" in p.name.lower()]
    layer_files["x64_codegen_ast"] = [p for p in x64_files if p not in layer_files["x64_codegen_mir"]]

    layer_files["runtime"] = runtime_exec_files

    ffi_sources = _collect_files([uxb_root / "src"], [".fbs", ".bas", ".bi"])
    layer_files["ffi"] = [p for p in ffi_sources if "ffi" in p.name.lower() or "ffi" in _read_text(p).lower()]

    layer_files["tests"] = _collect_files(
        [workspace_root / "tests", uxb_root / "tests"],
        [".fbs", ".bas", ".bi", ".md", ".csv", ".txt"],
    )

    layer_files["docs"] = _collect_files(
        [workspace_root / "docs", uxb_root / "docs"],
        [".md", ".txt", ".csv", ".json"],
    )

    layers = [
        "lexer",
        "parser",
        "ast",
        "semantic",
        "hir",
        "mir",
        "interpreter_ast",
        "interpreter_mir",
        "x64_codegen_ast",
        "x64_codegen_mir",
        "runtime",
        "ffi",
        "tests",
        "docs",
    ]

    corpora: Dict[str, LayerCorpus] = {layer: _build_layer_corpus(layer_files[layer]) for layer in layers}

    rows: List[Dict[str, object]] = []

    for kw in sorted_keywords:
        layer_hits: Dict[str, int] = {}
        layer_status: Dict[str, str] = {}

        lexer_hits = corpora["lexer"].token_counts[kw.lower()]

        for layer in layers:
            corpus = corpora[layer]
            hits = corpus.token_counts[kw.lower()]
            status = _status_for_layer(
                layer=layer,
                keyword=kw,
                keyword_hits=hits,
                lexer_hits=lexer_hits,
                layer_file_count=corpus.file_count,
                diagnostic_tokens=corpus.diagnostic_tokens,
            )
            layer_hits[layer] = int(hits)
            layer_status[layer] = status

        rows.append(
            {
                "keyword": kw,
                "layer_status": layer_status,
                "layer_hits": layer_hits,
            }
        )

    implemented_by_layer: Dict[str, int] = {layer: 0 for layer in layers}
    missing_by_layer: Dict[str, int] = {layer: 0 for layer in layers}

    parser_only_keywords: List[str] = []
    lexer_only_keywords: List[str] = []
    semantic_missing_keywords: List[str] = []
    mir_missing_keywords: List[str] = []
    x64_missing_keywords: List[str] = []

    for row in rows:
        keyword = str(row["keyword"])
        layer_status = row["layer_status"]  # type: ignore[assignment]

        for layer in layers:
            st = layer_status[layer]
            if st in {"implemented", "partial"}:
                implemented_by_layer[layer] += 1
            if _is_missing(st):
                missing_by_layer[layer] += 1

        if layer_status["lexer"] == "implemented" and _is_missing(layer_status["parser"]):
            lexer_only_keywords.append(keyword)

        if layer_status["parser"] in {"implemented", "diagnostic_only"} and all(
            _is_missing(layer_status[l]) for l in ["semantic", "hir", "mir", "x64_codegen_ast", "x64_codegen_mir"]
        ):
            parser_only_keywords.append(keyword)

        if _is_missing(layer_status["semantic"]) and layer_status["parser"] in {"implemented", "diagnostic_only"}:
            semantic_missing_keywords.append(keyword)

        if _is_missing(layer_status["mir"]) and layer_status["parser"] in {"implemented", "diagnostic_only"}:
            mir_missing_keywords.append(keyword)

        if _is_missing(layer_status["x64_codegen_ast"]) and layer_status["parser"] in {"implemented", "diagnostic_only"}:
            x64_missing_keywords.append(keyword)

    has_missing_core = any(
        missing_by_layer[layer] > 0
        for layer in [
            "parser",
            "semantic",
            "hir",
            "mir",
            "x64_codegen_ast",
            "x64_codegen_mir",
        ]
    )

    status = "warning" if has_missing_core else "ok"

    payload: Dict[str, object] = {
        "schema_version": "uxb-keyword-layer-matrix-1",
        "producer": "uXBasiC",
        "kind": "keyword_layer_matrix",
        "generated_at_utc": datetime.now(timezone.utc).isoformat(),
        "workspace_root": _to_rel(workspace_root, workspace_root),
        "uxb_root": _to_rel(uxb_root, workspace_root),
        "status": status,
        "layers": layers,
        "keyword_source": {
            "lexer_keyword_table": _to_rel(lexer_table, workspace_root),
            "token_kinds": _to_rel(token_kinds, workspace_root),
        },
        "summary": {
            "keyword_count": len(sorted_keywords),
            "implemented_by_layer": implemented_by_layer,
            "missing_by_layer": missing_by_layer,
            "parser_only_keywords": parser_only_keywords,
            "lexer_only_keywords": lexer_only_keywords,
            "semantic_missing_keywords": semantic_missing_keywords,
            "mir_missing_keywords": mir_missing_keywords,
            "x64_missing_keywords": x64_missing_keywords,
        },
        "keywords": rows,
    }

    out_json = Path(args.out_json)
    out_csv = Path(args.out_csv)
    out_md = Path(args.out_md)

    _write_json(out_json, payload)
    _write_csv(out_csv, layers, rows)
    _write_md(out_md, payload, layers, rows)

    print("Keyword layer matrix olusturuldu")
    print(f"keyword_count: {len(sorted_keywords)}")
    print(f"status: {status}")
    print(f"json: {out_json}")
    print(f"csv: {out_csv}")
    print(f"md: {out_md}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
