#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from __future__ import annotations

import json
import subprocess
from pathlib import Path


def run_cmd(cmd):
    try:
        p = subprocess.run(cmd, capture_output=True, text=True, shell=True)
        return {
            "cmd": cmd,
            "returncode": p.returncode,
            "stdout": p.stdout.strip(),
            "stderr": p.stderr.strip(),
        }
    except Exception as exc:
        return {
            "cmd": cmd,
            "returncode": -1,
            "stdout": "",
            "stderr": str(exc),
        }


def main() -> int:
    repo = Path(__file__).resolve().parents[3]
    out_dir = repo / "uxb" / "dist" / "runtime_ext"
    out_dir.mkdir(parents=True, exist_ok=True)

    fp80 = out_dir / "uxb_fp80.dll"
    fp128 = out_dir / "uxb_fp128.dll"

    fbc = repo / "tools" / "FreeBASIC-1.10.1-win64" / "fbc.exe"
    gcc = Path("C:/msys64/ucrt64/bin/gcc.exe")

    manifest = {
        "schema_version": "uxb-fp-runtime-manifest-1",
        "producer": "uXBasiC",
        "runtime_mode": "external_dll",
        "targets": {
            "fp80": {
                "dll": str(fp80).replace("\\", "/"),
                "exists": fp80.exists(),
                "builder": str(fbc).replace("\\", "/"),
                "builder_exists": fbc.exists(),
                "functions": [
                    "uxb_f80_size",
                    "uxb_f80_from_str",
                    "uxb_f80_to_str",
                    "uxb_f80_add",
                    "uxb_f80_sub",
                    "uxb_f80_mul",
                    "uxb_f80_div",
                    "uxb_f80_cmp"
                ]
            },
            "fp128": {
                "dll": str(fp128).replace("\\", "/"),
                "exists": fp128.exists(),
                "builder": str(gcc).replace("\\", "/"),
                "builder_exists": gcc.exists(),
                "functions": [
                    "uxb_f128_size",
                    "uxb_f128_from_str",
                    "uxb_f128_to_str",
                    "uxb_f128_add",
                    "uxb_f128_sub",
                    "uxb_f128_mul",
                    "uxb_f128_div",
                    "uxb_f128_cmp"
                ]
            }
        },
        "toolchain_probe": {
            "fbc_version": run_cmd(f'"{fbc}" -version') if fbc.exists() else None,
            "gcc_version": run_cmd(f'"{gcc}" --version') if gcc.exists() else None,
            "quadmath_path": run_cmd(f'"{gcc}" -print-file-name=libquadmath.a') if gcc.exists() else None
        }
    }

    out_path = out_dir / "uxb_fp_runtime_manifest.json"
    out_path.write_text(json.dumps(manifest, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"OK: {out_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
