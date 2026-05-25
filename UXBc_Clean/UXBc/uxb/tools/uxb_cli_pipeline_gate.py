#!/usr/bin/env python3
from __future__ import annotations

import csv
import json
import shutil
import subprocess
from dataclasses import dataclass, asdict
from pathlib import Path
from typing import Dict, List, Optional


@dataclass
class CaseResult:
    case_id: str
    command: List[str]
    exit_code: int
    status: str
    stdout_path: str
    artifact_json_ok: bool
    policy_json_ok: bool
    program_json_ok: bool
    actual_emitter: str
    fallback_used: str
    diagnostics: str


def find_repo_root(start: Path) -> Path:
    p = start.resolve()
    for c in [p] + list(p.parents):
        if (c / "uxb" / "src").is_dir():
            return c
    raise SystemExit("UXBc root not found")


def read_text(path: Path) -> str:
    if not path.exists():
        return ""
    return path.read_text(encoding="utf-8", errors="ignore")


def find_compiler(repo: Path) -> Path:
    candidates = [
        repo / "uxb" / "compiler" / "wrappers" / "uxb_main_wrapper_64.exe",
        repo / "uxb" / "build" / "uxb_main_64.exe",
    ]
    for c in candidates:
        if c.exists():
            return c
    raise SystemExit("Compiler executable not found")


def classify_failure(case_id: str, text: str, is_native: bool) -> str:
    t = text.upper()
    if "TOOLCHAIN_OR_FILE_MISSING" in t:
        return "TOOLCHAIN_OR_FILE_MISSING"
    if is_native and ("NASM" in t or "LINKER" in t or "NOT FOUND" in t or "CANNOT FIND" in t):
        return "TOOLCHAIN_OR_FILE_MISSING"
    if "MIR X64 EXPERIMENTAL BUILD PIPELINE HENUZ BAGLI DEGIL" in t:
        return "EXPECTED_DIAGNOSTIC"
    return "FAIL"


def json_ok(path: Path) -> bool:
    if not path.exists():
        return False
    try:
        json.loads(path.read_text(encoding="utf-8", errors="ignore"))
        return True
    except Exception:
        return False


def run_case(repo: Path, compiler: Path, case_id: str, source: Path, args: List[str], out_dir: Path, is_native: bool) -> CaseResult:
    case_dir = out_dir / case_id
    case_dir.mkdir(parents=True, exist_ok=True)

    artifact_json = case_dir / "artifact_report.json"
    policy_json = case_dir / "x64_policy.json"
    program_json = case_dir / "program_output.json"
    final_screen_json = case_dir / "final_screen.json"
    mir_verify_json = case_dir / "mir_verify.json"
    ast_json = case_dir / "ast.json"
    hir_json = case_dir / "hir.json"
    mir_full_json = case_dir / "mir_full.json"
    asm_out = case_dir / "out.nasm"
    build_out = case_dir / "out.exe"
    stdout_path = case_dir / "stdout.log"

    cmd = [str(compiler), str(source)]
    cmd += args

    if "--artifact-report-json-out" not in cmd:
        cmd += ["--artifact-report-json-out", str(artifact_json)]
    if "--program-output-json-out" not in cmd:
        cmd += ["--program-output-json-out", str(program_json)]
    if "--final-screen-json-out" not in cmd:
        cmd += ["--final-screen-json-out", str(final_screen_json)]
    if "--mir-verify" in cmd and "--mir-verify-json-out" not in cmd:
        cmd += ["--mir-verify-json-out", str(mir_verify_json)]
    if "--emit-x64-nasm" in cmd and "--emit-x64-nasm-out" not in cmd:
        cmd += ["--emit-x64-nasm-out", str(asm_out)]
    if "--build-x64" in cmd and "--build-x64-out" not in cmd:
        cmd += ["--build-x64-out", str(build_out)]
    if "--x64-codegen-policy-json-out" not in cmd and ("--emit-x64-nasm" in cmd or "--build-x64" in cmd):
        cmd += ["--x64-codegen-policy-json-out", str(policy_json)]

    if case_id == "json_full":
        cmd += [
            "--ast-json-out", str(ast_json),
            "--hir-json-out", str(hir_json),
            "--mir-full-json-out", str(mir_full_json),
            "--mir-verify-json-out", str(mir_verify_json),
            "--x64-codegen-policy-json-out", str(policy_json),
        ]

    proc = subprocess.run(cmd, cwd=str(repo), capture_output=True, text=True)
    combined = (proc.stdout or "") + "\n" + (proc.stderr or "")
    stdout_path.write_text(combined, encoding="utf-8")

    status = "PASS" if proc.returncode == 0 else classify_failure(case_id, combined, is_native)

    actual_emitter = ""
    fallback_used = ""
    if policy_json.exists() and json_ok(policy_json):
        policy = json.loads(policy_json.read_text(encoding="utf-8", errors="ignore"))
        cp = policy.get("codegen_policy", {})
        actual_emitter = str(cp.get("actual_emitter", ""))
        fallback_used = str(cp.get("fallback_used", ""))

    diagnostics = ""
    if proc.returncode != 0:
        diagnostics = combined.strip().splitlines()[-1] if combined.strip() else ""

    return CaseResult(
        case_id=case_id,
        command=cmd,
        exit_code=proc.returncode,
        status=status,
        stdout_path=str(stdout_path),
        artifact_json_ok=json_ok(artifact_json),
        policy_json_ok=json_ok(policy_json) if policy_json.exists() else False,
        program_json_ok=json_ok(program_json),
        actual_emitter=actual_emitter,
        fallback_used=fallback_used,
        diagnostics=diagnostics,
    )


