#!/usr/bin/env python3
"""
src7 uXBasic compiler feature matrix generator.

Bu arac kaynak agacini statik olarak tarar ve her dil ozelligi icin
Lexer / Parser / AST / Semantic / AST Exec / MIR / MIR Exec / x64 katmanlarinda
hangi destek izinin bulundugunu docs/compiler_feature_matrix.md olarak uretir.

Not: Bu arac davranissal test kosmaz; statik kaynak izlerine gore tablo uretir.
"""
from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import Iterable
import argparse
import re

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src"
OUT = ROOT / "docs" / "compiler_feature_matrix.md"

@dataclass(frozen=True)
class Probe:
    layer: str
    files: tuple[str, ...]
    patterns: tuple[str, ...]

@dataclass(frozen=True)
class Feature:
    name: str
    keyword: str
    ast_nodes: tuple[str, ...]
    semantic_patterns: tuple[str, ...]
    ast_exec_patterns: tuple[str, ...]
    mir_patterns: tuple[str, ...]
    mir_exec_patterns: tuple[str, ...]
    x64_patterns: tuple[str, ...]
    note: str


def read_rel(rel: str) -> str:
    p = SRC / rel
    if not p.exists():
        return ""
    return p.read_text(encoding="utf-8", errors="ignore")


def grep_any(files: Iterable[str], patterns: Iterable[str]) -> tuple[bool, list[str]]:
    hits: list[str] = []
    for rel in files:
        text = read_rel(rel)
        if not text:
            continue
        for pat in patterns:
            if re.search(pat, text, flags=re.IGNORECASE | re.MULTILINE):
                hits.append(f"{rel}:{pat}")
                break
    return (len(hits) > 0), hits


def node_pattern(node: str) -> str:
    return rf'"{re.escape(node)}"'


def keyword_pattern(keyword: str) -> str:
    return rf'\b{re.escape(keyword.lower())}\b|\b{re.escape(keyword.upper())}\b'


LEXER_FILES = ("parser/lexer/lexer_keyword_table.fbs",)
PARSER_FILES = tuple(str(p.relative_to(SRC)) for p in (SRC / "parser" / "parser").glob("*.fbs"))
AST_FILES = PARSER_FILES + ("parser/ast.fbs",)
SEMANTIC_FILES = tuple(str(p.relative_to(SRC)) for p in (SRC / "semantic").rglob("*.fbs"))
AST_EXEC_FILES = tuple(str(p.relative_to(SRC)) for p in (SRC / "runtime").rglob("*.fbs"))
MIR_FILES = ("semantic/mir.fbs", "semantic/mir_model.fbs")
MIR_EXEC_FILES = ("semantic/mir_evaluator.fbs",)
X64_FILES = tuple(str(p.relative_to(SRC)) for p in (SRC / "codegen" / "x64").rglob("*.fbs")) + ("build/x64_build_pipeline.fbs",)

