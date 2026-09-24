from __future__ import annotations

import argparse
import ctypes
import json
import os
import pathlib

I32, U32, I64, U64, F64, PTR, STRPTR = 1, 2, 3, 4, 5, 6, 7
REQUIRED_UXFFI_VERSION = 131


def require_pe32_plus(path: pathlib.Path) -> None:
    data = path.read_bytes()
    if len(data) < 0x100 or data[:2] != b"MZ":
        raise RuntimeError(f"{path} is not a PE file")
    peoff = int.from_bytes(data[0x3C:0x40], "little")
    if data[peoff:peoff + 4] != b"PE\0\0":
        raise RuntimeError(f"{path} has no PE signature")
    machine = int.from_bytes(data[peoff + 4:peoff + 6], "little")
    magic = int.from_bytes(data[peoff + 24:peoff + 26], "little")
    if machine != 0x8664 or magic != 0x20B:
        raise RuntimeError(
            f"{path} is not x64 PE32+ machine={machine:#x} magic={magic:#x}"
        )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", required=True)
    args = parser.parse_args()
    root = pathlib.Path(args.root).resolve()
    bindir = root / "bin"
    ffi_path = bindir / "uxffi.dll"
    config_path = bindir / "uxconfig.dll"

    require_pe32_plus(ffi_path)
    require_pe32_plus(config_path)
    newest_source = max(
        (root / "runtime_ext/uxffi/uxffi.c").stat().st_mtime,
        (root / "runtime_ext/uxffi/uxffi.h").stat().st_mtime,
    )
    if ffi_path.stat().st_mtime + 1 < newest_source:
        raise RuntimeError("bin/uxffi.dll is older than its patched source; rebuild did not deploy")

    os.add_dll_directory(str(bindir))
    ffi = ctypes.CDLL(str(ffi_path))
    ffi.uxffi_version.restype = ctypes.c_int
    ffi.uxffi_max_args.restype = ctypes.c_int
    ffi.uxffi_string_length.argtypes = [ctypes.c_uint32]
    ffi.uxffi_string_length.restype = ctypes.c_int
    ffi.uxffi_invoke10.argtypes = [
        ctypes.c_char_p,
        ctypes.c_char_p,
        ctypes.c_int,
        ctypes.c_int,
        ctypes.POINTER(ctypes.c_int),
        ctypes.POINTER(ctypes.c_uint64),
        ctypes.POINTER(ctypes.c_double),
        ctypes.POINTER(ctypes.c_uint64),
        ctypes.POINTER(ctypes.c_double),
        ctypes.c_char_p,
        ctypes.c_int,
    ]
    ffi.uxffi_invoke10.restype = ctypes.c_int
    ffi.uxffi_copy_string.argtypes = [ctypes.c_uint32, ctypes.c_char_p, ctypes.c_int]
    ffi.uxffi_copy_string.restype = ctypes.c_int
    ffi.uxffi_release_handle.argtypes = [ctypes.c_uint32]
    ffi.uxffi_release_handle.restype = ctypes.c_int

    version = ffi.uxffi_version()
    max_args = ffi.uxffi_max_args()
    if version < REQUIRED_UXFFI_VERSION:
        raise RuntimeError(f"stale uxffi.dll; expected >={REQUIRED_UXFFI_VERSION}, got {version}")
    if max_args < 10:
        raise RuntimeError("uxffi ABI10 limit is not available")

    def invoke(symbol: str, return_kind: int, kinds: list[int], values: list[int]):
        count = len(kinds)
        kind_array = (ctypes.c_int * count)(*kinds) if count else None
        u64_array = (ctypes.c_uint64 * count)(*values) if count else None
        f64_array = (ctypes.c_double * count)(*([0.0] * count)) if count else None
        return_u64 = ctypes.c_uint64()
        return_f64 = ctypes.c_double()
        error = ctypes.create_string_buffer(512)
        ok = ffi.uxffi_invoke10(
            str(config_path).encode(),
            symbol.encode(),
            return_kind,
            count,
            kind_array,
            u64_array,
            f64_array,
            ctypes.byref(return_u64),
            ctypes.byref(return_f64),
            error,
            512,
        )
        if not ok:
            raise RuntimeError(f"{symbol}: {error.value.decode(errors='replace')}")
        return return_u64.value, return_f64.value

    work = root / "build" / "ffi_final_native"
    work.mkdir(parents=True, exist_ok=True)
    ini = work / "roundtrip.ini"
    section = b"main"
    key = b"name"
    # Deliberately exceeds the old fixed 8192-byte copy buffer.
    value = ("UXB_LONG_VALUE_BEGIN_" + ("X" * 12000) + "_UXB_LONG_VALUE_END").encode()
    default = b"missing"
    buffers = [
        ctypes.create_string_buffer(str(ini).encode()),
        ctypes.create_string_buffer(section),
        ctypes.create_string_buffer(key),
        ctypes.create_string_buffer(value),
        ctypes.create_string_buffer(default),
    ]
    address = ctypes.addressof

    handle, _ = invoke("uxconfig_open", PTR, [STRPTR], [address(buffers[0])])
    if handle == 0:
        raise RuntimeError("uxconfig_open returned zero opaque token")

    set_result, _ = invoke(
        "uxconfig_set_string",
        I32,
        [PTR, STRPTR, STRPTR, STRPTR],
        [handle, address(buffers[1]), address(buffers[2]), address(buffers[3])],
    )
    if set_result != 1:
        raise RuntimeError("uxconfig_set_string did not return 1")

    string_token, _ = invoke(
        "uxconfig_get_string",
        STRPTR,
        [PTR, STRPTR, STRPTR, STRPTR],
        [handle, address(buffers[1]), address(buffers[2]), address(buffers[4])],
    )
    if string_token == 0:
        raise RuntimeError("uxconfig_get_string returned a zero string token")

    required = ffi.uxffi_string_length(ctypes.c_uint32(string_token))
    if required != len(value) + 1:
        raise RuntimeError(f"wrong exact string length: expected {len(value)+1}, got {required}")

    short_buffer = ctypes.create_string_buffer(max(1, required - 1))
    if ffi.uxffi_copy_string(ctypes.c_uint32(string_token), short_buffer, required - 1) != 0:
        raise RuntimeError("uxffi_copy_string accepted an undersized buffer")
    # A failed copy must not consume the token.
    if ffi.uxffi_string_length(ctypes.c_uint32(string_token)) != required:
        raise RuntimeError("failed short-buffer copy consumed the string token")

    output = ctypes.create_string_buffer(required)
    if not ffi.uxffi_copy_string(ctypes.c_uint32(string_token), output, required):
        raise RuntimeError("uxffi_copy_string failed with exact capacity")
    if output.value != value:
        raise RuntimeError("STRPTR snapshot/copy returned the wrong value")
    if ffi.uxffi_string_length(ctypes.c_uint32(string_token)) != 0:
        raise RuntimeError("successful string copy did not consume the string token")

    invoke("uxconfig_close", 0, [PTR], [handle])
    if ffi.uxffi_release_handle(ctypes.c_uint32(handle)) != 0:
        raise RuntimeError("uxconfig_close did not consume the pointer token")

    stale_rejected = False
    try:
        invoke(
            "uxconfig_get_string",
            STRPTR,
            [PTR, STRPTR, STRPTR, STRPTR],
            [handle, address(buffers[1]), address(buffers[2]), address(buffers[4])],
        )
    except RuntimeError as exc:
        stale_rejected = "stale or invalid pointer handle token" in str(exc)
    if not stale_rejected:
        raise RuntimeError("closed pointer token was not rejected as stale")

    second_handle, _ = invoke("uxconfig_open", PTR, [STRPTR], [address(buffers[0])])
    if second_handle == 0 or second_handle == handle:
        raise RuntimeError("generation-checked token was not renewed after slot reuse")
    invoke("uxconfig_close", 0, [PTR], [second_handle])

    print(
        json.dumps(
            {
                "version": version,
                "maxArgs": max_args,
                "valueBytes": len(value),
                "exactCopyBytes": required,
                "firstHandleToken": handle,
                "secondHandleToken": second_handle,
                "shortBufferRejected": True,
                "staleRejected": True,
                "generationChanged": True,
            }
        )
    )
    print("UXFFI_UXCONFIG_ROUNDTRIP_PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
