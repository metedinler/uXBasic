// uXBasic Browser Runtime - matrix aware runtime
// This runtime is intentionally host-side: browser APIs, async I/O, canvas, audio,
// AI, file pickers, serial/bluetooth and fallback builtins live here.
// Generated JS and MIR executor both call this object.

import { UXB_SURFACE_REGISTRY } from "./ux_surface_registry.js";

function toNumber(v) {
  if (v === null || v === undefined || v === "") return 0;
  if (typeof v === "number") return v;
  if (typeof v === "boolean") return v ? 1 : 0;
  const n = Number(v);
  return Number.isNaN(n) ? 0 : n;
}

function toStringValue(v) {
  if (v === null || v === undefined) return "";
  return String(v);
}

class UxbDiagnostic extends Error {
  constructor(message, code = "UXB_DIAGNOSTIC") {
    super(message);
    this.name = "UxbDiagnostic";
    this.code = code;
  }
}

export const ux = {
  version: "uxb-browser-runtime-matrix-v1",
  registry: UXB_SURFACE_REGISTRY,
  vars: Object.create(null),
  globals: Object.create(null),
  outputBuffer: "",
  canvas: null,
  ctx: null,
  keys: new Set(),
  mouse: {x: 0, y: 0, buttons: new Set()},
  sprites: new Map(),
  spriteSheets: new Map(),
  animations: new Map(),
  wasm: null,
  files: new Map(),
  collections: new Map(),
  objects: new Map(),
  eventBus: new EventTarget(),
  randomSeed: 123456789,
  aiConfig: {backend: "auto", systemPrompt: "Türkçe yanıt ver."},
  ffiEndpoint: null,

  diag(message, code = "UXB_DIAGNOSTIC") {
    const line = `[${code}] ${message}`;
    console.warn(line);
    return {ok: false, code, message};
  },

  fail(message, code = "UXB_ERROR") {
    throw new UxbDiagnostic(message, code);
  },

  print(value = "") {
    const text = toStringValue(value);
    this.outputBuffer += text + "\n";
    console.log(text);
    const out = document.getElementById("ux-output");
    if (out) out.textContent += text + "\n";
    return text.length;
  },

  input(promptText = "") {
    return globalThis.prompt ? globalThis.prompt(promptText) ?? "" : "";
  },

  locate(row, col) {
    this.globals.__cursorRow = toNumber(row);
    this.globals.__cursorCol = toNumber(col);
  },

  color(fg, bg = null) {
    this.globals.__colorFg = fg;
    this.globals.__colorBg = bg;
    if (this.ctx) {
      this.ctx.fillStyle = fg;
      this.ctx.strokeStyle = fg;
    }
  },

  screen(width = 800, height = 600) {
    let canvas = document.getElementById("ux-canvas");
    if (!canvas) {
      canvas = document.createElement("canvas");
      canvas.id = "ux-canvas";
      document.body.appendChild(canvas);
    }
    canvas.width = toNumber(width);
    canvas.height = toNumber(height);
    this.canvas = canvas;
    this.ctx = canvas.getContext("2d");
    canvas.addEventListener("mousemove", e => {
      const r = canvas.getBoundingClientRect();
      this.mouse.x = e.clientX - r.left;
      this.mouse.y = e.clientY - r.top;
    });
    canvas.addEventListener("mousedown", e => this.mouse.buttons.add(e.button));
    canvas.addEventListener("mouseup", e => this.mouse.buttons.delete(e.button));
    return canvas;
  },

  cls() {
    if (!this.ctx || !this.canvas) return;
    this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
  },

  line(x1, y1, x2, y2) {
    if (!this.ctx) this.screen();
    this.ctx.beginPath();
    this.ctx.moveTo(toNumber(x1), toNumber(y1));
    this.ctx.lineTo(toNumber(x2), toNumber(y2));
    this.ctx.stroke();
  },

  rect(x, y, w, h) {
    if (!this.ctx) this.screen();
    this.ctx.strokeRect(toNumber(x), toNumber(y), toNumber(w), toNumber(h));
  },

  fillRect(x, y, w, h) {
    if (!this.ctx) this.screen();
    this.ctx.fillRect(toNumber(x), toNumber(y), toNumber(w), toNumber(h));
  },

  circle(x, y, r) {
    if (!this.ctx) this.screen();
    this.ctx.beginPath();
    this.ctx.arc(toNumber(x), toNumber(y), toNumber(r), 0, Math.PI * 2);
    this.ctx.stroke();
  },

  text(x, y, value) {
    if (!this.ctx) this.screen();
    this.ctx.fillText(toStringValue(value), toNumber(x), toNumber(y));
  },

  async loadSprite(id, path) {
    const img = new Image();
    img.src = path;
    await img.decode();
    this.sprites.set(String(id), img);
    return img;
  },

  drawSprite(id, x, y, w = null, h = null) {
    if (!this.ctx) this.screen();
    const img = this.sprites.get(String(id));
    if (!img) return this.diag(`Sprite bulunamadı: ${id}`, "UXB_SPRITE_MISSING");
    if (w === null || h === null) this.ctx.drawImage(img, toNumber(x), toNumber(y));
    else this.ctx.drawImage(img, toNumber(x), toNumber(y), toNumber(w), toNumber(h));
  },

  loadSheet(id, path, frameW, frameH) {
    return this.loadSprite(id, path).then(img => {
      this.spriteSheets.set(String(id), {img, frameW: toNumber(frameW), frameH: toNumber(frameH)});
      return img;
    });
  },

  drawFrame(id, frame, x, y, w = null, h = null) {
    if (!this.ctx) this.screen();
    const sh = this.spriteSheets.get(String(id));
    if (!sh) return this.diag(`Sprite sheet bulunamadı: ${id}`, "UXB_SHEET_MISSING");
    const cols = Math.max(1, Math.floor(sh.img.width / sh.frameW));
    const f = toNumber(frame);
    const sx = (f % cols) * sh.frameW;
    const sy = Math.floor(f / cols) * sh.frameH;
    this.ctx.drawImage(sh.img, sx, sy, sh.frameW, sh.frameH, toNumber(x), toNumber(y), w ?? sh.frameW, h ?? sh.frameH);
  },

  flip() {
    // Canvas2D immediate-mode backend has no swapchain. Kept for BASIC compatibility.
  },

  keyDown(key) {
    return this.keys.has(String(key).toUpperCase()) ? 1 : 0;
  },

  mouseX() { return this.mouse.x; },
  mouseY() { return this.mouse.y; },
  mouseDown(button = 0) { return this.mouse.buttons.has(toNumber(button)) ? 1 : 0; },

  rnd() {
    // LCG deterministic fallback.
    this.randomSeed = (1103515245 * this.randomSeed + 12345) >>> 0;
    return (this.randomSeed & 0x7fffffff) / 0x80000000;
  },

  randomize(seed = Date.now()) {
    this.randomSeed = toNumber(seed) >>> 0;
  },

  // Numeric/string builtins
  math(name, ...args) {
    const n = name.toUpperCase();
    const a0 = toNumber(args[0]);
    switch (n) {
      case "ABS": return Math.abs(a0);
      case "INT": return Math.floor(a0);
      case "FIX": return a0 < 0 ? Math.ceil(a0) : Math.floor(a0);
      case "SGN": return a0 < 0 ? -1 : a0 > 0 ? 1 : 0;
      case "SQR": return Math.sqrt(a0);
      case "SIN": return Math.sin(a0);
      case "COS": return Math.cos(a0);
      case "TAN": return Math.tan(a0);
      case "ATN": return Math.atan(a0);
      case "EXP": return Math.exp(a0);
      case "LOG": return Math.log(a0);
      case "RND": return this.rnd();
      case "RANDOMIZE": return this.randomize(a0);
      case "VAL": return Number.parseFloat(toStringValue(args[0])) || 0;
      case "CINT": return Math.trunc(a0);
      case "CLNG": return Math.trunc(a0);
      case "CDBL": return Number(a0);
      case "CSNG": return Number(a0);
      default: return this.diag(`Math builtin eksik: ${name}`, "UXB_MATH_MISSING");
    }
  },

  string(name, ...args) {
    const n = name.toUpperCase();
    const s = toStringValue(args[0]);
    switch (n) {
      case "LEN": return s.length;
      case "ASC": return s.length ? s.charCodeAt(0) : 0;
      case "CHR": return String.fromCharCode(toNumber(args[0]));
      case "STR": return String(args[0]);
      case "UCASE": return s.toUpperCase();
      case "LCASE": return s.toLowerCase();
      case "LTRIM": return s.replace(/^\s+/, "");
      case "RTRIM": return s.replace(/\s+$/, "");
      case "MID": {
        const start = Math.max(1, toNumber(args[1] ?? 1));
        const len = args.length >= 3 ? toNumber(args[2]) : undefined;
        return len === undefined ? s.substring(start - 1) : s.substring(start - 1, start - 1 + len);
      }
      case "SPACE": return " ".repeat(Math.max(0, toNumber(args[0])));
      case "STRING": return toStringValue(args[1] ?? " ").repeat(Math.max(0, toNumber(args[0])));
      default: return this.diag(`String builtin eksik: ${name}`, "UXB_STRING_MISSING");
    }
  },

  collectionNew(kind = "LIST") {
    const id = "c" + (this.collections.size + 1);
    const k = String(kind).toUpperCase();
    const value = k === "DICT" ? new Map() : k === "SET" ? new Set() : [];
    this.collections.set(id, {kind: k, value});
    return id;
  },

  collectionOp(op, id, ...args) {
    const c = this.collections.get(String(id));
    if (!c) return this.diag(`Koleksiyon bulunamadı: ${id}`, "UXB_COLLECTION_MISSING");
    const opu = String(op).toUpperCase();
    if (c.kind === "LIST") {
      if (opu === "PUSH" || opu === "ADD") return c.value.push(args[0]);
      if (opu === "GET") return c.value[toNumber(args[0])];
      if (opu === "SET") { c.value[toNumber(args[0])] = args[1]; return args[1]; }
      if (opu === "LEN") return c.value.length;
    }
    if (c.kind === "DICT") {
      if (opu === "SET") { c.value.set(String(args[0]), args[1]); return args[1]; }
      if (opu === "GET") return c.value.get(String(args[0]));
      if (opu === "HAS") return c.value.has(String(args[0])) ? 1 : 0;
      if (opu === "LEN") return c.value.size;
    }
    if (c.kind === "SET") {
      if (opu === "ADD") { c.value.add(args[0]); return c.value.size; }
      if (opu === "HAS") return c.value.has(args[0]) ? 1 : 0;
      if (opu === "LEN") return c.value.size;
    }
    return this.diag(`Koleksiyon işlemi eksik: ${c.kind}.${op}`, "UXB_COLLECTION_OP_MISSING");
  },

  async fileOpen(handle, mode = "text") {
    // Browser cannot open arbitrary local paths without user gesture.
    this.files.set(String(handle), {mode, data: ""});
    return handle;
  },

  filePut(handle, data) {
    const h = String(handle);
    const f = this.files.get(h) ?? {mode: "text", data: ""};
    f.data += toStringValue(data);
    this.files.set(h, f);
    return f.data.length;
  },

  fileGet(handle) {
    return this.files.get(String(handle))?.data ?? "";
  },

  eof(handle) {
    return this.files.has(String(handle)) ? 0 : 1;
  },

  lof(handle) {
    return (this.files.get(String(handle))?.data ?? "").length;
  },

  async aiPrompt(text) {
    if (globalThis.ai?.languageModel) {
      const availability = await globalThis.ai.languageModel.availability();
      if (availability === "readily" || availability === "after-download") {
        const session = await globalThis.ai.languageModel.create({systemPrompt: this.aiConfig.systemPrompt});
        return await session.prompt(String(text));
      }
    }
    if (globalThis.uxLocalAiEndpoint) {
      const r = await fetch(globalThis.uxLocalAiEndpoint, {
        method: "POST",
        headers: {"Content-Type": "application/json"},
        body: JSON.stringify({prompt: String(text), system: this.aiConfig.systemPrompt})
      });
      const j = await r.json();
      return j.result ?? j.text ?? "";
    }
    return `[AI fallback] ${text}`;
  },

  async callFfi(kind, library, symbol, args = []) {
    // Browser cannot directly call Windows DLL/API. Use localhost bridge.
    if (!this.ffiEndpoint) return this.diag(`FFI bridge yok: ${kind} ${library}.${symbol}`, "UXB_FFI_BRIDGE_MISSING");
    const r = await fetch(this.ffiEndpoint, {
      method: "POST",
      headers: {"Content-Type": "application/json"},
      body: JSON.stringify({kind, library, symbol, args})
    });
    return await r.json();
  },

  async callHost(name, args = []) {
    const n = String(name).toUpperCase();
    switch (n) {
      case "PRINT": return this.print(args[0] ?? "");
      case "INPUT": return this.input(args[0] ?? "");
      case "CLS": return this.cls();
      case "COLOR": return this.color(args[0], args[1]);
      case "LOCATE": return this.locate(args[0], args[1]);
      case "SCREEN": return this.screen(args[0], args[1]);
      case "LINE": return this.line(args[0], args[1], args[2], args[3]);
      case "RECT": return this.rect(args[0], args[1], args[2], args[3]);
      case "FILLRECT": return this.fillRect(args[0], args[1], args[2], args[3]);
      case "TEXT": return this.text(args[0], args[1], args[2]);
      case "CIRCLE": return this.circle(args[0], args[1], args[2]);
      case "LOADSPRITE": return this.loadSprite(args[0], args[1]);
      case "DRAWSPRITE": return this.drawSprite(args[0], args[1], args[2], args[3], args[4]);
      case "LOADSHEET": return this.loadSheet(args[0], args[1], args[2], args[3]);
      case "DRAWFRAME": return this.drawFrame(args[0], args[1], args[2], args[3], args[4], args[5]);
      case "FLIP": return this.flip();
      case "KEYDOWN": return this.keyDown(args[0]);
      case "MOUSEX": return this.mouseX();
      case "MOUSEY": return this.mouseY();
      case "MOUSEDOWN": return this.mouseDown(args[0]);
      case "AI": case "AI$": case "AI_PROMPT": return this.aiPrompt(args[0]);
      case "OPEN": return this.fileOpen(args[0], args[1]);
      case "PUT": return this.filePut(args[0], args[1]);
      case "GET": return this.fileGet(args[0]);
      case "EOF": return this.eof(args[0]);
      case "LOF": return this.lof(args[0]);
    }
    if (["ABS","INT","FIX","SGN","SQR","SIN","COS","TAN","ATN","EXP","LOG","RND","RANDOMIZE","VAL","CINT","CLNG","CDBL","CSNG"].includes(n)) {
      return this.math(n, ...args);
    }
    if (["LEN","ASC","CHR","STR","UCASE","LCASE","LTRIM","RTRIM","MID","SPACE","STRING"].includes(n)) {
      return this.string(n, ...args);
    }
    const entry = this.registry[n];
    if (entry && !String(entry.jsPolicy).startsWith("diagnostic")) {
      return this.diag(`Host handler henüz bağlanmadı: ${n} (${entry.jsPolicy})`, "UXB_HOST_HANDLER_PENDING");
    }
    return this.diag(`Bilinmeyen/uygulanmayan uXBasic çağrısı: ${n}`, "UXB_UNKNOWN_CALL");
  }
};

window.addEventListener("keydown", e => ux.keys.add(e.key.toUpperCase()));
window.addEventListener("keyup", e => ux.keys.delete(e.key.toUpperCase()));

export { UxbDiagnostic, toNumber, toStringValue };