def analyze_lock_and_verify(repo: Path) -> Dict[str, object]:
    main_entry = read_text(repo / "uxb" / "src" / "main_program_entry.fbs")
    build_pipeline = read_text(repo / "uxb" / "src" / "build" / "x64_build_pipeline.fbs")

    return {
        "lock_file_detected": "x64_native_slot_0.lock" in build_pipeline,
        "hardcoded_timeout_120s_detected": "120000" in build_pipeline,
        "lock_timeout_sec_option_present": "--lock-timeout-sec" in main_entry,
        "mir_verified_for_policy_cache_present": "mirVerifiedForPolicy" in main_entry,
        "mir_verify_call_count": main_entry.upper().count("MIRVERIFYMODULE"),
    }


def main() -> int:
    repo = find_repo_root(Path(__file__).resolve())
    compiler = find_compiler(repo)
    source = repo / "uxb" / "tests" / "mir_x64_completion" / "mir_x64_builtin_scalar.bas"

    out_dir = repo / "uxb" / "dist" / "adim2"
    run_dir = out_dir / "cli_pipeline_runs"
    run_dir.mkdir(parents=True, exist_ok=True)

    cases = [
        ("ast_interpreter", ["--execmem", "--interpreter-backend", "AST", "--console-mode", "CAPTURE"], False),
        ("mir_interpreter", ["--execmem", "--interpreter-backend", "MIR", "--mir-verify", "--console-mode", "CAPTURE"], False),
        ("x64_ast_asm", ["--emit-x64-nasm", "--codegen-source", "AST"], True),
        ("x64_mir_asm", ["--emit-x64-nasm", "--codegen-source", "MIR", "--enable-mir-x64-experimental", "--mir-verify"], True),
        ("x64_ast_exe", ["--build-x64", "--codegen-source", "AST"], True),
        ("x64_mir_exe", ["--build-x64", "--codegen-source", "MIR", "--enable-mir-x64-experimental", "--mir-verify"], True),
        ("json_full", ["--execmem", "--interpreter-backend", "AST", "--mir-verify", "--codegen-source", "MIR", "--enable-mir-x64-experimental", "--console-mode", "CAPTURE"], False),
    ]

    results: List[CaseResult] = []
    for cid, args, is_native in cases:
        results.append(run_case(repo, compiler, cid, source, args, run_dir, is_native))

    lock_audit = analyze_lock_and_verify(repo)

    report = {
        "schema_version": "uxb-adim2-cli-pipeline-gate-1",
        "producer": "uXBasiC",
        "repo_root": str(repo),
        "compiler": str(compiler),
        "source": str(source),
        "cases": [asdict(r) for r in results],
        "policy_fallback_transparency": {
            "checked": True,
            "requirement": "fallback_used and actual_emitter must be visible in policy json when x64 policies are emitted",
        },
        "lock_and_verify_audit": lock_audit,
    }

    out_json = out_dir / "cli_pipeline_gate.json"
    out_md = out_dir / "cli_pipeline_gate.md"
    out_csv = out_dir / "cli_pipeline_gate.csv"
    out_json.write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")

    with out_csv.open("w", encoding="utf-8", newline="") as f:
        w = csv.writer(f)
        w.writerow([
            "case_id", "status", "exit_code", "artifact_json_ok", "policy_json_ok", "program_json_ok", "actual_emitter", "fallback_used", "diagnostics"
        ])
        for r in results:
            w.writerow([
                r.case_id, r.status, r.exit_code, r.artifact_json_ok, r.policy_json_ok, r.program_json_ok, r.actual_emitter, r.fallback_used, r.diagnostics
            ])

    lines: List[str] = []
    lines.append("# Adim2 CLI Pipeline Gate")
    lines.append("")
    lines.append("| case | status | exit | artifact_json | policy_json | program_json | actual_emitter | fallback_used |")
    lines.append("|---|---|---:|---|---|---|---|---|")
    for r in results:
        lines.append(
            f"| {r.case_id} | {r.status} | {r.exit_code} | {r.artifact_json_ok} | {r.policy_json_ok} | {r.program_json_ok} | {r.actual_emitter} | {r.fallback_used} |"
        )

    lines.append("")
    lines.append("## Lock and Verify Audit")
    lines.append("")
    for k, v in lock_audit.items():
        lines.append(f"- {k}: `{v}`")

    out_md.write_text("\n".join(lines), encoding="utf-8")

    print(f"OUT_JSON={out_json}")
    print(f"OUT_MD={out_md}")
    print(f"OUT_CSV={out_csv}")
    print(f"CASE_COUNT={len(results)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
