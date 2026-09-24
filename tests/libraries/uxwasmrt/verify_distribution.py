#!/usr/bin/env python3
from __future__ import annotations

import argparse
import ctypes
import json
import os
import pathlib
import shutil
import subprocess
import sys
import tempfile


def run(command: list[str], cwd: pathlib.Path, name: str) -> subprocess.CompletedProcess[str]:
    process = subprocess.run(command, cwd=cwd, text=True, capture_output=True, check=False)
    if process.returncode != 0:
        raise RuntimeError(
            f"{name} failed exit={process.returncode}\n"
            f"stdout:\n{process.stdout}\nstderr:\n{process.stderr}"
        )
    return process


def configure(lib: ctypes.CDLL) -> None:
    lib.uxwasm_open_file.argtypes = [ctypes.c_char_p]
    lib.uxwasm_open_file.restype = ctypes.c_int32
    lib.uxwasm_call_i32_2.argtypes = [
        ctypes.c_int32, ctypes.c_char_p, ctypes.c_int32, ctypes.c_int32
    ]
    lib.uxwasm_call_i32_2.restype = ctypes.c_int32
    lib.uxwasm_last_ok.argtypes = [ctypes.c_int32]
    lib.uxwasm_last_ok.restype = ctypes.c_int32
    lib.uxwasm_last_error.argtypes = [ctypes.c_int32]
    lib.uxwasm_last_error.restype = ctypes.c_char_p
    lib.uxwasm_close.argtypes = [ctypes.c_int32]
    lib.uxwasm_close.restype = ctypes.c_int32


def last_error(lib: ctypes.CDLL, handle: int) -> str:
    raw = lib.uxwasm_last_error(handle)
    return raw.decode("utf-8", "replace") if raw else ""


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", default=".")
    parser.add_argument("--json-out", default="")
    args = parser.parse_args()
    root = pathlib.Path(args.root).resolve()

    required = [
        root / "bin" / "uxb.exe",
        root / "bin" / "uxwasmrt.dll",
        root / "bin" / "wasmtime.dll",
        root / "tools" / "wabt" / "bin" / "wat2wasm.exe",
        root / "tools" / "wabt" / "bin" / "wasm-validate.exe",
        root / "runtime" / "browser" / "ux_wasm_bridge.js",
        root / "tests" / "libraries" / "uxwasmrt" / "reference_26_07" / "add.wasm",
    ]
    missing = [str(path) for path in required if not path.is_file()]
    if missing:
        raise RuntimeError("Distribution files missing:\n" + "\n".join(missing))

    uxb = root / "bin" / "uxb.exe"
    wat2wasm = root / "tools" / "wabt" / "bin" / "wat2wasm.exe"
    validate = root / "tools" / "wabt" / "bin" / "wasm-validate.exe"
    run([str(uxb), "--help"], root, "uxb-help")
    run(
        [str(validate), str(root / "tests" / "libraries" / "uxwasmrt" / "reference_26_07" / "add.wasm")],
        root,
        "reference-wasm-validate",
    )
    native = run(
        [sys.executable, ".\\tests\\libraries\\uxwasmrt\\test_uxwasmrt.py", "--root", "."],
        root,
        "native-runtime-smoke",
    )
    if "UXWASMRT_NATIVE_SMOKE_PASS" not in native.stdout:
        raise RuntimeError("Native runtime smoke lacked its PASS marker")

    with tempfile.TemporaryDirectory(prefix="uxb-wasm-dist-") as temporary:
        temp = pathlib.Path(temporary)
        wat = temp / "program.wat"
        wasm = temp / "program.wasm"
        source = root / "tests" / "libraries" / "uxwasmrt" / "compiler_core_i32.uxb"
        run(
            [
                str(uxb), "--source", str(source), "--emit-wasm",
                "--wasm-wat-out", str(wat), "--wasm-out", str(wasm),
                "--wat2wasm", str(wat2wasm),
            ],
            root,
            "compiler-generated-wasm",
        )
        if not wat.is_file() or not wasm.is_file():
            raise RuntimeError("Compiler did not create both WAT and WASM outputs")
        run([str(validate), str(wasm)], root, "generated-wasm-validate")

        if hasattr(os, "add_dll_directory"):
            dll_directory = os.add_dll_directory(str(root / "bin"))
        else:
            dll_directory = None
        try:
            lib = ctypes.CDLL(str(root / "bin" / "uxwasmrt.dll"))
            configure(lib)
            handle = lib.uxwasm_open_file(os.fsencode(wasm))
            if not handle:
                raise RuntimeError("Generated WASM open failed: " + last_error(lib, 0))
            try:
                value = lib.uxwasm_call_i32_2(handle, b"ADD", 10, 20)
                if lib.uxwasm_last_ok(handle) != 1 or value != 30:
                    raise RuntimeError(
                        f"Generated WASM ADD result={value}: {last_error(lib, handle)}"
                    )
            finally:
                if lib.uxwasm_close(handle) != 1:
                    raise RuntimeError("Generated WASM session close failed")
        finally:
            if dll_directory is not None:
                dll_directory.close()

    browser_status = "SKIP_NODE_NOT_FOUND"
    node = shutil.which("node.exe") or shutil.which("node")
    if node:
        browser = run(
            [
                node,
                ".\\tests\\libraries\\uxwasmrt\\browser_bridge_smoke.mjs", ".",
            ],
            root,
            "browser-bridge-smoke",
        )
        if "UXWASM_BROWSER_BRIDGE_SMOKE_PASS" not in browser.stdout:
            raise RuntimeError("Browser bridge smoke lacked its PASS marker")
        browser_status = "PASS"

    report = {
        "schema": "uxb.wasm.distribution.verify.v1",
        "status": "PASS",
        "profile": "core-i32",
        "nativeProvider": "wasmtime-wasm-c-api",
        "browserProvider": "browser-webassembly",
        "compilerGeneratedAdd": 30,
        "browserSmoke": browser_status,
    }
    if args.json_out:
        output = pathlib.Path(args.json_out)
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(json.dumps(report, indent=2), encoding="utf-8")
    print("UXB_WASM_DISTRIBUTION_VERIFY_PASS")
    print(json.dumps(report))
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as error:
        print(f"UXB_WASM_DISTRIBUTION_VERIFY_FAIL: {error}", file=sys.stderr)
        raise SystemExit(1)
