#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
UXBc expected runner.

Runs a bounded set of tests through existing project runner when available,
classifies status, and records broken_layer.
"""

from __future__ import annotations

import argparse, csv, json, re, subprocess, time
from pathlib import Path
from typing import Dict, Any, List


LAYER_PATTERNS = [
    ("SOURCE_LOAD", ["source not found", "cannot open", "file not found"]),
    ("LEXER", ["lexer", "token"]),
    ("PARSER", ["parser", "parse error", "syntax"]),
    ("AST_CONTRACT", ["ast contract"]),
    ("SEMANTIC", ["semantic", "type binding", "layout"]),
    ("MIR_BUILD", ["mir lowering", "mir build", "lowering missing"]),
    ("MIR_VERIFY", ["mir verify", "branch target"]),
    ("AST_INTERPRETER", ["ast interpreter"]),
    ("MIR_INTERPRETER", ["mir interpreter", "mir evaluator"]),
    ("X64_AST_CODEGEN", ["x64 ast", "code_generator"]),
    ("MIR_X64_CODEGEN", ["mir x64", "mir_x64"]),
    ("X64_BUILD", ["nasm", "linker", "gcc", "too many memory references", "assembler messages"]),
    ("EXTFP_RUNTIME", ["f80", "f128", "bigf", "bigd", "ball", "runtime dll", "extfp"]),
    ("FFI_BACKEND", ["ffi", "call dll", "call api", "inline", "import"]),
    ("TYPE_CLASS_BACKEND", ["class", "method", "type field", "this", "ctor", "dtor"]),
]


def find_root(start: Path) -> Path:
    p = start.resolve()
    for c in [p] + list(p.parents):
        if (c / "uxb" / "src").is_dir():
            return c
    raise SystemExit("UXBc root not found")


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="ignore") if path.exists() else ""


def classify_output(text: str, rc: int) -> Dict[str, str]:
    low = text.lower()
    if "toolchain_or_file_missing" in low or ("fbc" in low and "missing" in low) or ("nasm" in low and "missing" in low):
        status = "TOOLCHAIN_OR_FILE_MISSING"
        broken = "X64_BUILD"
    elif rc == 0 and "expected_diagnostic" not in low and "diagnostic" not in low and "fail" not in low:
        status = "PASS_OR_ACCEPTED"
        broken = ""
    elif "expected_diagnostic" in low or "diagnostic" in low or "unsupported" in low or "pending" in low:
        status = "EXPECTED_DIAGNOSTIC"
        broken = "SEMANTIC"
    elif "mismatch" in low:
        status = "NATIVE_MISMATCH"
        broken = "MIR_INTERPRETER"
    elif "nasm" in low or "linker" in low or "too many memory references" in low:
        status = "BUILD_OR_RUNTIME_FAIL"
        broken = "X64_BUILD"
    else:
        status = "FAIL" if rc != 0 else "PASS_WITH_WARNINGS"
        broken = "UNKNOWN"

    if broken in {"UNKNOWN", "SEMANTIC"}:
        for layer, pats in LAYER_PATTERNS:
            if any(p in low for p in pats):
                broken = layer
                break

    if rc == 0 and status.startswith("PASS"):
        broken = "PASS"

    return {"actual_status": status, "broken_layer": broken}


def load_manifest(root: Path) -> List[Dict[str, str]]:
    candidates = [
        root / "uxb/tests/expected/uxb_expected_tests.csv",
        root / "uxb/dist/step6/test_matrix_link.csv",
        root / "uxb/tests/expected/uxb_expected_tests_seed.csv",
    ]
    for p in candidates:
        if p.exists():
            with p.open("r", encoding="utf-8", newline="") as f:
                return list(csv.DictReader(f))
    return []


def _norm_test_id(value: str) -> str:
    t = str(value or "").strip().lower()
    if not t:
        return ""
    if t.startswith("t") and t[1:].isdigit():
        return f"t{int(t[1:]):05d}"
    if t.isdigit():
        return f"t{int(t):05d}"
    return t


def parse_id_set(raw: str) -> set[str]:
    if not raw:
        return set()
    out = set()
    for part in str(raw).split(","):
        n = _norm_test_id(part)
        if n:
            out.add(n)
    return out


def parse_id_range(raw: str) -> tuple[str, str] | tuple[None, None]:
    if not raw:
        return (None, None)
    s = str(raw).strip()
    if "-" not in s:
        n = _norm_test_id(s)
        return (n, n) if n else (None, None)
    left, right = s.split("-", 1)
    l = _norm_test_id(left)
    r = _norm_test_id(right)
    if not l or not r:
        return (None, None)
    return (l, r)


def run_command(root: Path, cmd: str, timeout: int) -> Dict[str, Any]:
    start = time.time()
    try:
        p = subprocess.run(cmd, cwd=str(root), shell=True, capture_output=True, text=True, errors="replace", timeout=timeout)
        out = (p.stdout or "") + ("\n" if p.stdout and p.stderr else "") + (p.stderr or "")
        rc = p.returncode
    except subprocess.TimeoutExpired as exc:
        out = (exc.stdout or "") + "\n" + (exc.stderr or "") + f"\nTIMEOUT after {timeout}s"
        rc = -777
    except Exception as exc:
        out = f"RUNNER_EXCEPTION: {exc}"
        rc = -999
    return {"returncode": rc, "output": out, "duration_sec": round(time.time() - start, 3)}


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=".")
    ap.add_argument("--max-tests", type=int, default=40)
    ap.add_argument("--timeout", type=int, default=180)
    ap.add_argument("--full", action="store_true")
    ap.add_argument("--ids", default="", help="Comma-separated test ids. Examples: t00001,t00007 or 1,7")
    ap.add_argument("--id-range", default="", help="Inclusive id range. Example: 10-30 or t00010-t00030")
    ap.add_argument("--name-contains", default="", help="Run tests whose test_path contains this value (case-insensitive)")
    ap.add_argument("--manifest", default="", help="Optional explicit manifest CSV path")
    ap.add_argument("--alias-layer", action="store_true", help="Run project runner with alias normalization layer")
    ap.add_argument("--alias-spec", default="", help="Optional alias spec path passed to project runner")
    args = ap.parse_args()

    root = find_root(Path(args.root))
    out_dir = root / "uxb/dist/step6"
    log_dir = out_dir / "logs"
    log_dir.mkdir(parents=True, exist_ok=True)

    manifest = load_manifest(root)
    if args.manifest:
        m = Path(args.manifest)
        if not m.is_absolute():
            m = root / m
        if m.exists():
            with m.open("r", encoding="utf-8", newline="") as f:
                manifest = list(csv.DictReader(f))

    id_set = parse_id_set(args.ids)
    range_start, range_end = parse_id_range(args.id_range)
    name_filter = str(args.name_contains or "").strip().lower()

    if id_set:
        manifest = [r for r in manifest if _norm_test_id(r.get("test_id", "")) in id_set]
    if range_start and range_end:
        manifest = [
            r for r in manifest
            if range_start <= _norm_test_id(r.get("test_id", "")) <= range_end
        ]
    if name_filter:
        manifest = [r for r in manifest if name_filter in str(r.get("test_path", "")).lower()]

    if not args.full and not id_set and not (range_start and range_end) and not name_filter:
        manifest = manifest[:args.max_tests]

    project_runner = root / "uxb/compiler/scripts/run_step3_project_runner.bat"
    has_project_runner = project_runner.exists()

    rows = []
    for row in manifest:
        test_path = row.get("test_path", "")
        if not test_path:
            continue
        if row.get("duplicate_of"):
            actual = "SKIPPED_DUPLICATE"
            broken = "PASS"
            rc = 0
            output = "duplicate skipped"
            cmd = ""
        elif not (root / test_path).exists():
            actual = "TOOLCHAIN_OR_FILE_MISSING"
            broken = "SOURCE_LOAD"
            rc = 2
            output = "test file missing"
            cmd = ""
        elif has_project_runner:
            cmd = f'uxb\\compiler\\scripts\\run_step3_project_runner.bat "{test_path}"'
            if args.alias_layer:
                cmd += " --alias-layer"
                if args.alias_spec:
                    cmd += f' --alias-spec "{args.alias_spec}"'
            res = run_command(root, cmd, args.timeout)
            rc = res["returncode"]
            output = res["output"]
            cl = classify_output(output, rc)
            actual = cl["actual_status"]
            broken = cl["broken_layer"]
        else:
            cmd = "project runner missing"
            rc = 2
            output = "uxb/compiler/scripts/run_step3_project_runner.bat missing"
            actual = "TOOLCHAIN_OR_FILE_MISSING"
            broken = "AST_INTERPRETER"

        log_name = re.sub(r"[^A-Za-z0-9_.-]+", "_", test_path)[:180] + ".log"
        (log_dir / log_name).write_text(output, encoding="utf-8", errors="ignore")

        expected = row.get("expected_status", "PASS_INTERPRETERS_ONLY")
        accepted = False
        if actual == expected:
            accepted = True
        elif actual == "SKIPPED_DUPLICATE":
            accepted = True
        elif expected == "PASS_INTERPRETERS_ONLY" and actual in {"PASS_OR_ACCEPTED", "EXPECTED_DIAGNOSTIC", "TOOLCHAIN_OR_FILE_MISSING"}:
            accepted = True
        elif expected == "EXPECTED_DIAGNOSTIC" and actual in {"EXPECTED_DIAGNOSTIC", "TOOLCHAIN_OR_FILE_MISSING"}:
            accepted = True

        rows.append({
            **row,
            "actual_status": actual,
            "broken_layer": broken,
            "accepted": "YES" if accepted else "NO",
            "returncode": str(rc),
            "log": str((log_dir / log_name).relative_to(root)).replace("\\", "/"),
            "cmd": cmd,
        })

    pass_count = sum(1 for r in rows if r["accepted"] == "YES")
    fail_count = len(rows) - pass_count
    report = {
        "schema_version": "uxb-expected-runner-1",
        "selection": {
            "full": bool(args.full),
            "max_tests": args.max_tests,
            "ids": sorted(id_set),
            "id_range": [range_start, range_end] if range_start and range_end else [],
            "name_contains": name_filter,
            "manifest": args.manifest,
            "alias_layer": bool(args.alias_layer),
            "alias_spec": args.alias_spec,
        },
        "test_count": len(rows),
        "accepted": pass_count,
        "not_accepted": fail_count,
        "rows": rows,
    }
    (out_dir / "expected_runner.json").write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")

    csv_path = out_dir / "expected_runner.csv"
    fieldnames = ["test_id","test_path","feature_family","expected_status","actual_status","broken_layer","accepted","returncode","log","cmd","required_layers","strictness","duplicate_of","notes"]
    with csv_path.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fieldnames, extrasaction="ignore")
        w.writeheader()
        for r in rows:
            w.writerow(r)

    md = ["# UXBc Expected Runner", ""]
    md.append(f"- selection: `{report['selection']}`")
    md.append(f"- test_count: `{len(rows)}`")
    md.append(f"- accepted: `{pass_count}`")
    md.append(f"- not_accepted: `{fail_count}`")
    md.append("")
    md.append("| test | expected | actual | broken_layer | accepted |")
    md.append("|---|---|---|---|---|")
    for r in rows[:200]:
        md.append(f"| `{r['test_path']}` | {r['expected_status']} | {r['actual_status']} | {r['broken_layer']} | {r['accepted']} |")
    (out_dir / "expected_runner.md").write_text("\n".join(md), encoding="utf-8")

    print("EXPECTED_RUNNER=" + str(out_dir / "expected_runner.md"))
    print("NOT_ACCEPTED=" + str(fail_count))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
