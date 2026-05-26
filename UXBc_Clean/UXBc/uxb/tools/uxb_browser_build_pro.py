#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Professional browser build wrapper: uses uxb_browser_build.py, then injects pro runtime imports."""
from __future__ import annotations
import argparse, pathlib, subprocess, sys

def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--uxb-root", default=".")
    ap.add_argument("--out-dir", required=True)
    args, extra = ap.parse_known_args()
    args.extra = extra
    root = pathlib.Path(args.uxb_root).resolve()
    builder = root / "tools" / "uxb_browser_build.py"
    cmd = [sys.executable, str(builder), "--uxb-root", str(root), "--out-dir", args.out_dir] + args.extra
    res = subprocess.run(cmd)
    if res.returncode != 0: return res.returncode
    game = pathlib.Path(args.out_dir) / "game.js"
    if game.exists():
      txt = game.read_text(encoding="utf-8")
      if './ux_runtime_pro.js' not in txt:
        txt = 'import "./ux_runtime_pro.js";\n' + txt
        game.write_text(txt, encoding="utf-8")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