FEATURES: tuple[Feature, ...] = (
    Feature("PRINT", "print", ("PRINT_STMT",), ("PRINT_STMT",), ("PRINT_STMT",), ("PRINT_STMT",), ("PRINT",), ("PRINT_STMT",), "Temel cikti destegi var; string ayrintilari x64/runtime tarafinda ayrica test edilmeli."),
    Feature("INPUT", "input", ("INPUT_STMT", "INPUT_FILE_STMT"), ("INPUT_STMT",), ("INPUT_STMT",), (), (), ("INPUT_FILE_STMT",), "Konsol/file input parser/runtime izleri var; MIR destegi gorunmuyor."),
    Feature("DIM", "dim", ("DIM_STMT", "DIM_DECL"), ("DIM_STMT",), ("DIM_STMT",), ("DIM_STMT", "MIR_OP_DIM"), ("DIM",), ("DIM_STMT",), "Degisken bildirimi tum ana katmanlarda iz birakiyor; object/array detaylari ayri."),
    Feature("CONST", "const", ("CONST_STMT", "CONST_DECL"), ("CONST_STMT",), ("CONST_STMT",), ("CONST_STMT", "MIR_OP_CONST"), ("CONST",), (), "Parser/semantic/MIR izleri var; x64 statement case'i belirgin degil."),
    Feature("ASSIGN", "=", ("ASSIGN_STMT",), ("ASSIGN_STMT",), ("ASSIGN_STMT",), ("ASSIGN_STMT", "STORE_VAR"), ("STORE_VAR",), ("ASSIGN_STMT",), "Atama temel katmanlarda var; field/index hedefleri kismi."),
    Feature("IF", "if", ("IF_STMT",), ("IF_STMT",), ("IF_STMT",), ("IF_STMT",), ("JZ", "JNZ"), ("IF_STMT",), "Kosul akisi tum ana katmanlarda mevcut."),
    Feature("SELECT CASE", "select", ("SELECT_STMT", "CASE_BLOCK"), ("SELECT_STMT",), ("SELECT_STMT",), ("SELECT_STMT",), (), ("SELECT_STMT",), "Parser/MIR/x64 izi var; MIR evaluator tarafinda ozel select izi zayif."),
    Feature("FOR", "for", ("FOR_STMT",), ("FOR_STMT",), ("FOR_STMT",), ("FOR_STMT",), (), ("FOR_STMT",), "Klasik FOR tum buyuk katmanlarda izli."),
    Feature("FOR EACH", "each", ("FOR_EACH_STMT",), ("FOR_EACH_STMT",), ("FOR_EACH_STMT",), ("FOR_EACH_STMT",), (), ("FOR_EACH_STMT",), "Yuzey var; koleksiyon baglama kismi kabul edilmeli."),
    Feature("DO/LOOP", "do", ("DO_STMT",), ("DO_STMT",), ("DO_STMT",), ("DO_STMT",), (), ("DO_STMT",), "Dongu katmanlarda var."),
    Feature("GOTO", "goto", ("GOTO_STMT",), ("GOTO_STMT",), ("GOTO_STMT",), (), (), ("GOTO_STMT",), "AST/x64 izi var; MIR lowering izinde yok."),
    Feature("GOSUB/RETURN", "gosub", ("GOSUB_STMT", "RETURN_STMT"), ("GOSUB_STMT", "RETURN_STMT"), ("GOSUB_STMT", "RETURN_STMT"), (), (), ("GOSUB_STMT", "RETURN_STMT"), "Eski BASIC kontrol akisi x64/AST tarafinda var; MIR tarafi zayif."),
    Feature("SUB", "sub", ("SUB_STMT", "PARAM_DECL"), ("SUB_STMT",), ("SUB_STMT",), (), (), ("SUB_STMT",), "Bildirim ve codegen izi var; MIR fonksiyon indirme sinirli."),
    Feature("FUNCTION", "function", ("FUNCTION_STMT", "RETURN_TYPE"), ("FUNCTION_STMT",), ("FUNCTION_STMT",), (), (), ("FUNCTION_STMT",), "Bildirim ve codegen izi var; call/return tam davranis test edilmeli."),
    Feature("CALL", "call", ("CALL_STMT", "CALL_EXPR"), ("CALL_STMT", "CALL_EXPR"), ("CALL_STMT", "CALL_EXPR"), ("CALL_STMT",), ("CALL",), ("CALL_STMT", "CALL_EXPR"), "User/builtin/FFI ayrimi daginik; dispatcher guclendirilmeli."),
    Feature("TYPE", "type", ("TYPE_STMT", "TYPE_FIELD"), ("TYPE_STMT",), ("TYPE_STMT",), (), (), ("TYPE_STMT",), "UDT yuzeyi var; layout/codegen detaylari kismi."),
    Feature("CLASS", "class", ("CLASS_STMT", "CLASS_FIELD"), ("CLASS_STMT",), ("CLASS_STMT", "CLASS_FIELD"), (), (), (), "Class parser/semantic yuzeyi var; MIR/x64/object runtime yok veya cok zayif."),
    Feature("CLASS METHOD", "method", ("CLASS_METHOD_DECL",), ("CLASS_METHOD_DECL",), ("CLASS_METHOD_DECL",), (), (), (), "Method bildirimi var; inline body ve cagirma tam degil."),
    Feature("CONSTRUCTOR", "constructor", ("CLASS_CONSTRUCTOR_DECL",), ("CLASS_CONSTRUCTOR_DECL",), ("CLASS_CONSTRUCTOR_DECL",), (), (), (), "Constructor bildirimi var; NEW ile yasam dongusu bagli degil."),
    Feature("DESTRUCTOR", "destructor", ("CLASS_DESTRUCTOR_DECL",), ("CLASS_DESTRUCTOR_DECL",), ("CLASS_DESTRUCTOR_DECL",), (), (), (), "Destructor bildirimi var; DELETE/finalize ile bagli degil."),
    Feature("INTERFACE", "interface", ("INTERFACE_STMT", "INTERFACE_METHOD_DECL"), ("INTERFACE_STMT",), ("INTERFACE_STMT",), (), (), (), "Interface yuzeyi var; implements imza denetimi/runtime dispatch eksik."),
    Feature("NEW", "new", ("NEW_EXPR",), ("NEW_EXPR",), ("NEW_EXPR",), ("MIR_OP_NEW", "NEW_EXPR"), ("NEW",), ("NEW_EXPR",), "NEW expression taniniyor; class constructor baglantisi ayrica eksik."),
    Feature("DELETE", "delete", ("DELETE_STMT",), ("DELETE_STMT",), ("DELETE_STMT",), (), (), ("DELETE_STMT",), "DELETE statement var; destructor/free semantigi tamam degil."),
    Feature("FIELD ACCESS", ".", ("FIELD_EXPR",), ("FIELD_EXPR",), ("FIELD_EXPR",), (), (), ("FIELD_EXPR",), "Nokta erisimi parse/codegen izli; semantic layout baglantisi kismi."),
    Feature("REDIM", "redim", ("REDIM_STMT", "REDIM_DECL"), ("REDIM_STMT",), ("REDIM_STMT",), ("REDIM_STMT", "MIR_OP_REDIM"), ("REDIM",), ("REDIM_STMT",), "Dinamik dizi bildirimi var; tam bounds/runtime davranisi test edilmeli."),
    Feature("FILE IO", "open", ("OPEN_STMT", "CLOSE_STMT", "GET_STMT", "PUT_STMT", "SEEK_STMT"), ("OPEN_STMT",), ("OPEN_STMT", "GET_STMT", "PUT_STMT", "SEEK_STMT"), (), (), ("OPEN_STMT", "GET_STMT", "PUT_STMT", "SEEK_STMT"), "File IO parser/runtime/x64 izli; MIR tarafi yok."),
    Feature("TRY/CATCH/THROW", "try", ("TRY_STMT", "CATCH_PART", "THROW_STMT"), ("TRY_STMT", "THROW_STMT"), ("TRY_STMT", "THROW_STMT"), ("TRY_STMT", "THROW_STMT"), (), (), "Exception yuzeyi AST/MIR lowering tarafinda var; x64 destegi yok."),
    Feature("ASSERT", "assert", ("ASSERT_STMT",), ("ASSERT_STMT",), ("ASSERT_STMT",), ("ASSERT_STMT",), (), (), "Assert parser/runtime/MIR izli; x64 yok."),
    Feature("INLINE ASM", "inline", ("INLINE_STMT",), ("INLINE_STMT",), (), (), (), ("inline_backend", "INLINE"), "Parser ve x64 backend var; AST exec/MIR dogal olarak yok."),
    Feature("IMPORT", "import", ("IMPORT_STMT",), ("IMPORT_STMT",), (), (), (), ("interop", "IMPORT"), "Interop manifest/build tarafina yakin; semantic/runtime baglama kismi."),
    Feature("EVENT/THREAD/PIPE/SLOT", "event", ("SLOT_STMT",), ("EVENT_STMT", "THREAD_STMT", "PIPE_STMT", "SLOT_STMT"), ("SLOT_STMT",), (), (), (), "Parser yuzeyi ve slot runtime var; MIR/x64 yok."),
)


