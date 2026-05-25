#!/usr/bin/env python3
from __future__ import annotations

import csv
import json
import subprocess
from dataclasses import dataclass, asdict
from pathlib import Path
from typing import Dict, List


@dataclass
class ModeRun:
    mode: str
    exit_code: int
    status: str
    output_text: str
    stdout_path: str
    artifact_json: str
    program_json: str
    diagnostics: str


@dataclass
class TestResult:
    test_file: str
    final_status: str
    reason: str
    runs: List[ModeRun]


def find_repo_root(start: Path) -> Path:
    p = start.resolve()
    for c in [p] + list(p.parents):
        if (c / "uxb" / "src").is_dir():
            return c
    raise SystemExit("UXBc root not found")


def find_compiler(repo: Path) -> Path:
    candidates = [
        repo / "uxb" / "compiler" / "wrappers" / "uxb_main_wrapper_64.exe",
        repo / "uxb" / "build" / "uxb_main_64.exe",
    ]
    for c in candidates:
        if c.exists():
            return c
    raise SystemExit("Compiler executable not found")


def read_json(path: Path) -> Dict:
    if not path.exists():
        return {}
    try:
        return json.loads(path.read_text(encoding="utf-8", errors="ignore"))
    except Exception:
        return {}


def classify_failure(text: str, native: bool) -> str:
    t = text.upper()
    if "MIR X64 EXPERIMENTAL BUILD PIPELINE HENUZ BAGLI DEGIL" in t:
        return "EXPECTED_DIAGNOSTIC"
    if "TOOLCHAIN_OR_FILE_MISSING" in t:
        return "TOOLCHAIN_MISSING"
    if native and (
        "LINKER MISSING" in t
        or "NASM MISSING" in t
        or "TOOLCHAIN MISSING" in t
        or "NOT RECOGNIZED AS AN INTERNAL OR EXTERNAL COMMAND" in t
        or "CANNOT FIND THE PATH" in t
        or "CANNOT FIND FILE" in t
    ):
        return "TOOLCHAIN_MISSING"
    return "FAIL"


def run_mode(repo: Path, compiler: Path, test_file: Path, mode: str, args: List[str], out_root: Path, native: bool) -> ModeRun:
    test_name = test_file.stem
    mode_dir = out_root / test_name / mode
    mode_dir.mkdir(parents=True, exist_ok=True)

    artifact_json = mode_dir / "artifact_report.json"
    program_json = mode_dir / "program_output.json"
    program_txt = mode_dir / "program_output.txt"
    final_screen = mode_dir / "final_screen.json"
    stdout_log = mode_dir / "stdout.log"
    policy_json = mode_dir / "x64_policy.json"
    asm_out = mode_dir / "out.nasm"
    exe_out = mode_dir / "out.exe"
    mir_verify_json = mode_dir / "mir_verify.json"

    cmd = [str(compiler), str(test_file)]
    cmd += args
    cmd += [
        "--console-mode", "CAPTURE",
        "--program-output-out", str(program_txt),
        "--program-output-json-out", str(program_json),
        "--final-screen-json-out", str(final_screen),
        "--artifact-report-json-out", str(artifact_json),
    ]

    if "--emit-x64-nasm" in cmd:
        cmd += ["--emit-x64-nasm-out", str(asm_out), "--x64-codegen-policy-json-out", str(policy_json)]
    if "--build-x64" in cmd:
        cmd += ["--build-x64-out", str(exe_out), "--x64-codegen-policy-json-out", str(policy_json)]
    if "--mir-verify" in cmd and "--mir-verify-json-out" not in cmd:
        cmd += ["--mir-verify-json-out", str(mir_verify_json)]

    proc = subprocess.run(cmd, cwd=str(repo), capture_output=True, text=True)
    combined = (proc.stdout or "") + "\n" + (proc.stderr or "")
    stdout_log.write_text(combined, encoding="utf-8")

    output_text = ""
    if program_txt.exists():
        output_text = program_txt.read_text(encoding="utf-8", errors="ignore").strip()
    elif program_json.exists():
        pj = read_json(program_json)
        output_text = json.dumps(pj, ensure_ascii=False, sort_keys=True)

    if proc.returncode == 0:
        status = "PASS"
    else:
        status = classify_failure(combined, native)

    diagnostics = ""
    if proc.returncode != 0:
        diagnostics = combined.strip().splitlines()[-1] if combined.strip() else ""

    return ModeRun(
        mode=mode,
        exit_code=proc.returncode,
        status=status,
        output_text=output_text,
        stdout_path=str(stdout_log),
        artifact_json=str(artifact_json),
        program_json=str(program_json),
        diagnostics=diagnostics,
    )


