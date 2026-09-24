#!/usr/bin/env python3
from __future__ import annotations
import argparse
import ctypes
import json
from pathlib import Path


def configure(dll: ctypes.CDLL) -> None:
    dll.uxjs_version.restype = ctypes.c_int32
    dll.uxjs_quickjs_version.restype = ctypes.c_char_p
    for name in ("uxjs_runtime_create", "uxjs_context_create"):
        getattr(dll, name).restype = ctypes.c_int32
    dll.uxjs_runtime_free.argtypes = [ctypes.c_int32]
    dll.uxjs_context_free.argtypes = [ctypes.c_int32]
    dll.uxjs_install_native_host.argtypes = [ctypes.c_int32]
    dll.uxjs_bootstrap_uxb.argtypes = [ctypes.c_int32, ctypes.c_char_p, ctypes.c_char_p]
    dll.uxjs_eval_file.argtypes = [ctypes.c_int32, ctypes.c_char_p, ctypes.c_int32]
    dll.uxjs_call_json.argtypes = [ctypes.c_int32, ctypes.c_char_p, ctypes.c_char_p]
    dll.uxjs_call_json.restype = ctypes.c_int32
    dll.uxjs_call_json_await.argtypes = [ctypes.c_int32, ctypes.c_char_p, ctypes.c_char_p, ctypes.c_int32]
    dll.uxjs_call_json_await.restype = ctypes.c_int32
    dll.uxjs_result_json.argtypes = [ctypes.c_int32, ctypes.c_int32]
    dll.uxjs_result_json.restype = ctypes.c_char_p
    dll.uxjs_result_free.argtypes = [ctypes.c_int32, ctypes.c_int32]
    dll.uxjs_last_error.argtypes = [ctypes.c_int32]
    dll.uxjs_last_error.restype = ctypes.c_char_p


def error(dll: ctypes.CDLL, context: int) -> str:
    raw = dll.uxjs_last_error(context)
    return raw.decode("utf-8", errors="replace") if raw else ""


def check(value: int, message: str, dll: ctypes.CDLL, context: int = 0) -> int:
    if not value:
        raise RuntimeError(f"{message}: {error(dll, context)}")
    return value


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", default=".")
    parser.add_argument("--dll", default="bin/uxjsrt.dll")
    args = parser.parse_args()
    root = Path(args.root).resolve()
    dll = ctypes.CDLL(str((root / args.dll).resolve()))
    configure(dll)
    assert dll.uxjs_version() == 110
    runtime = check(dll.uxjs_runtime_create(), "runtime create", dll)
    context = 0
    try:
        context = check(dll.uxjs_context_create(runtime), "context create", dll)
        core = str(root / "runtime/js/common/ux_runtime_core.js").encode()
        provider = str(root / "runtime/js/quickjs/ux_runtime_quickjs.js").encode()
        check(dll.uxjs_bootstrap_uxb(context, core, provider), "bootstrap", dll, context)
        smoke = str(root / "tests/libraries/uxjsruntime/smoke.js").encode()
        check(dll.uxjs_eval_file(context, smoke, 2), "smoke eval", dll, context)
        result = check(dll.uxjs_call_json_await(context, b"uxbMain", b"[]", 10000), "uxbMain", dll, context)
        try:
            payload = json.loads(dll.uxjs_result_json(context, result).decode())
            assert payload["marker"] == "UXJSRT_GLOBALTHIS_UXB_PASS"
            assert payload["provider"] == "quickjs"
            assert payload["sum"] == 30
            print(json.dumps(payload, ensure_ascii=False, indent=2))
        finally:
            check(dll.uxjs_result_free(context, result), "result free", dll, context)
    finally:
        if context:
            check(dll.uxjs_context_free(context), "context free", dll, context)
        check(dll.uxjs_runtime_free(runtime), "runtime free", dll)
    print("UXJSRT_NATIVE_SMOKE_PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