def layer_status(feature: Feature, layer: str) -> tuple[str, list[str]]:
    if layer == "Lexer":
        if feature.keyword in {"=", "."}:
            return "OP", []
        ok, hits = grep_any(LEXER_FILES, [keyword_pattern(feature.keyword)])
        return ("Var" if ok else "Yok"), hits
    if layer == "Parser":
        pats = [rf'Parse\w*{re.escape(feature.name.split()[0])}\w*Stmt'] + [node_pattern(n) for n in feature.ast_nodes]
        ok, hits = grep_any(PARSER_FILES, pats)
        return ("Var" if ok else "Yok"), hits
    if layer == "AST":
        ok, hits = grep_any(AST_FILES, [node_pattern(n) for n in feature.ast_nodes])
        return ("Var" if ok else "Yok"), hits
    if layer == "Semantic":
        pats = [node_pattern(p) for p in feature.semantic_patterns]
        ok, hits = grep_any(SEMANTIC_FILES, pats)
        return ("Var" if ok else "Yok"), hits
    if layer == "AST Exec":
        pats = [node_pattern(p) for p in feature.ast_exec_patterns]
        ok, hits = grep_any(AST_EXEC_FILES, pats)
        return ("Var" if ok else "Yok"), hits
    if layer == "MIR":
        pats = [node_pattern(p) if p.endswith("_STMT") or p.endswith("_EXPR") else re.escape(p) for p in feature.mir_patterns]
        ok, hits = grep_any(MIR_FILES, pats)
        return ("Var" if ok else "Yok"), hits
    if layer == "MIR Exec":
        pats = [node_pattern(p) if p.endswith("_STMT") else re.escape(p) for p in feature.mir_exec_patterns]
        ok, hits = grep_any(MIR_EXEC_FILES, pats)
        return ("Var" if ok else "Yok"), hits
    if layer == "x64":
        pats = [node_pattern(p) if (p.endswith("_STMT") or p.endswith("_EXPR")) else re.escape(p) for p in feature.x64_patterns]
        ok, hits = grep_any(X64_FILES, pats)
        return ("Var" if ok else "Yok"), hits
    raise ValueError(layer)


