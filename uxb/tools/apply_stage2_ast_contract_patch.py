#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
uXBasiC Stage 2 AST Contract patch applier.

Run from the uxb repository root:

    python tools\apply_stage2_ast_contract_patch.py

What it does:
  - inserts ast_contract.fbs include lines if missing
  - adds --ast-contract-json-out and --ast-contract-check CLI wiring
  - does not overwrite existing code blindly
  - writes .stage2bak backup files before editing
"""
from __future__ import annotations

import shutil
import sys
from pathlib import Path


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8-sig")


def write_text(path: Path, text: str) -> None:
    path.write_text(text, encoding="utf-8", newline="")


def backup(path: Path) -> None:
    bak = path.with_suffix(path.suffix + ".stage2bak")
    if not bak.exists():
        shutil.copy2(path, bak)


def ensure_contains(path: Path, needle: str) -> None:
    if not path.exists():
        raise FileNotFoundError(f"missing required file: {path}")
    text = read_text(path)
    if needle not in text:
        raise RuntimeError(f"expected marker not found in {path}: {needle!r}")


def insert_after_once(text: str, marker: str, insertion: str) -> tuple[str, bool]:
    if insertion.strip() in text:
        return text, False
    idx = text.find(marker)
    if idx < 0:
        raise RuntimeError(f"marker not found: {marker!r}")
    end = idx + len(marker)
    return text[:end] + insertion + text[end:], True


def insert_before_once(text: str, marker: str, insertion: str) -> tuple[str, bool]:
    if insertion.strip() in text:
        return text, False
    idx = text.find(marker)
    if idx < 0:
        raise RuntimeError(f"marker not found: {marker!r}")
    return text[:idx] + insertion + text[idx:], True


def patch_file(path: Path, patcher) -> bool:
    text = read_text(path)
    new_text, changed = patcher(text)
    if changed:
        backup(path)
        write_text(path, new_text)
    return changed


def patch_main_bas(text: str) -> tuple[str, bool]:
    changed = False

    text2, ch = insert_after_once(
        text,
        '#include "parser/ast.fbs"',
        '\n#include "parser/ast_contract.fbs"',
    )
    text, changed = text2, changed or ch

    value_arg_line = '    If k = "--ast-json-out" Then Return 1\n'
    if 'If k = "--ast-contract-json-out" Then Return 1' not in text:
        replacement = value_arg_line + '    If k = "--ast-contract-json-out" Then Return 1\n    If k = "--ast-contract-report-json-out" Then Return 1\n'
        if value_arg_line not in text:
            raise RuntimeError("cannot find --ast-json-out IsValueArgKey marker in main.bas")
        text = text.replace(value_arg_line, replacement, 1)
        changed = True

    return text, changed


def patch_frontend_bundle(text: str) -> tuple[str, bool]:
    return insert_after_once(
        text,
        '#include "../parser/ast.fbs"',
        '\n#include "../parser/ast_contract.fbs"',
    )


def patch_entry(text: str) -> tuple[str, bool]:
    changed = False

    # 1) variables
    marker = 'Dim As String astJsonOutPath\n'
    if 'Dim As String astContractJsonOutPath' not in text:
        if marker not in text:
            raise RuntimeError("cannot find astJsonOutPath variable marker")
        text = text.replace(
            marker,
            marker + 'Dim As String astContractJsonOutPath\nDim As Integer astContractCheckMode\n',
            1,
        )
        changed = True

    # 2) option read
    marker = 'astJsonOutPath = ""\nIf GetArgValue("--ast-json-out", astJsonOutPath) = 0 Then astJsonOutPath = ""\n'
    if 'astContractJsonOutPath = ""' not in text:
        if marker not in text:
            raise RuntimeError("cannot find astJsonOutPath parse marker")
        insertion = (
            marker
            + '\nastContractJsonOutPath = ""\n'
            + 'If GetArgValue("--ast-contract-json-out", astContractJsonOutPath) = 0 Then\n'
            + '    If GetArgValue("--ast-contract-report-json-out", astContractJsonOutPath) = 0 Then astContractJsonOutPath = ""\n'
            + 'End If\n'
            + 'astContractCheckMode = HasArg("--ast-contract-check")\n'
        )
        text = text.replace(marker, insertion, 1)
        changed = True

    # 3) debug lines
    marker = 'If debugMode Then UxbDebug "astJsonOut=" & astJsonOutPath\n'
    if 'If debugMode Then UxbDebug "astContractJsonOut=" & astContractJsonOutPath' not in text:
        if marker not in text:
            raise RuntimeError("cannot find astJsonOut debug marker")
        text = text.replace(
            marker,
            marker
            + 'If debugMode Then UxbDebug "astContractJsonOut=" & astContractJsonOutPath\n'
            + 'If debugMode Then UxbDebug "astContractCheck=" & Str(astContractCheckMode)\n',
            1,
        )
        changed = True

    # 4) contract report block after AST JSON block
    marker = 'End If\n\nIf Trim(inventoryJsonOutPath) <> "" Then\n'
    contract_block = '''End If

If Trim(astContractJsonOutPath) <> "" Or astContractCheckMode <> 0 Then
    Dim astContractErr As String
    If astContractCheckMode <> 0 Then
        If UXBAstValidateContract(ps.ast, ps.rootNode, astContractErr) = 0 Then
            UxbError "AST sozlesme denetimi basarisiz: " & LocalizeErrorMessage(astContractErr)
            End 17
        End If
        If debugMode Then UxbInfo "AST sozlesme denetimi PASS"
    End If

    If Trim(astContractJsonOutPath) <> "" Then
        Dim astContractParent As String
        astContractParent = PathDirName(astContractJsonOutPath)
        If astContractParent <> "." Then
            If Dir(astContractParent) = "" Then
                Dim astContractMkCmd As String
                astContractMkCmd = "cmd /c mkdir " & Chr(34) & astContractParent & Chr(34)
                Shell astContractMkCmd
            End If
        End If

        If UXBAstWriteContractReportJson(ps.ast, ps.rootNode, astContractJsonOutPath, astContractErr) = 0 Then
            UxbError "AST sozlesme JSON cikti yazimi basarisiz: " & LocalizeErrorMessage(astContractErr)
            End 18
        End If
        If debugMode Then UxbInfo "AST sozlesme JSON yazildi: " & astContractJsonOutPath
    End If
End If

If Trim(inventoryJsonOutPath) <> "" Then
'''
    if 'UXBAstWriteContractReportJson(ps.ast, ps.rootNode' not in text:
        if marker not in text:
            raise RuntimeError("cannot find insertion marker before inventory JSON block")
        text = text.replace(marker, contract_block, 1)
        changed = True

    return text, changed


def main() -> int:
    root = Path.cwd()
    if not (root / "src" / "main.bas").exists():
        print("ERROR: run this script from the uxb repository root", file=sys.stderr)
        print("Expected: ./src/main.bas", file=sys.stderr)
        return 2

    files = {
        "main": root / "src" / "main.bas",
        "bundle": root / "src" / "build" / "main_frontend_include_bundle.fbs",
        "entry": root / "src" / "main_program_entry.fbs",
        "contract": root / "src" / "parser" / "ast_contract.fbs",
    }
    for name, path in files.items():
        if not path.exists():
            print(f"ERROR: missing {name}: {path}", file=sys.stderr)
            return 2

    changed_any = False
    changed_any |= patch_file(files["main"], patch_main_bas)
    changed_any |= patch_file(files["bundle"], patch_frontend_bundle)
    changed_any |= patch_file(files["entry"], patch_entry)

    if changed_any:
        print("Stage 2 AST contract patch applied. Backups: *.stage2bak")
    else:
        print("Stage 2 AST contract patch already applied; no changes.")

    print("Next:")
    print("  compiler\\scripts\\build_uxb_main_64.bat")
    print("  build\\uxb_main_64.exe tests\\basicCodeTests\\42_uxb_native_console_codegen_smoke.bas --ast-contract-json-out dist\\ast_contract.json --ast-contract-check --debug")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
