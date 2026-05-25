#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Run imported UXBc library smoke scripts/tests.

Discovers:
- uxb/compiler/scripts/run_*smoke*.bat
- uxb/tests/<module>/*.bat
Reports status; does not fake success.
"""

from __future__ import annotations

import argparse, csv, json, subprocess, time, re
from pathlib import Path


def find_root(start: Path) -> Path:
    p = start.resolve()
    for c in [p] + list(p.parents):
        if (c / "uxb" / "src").is_dir():
            return c
    raise SystemExit("UXBc root not found")


def run(root: Path, script: Path, timeout: int = 180):
    start = time.time()
    try:
        p = subprocess.run(str(script), cwd=str(root), shell=True, capture_output=True, text=True, errors="replace", timeout=timeout)
        out = (p.stdout or "") + ("\n" if p.stdout and p.stderr else "") + (p.stderr or "")
        rc = p.returncode
    except subprocess.TimeoutExpired as exc:
        out = (exc.stdout or "") + "\n" + (exc.stderr or "") + f"\nTIMEOUT after {timeout}s"
        rc = -777
    except Exception as exc:
        out = f"RUNNER_EXCEPTION: {exc}"
        rc = -999
    low = out.lower()
    if rc == 0:
        status = "PASS"
    elif any(x in low for x in ["missing", "not found", "cannot find", "dll", "dependency", "toolchain"]):
        status = "TOOLCHAIN_OR_DEP_MISSING"
    elif any(x in low for x in ["diagnostic", "unsupported", "pending"]):
        status = "EXPECTED_DIAGNOSTIC"
    else:
        status = "FAIL"
    return {"script": str(script.relative_to(root)).replace("\\", "/"), "returncode": rc, "status": status, "duration_sec": round(time.time()-start,3), "output_tail": out[-4000:]}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--include-probes", action="store_true", help="Also run module test probe .bat files under uxb/tests/<module>")
    ap.add_argument("--timeout", type=int, default=180, help="Per-script timeout in seconds")
    args = ap.parse_args()

    root = find_root(Path("."))
    out = root / "uxb" / "dist" / "libraries"
    logs = out / "smoke_logs"
    out.mkdir(parents=True, exist_ok=True); logs.mkdir(parents=True, exist_ok=True)

    registry_path = root / "uxb" / "libs" / "uxb_library_registry.json"
    imported_modules = set()
    if registry_path.exists():
        try:
            registry = json.loads(registry_path.read_text(encoding="utf-8", errors="ignore"))
            for pkg in registry:
                for mod in pkg.get("modules", []):
                    if isinstance(mod, str) and mod.strip():
                        imported_modules.add(mod.strip())
        except Exception:
            imported_modules = set()

    scripts = []
    script_dir = root / "uxb" / "compiler" / "scripts"
    for mod in sorted(imported_modules):
        # Library bundle smoke scripts follow run_<module>_smoke.bat naming.
        scripts += list(script_dir.glob(f"run_{mod}*smoke*.bat"))

    if args.include_probes:
        for test_dir in (root / "uxb" / "tests").iterdir() if (root / "uxb" / "tests").exists() else []:
            if test_dir.is_dir() and test_dir.name in imported_modules:
                scripts += list(test_dir.glob("*.bat"))

    scripts = sorted(set(scripts))
    rows = []
    for idx, s in enumerate(scripts, start=1):
        print(f"[SMOKE {idx}/{len(scripts)}] {s}")
        r = run(root, s, timeout=args.timeout)
        safe = re.sub(r"[^A-Za-z0-9_.-]+", "_", str(s.relative_to(root)))
        log_path = logs / (safe + ".log")
        log_path.write_text(r["output_tail"], encoding="utf-8", errors="ignore")
        r["log"] = str(log_path.relative_to(root)).replace("\\", "/")
        del r["output_tail"]
        rows.append(r)

    report = {"schema_version": "uxb-library-smoke-run-1", "script_count": len(rows), "rows": rows}
    (out / "library_smoke_report.json").write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")
    with (out / "library_smoke_report.csv").open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=["script","status","returncode","duration_sec","log"])
        w.writeheader(); w.writerows(rows)
    md = ["# UXBc Library Smoke Report", "", f"- script_count: `{len(rows)}`", ""]
    md.append("| script | status | rc | log |")
    md.append("|---|---|---:|---|")
    for r in rows:
        md.append(f"| `{r['script']}` | {r['status']} | {r['returncode']} | `{r['log']}` |")
    (out / "library_smoke_report.md").write_text("\n".join(md), encoding="utf-8")
    print("LIBRARY_SMOKE_REPORT=" + str(out / "library_smoke_report.md"))
    print("INCLUDE_PROBES=" + str(bool(args.include_probes)))
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
