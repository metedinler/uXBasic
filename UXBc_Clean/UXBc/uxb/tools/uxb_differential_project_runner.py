#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
UXBc differential project runner.

Runs available UXBc pipelines into a classified project output directory:
- AST interpreter
- MIR interpreter
- x64 AST NASM emit
- MIR x64 NASM emit
- JSON exports

Toolchain missing is reported, not hidden.
"""

from __future__ import annotations

import argparse
import csv
import datetime as dt
import json
import re
import shutil
import subprocess
from pathlib import Path
from typing import Dict, Any, List


CLASS_DIRS = [
    "source", "ast_interpreter", "mir_interpreter", "x64_ast_asm", "mir_x64_asm",
    "json", "logs", "diagnostics", "reports", "artifacts"
]

TOOL_MISSING_PATTERNS = [
    "not found", "cannot find", "missing", "fbc", "nasm", "gcc", "toolchain"
]


def bi_text(tr: str, en: str) -> str:
    return f"TR: {tr} | EN: {en}"


def event(level: str, layer: str, command: str, tr: str, en: str) -> Dict[str, Any]:
    return {
        "time": dt.datetime.now().isoformat(timespec="seconds"),
        "level": level,
        "layer": layer,
        "command": command,
        "message_tr": tr,
        "message_en": en,
        "message": bi_text(tr, en),
    }


def append_event(events: List[Dict[str, Any]], level: str, layer: str, command: str, tr: str, en: str) -> None:
    e = event(level, layer, command, tr, en)
    events.append(e)
    print(f"[{level}] [{layer}] {e['message']}")


def write_events(out_path: Path, events: List[Dict[str, Any]]) -> None:
    lines: List[str] = []
    for e in events:
        lines.append(f"[{e['time']}] [{e['level']}] [{e['layer']}] {e['message']}")
        lines.append(f"COMMAND: {e['command']}")
    out_path.write_text("\n".join(lines).strip() + "\n", encoding="utf-8")


def find_root(start: Path) -> Path:
    p = start.resolve()
    for c in [p] + list(p.parents):
        if (c / "uxb" / "src").is_dir():
            return c
    raise SystemExit(bi_text("UXBc kok dizini bulunamadi", "UXBc root not found"))


def find_compiler(root: Path) -> Path | None:
    candidates = [
        root / "uxb" / "compiler" / "wrappers" / "uxb_main_wrapper_64.exe",
        root / "uxb" / "build" / "uxb_main_wrapper_64.exe",
        root / "uxb" / "build" / "uxb_main_64.exe",
        root / "main_64.exe",
        root / "main.exe",
    ]
    for c in candidates:
        if c.exists():
            return c
    return None


def make_layout(root: Path, project: str, run_id: str | None) -> Dict[str, Any]:
    if not run_id:
        run_id = dt.datetime.now().strftime("%Y%m%d_%H%M%S")
    base = root / "uxb" / "_work" / "projects" / project / "runs" / run_id
    dirs = {name: base / name for name in CLASS_DIRS}
    for d in dirs.values():
        d.mkdir(parents=True, exist_ok=True)
    return {
        "project": project,
        "run_id": run_id,
        "base": base,
        "dirs": dirs,
    }


def classify(rc: int, out: str) -> str:
    low = out.lower()
    if rc == 0:
        if "diagnostic" in low or "unsupported" in low or "not implemented" in low:
            return "PASS_WITH_DIAGNOSTIC"
        return "PASS"
    if any(p in low for p in TOOL_MISSING_PATTERNS):
        return "TOOLCHAIN_OR_FILE_MISSING"
    if "diagnostic" in low or "unsupported" in low or "not implemented" in low:
        return "EXPECTED_DIAGNOSTIC"
    return "FAIL"


def run_cmd(
    root: Path,
    name: str,
    cmd: str,
    cwd: Path,
    log_dir: Path,
    timeout: int,
    events: List[Dict[str, Any]],
) -> Dict[str, Any]:
    log = log_dir / f"{name}.log"
    append_event(events, "INFO", name, cmd, "Komut isleniyor", "Processing command")
    try:
        started = dt.datetime.now().isoformat(timespec="seconds")
        p = subprocess.run(cmd, cwd=str(cwd), shell=True, capture_output=True, text=True, timeout=timeout, errors="replace")
        output = (p.stdout or "") + ("\n" if p.stdout and p.stderr else "") + (p.stderr or "")
        rc = p.returncode
        finished = dt.datetime.now().isoformat(timespec="seconds")
    except subprocess.TimeoutExpired as exc:
        started = dt.datetime.now().isoformat(timespec="seconds")
        output = (exc.stdout or "") + "\n" + (exc.stderr or "") + f"\nTIMEOUT after {timeout}s"
        rc = -777
        finished = dt.datetime.now().isoformat(timespec="seconds")
        append_event(events, "WARN", name, cmd, "Komut zaman asimina ugradi", "Command timed out")
    except Exception as exc:
        started = dt.datetime.now().isoformat(timespec="seconds")
        output = f"RUNNER_EXCEPTION: {exc}"
        rc = -999
        finished = dt.datetime.now().isoformat(timespec="seconds")
        append_event(events, "ERROR", name, cmd, "Calistirici istisnasi olustu", "Runner exception occurred")

    status = classify(rc, output)
    header_lines = [
        "# UXBc Layer Command Log",
        f"layer={name}",
        f"command={cmd}",
        f"cwd={cwd}",
        f"started={started}",
        f"finished={finished}",
        f"returncode={rc}",
        f"status={status}",
        "",
    ]
    output_with_header = "\n".join(header_lines) + output

    log.write_text(output_with_header, encoding="utf-8", errors="ignore")
    if status in ("TOOLCHAIN_OR_FILE_MISSING", "EXPECTED_DIAGNOSTIC"):
        append_event(
            events,
            "WARN",
            name,
            cmd,
            f"Katmanda uyari/teshis kaydi olustu: {status}",
            f"Warning/diagnostic recorded at layer: {status}",
        )
    elif status != "PASS":
        append_event(
            events,
            "ERROR",
            name,
            cmd,
            f"Katman basarisiz: {status}",
            f"Layer failed: {status}",
        )
    else:
        append_event(events, "INFO", name, cmd, "Komut basariyla tamamlandi", "Command completed successfully")

    return {
        "name": name,
        "cmd": cmd,
        "returncode": rc,
        "status": status,
        "log": str(log),
    }


def normalize_text(path: Path) -> str:
    if not path.exists():
        return ""
    txt = path.read_text(encoding="utf-8", errors="ignore")
    txt = re.sub(r"\r\n?", "\n", txt)
    return txt.strip()


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("source", help="Source .bas/.uxb/.uxm/.uxmh path relative to root")
    ap.add_argument("--root", default=".")
    ap.add_argument("--project", default="default")
    ap.add_argument("--run-id", default="")
    ap.add_argument("--timeout", type=int, default=180)
    args = ap.parse_args()

    events: List[Dict[str, Any]] = []

    root = find_root(Path(args.root))
    source = root / args.source
    if not source.exists():
        raise SystemExit(
            bi_text(
                f"Kaynak dosya bulunamadi: {source}",
                f"Source not found: {source}",
            )
        )

    layout = make_layout(root, args.project, args.run_id or None)
    dirs = layout["dirs"]
    append_event(events, "INFO", "runner", "layout_init", "Proje cikti duzeni olusturuldu", "Project output layout created")
    shutil.copy2(source, dirs["source"] / source.name)
    append_event(events, "INFO", "source", f"copy {source}", "Kaynak dosya run klasorune kopyalandi", "Source copied to run folder")

    compiler = find_compiler(root)
    checks: List[Dict[str, Any]] = []

    # Build compiler if no compiler exists.
    if compiler is None and (root / "build_compiler_64.bat").exists():
        checks.append(run_cmd(root, "build_compiler_64", "build_compiler_64.bat", root, dirs["logs"], args.timeout, events))
        compiler = find_compiler(root)

    if compiler is None:
        append_event(
            events,
            "ERROR",
            "compiler_binary",
            "find compiler binary",
            "Derleyici ikilisi bulunamadi",
            "Compiler binary not found",
        )
        checks.append({
            "name": "compiler_binary",
            "cmd": "find compiler binary",
            "returncode": 2,
            "status": "TOOLCHAIN_OR_FILE_MISSING",
            "log": "",
        })
    else:
        comp = str(compiler)
        src = args.source

        ast_out = dirs["ast_interpreter"] / "program_output.txt"
        mir_out = dirs["mir_interpreter"] / "program_output.txt"
        ast_json = dirs["json"] / "ast.json"
        mir_json = dirs["json"] / "mir_full.json"
        mir_verify_json = dirs["json"] / "mir_verify.json"
        policy_ast = dirs["json"] / "x64_ast_policy.json"
        policy_mir = dirs["json"] / "mir_x64_policy.json"
        x64_ast_asm = dirs["x64_ast_asm"] / "program_ast.nasm"
        mir_x64_asm = dirs["mir_x64_asm"] / "program_mir.nasm"

        commands = [
            ("ast_interpreter", f'"{comp}" "{src}" --execmem --interpreter-backend AST --console-mode CAPTURE --program-output-out "{ast_out}" --program-output-json-out "{dirs["json"] / "ast_program_output.json"}" --artifact-report-json-out "{dirs["json"] / "ast_artifact_report.json"}"'),
            ("mir_interpreter", f'"{comp}" "{src}" --execmem --interpreter-backend MIR --mir-verify --console-mode CAPTURE --program-output-out "{mir_out}" --program-output-json-out "{dirs["json"] / "mir_program_output.json"}" --mir-verify-json-out "{mir_verify_json}" --artifact-report-json-out "{dirs["json"] / "mir_artifact_report.json"}"'),
            ("x64_ast_asm", f'"{comp}" "{src}" --emit-x64-nasm --codegen-source AST --emit-x64-nasm-out "{x64_ast_asm}" --x64-codegen-policy-json-out "{policy_ast}" --ast-json-out "{ast_json}"'),
            ("mir_x64_asm", f'"{comp}" "{src}" --emit-x64-nasm --codegen-source MIR --enable-mir-x64-experimental --mir-verify --emit-x64-nasm-out "{mir_x64_asm}" --x64-codegen-policy-json-out "{policy_mir}" --mir-full-json-out "{mir_json}"'),
        ]

        for name, cmd in commands:
            checks.append(run_cmd(root, name, cmd, root, dirs["logs"], args.timeout, events))

    ast_txt = normalize_text(dirs["ast_interpreter"] / "program_output.txt")
    mir_txt = normalize_text(dirs["mir_interpreter"] / "program_output.txt")

    comparison = {
        "ast_output_exists": bool(ast_txt),
        "mir_output_exists": bool(mir_txt),
        "ast_equals_mir": ast_txt == mir_txt if ast_txt or mir_txt else None,
        "ast_output": ast_txt,
        "mir_output": mir_txt,
    }

    status_counts: Dict[str, int] = {}
    for c in checks:
        status_counts[c["status"]] = status_counts.get(c["status"], 0) + 1

    report = {
        "schema_version": "uxb-differential-project-runner-1",
        "messages": {
            "default_language": "tr",
            "secondary_language": "en",
        },
        "project": args.project,
        "run_id": layout["run_id"],
        "source": args.source,
        "base": str(layout["base"]),
        "checks": checks,
        "summary": status_counts,
        "comparison": comparison,
        "dirs": {k: str(v) for k, v in dirs.items()},
        "events": events,
    }

    (dirs["reports"] / "differential_report.json").write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")
    with (dirs["reports"] / "differential_report.csv").open("w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["name", "status", "returncode", "cmd", "log"])
        for c in checks:
            w.writerow([c["name"], c["status"], c["returncode"], c["cmd"], c["log"]])

    md = ["# UXBc Differential Project Run", ""]
    md.append(f"- source: {args.source}")
    md.append(f"- base: {layout['base']}")
    md.append("- default_language: tr")
    md.append("- secondary_language: en")
    md.append("")
    md.append("## Checks")
    md.append("")
    md.append("| name | status | rc | log |")
    md.append("|---|---|---:|---|")
    for c in checks:
        md.append(f"| {c['name']} | {c['status']} | {c['returncode']} | `{c['log']}` |")
    md.append("")
    md.append("## Interpreter comparison")
    md.append("")
    md.append(f"- ast_equals_mir: {comparison['ast_equals_mir']}")
    md.append("")
    md.append("## Events")
    md.append("")
    md.append("| time | level | layer | message |")
    md.append("|---|---|---|---|")
    for e in events:
        md.append(f"| {e['time']} | {e['level']} | {e['layer']} | {e['message']} |")
    (dirs["reports"] / "differential_report.md").write_text("\n".join(md), encoding="utf-8")

    (dirs["diagnostics"] / "layer_events.json").write_text(
        json.dumps({"events": events}, indent=2, ensure_ascii=False),
        encoding="utf-8",
    )
    write_events(dirs["diagnostics"] / "layer_events.log", events)

    print("UXB_PROJECT_RUN_BASE=" + str(layout["base"]))
    print("UXB_DIFFERENTIAL_REPORT=" + str(dirs["reports"] / "differential_report.md"))
    print("UXB_LAYER_EVENTS_LOG=" + str(dirs["diagnostics"] / "layer_events.log"))
    print("SUMMARY=" + json.dumps(status_counts, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
