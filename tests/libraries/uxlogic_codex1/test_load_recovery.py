"""Execute a freshly built DLL; reject incomplete Lua and recover with real Lua."""
import ctypes
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[3]
OUT = ROOT / "reports/system_audit_20260915/uxlogic_fixed"
OUT.mkdir(parents=True, exist_ok=True)
DLL = OUT / "uxlogic_codex1.dll"
GCC = Path(os.environ.get("UXB_GCC", "C:/msys64/ucrt64/bin/gcc.exe"))
os.environ["PATH"] = str(GCC.parent) + os.pathsep + os.environ["PATH"]
build = subprocess.run([str(GCC), "-std=c11", "-O2", "-Wall", "-Wextra", "-Werror",
                        "-shared", "-static-libgcc", "-o", str(DLL),
                        str(ROOT / "runtime_ext/uxlogic/uxlogic.c")],
                       capture_output=True, text=True, timeout=60)
(OUT / "build.txt").write_text(f"exit={build.returncode}\n" + build.stdout + build.stderr, encoding="utf-8")
if build.returncode:
    print(build.stdout + build.stderr or f"GCC failed: {build.returncode}")
    sys.exit(build.returncode)
search_dirs = [os.add_dll_directory(str(ROOT / "bin")), os.add_dll_directory(str(GCC.parent))]
lib = ctypes.CDLL(str(DLL))
lib.uxlogic_lua_load.argtypes = [ctypes.c_char_p]
lib.uxlogic_lua_load.restype = ctypes.c_int
lib.uxlogic_last_error.restype = ctypes.c_char_p
lib.uxlogic_lua_new.restype = ctypes.c_uint64
lib.uxlogic_lua_close.argtypes = [ctypes.c_uint64]
lib.uxlogic_lua_do_string.argtypes = [ctypes.c_uint64, ctypes.c_char_p]
lib.uxlogic_lua_do_string.restype = ctypes.c_int
lib.uxlogic_lua_get_number.argtypes = [ctypes.c_uint64, ctypes.c_char_p]
lib.uxlogic_lua_get_number.restype = ctypes.c_double
results = []
for path, expected in [(b"kernel32.dll", 0), (b"codex1_missing_lua.dll", 0),
                       (str(ROOT / "bin/lua54.dll").encode(), 1)]:
    value = lib.uxlogic_lua_load(path)
    error = lib.uxlogic_last_error().decode(errors="replace")
    results.append({"path": path.decode(), "expected": expected, "actual": value,
                    "error": error, "pass": value == expected and (not error if expected else bool(error))})
state = lib.uxlogic_lua_new()
status = lib.uxlogic_lua_do_string(state, b"answer = 6 * 7") if state else 0
answer = lib.uxlogic_lua_get_number(state, b"answer") if status else None
results.append({"case": "real Lua execution after recovery", "state_created": bool(state),
                "status": status, "actual": answer, "expected": 42,
                "pass": bool(state) and status == 1 and answer == 42})
if state:
    lib.uxlogic_lua_close(state)
payload = {"dll": str(DLL), "sha256": hashlib.sha256(DLL.read_bytes()).hexdigest(),
           "results": results, "pass": all(r["pass"] for r in results)}
(OUT / "results.json").write_text(json.dumps(payload, indent=2, ensure_ascii=False), encoding="utf-8")
print(json.dumps(payload, indent=2))
sys.exit(0 if payload["pass"] else 1)
