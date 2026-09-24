#!/usr/bin/env python3
from __future__ import annotations
import argparse, ctypes, json, os, pathlib, subprocess, sys

def fail(msg: str) -> None:
    raise RuntimeError(msg)

def configure(lib: ctypes.CDLL) -> None:
    lib.uxwasm_version.restype=ctypes.c_int32
    lib.uxwasm_provider.restype=ctypes.c_char_p
    lib.uxwasm_runtime_available.restype=ctypes.c_int32
    lib.uxwasm_runtime_path.restype=ctypes.c_char_p
    lib.uxwasm_validate_file.argtypes=[ctypes.c_char_p]; lib.uxwasm_validate_file.restype=ctypes.c_int32
    lib.uxwasm_open_file.argtypes=[ctypes.c_char_p]; lib.uxwasm_open_file.restype=ctypes.c_int32
    lib.uxwasm_close.argtypes=[ctypes.c_int32]; lib.uxwasm_close.restype=ctypes.c_int32
    lib.uxwasm_has_export.argtypes=[ctypes.c_int32,ctypes.c_char_p]; lib.uxwasm_has_export.restype=ctypes.c_int32
    lib.uxwasm_call_i32_1.argtypes=[ctypes.c_int32,ctypes.c_char_p,ctypes.c_int32]; lib.uxwasm_call_i32_1.restype=ctypes.c_int32
    lib.uxwasm_call_i32_2.argtypes=[ctypes.c_int32,ctypes.c_char_p,ctypes.c_int32,ctypes.c_int32]; lib.uxwasm_call_i32_2.restype=ctypes.c_int32
    lib.uxwasm_last_ok.argtypes=[ctypes.c_int32]; lib.uxwasm_last_ok.restype=ctypes.c_int32
    lib.uxwasm_last_error.argtypes=[ctypes.c_int32]; lib.uxwasm_last_error.restype=ctypes.c_char_p

def err(lib: ctypes.CDLL, handle: int=0) -> str:
    raw=lib.uxwasm_last_error(handle)
    return raw.decode('utf-8','replace') if raw else ''

def main() -> int:
    ap=argparse.ArgumentParser(); ap.add_argument('--root',default='.'); ap.add_argument('--json-out',default='')
    ns=ap.parse_args(); root=pathlib.Path(ns.root).resolve()
    dll=root/'bin'/'uxwasmrt.dll'; wasm=root/'tests'/'libraries'/'uxwasmrt'/'reference_26_07'/'add.wasm'
    generated_smoke=root/'tests'/'libraries'/'uxwasmrt'/'core_i32_smoke.wasm'
    invalid_import=root/'tests'/'libraries'/'uxwasmrt'/'invalid_import.wasm'
    if not dll.is_file(): fail(f'missing {dll}')
    if not wasm.is_file(): fail(f'missing {wasm}')
    os.add_dll_directory(str(root/'bin')) if hasattr(os,'add_dll_directory') else None
    lib=ctypes.CDLL(str(dll)); configure(lib)
    if lib.uxwasm_version()!=100: fail('uxwasm ABI version mismatch')
    if lib.uxwasm_runtime_available()!=1: fail('Wasmtime unavailable: '+err(lib,0))
    if lib.uxwasm_validate_file(os.fsencode(wasm))!=1: fail('reference wasm rejected: '+err(lib,0))
    h=lib.uxwasm_open_file(os.fsencode(wasm));
    if not h: fail('open failed: '+err(lib,0))
    try:
        if lib.uxwasm_has_export(h,b'ADD')!=1: fail('ADD export missing: '+err(lib,h))
        value=lib.uxwasm_call_i32_2(h,b'ADD',10,20)
        if lib.uxwasm_last_ok(h)!=1 or value!=30: fail(f'ADD result={value}: '+err(lib,h))
        missing=lib.uxwasm_call_i32_1(h,b'DOES_NOT_EXIST',1)
        if lib.uxwasm_last_ok(h)!=0: fail('missing export did not fail closed')
    finally:
        if lib.uxwasm_close(h)!=1: fail('close failed')
    # Stale generation-token use must fail closed after close.
    _=lib.uxwasm_call_i32_1(h,b'ADD',1)
    if lib.uxwasm_last_ok(h)!=0: fail('stale session handle remained usable')
    host_abs=None
    if generated_smoke.is_file():
        sh=lib.uxwasm_open_file(os.fsencode(generated_smoke))
        if not sh: fail('generated host smoke open failed: '+err(lib,0))
        try:
            host_abs=lib.uxwasm_call_i32_1(sh,b'HOST_ABS',-7)
            if lib.uxwasm_last_ok(sh)!=1 or host_abs!=7: fail('host_call4 ABS failed: '+err(lib,sh))
            rng_a=lib.uxwasm_call_i32_1(sh,b'HOST_RNG_SEED_NEXT',123456)
            if lib.uxwasm_last_ok(sh)!=1: fail('host RNG first call failed: '+err(lib,sh))
            rng_b=lib.uxwasm_call_i32_1(sh,b'HOST_RNG_SEED_NEXT',123456)
            if lib.uxwasm_last_ok(sh)!=1 or rng_a!=rng_b: fail('host RNG is not deterministic across identical seeds')
            _=lib.uxwasm_call_i32_1(sh,b'HOST_SQRT',-1)
            if lib.uxwasm_last_ok(sh)!=0: fail('invalid host math input did not trap')
        finally:
            if lib.uxwasm_close(sh)!=1: fail('host smoke close failed')
    if invalid_import.is_file():
        bad=lib.uxwasm_open_file(os.fsencode(invalid_import))
        if bad: lib.uxwasm_close(bad); fail('unknown import was not rejected')
        if 'Unsupported WASM import' not in err(lib,0): fail('unknown import rejection lacked a clear error: '+err(lib,0))
    report={'schema':'uxb.uxwasmrt.native-smoke.v1','status':'PASS','apiVersion':100,'provider':lib.uxwasm_provider().decode(),'runtimePath':lib.uxwasm_runtime_path().decode(),'add':30,'hostAbs':host_abs,'deterministicRng':True if host_abs is not None else None,'invalidMathTrap':True if host_abs is not None else None,'unknownImportFailClosed':invalid_import.is_file()}
    if ns.json_out:
        out=pathlib.Path(ns.json_out); out.parent.mkdir(parents=True,exist_ok=True); out.write_text(json.dumps(report,indent=2),encoding='utf-8')
    print('UXWASMRT_NATIVE_SMOKE_PASS'); print(json.dumps(report))
    return 0
if __name__=='__main__':
    try: raise SystemExit(main())
    except Exception as exc: print(f'UXWASMRT_NATIVE_SMOKE_FAIL: {exc}',file=sys.stderr); raise SystemExit(1)
