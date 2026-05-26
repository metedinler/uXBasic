from __future__ import annotations
import sys
from pathlib import Path

REQUIRED = [
    "src/codegen/js/js_emitter.fbs",
    "src/codegen/wasm/wasm_emitter.fbs",
    "runtime/browser/ux_runtime.js",
    "runtime/browser/ux_wasm_bridge.js",
    "tests/browser/01_print.bas",
    "tests/wasm/01_add_function.bas",
]
INCLUDES = [
    'codegen/js/js_emitter.fbs',
    'codegen/wasm/wasm_emitter.fbs',
]

def main() -> int:
    root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path.cwd()
    ok = True
    for rel in REQUIRED:
        p = root / rel
        if not p.exists():
            ok = False
            print(f"MISSING: {rel}")
        else:
            print(f"OK: {rel}")
    main_bas = root / "src" / "main.bas"
    if main_bas.exists():
        text = main_bas.read_text(encoding="utf-8", errors="ignore")
        for inc in INCLUDES:
            if inc not in text:
                ok = False
                print(f"MISSING_INCLUDE: {inc}")
            else:
                print(f"OK_INCLUDE: {inc}")
    else:
        ok = False
        print("MISSING: src/main.bas")
    return 0 if ok else 1

if __name__ == "__main__":
    raise SystemExit(main())