def overall(statuses: dict[str, str]) -> str:
    core = [statuses[x] for x in ("Lexer", "Parser", "AST", "Semantic", "AST Exec", "MIR", "MIR Exec", "x64")]
    var_count = sum(1 for s in core if s in {"Var", "OP"})
    if var_count == len(core):
        return "Tam iz var"
    if statuses["Parser"] == "Var" and statuses["AST"] == "Var" and var_count >= 5:
        return "Kısmi"
    if statuses["Parser"] == "Var" and statuses["AST"] == "Var":
        return "Yüzey var"
    return "Eksik"


def generate() -> str:
    layers = ["Lexer", "Parser", "AST", "Semantic", "AST Exec", "MIR", "MIR Exec", "x64"]
    lines: list[str] = []
    lines.append("# uXBasic src7 Compiler Feature Matrix")
    lines.append("")
    lines.append("Bu belge `tools/feature_matrix.py` ile `src7` kaynak agacindan statik olarak uretilir. `Var`, kaynak kodunda o katmana ait dogrudan destek izi bulundugu anlamina gelir; davranissal dogrulama icin ayrica test kosmak gerekir.")
    lines.append("")
    lines.append("| Özellik | Lexer | Parser | AST | Semantic | AST Exec | MIR | MIR Exec | x64 | Durum | Not |")
    lines.append("|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---|")
    evidence: list[str] = []
    for f in FEATURES:
        statuses: dict[str, str] = {}
        hits_by_layer: dict[str, list[str]] = {}
        for layer in layers:
            st, hits = layer_status(f, layer)
            statuses[layer] = st
            hits_by_layer[layer] = hits
        lines.append("| " + " | ".join([
            f.name,
            statuses["Lexer"], statuses["Parser"], statuses["AST"], statuses["Semantic"], statuses["AST Exec"], statuses["MIR"], statuses["MIR Exec"], statuses["x64"],
            overall(statuses), f.note
        ]) + " |")
        evidence.append(f"### {f.name}")
        for layer in layers:
            sample = hits_by_layer[layer][:3]
            evidence.append(f"- {layer}: {statuses[layer]}" + (" — " + "; ".join(sample) if sample else ""))
        evidence.append("")
    lines.append("")
    lines.append("## Kritik sonuç")
    lines.append("")
    lines.append("`src7` icin ana sonuc: parser ve AST yuzeyi genis; semantic, AST interpreter, MIR, MIR evaluator ve x64 ayni kapsami tasimiyor. Bu yuzden yeni ozellik eklemeden once katman esitleme yapilmalidir.")
    lines.append("")
    lines.append("## Kanıt izleri")
    lines.append("")
    lines.extend(evidence)
    return "\n".join(lines).replace("ı", "ı") + "\n"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--out", default=str(OUT), help="Markdown cikti yolu")
    args = parser.parse_args()
    out = Path(args.out)
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(generate(), encoding="utf-8")
    print(f"wrote {out}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
