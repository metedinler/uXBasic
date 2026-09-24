#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from __future__ import annotations
import json, subprocess
from pathlib import Path

def run_cmd(cmd: str):
    try:
        p = subprocess.run(cmd, capture_output=True, text=True, shell=True)
        return {"cmd": cmd, "returncode": p.returncode, "stdout": p.stdout.strip(), "stderr": p.stderr.strip()}
    except Exception as exc:
        return {"cmd": cmd, "returncode": -1, "stdout": "", "stderr": str(exc)}

def main() -> int:
    repo = Path(__file__).resolve().parents[3]
    out_dir = repo / "uxb" / "dist" / "runtime_ext"
    out_dir.mkdir(parents=True, exist_ok=True)
    gcc = Path("C:/msys64/ucrt64/bin/gcc.exe")
    dlls = {
        "fp80": out_dir / "uxb_fp80.dll",
        "fp128": out_dir / "uxb_fp128.dll",
        "bigfp": out_dir / "uxb_bigfp.dll",
    }
    manifest = {
        "schema_version": "uxb-fp-runtime-manifest-2",
        "producer": "uXBasiC",
        "runtime_mode": "external_dll",
        "targets": {
            "fp80": {"dll": str(dlls["fp80"]).replace("\\", "/"), "exists": dlls["fp80"].exists(), "builder": str(gcc).replace("\\", "/"), "builder_exists": gcc.exists(), "functions_prefix": "uxb_f80", "backend": "GCC long double, 16-byte storage"},
            "fp128": {"dll": str(dlls["fp128"]).replace("\\", "/"), "exists": dlls["fp128"].exists(), "builder": str(gcc).replace("\\", "/"), "builder_exists": gcc.exists(), "functions_prefix": "uxb_f128"},
            "bigf": {"dll": str(dlls["bigfp"]).replace("\\", "/"), "exists": dlls["bigfp"].exists(), "builder": str(gcc).replace("\\", "/"), "builder_exists": gcc.exists(), "functions_prefix": "uxb_bigf", "backend": "MPFR/GMP"},
            "bigd": {"dll": str(dlls["bigfp"]).replace("\\", "/"), "exists": dlls["bigfp"].exists(), "builder": str(gcc).replace("\\", "/"), "builder_exists": gcc.exists(), "functions_prefix": "uxb_bigd", "backend": "MPFR/GMP decimal-digit precision policy"},
            "ball": {"dll": str(dlls["bigfp"]).replace("\\", "/"), "exists": dlls["bigfp"].exists(), "builder": str(gcc).replace("\\", "/"), "builder_exists": gcc.exists(), "functions_prefix": "uxb_ball", "backend": "MPFR midpoint-radius interval"},
        },
        "toolchain_probe": {
            "gcc_version": run_cmd(f'"{gcc}" --version') if gcc.exists() else None,
            "mpfr_probe": run_cmd(f'"{gcc}" -print-file-name=libmpfr.a') if gcc.exists() else None,
            "gmp_probe": run_cmd(f'"{gcc}" -print-file-name=libgmp.a') if gcc.exists() else None,
            "quadmath_probe": run_cmd(f'"{gcc}" -print-file-name=libquadmath.a') if gcc.exists() else None,
        }
    }
    out_path = out_dir / "uxb_fp_runtime_manifest.json"
    out_path.write_text(json.dumps(manifest, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"OK: {out_path}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
