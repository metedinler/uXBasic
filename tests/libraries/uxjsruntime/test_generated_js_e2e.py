from __future__ import annotations

import argparse
import ctypes
import json
import os
import pathlib
import subprocess


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", required=True)
    args = parser.parse_args()
    root = pathlib.Path(args.root).resolve()
    output_dir = root / "build" / "uxjsruntime_generated_e2e"
    output_dir.mkdir(parents=True, exist_ok=True)
    js_path = output_dir / "program.js"

    command = [
        str(root / "bin" / "uxb.exe"),
        "jsw",
        "tests/libraries/uxjsruntime/generated_e2e.uxb",
        "--emit-js",
        "--js-out",
        str(js_path),
    ]
    completed = subprocess.run(command, cwd=root, text=True, capture_output=True)
    (output_dir / "compiler.stdout.log").write_text(completed.stdout, encoding="utf-8")
    (output_dir / "compiler.stderr.log").write_text(completed.stderr, encoding="utf-8")
    if completed.returncode:
        raise RuntimeError(completed.stdout + "\n" + completed.stderr)

    emitted = js_path.read_text(encoding="utf-8", errors="replace")
    if "globalThis.uxbMain" not in emitted:
        raise RuntimeError("compiler JS output does not export globalThis.uxbMain")
    if "UXJS_GENERATED_PROGRAM_RAN" not in emitted:
        raise RuntimeError("compiler JS output lost the generated source marker")
    if "globalThis.uxb" not in emitted:
        raise RuntimeError("compiler JS output is not connected to globalThis.uxb")

    os.add_dll_directory(str(root / "bin"))
    dll = ctypes.CDLL(str(root / "bin" / "uxjsrt.dll"))
    dll.uxjs_version.argtypes = []
    dll.uxjs_version.restype = ctypes.c_int32
    dll.uxjs_runtime_create.argtypes = []
    dll.uxjs_runtime_create.restype = ctypes.c_int32
    dll.uxjs_runtime_free.argtypes = [ctypes.c_int32]
    dll.uxjs_runtime_free.restype = ctypes.c_int32
    dll.uxjs_context_create.argtypes = [ctypes.c_int32]
    dll.uxjs_context_create.restype = ctypes.c_int32
    dll.uxjs_context_free.argtypes = [ctypes.c_int32]
    dll.uxjs_context_free.restype = ctypes.c_int32
    dll.uxjs_bootstrap_uxb.argtypes = [ctypes.c_int32, ctypes.c_char_p, ctypes.c_char_p]
    dll.uxjs_bootstrap_uxb.restype = ctypes.c_int32
    dll.uxjs_eval_file.argtypes = [ctypes.c_int32, ctypes.c_char_p, ctypes.c_int32]
    dll.uxjs_eval_file.restype = ctypes.c_int32
    dll.uxjs_call_json_await.argtypes = [ctypes.c_int32, ctypes.c_char_p, ctypes.c_char_p, ctypes.c_int32]
    dll.uxjs_call_json_await.restype = ctypes.c_int32
    dll.uxjs_result_json.argtypes = [ctypes.c_int32, ctypes.c_int32]
    dll.uxjs_result_json.restype = ctypes.c_char_p
    dll.uxjs_result_free.argtypes = [ctypes.c_int32, ctypes.c_int32]
    dll.uxjs_result_free.restype = ctypes.c_int32
    dll.uxjs_last_error.argtypes = [ctypes.c_int32]
    dll.uxjs_last_error.restype = ctypes.c_char_p

    if dll.uxjs_version() < 100:
        raise RuntimeError("stale uxjsrt.dll API")
    runtime_handle = dll.uxjs_runtime_create()
    if runtime_handle <= 0:
        raise RuntimeError("runtime creation failed")
    context_handle = dll.uxjs_context_create(runtime_handle)
    if context_handle <= 0:
        dll.uxjs_runtime_free(runtime_handle)
        raise RuntimeError("context creation failed")

    core = root / "runtime" / "js" / "common" / "ux_runtime_core.js"
    provider = root / "runtime" / "js" / "quickjs" / "ux_runtime_quickjs.js"
    try:
        if not dll.uxjs_bootstrap_uxb(context_handle, str(core).encode(), str(provider).encode()):
            error = dll.uxjs_last_error(context_handle)
            raise RuntimeError(f"bootstrap failed: {(error or b'').decode(errors='replace')}")
        if not dll.uxjs_eval_file(context_handle, str(js_path).encode(), 0):
            error = dll.uxjs_last_error(context_handle)
            raise RuntimeError(f"generated JS eval failed: {(error or b'').decode(errors='replace')}")
        result_handle = dll.uxjs_call_json_await(context_handle, b"uxbMain", b"[]", 1000)
        if result_handle <= 0:
            error = dll.uxjs_last_error(context_handle)
            raise RuntimeError(f"uxbMain call failed: {(error or b'').decode(errors='replace')}")
        result_pointer = dll.uxjs_result_json(context_handle, result_handle)
        if not result_pointer:
            raise RuntimeError("uxbMain result JSON is null")
        result_text = result_pointer.decode(errors="replace")
        # MAIN normally returns undefined; UXJSRT encodes it as tagged valid JSON.
        if not result_text.strip():
            raise RuntimeError("uxbMain result JSON is empty")
        parsed_result = json.loads(result_text)
        if not isinstance(parsed_result, dict) or parsed_result.get("$uxbType") != "undefined":
            raise RuntimeError(f"unexpected uxbMain result JSON: {result_text}")
        dll.uxjs_result_free(context_handle, result_handle)
    finally:
        dll.uxjs_context_free(context_handle)
        dll.uxjs_runtime_free(runtime_handle)

    print(json.dumps({"uxjsApi": dll.uxjs_version(), "generatedJs": str(js_path), "resultJson": result_text}))
    print("UXJSRT_GENERATED_JS_E2E_PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
