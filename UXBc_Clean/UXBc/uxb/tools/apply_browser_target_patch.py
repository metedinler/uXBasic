from __future__ import annotations
import argparse
import shutil
from pathlib import Path

JS_WASM_INCLUDES = """
' UXB_BROWSER_TARGET_PATCH_BEGIN includes
#include once "codegen/js/js_expr_emit.fbs"
#include once "codegen/js/js_stmt_emit.fbs"
#include once "codegen/js/js_mir_runtime_emit.fbs"
#include once "codegen/js/js_wasm_bridge_emit.fbs"
#include once "codegen/js/js_emitter.fbs"

#include once "codegen/wasm/wasm_type_emit.fbs"
#include once "codegen/wasm/wasm_instr_emit.fbs"
#include once "codegen/wasm/wasm_host_imports.fbs"
#include once "codegen/wasm/wasm_manifest_emit.fbs"
#include once "codegen/wasm/wasm_emitter.fbs"
' UXB_BROWSER_TARGET_PATCH_END includes
""".strip()

VALUE_ARG_PATCH = """
    ' UXB_BROWSER_TARGET_PATCH_BEGIN value-args
    If k = "--target" Then Return 1
    If k = "--js-out" Then Return 1
    If k = "--browser-out-dir" Then Return 1
    If k = "--browser-runtime-dir" Then Return 1
    If k = "--wasm-wat-out" Then Return 1
    If k = "--wasm-out" Then Return 1
    If k = "--wasm-manifest-out" Then Return 1
    If k = "--hybrid-manifest-out" Then Return 1
    If k = "--wat2wasm" Then Return 1
    ' UXB_BROWSER_TARGET_PATCH_END value-args
""".rstrip()

ENTRY_VAR_PATCH = """
' UXB_BROWSER_TARGET_PATCH_BEGIN vars
Dim As String targetMode
Dim As String jsOutPath
Dim As String browserOutDir
Dim As String browserRuntimeDir
Dim As String wasmWatOutPath
Dim As String wasmOutPath
Dim As String wasmManifestOutPath
Dim As String hybridManifestOutPath
Dim As String wat2wasmPath

Dim As Integer jsTargetMode
Dim As Integer wasmTargetMode
Dim As Integer browserHybridMode
' UXB_BROWSER_TARGET_PATCH_END vars
""".strip()

ENTRY_ARG_PATCH = """
' UXB_BROWSER_TARGET_PATCH_BEGIN args
targetMode = ""
If GetArgValue("--target", targetMode) = 0 Then targetMode = ""
targetMode = LCase(Trim(targetMode))

jsTargetMode = IIf(targetMode = "js", 1, 0)
wasmTargetMode = IIf(targetMode = "wasm", 1, 0)
browserHybridMode = IIf(targetMode = "browser" Or targetMode = "browser-hybrid", 1, 0)

jsOutPath = "dist\\js\\program.js"
GetArgValue("--js-out", jsOutPath)

browserOutDir = "dist\\browser\\program"
GetArgValue("--browser-out-dir", browserOutDir)

browserRuntimeDir = "runtime\\browser"
GetArgValue("--browser-runtime-dir", browserRuntimeDir)

wasmWatOutPath = "dist\\wasm\\program.wat"
GetArgValue("--wasm-wat-out", wasmWatOutPath)

wasmOutPath = "dist\\wasm\\program.wasm"
GetArgValue("--wasm-out", wasmOutPath)

wasmManifestOutPath = "dist\\wasm\\wasm_manifest.json"
GetArgValue("--wasm-manifest-out", wasmManifestOutPath)

hybridManifestOutPath = "dist\\browser\\hybrid_manifest.json"
GetArgValue("--hybrid-manifest-out", hybridManifestOutPath)

wat2wasmPath = "wat2wasm"
GetArgValue("--wat2wasm", wat2wasmPath)
' UXB_BROWSER_TARGET_PATCH_END args
""".strip()

NEED_MIR_PATCH = """
' UXB_BROWSER_TARGET_PATCH_BEGIN need-mir
If jsTargetMode <> 0 Then needMirModule = 1
If wasmTargetMode <> 0 Then needMirModule = 1
If browserHybridMode <> 0 Then needMirModule = 1
' UXB_BROWSER_TARGET_PATCH_END need-mir
""".strip()

BACKEND_DISPATCH_PATCH = """
' UXB_BROWSER_TARGET_PATCH_BEGIN backend-dispatch
If wasmTargetMode <> 0 Or browserHybridMode <> 0 Then
    Dim wasmErr As String
    If UXBWasmEmitWatFromMIR(mirModule, wasmWatOutPath, wasmManifestOutPath, wasmErr) = 0 Then
        UxbError "WASM WAT üretimi başarısız: " & LocalizeErrorMessage(wasmErr)
        End 30
    End If

    If Trim(wasmOutPath) <> "" Then
        UXBWasmTryBuildBinary wasmWatOutPath, wasmOutPath, wat2wasmPath
    End If
End If

If jsTargetMode <> 0 Then
    Dim jsErr As String
    If UXBJsEmitFromMIR(mirModule, sourcePath, jsOutPath, "", jsErr) = 0 Then
        UxbError "JS transpiler başarısız: " & LocalizeErrorMessage(jsErr)
        End 31
    End If
End If

If browserHybridMode <> 0 Then
    Dim browserErr As String
    If UXBJsEmitBrowserHybridBundle(mirModule, sourcePath, browserOutDir, browserRuntimeDir, wasmWatOutPath, wasmOutPath, wasmManifestOutPath, browserErr) = 0 Then
        UxbError "Browser hybrid paket üretimi başarısız: " & LocalizeErrorMessage(browserErr)
        End 32
    End If
End If
' UXB_BROWSER_TARGET_PATCH_END backend-dispatch
""".strip()

