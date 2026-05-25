#!/usr/bin/env python3
from __future__ import annotations

import json
import shutil
from dataclasses import dataclass, asdict
from pathlib import Path
from typing import Dict, List, Optional


@dataclass
class CheckItem:
    name: str
    ok: bool
    path: str
    note: str = ""


def find_repo_root(start: Path) -> Path:
    p = start.resolve()
    for c in [p] + list(p.parents):
        if (c / "uxb" / "src").is_dir():
            return c
    raise SystemExit("UXBc root not found")


def first_existing(paths: List[Path]) -> Optional[Path]:
    for p in paths:
        if p.exists():
            return p
    return None


def first_which(names: List[str]) -> Optional[str]:
    for n in names:
        w = shutil.which(n)
        if w:
            return w
    return None


def detect_toolchain(repo: Path) -> Dict[str, object]:
    local_fbc = repo / "tools" / "FreeBASIC-1.10.1-win64" / "fbc.exe"
    global_fbc = Path("C:/Program Files (x86)/FreeBASIC/fbc.exe")
    fbc_path = first_existing([local_fbc, global_fbc])
    if fbc_path is None:
        w = first_which(["fbc.exe", "fbc"])
        if w:
            fbc_path = Path(w)

    nasm_candidates = [
        Path("C:/Program Files/CodeBlocks/MinGW/bin/nasm.exe"),
        Path("C:/msys64/ucrt64/bin/nasm.exe"),
    ]
    nasm_path = first_existing(nasm_candidates)
    if nasm_path is None:
        w = first_which(["nasm.exe", "nasm"])
        if w:
            nasm_path = Path(w)

    gcc_ucrt = Path("C:/msys64/ucrt64/bin/gcc.exe")
    clang_ucrt = Path("C:/msys64/ucrt64/bin/clang.exe")
    gxx_ucrt = Path("C:/msys64/ucrt64/bin/g++.exe")
    pacman = Path("C:/msys64/usr/bin/pacman.exe")

    gcc_any = first_existing([gcc_ucrt])
    if gcc_any is None:
        w = first_which(["gcc.exe", "gcc"])
        if w:
            gcc_any = Path(w)

    clang_any = first_existing([clang_ucrt])
    if clang_any is None:
        w = first_which(["clang.exe", "clang"])
        if w:
            clang_any = Path(w)

    link_any = first_which(["link.exe", "link"])

    linker_priority = "none"
    linker_path = ""
    if gcc_any is not None:
        linker_priority = "gcc_or_g++"
        linker_path = str(gcc_any)
    elif clang_any is not None:
        linker_priority = "clang"
        linker_path = str(clang_any)
    elif link_any is not None:
        linker_priority = "msvc_link"
        linker_path = link_any

    ucrt_bin = Path("C:/msys64/ucrt64/bin")
    ucrt_lib = Path("C:/msys64/ucrt64/lib")
    quadmath = any(ucrt_bin.glob("libquadmath*.dll")) or any(ucrt_lib.glob("*quadmath*"))
    mpfr = any(ucrt_bin.glob("libmpfr*.dll")) or any(ucrt_lib.glob("*mpfr*"))
    gmp = any(ucrt_bin.glob("libgmp*.dll")) or any(ucrt_lib.glob("*gmp*"))

    checks: List[CheckItem] = [
        CheckItem("fbc", fbc_path is not None, str(fbc_path or ""), "FreeBASIC compiler"),
        CheckItem("nasm", nasm_path is not None, str(nasm_path or ""), "NASM assembler"),
        CheckItem("msys2_gcc", gcc_ucrt.exists(), str(gcc_ucrt), "MSYS2 UCRT64 gcc"),
        CheckItem("msys2_g++", gxx_ucrt.exists(), str(gxx_ucrt), "MSYS2 UCRT64 g++"),
        CheckItem("msys2_pacman", pacman.exists(), str(pacman), "MSYS2 pacman"),
        CheckItem("libquadmath", quadmath, "C:/msys64/ucrt64", "quadmath runtime/library"),
        CheckItem("mpfr", mpfr, "C:/msys64/ucrt64", "mpfr runtime/library"),
        CheckItem("gmp", gmp, "C:/msys64/ucrt64", "gmp runtime/library"),
        CheckItem("linker", linker_priority != "none", linker_path, f"priority={linker_priority}"),
    ]

    extfp_root = repo / "uxb" / "dist" / "runtime_ext"
    extfp_checks: List[CheckItem] = [
        CheckItem("uxb_fp80.dll", (extfp_root / "uxb_fp80.dll").exists(), str(extfp_root / "uxb_fp80.dll")),
        CheckItem("uxb_fp128.dll", (extfp_root / "uxb_fp128.dll").exists(), str(extfp_root / "uxb_fp128.dll")),
        CheckItem("uxb_bigfp.dll", (extfp_root / "uxb_bigfp.dll").exists(), str(extfp_root / "uxb_bigfp.dll")),
    ]

    return {
        "schema_version": "uxb-adim2-toolchain-doctor-1",
        "producer": "uXBasiC",
        "repo_root": str(repo),
        "checks": [asdict(c) for c in checks],
        "overall_ok": all(c.ok for c in checks if c.name in {"fbc", "nasm", "linker"}),
        "linker_priority": linker_priority,
        "extfp_runtime_gate": {
            "schema_version": "uxb-adim2-extfp-runtime-gate-1",
            "runtime_dir": str(extfp_root),
            "checks": [asdict(c) for c in extfp_checks],
            "strict_status": "PASS" if all(c.ok for c in extfp_checks) else "FAIL",
            "diagnostics_status": "PASS" if all(c.ok for c in extfp_checks) else "EXPECTED_DIAGNOSTIC",
        },
    }


