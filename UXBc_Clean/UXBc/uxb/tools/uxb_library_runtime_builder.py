#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Build imported UXBc library runtimes by discovering build_*.bat scripts under uxb/runtime_ext.
Reports status; does not fake success.
"""

from __future__ import annotations

import csv, json, subprocess, time
from pathlib import Path


def find_root(start: Path) -> Path:
    p = start.resolve()
    for c in [p] + list(p.parents):
        if (c / "uxb" / "src").is_dir():
            return c
    raise SystemExit("UXBc root not found")


def run(root: Path, script: Path, timeout: int = 240):
    start = time.time()
    try:
        p = subprocess.run(str(script), cwd=str(script.parent), shell=True, capture_output=True, text=True, errors="replace", timeout=timeout)
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
    elif any(x in low for x in ["not found", "cannot find", "missing", "pacman", "openblas", "duckdb", "igraph", "onnx", "llama"]):
        status = "TOOLCHAIN_OR_DEP_MISSING"
    else:
        status = "FAIL"
    return {"script": str(script.relative_to(root)).replace("\\", "/"), "returncode": rc, "status": status, "duration_sec": round(time.time()-start,3), "output_tail": out[-4000:]}


def main():
    root = find_root(Path("."))
    out = root / "uxb" / "dist" / "libraries"
    logs = out / "runtime_build_logs"
    out.mkdir(parents=True, exist_ok=True); logs.mkdir(parents=True, exist_ok=True)

    # Restrict runtime builds to imported library modules to avoid unrelated full-runtime loops.
    registry_path = root / "uxb" / "libs" / "uxb_library_registry.json"
    imported_runtime_dirs = set()
    if registry_path.exists():
        try:
            registry = json.loads(registry_path.read_text(encoding="utf-8", errors="ignore"))
            for pkg in registry:
                for mod in pkg.get("runtime_ext", []):
                    if isinstance(mod, str) and mod.strip():
                        imported_runtime_dirs.add(mod.strip())
        except Exception:
            imported_runtime_dirs = set()

    scripts = []
    runtime_root = root / "uxb" / "runtime_ext"
    for mod in sorted(imported_runtime_dirs):
        mod_dir = runtime_root / mod
        if mod_dir.is_dir():
            scripts += list(mod_dir.glob("build_*.bat"))
    scripts = sorted(set(scripts))
    rows = []
    for s in scripts:
        r = run(root, s)
        log_path = logs / (s.parent.name + "__" + s.name + ".log")
        log_path.write_text(r["output_tail"], encoding="utf-8", errors="ignore")
        r["log"] = str(log_path.relative_to(root)).replace("\\", "/")
        del r["output_tail"]
        rows.append(r)

    report = {"schema_version": "uxb-library-runtime-build-1", "script_count": len(rows), "rows": rows}
    (out / "library_runtime_build_report.json").write_text(json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8")
    with (out / "library_runtime_build_report.csv").open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=["script","status","returncode","duration_sec","log"])
        w.writeheader(); w.writerows(rows)
    md = ["# UXBc Library Runtime Build Report", "", f"- script_count: `{len(rows)}`", ""]
    md.append("| script | status | rc | log |")
    md.append("|---|---|---:|---|")
    for r in rows:
        md.append(f"| `{r['script']}` | {r['status']} | {r['returncode']} | `{r['log']}` |")
    (out / "library_runtime_build_report.md").write_text("\n".join(md), encoding="utf-8")
    print("LIBRARY_RUNTIME_BUILD_REPORT=" + str(out / "library_runtime_build_report.md"))
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
