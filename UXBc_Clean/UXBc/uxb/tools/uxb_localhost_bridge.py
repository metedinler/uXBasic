#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
uXBasic secure localhost bridge for browser targets.

Purpose:
  Browser JS/WASM cannot call Windows DLL/API directly. This bridge exposes a
  local, token-protected, allowlist-based HTTP API for controlled native services.

Endpoints:
  GET  /health
  POST /api/ai/prompt       {prompt, system?}
  POST /api/fp/op           {op, a, b?} with Decimal string results
  POST /api/ffi/call-dll    {dll, function, args} allowlist only; disabled by default
  POST /api/oop/*           small server-side handle store for testing

Security model:
  - binds to 127.0.0.1 by default
  - requires X-UXB-Token header if token is non-empty
  - DLL calls disabled unless allow_ffi=true and function is allowlisted
"""
from __future__ import annotations

import argparse, ctypes, decimal, json, os, pathlib, sys, threading, uuid
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import urlparse

CTYPES = {
    "i32": ctypes.c_int32,
    "u32": ctypes.c_uint32,
    "i64": ctypes.c_int64,
    "u64": ctypes.c_uint64,
    "f32": ctypes.c_float,
    "f64": ctypes.c_double,
    "ptr": ctypes.c_void_p,
    "str": ctypes.c_char_p,
}

def load_config(path: str) -> dict:
    if path and pathlib.Path(path).exists():
        return json.loads(pathlib.Path(path).read_text(encoding="utf-8"))
    return {"bind":"127.0.0.1", "port":8765, "token":"", "allow_ffi":False, "dll_allowlist":[], "ai":{"mode":"echo"}, "fp":{"precision":80}}

class ObjectStore:
    def __init__(self):
        self._lock = threading.Lock()
        self._items: dict[str, dict] = {}
    def new(self, class_name: str, fields: dict | None = None) -> str:
        hid = "srv_" + uuid.uuid4().hex
        with self._lock:
            self._items[hid] = {"className": class_name, "fields": fields or {}}
        return hid
    def get(self, hid: str) -> dict:
        with self._lock:
            if hid not in self._items: raise KeyError(hid)
            return self._items[hid]
    def delete(self, hid: str) -> bool:
        with self._lock:
            return self._items.pop(hid, None) is not None

class Bridge:
    def __init__(self, cfg: dict):
        self.cfg = cfg
        self.objects = ObjectStore()
        self._dll_cache: dict[str, ctypes.CDLL] = {}
    def check_token(self, handler) -> bool:
        token = self.cfg.get("token") or ""
        if not token:
            return True
        return handler.headers.get("X-UXB-Token", "") == token
    def ai_prompt(self, data: dict) -> dict:
        prompt = str(data.get("prompt", ""))
        mode = (self.cfg.get("ai") or {}).get("mode", "echo")
        if mode == "echo":
            return {"ok": True, "result": "[local-bridge AI echo] " + prompt}
        return {"ok": False, "error": "AI mode not implemented in bridge: " + mode}
    def fp_op(self, data: dict) -> dict:
        decimal.getcontext().prec = int((self.cfg.get("fp") or {}).get("precision", 80))
        op = str(data.get("op", "")).lower()
        a = decimal.Decimal(str(data.get("a", "0")))
        b = decimal.Decimal(str(data.get("b", "0")))
        if op in ("add", "+"): r = a + b
        elif op in ("sub", "-"): r = a - b
        elif op in ("mul", "*"): r = a * b
        elif op in ("div", "/"): r = a / b
        elif op == "neg": r = -a
        else: return {"ok": False, "error": "unsupported fp op: " + op}
        return {"ok": True, "result": format(r, "f"), "precision": decimal.getcontext().prec}
    def ffi_call_dll(self, data: dict) -> dict:
        if not self.cfg.get("allow_ffi", False):
            return {"ok": False, "error": "FFI disabled. Set allow_ffi=true and use allowlist."}
        dll_name = str(data.get("dll", ""))
        fn_name = str(data.get("function", ""))
        args = data.get("args", [])
        entry = None
        for d in self.cfg.get("dll_allowlist", []):
            if d.get("name") == dll_name:
                entry = d; break
        if not entry: return {"ok": False, "error": "DLL not allowlisted: " + dll_name}
        spec = (entry.get("functions") or {}).get(fn_name)
        if not spec: return {"ok": False, "error": "Function not allowlisted: " + fn_name}
        path = entry.get("path", "")
        if not pathlib.Path(path).exists(): return {"ok": False, "error": "DLL path missing: " + path}
        dll = self._dll_cache.get(path)
        if dll is None:
            dll = ctypes.CDLL(path)
            self._dll_cache[path] = dll
        fn = getattr(dll, fn_name)
        argtypes = [CTYPES[t] for t in spec.get("argtypes", [])]
        restype = CTYPES.get(spec.get("restype", "i32"), ctypes.c_int32)
        fn.argtypes = argtypes
        fn.restype = restype
        conv = []
        for t, v in zip(spec.get("argtypes", []), args):
            if t == "str": conv.append(str(v).encode("utf-8"))
            else: conv.append(v)
        res = fn(*conv)
        if isinstance(res, bytes): res = res.decode("utf-8", "replace")
        return {"ok": True, "result": res}

class Handler(BaseHTTPRequestHandler):
    bridge: Bridge
    def log_message(self, fmt, *args):
        sys.stderr.write("[uxb-bridge] " + fmt % args + "\n")
    def _send(self, code: int, obj: dict):
        data = json.dumps(obj, ensure_ascii=False).encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Headers", "Content-Type, X-UXB-Token")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers(); self.wfile.write(data)
    def do_OPTIONS(self):
        self._send(200, {"ok": True})
    def do_GET(self):
        if urlparse(self.path).path == "/health":
            return self._send(200, {"ok": True, "service":"uxb-localhost-bridge"})
        return self._send(404, {"ok": False, "error":"not found"})
    def _json_body(self):
        n = int(self.headers.get("Content-Length", "0") or "0")
        if n <= 0: return {}
        return json.loads(self.rfile.read(n).decode("utf-8"))
    def do_POST(self):
        if not self.bridge.check_token(self):
            return self._send(403, {"ok": False, "error":"bad token"})
        path = urlparse(self.path).path
        try:
            data = self._json_body()
            if path == "/api/ai/prompt": return self._send(200, self.bridge.ai_prompt(data))
            if path == "/api/fp/op": return self._send(200, self.bridge.fp_op(data))
            if path == "/api/ffi/call-dll": return self._send(200, self.bridge.ffi_call_dll(data))
            if path == "/api/oop/new":
                hid = self.bridge.objects.new(str(data.get("className", "Object")), data.get("fields") or {})
                return self._send(200, {"ok": True, "handle": hid})
            if path == "/api/oop/get":
                return self._send(200, {"ok": True, "object": self.bridge.objects.get(str(data.get("handle", "")))})
            if path == "/api/oop/delete":
                return self._send(200, {"ok": True, "deleted": self.bridge.objects.delete(str(data.get("handle", "")))})
            return self._send(404, {"ok": False, "error":"not found"})
        except Exception as e:
            return self._send(500, {"ok": False, "error": str(e)})

def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--config", default="tools/uxb_bridge_allowlist.example.json")
    ap.add_argument("--bind", default="")
    ap.add_argument("--port", type=int, default=0)
    args = ap.parse_args()
    cfg = load_config(args.config)
    if args.bind: cfg["bind"] = args.bind
    if args.port: cfg["port"] = args.port
    Handler.bridge = Bridge(cfg)
    bind = cfg.get("bind", "127.0.0.1")
    port = int(cfg.get("port", 8765))
    print(f"uXBasic localhost bridge listening on http://{bind}:{port}")
    ThreadingHTTPServer((bind, port), Handler).serve_forever()
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