def decide_result(runs: List[ModeRun]) -> (str, str):
    by_mode = {r.mode: r for r in runs}
    ast = by_mode["ast_interpreter"]
    mir = by_mode["mir_interpreter"]
    nat_ast = by_mode["x64_ast_native"]
    nat_mir = by_mode["x64_mir_native"]

    if ast.status != "PASS" or mir.status != "PASS":
        if ast.status == "TOOLCHAIN_MISSING" or mir.status == "TOOLCHAIN_MISSING":
            return "TOOLCHAIN_MISSING", "interpreter mode dependency missing"
        if ast.status == "EXPECTED_DIAGNOSTIC" or mir.status == "EXPECTED_DIAGNOSTIC":
            return "EXPECTED_DIAGNOSTIC", "interpreter diagnostic"
        return "FAIL", "interpreter execution failed"

    if ast.output_text != mir.output_text:
        return "MIR_MISMATCH", "AST interpreter and MIR interpreter outputs differ"

    native_statuses = {nat_ast.status, nat_mir.status}
    if native_statuses == {"PASS"}:
        if nat_ast.output_text == ast.output_text and nat_mir.output_text == ast.output_text:
            return "PASS_ALL", "all four paths match"
        return "NATIVE_MISMATCH", "native output differs from interpreter reference"

    if "TOOLCHAIN_MISSING" in native_statuses:
        return "PASS_INTERPRETERS_ONLY", "native toolchain missing"

    if "EXPECTED_DIAGNOSTIC" in native_statuses:
        return "PASS_INTERPRETERS_ONLY", "native diagnostic expected"

    return "FAIL", "native execution failed"


def main() -> int:
    repo = find_repo_root(Path(__file__).resolve())
    compiler = find_compiler(repo)

    tests_dir = repo / "uxb" / "tests" / "mir_x64_completion"
    tests = sorted(tests_dir.glob("mir_x64_*.bas"))
    if not tests:
        raise SystemExit("No mir_x64 completion tests found")

    out_root = repo / "uxb" / "dist" / "adim2"
    logs_root = out_root / "logs"
    logs_root.mkdir(parents=True, exist_ok=True)

    mode_matrix = [
        ("ast_interpreter", ["--execmem", "--interpreter-backend", "AST"], False),
        ("mir_interpreter", ["--execmem", "--interpreter-backend", "MIR", "--mir-verify"], False),
        ("x64_ast_native", ["--build-x64", "--codegen-source", "AST"], True),
        ("x64_mir_native", ["--build-x64", "--codegen-source", "MIR", "--enable-mir-x64-experimental", "--mir-verify"], True),
    ]

    test_results: List[TestResult] = []
    for t in tests:
        runs: List[ModeRun] = []
        for mode, args, native in mode_matrix:
            runs.append(run_mode(repo, compiler, t, mode, args, logs_root, native))
        final_status, reason = decide_result(runs)
        test_results.append(TestResult(test_file=str(t.relative_to(repo)), final_status=final_status, reason=reason, runs=runs))

    report = {
        "schema_version": "uxb-adim2-differential-gate-1",
        "producer": "uXBasiC",
        "repo_root": str(repo),
        "compiler": str(compiler),
        "tests": [
            {
                "test_file": tr.test_file,
                "final_status": tr.final_status,
                "reason": tr.reason,
                "runs": [asdict(r) for r in tr.runs],
            }
            for tr in test_results
        ],
    }

    out_json = out_root / "differential_gate.json"
    out_md = out_root / "differential_gate.md"
    out_csv = out_root / "differential_gate.csv"

    out_json.write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")

    with out_csv.open("w", encoding="utf-8", newline="") as f:
        w = csv.writer(f)
        w.writerow(["test_file", "final_status", "reason"])
        for tr in test_results:
            w.writerow([tr.test_file, tr.final_status, tr.reason])

    lines: List[str] = []
    lines.append("# Adim2 Differential Gate")
    lines.append("")
    lines.append("| test | status | reason |")
    lines.append("|---|---|---|")
    for tr in test_results:
        lines.append(f"| {tr.test_file} | {tr.final_status} | {tr.reason} |")

    lines.append("")
    lines.append("## Mode Details")
    lines.append("")
    for tr in test_results:
        lines.append(f"### {tr.test_file}")
        lines.append("")
        lines.append("| mode | status | exit | diagnostics |")
        lines.append("|---|---|---:|---|")
        for r in tr.runs:
            lines.append(f"| {r.mode} | {r.status} | {r.exit_code} | {r.diagnostics} |")
        lines.append("")

    out_md.write_text("\n".join(lines), encoding="utf-8")

    print(f"OUT_JSON={out_json}")
    print(f"OUT_MD={out_md}")
    print(f"OUT_CSV={out_csv}")
    print(f"TEST_COUNT={len(test_results)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