def read(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="ignore")

def write(path: Path, text: str) -> None:
    path.write_text(text, encoding="utf-8", newline="")

def copy_patch_files(patch_uxb: Path, target_uxb: Path) -> None:
    for src in patch_uxb.rglob("*"):
        if src.is_dir():
            continue
        rel = src.relative_to(patch_uxb)
        dst = target_uxb / rel
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dst)

def patch_main_bas(target_uxb: Path) -> None:
    path = target_uxb / "src" / "main.bas"
    text = read(path)
    if "UXB_BROWSER_TARGET_PATCH_BEGIN includes" not in text:
        anchor = '#include "build/x64_build_pipeline.fbs"'
        if anchor in text:
            text = text.replace(anchor, anchor + "\n" + JS_WASM_INCLUDES, 1)
        else:
            anchor = '#include "codegen/x64/code_generator.fbs"'
            text = text.replace(anchor, anchor + "\n" + JS_WASM_INCLUDES, 1)

    if "UXB_BROWSER_TARGET_PATCH_BEGIN value-args" not in text:
        marker = "Private Function IsValueArgKey"
        idx = text.find(marker)
        if idx >= 0:
            end_idx = text.find("    Return 0", idx)
            if end_idx >= 0:
                text = text[:end_idx] + VALUE_ARG_PATCH + "\n" + text[end_idx:]
    write(path, text)

def patch_entry(target_uxb: Path) -> None:
    path = target_uxb / "src" / "main_program_entry.fbs"
    text = read(path)

    if "UXB_BROWSER_TARGET_PATCH_BEGIN vars" not in text:
        anchor = "Dim As Integer enableMirX64Experimental"
        idx = text.find(anchor)
        if idx >= 0:
            line_end = text.find("\n", idx)
            text = text[:line_end+1] + ENTRY_VAR_PATCH + "\n" + text[line_end+1:]
        else:
            text = ENTRY_VAR_PATCH + "\n" + text

    if "UXB_BROWSER_TARGET_PATCH_BEGIN args" not in text:
        # Insert after a stable mode parsing line if present, otherwise after UxbInit.
        anchors = [
            'GetArgValue("--codegen-source", codegenSourceMode)',
            'UxbInit',
        ]
        inserted = False
        for anchor in anchors:
            idx = text.find(anchor)
            if idx >= 0:
                line_end = text.find("\n", idx)
                text = text[:line_end+1] + ENTRY_ARG_PATCH + "\n" + text[line_end+1:]
                inserted = True
                break
        if not inserted:
            text = ENTRY_ARG_PATCH + "\n" + text

    if "UXB_BROWSER_TARGET_PATCH_BEGIN need-mir" not in text:
        anchor = 'If codegenSourceMode = "MIR" And Trim(x64CodegenPolicyJsonOutPath) <> "" Then needMirModule = 1'
        idx = text.find(anchor)
        if idx >= 0:
            line_end = text.find("\n", idx)
            text = text[:line_end+1] + NEED_MIR_PATCH + "\n" + text[line_end+1:]
        else:
            anchor = "If Trim(mirFullJsonOutPath) <> \"\" Then needMirModule = 1"
            idx = text.find(anchor)
            line_end = text.find("\n", idx)
            text = text[:line_end+1] + NEED_MIR_PATCH + "\n" + text[line_end+1:]

    if "UXB_BROWSER_TARGET_PATCH_BEGIN backend-dispatch" not in text:
        anchor = "Dim As Integer needX64Policy"
        idx = text.find(anchor)
        if idx >= 0:
            text = text[:idx] + BACKEND_DISPATCH_PATCH + "\n\n" + text[idx:]
        else:
            text += "\n" + BACKEND_DISPATCH_PATCH + "\n"

    write(path, text)

def main() -> int:
    parser = argparse.ArgumentParser(description="Apply uXBasic JS/WASM browser target patch.")
    parser.add_argument("target_uxb", help="Path to the target uxb directory, e.g. C:\\UXBc\\uxb")
    parser.add_argument("--patch-uxb", default=None, help="Optional path to patch_root/uxb")
    args = parser.parse_args()

    target_uxb = Path(args.target_uxb).resolve()
    if not (target_uxb / "src" / "main.bas").exists():
        raise SystemExit(f"main.bas not found under: {target_uxb}")

    script_dir = Path(__file__).resolve().parent
    if args.patch_uxb:
        patch_uxb = Path(args.patch_uxb).resolve()
    else:
        # script may be in package tools/ or copied into target uxb/tools/
        candidate1 = script_dir.parent / "patch_root" / "uxb"
        candidate2 = script_dir.parent / "uxb"
        if candidate1.exists():
            patch_uxb = candidate1
        elif candidate2.exists():
            patch_uxb = candidate2
        else:
            raise SystemExit("patch_root/uxb not found. Use --patch-uxb.")

    copy_patch_files(patch_uxb, target_uxb)
    patch_main_bas(target_uxb)
    patch_entry(target_uxb)

    print("uXBasic JS/WASM browser target patch applied.")
    print(f"Target: {target_uxb}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