def write_md(out_json: Dict[str, object], md_path: Path) -> None:
    lines: List[str] = []
    lines.append("# Adim2 Toolchain Doctor")
    lines.append("")
    lines.append(f"- overall_ok: `{out_json['overall_ok']}`")
    lines.append(f"- linker_priority: `{out_json['linker_priority']}`")
    lines.append("")
    lines.append("## Checks")
    lines.append("")
    lines.append("| name | ok | path | note |")
    lines.append("|---|---|---|---|")
    for c in out_json["checks"]:
        lines.append(f"| {c['name']} | {c['ok']} | {c['path']} | {c.get('note','')} |")

    lines.append("")
    lines.append("## ExtFP Runtime Gate")
    lines.append("")
    gate = out_json["extfp_runtime_gate"]
    lines.append(f"- strict_status: `{gate['strict_status']}`")
    lines.append(f"- diagnostics_status: `{gate['diagnostics_status']}`")
    lines.append("")
    lines.append("| dll | ok | path |")
    lines.append("|---|---|---|")
    for c in gate["checks"]:
        lines.append(f"| {c['name']} | {c['ok']} | {c['path']} |")

    md_path.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    repo = find_repo_root(Path(__file__).resolve())
    out_dir = repo / "uxb" / "dist" / "adim2"
    out_dir.mkdir(parents=True, exist_ok=True)

    report = detect_toolchain(repo)

    doctor_json = out_dir / "toolchain_doctor.json"
    doctor_md = out_dir / "toolchain_doctor.md"
    extfp_json = out_dir / "extfp_runtime_gate.json"
    extfp_md = out_dir / "extfp_runtime_gate.md"

    doctor_json.write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")
    write_md(report, doctor_md)

    extfp_only = report["extfp_runtime_gate"]
    extfp_json.write_text(json.dumps(extfp_only, indent=2, ensure_ascii=False), encoding="utf-8")

    ext_lines = [
        "# Adim2 ExtFP Runtime Gate",
        "",
        f"- strict_status: `{extfp_only['strict_status']}`",
        f"- diagnostics_status: `{extfp_only['diagnostics_status']}`",
        "",
        "| dll | ok | path |",
        "|---|---|---|",
    ]
    for c in extfp_only["checks"]:
        ext_lines.append(f"| {c['name']} | {c['ok']} | {c['path']} |")
    extfp_md.write_text("\n".join(ext_lines), encoding="utf-8")

    print(f"OUT_JSON={doctor_json}")
    print(f"OUT_MD={doctor_md}")
    print(f"OUT_EXTFP_JSON={extfp_json}")
    print(f"OUT_EXTFP_MD={extfp_md}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
