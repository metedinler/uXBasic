// Generic uXBasic MIR JSON executor for browser.
// Consumes uxb-mir-module-1 style JSON and executes a conservative subset.
// Unknown operations are routed through ux.callHost so the language surface remains diagnosable.

import { ux, toNumber } from "./ux_runtime.js";

function getFunctions(mir) {
  if (!mir) return [];
  if (Array.isArray(mir.functions)) return mir.functions;
  if (mir.module && Array.isArray(mir.module.functions)) return mir.module.functions;
  if (mir.mir && Array.isArray(mir.mir.functions)) return mir.mir.functions;
  return [];
}

function getBlocks(fn) {
  return Array.isArray(fn.blocks) ? fn.blocks : [];
}

function getInstructions(block) {
  return Array.isArray(block.instructions) ? block.instructions : [];
}

function operandsOf(ins) {
  if (Array.isArray(ins.operands)) return ins.operands;
  const out = [];
  for (let i = 0; i < 16; i++) {
    if (Object.prototype.hasOwnProperty.call(ins, "operand" + i)) out.push(ins["operand" + i]);
  }
  return out;
}

function isNumberLiteral(s) {
  return /^[-+]?(?:\d+(?:\.\d*)?|\.\d+)$/.test(String(s));
}

function isStringLiteral(s) {
  const t = String(s);
  return (t.startsWith('"') && t.endsWith('"')) || (t.startsWith("'") && t.endsWith("'"));
}

function unquote(s) {
  const t = String(s);
  if (isStringLiteral(t)) return t.slice(1, -1);
  return t;
}

function upperName(v) {
  return String(v ?? "").toUpperCase();
}

function findOwnKeyCaseInsensitive(obj, key) {
  const target = upperName(key);
  for (const k of Object.keys(obj)) {
    if (upperName(k) === target) return k;
  }
  return null;
}

function toBlockId(blockMap, blocks, value) {
  const n = Number(value);
  if (Number.isFinite(n) && blockMap.has(n)) return n;

  const s = String(value ?? "").trim();
  if (!s) return null;

  const exact = blocks.find(b => String(b.id ?? "") === s || String(b.label ?? "") === s);
  if (exact) return Number(exact.id);

  const needle = s.toUpperCase();
  const ci = blocks.find(b => String(b.id ?? "").toUpperCase() === needle || String(b.label ?? "").toUpperCase() === needle);
  if (ci) return Number(ci.id);

  return null;
}

export class UxbMirExecutor {
  constructor(mir, runtime = ux) {
    this.mir = mir;
    this.ux = runtime;
    this.functions = new Map();
    for (const fn of getFunctions(mir)) {
      this.functions.set(String(fn.name || "main").toUpperCase(), fn);
    }
  }

  resolveName(env, token) {
    const raw = String(token ?? "");
    if (!raw) return "";
    if (Object.prototype.hasOwnProperty.call(env, raw)) return raw;
    const upper = upperName(raw);
    if (Object.prototype.hasOwnProperty.call(env, upper)) return upper;
    const found = findOwnKeyCaseInsensitive(env, raw);
    if (found) return found;
    return raw;
  }

  resolve(env, token) {
    if (token === null || token === undefined) return null;
    const s = String(token);
    if (isStringLiteral(s)) return unquote(s);
    if (isNumberLiteral(s)) return Number(s);
    const envName = this.resolveName(env, s);
    if (Object.prototype.hasOwnProperty.call(env, envName)) return env[envName];

    if (Object.prototype.hasOwnProperty.call(this.ux.globals, s)) return this.ux.globals[s];
    const su = upperName(s);
    if (Object.prototype.hasOwnProperty.call(this.ux.globals, su)) return this.ux.globals[su];

    const globalKey = findOwnKeyCaseInsensitive(this.ux.globals, s);
    if (globalKey !== null) return this.ux.globals[globalKey];

    return s;
  }

  assign(env, name, value) {
    if (!name) return value;
    const key = String(name);
    const resolved = this.resolveName(env, key);
    env[resolved] = value;
    const upper = upperName(resolved);
    if (upper && upper !== resolved) env[upper] = value;
    if (typeof this.ux.setVarValue === "function") {
      this.ux.setVarValue(resolved, value);
    } else {
      this.ux.globals[resolved] = value;
      if (upper && upper !== resolved) this.ux.globals[upper] = value;
    }
    return value;
  }

  makeArrayFromDims(dims, depth = 0) {
    const size = Math.max(0, toNumber(dims[depth]) | 0);
    const arr = new Array(size);
    if (depth >= dims.length - 1) {
      arr.fill(0);
      return arr;
    }
    for (let i = 0; i < arr.length; i++) {
      arr[i] = this.makeArrayFromDims(dims, depth + 1);
    }
    return arr;
  }

  copyArrayInto(src, dst) {
    if (!Array.isArray(src) || !Array.isArray(dst)) return;
    const n = Math.min(src.length, dst.length);
    for (let i = 0; i < n; i++) {
      if (Array.isArray(src[i]) && Array.isArray(dst[i])) {
        this.copyArrayInto(src[i], dst[i]);
      } else {
        dst[i] = src[i];
      }
    }
  }

  rotateLeft32(value, shift) {
    const v = toNumber(value) >>> 0;
    const s = toNumber(shift) & 31;
    return ((v << s) | (v >>> (32 - s))) >>> 0;
  }

  async callFunction(name, args = []) {
    const fn = this.functions.get(String(name).toUpperCase());
    if (!fn) {
      if (this.ux.wasm && this.ux.wasm[name]) return this.ux.wasm[name](...args);
      return this.ux.callHost(name, args);
    }
    return await this.executeFunction(fn, args);
  }

  async executeFunction(fn, args = []) {
    const env = Object.create(null);
    const params = Array.isArray(fn.params) ? fn.params : [];
    for (let i = 0; i < params.length; i++) {
      const p = String(params[i]);
      const v = args[i] ?? 0;
      env[p] = v;
      env[upperName(p)] = v;
    }
    const locals = Array.isArray(fn.locals) ? fn.locals : [];
    for (const l of locals) {
      const k = String(l);
      const ku = upperName(k);
      if (!Object.prototype.hasOwnProperty.call(env, k) && !Object.prototype.hasOwnProperty.call(env, ku)) {
        env[k] = 0;
      }
      env[ku] = env[k] ?? env[ku] ?? 0;
    }

    const blocks = getBlocks(fn);
    const blockMap = new Map(blocks.map((b, idx) => [Number(b.id ?? idx), b]));
    let pc = Number(fn.entry_block ?? fn.entryBlock ?? (blocks[0]?.id ?? 0));
    let guard = 0;

    while (pc !== null) {
      if (++guard > 1000000) throw new Error("MIR execution guard exceeded");
      const block = blockMap.get(Number(pc));
      if (!block) break;
      let jumped = false;

      for (const ins of getInstructions(block)) {
        const op = String(ins.opcode ?? ins.op ?? "").toUpperCase();
        const ops = operandsOf(ins);
        const result = ins.result ?? ins.target ?? "";
        const val = (i) => this.resolve(env, ops[i]);
        const jumpTarget = (token) => {
          const direct = toBlockId(blockMap, blocks, token);
          if (direct !== null) return direct;
          return toBlockId(blockMap, blocks, this.resolve(env, token));
        };

        switch (op) {
          case "NOP": break;
          case "CONST":
          case "LOAD_CONST":
          case "LOADI":
          case "LOADF":
          case "LOADS":
            this.assign(env, result || ops[0], this.resolve(env, ops.length > 1 ? ops[1] : ops[0]));
            break;

          case "LOAD":
          case "LOAD_VAR":
            this.assign(env, result, val(0));
            break;

          case "STORE":
          case "STORE_VAR":
          case "ASSIGN":
            this.assign(env, ops[0] || result, ops.length > 1 ? val(1) : val(0));
            break;

          case "DIM":
          case "REDIM": {
            const arrName = String(ops[0] ?? result ?? "");
            const rawDims = ops.slice(1).map(o => toNumber(this.resolve(env, o)));
            let preserve = false;
            if (op === "REDIM" && rawDims.length % 2 === 1) {
              preserve = toNumber(rawDims.pop()) !== 0;
            }
            const dims = [];
            if (rawDims.length >= 2 && rawDims.length % 2 === 0) {
              for (let i = 0; i < rawDims.length; i += 2) {
                const low = toNumber(rawDims[i]) | 0;
                const high = toNumber(rawDims[i + 1]) | 0;
                dims.push(Math.max(0, high - low + 1));
              }
            } else {
              for (const d of rawDims) {
                dims.push(Math.max(0, (toNumber(d) | 0) + 1));
              }
            }
            if (!dims.length) dims.push(1);
            const prev = preserve ? this.resolve(env, arrName) : null;
            const next = this.makeArrayFromDims(dims);
            if (preserve) this.copyArrayInto(prev, next);
            this.assign(env, arrName, next);
            break;
          }

          case "SETSTRINGSIZE":
            await this.ux.callHost("SETSTRINGSIZE", [val(0)]);
            break;

          case "NEW": {
            const className = val(0);
            const ctorArgs = ops.slice(1).map(o => this.resolve(env, o));
            const obj = await this.ux.callHost("NEW", [className, ...ctorArgs]);
            this.assign(env, result || ops[0], obj);
            break;
          }

          case "LOAD_INDEXED": {
            const container = val(0);
            const idx = val(1);
            let loaded;
            if (container instanceof Map) {
              loaded = container.get(idx);
            } else if (Array.isArray(container) || (container && typeof container === "object")) {
              loaded = container[toNumber(idx) | 0];
            }
            this.assign(env, result || ops[2], loaded ?? 0);
            break;
          }

          case "STORE_INDEXED": {
            const baseName = String(ops[0] ?? "");
            const idx = val(1);
            const storeValue = val(2);
            let container = this.resolve(env, baseName);
            if (container instanceof Map) {
              container.set(idx, storeValue);
            } else {
              if (!Array.isArray(container) && !(container && typeof container === "object")) {
                container = [];
              }
              container[toNumber(idx) | 0] = storeValue;
            }
            this.assign(env, baseName, container);
            break;
          }

          case "ADD": this.assign(env, result, toNumber(val(0)) + toNumber(val(1))); break;
          case "SUB": this.assign(env, result, toNumber(val(0)) - toNumber(val(1))); break;
          case "MUL": this.assign(env, result, toNumber(val(0)) * toNumber(val(1))); break;
          case "DIV": this.assign(env, result, toNumber(val(0)) / toNumber(val(1))); break;
          case "IDIV": this.assign(env, result, Math.trunc(toNumber(val(0)) / toNumber(val(1)))); break;
          case "MOD": this.assign(env, result, toNumber(val(0)) % toNumber(val(1))); break;
          case "FADD": this.assign(env, result, Number(val(0)) + Number(val(1))); break;
          case "FMUL": this.assign(env, result, Number(val(0)) * Number(val(1))); break;
          case "FDIV": this.assign(env, result, Number(val(0)) / Number(val(1))); break;

          case "EQ": this.assign(env, result, val(0) == val(1) ? 1 : 0); break;
          case "NE": this.assign(env, result, val(0) != val(1) ? 1 : 0); break;
          case "LT": this.assign(env, result, toNumber(val(0)) < toNumber(val(1)) ? 1 : 0); break;
          case "LE": this.assign(env, result, toNumber(val(0)) <= toNumber(val(1)) ? 1 : 0); break;
          case "GT": this.assign(env, result, toNumber(val(0)) > toNumber(val(1)) ? 1 : 0); break;
          case "GE": this.assign(env, result, toNumber(val(0)) >= toNumber(val(1)) ? 1 : 0); break;

          case "AND": this.assign(env, result, (toNumber(val(0)) | 0) & (toNumber(val(1)) | 0)); break;
          case "OR": this.assign(env, result, (toNumber(val(0)) | 0) | (toNumber(val(1)) | 0)); break;
          case "XOR": this.assign(env, result, (toNumber(val(0)) | 0) ^ (toNumber(val(1)) | 0)); break;
          case "ROL": this.assign(env, result, this.rotateLeft32(val(0), val(1))); break;
          case "NOT": this.assign(env, result, ~(toNumber(val(0)) | 0)); break;

          case "CALL":
          case "CALL_BUILTIN": {
            const name = String(ops[0] ?? ins.name ?? "");
            const cargs = ops.slice(1).map(o => this.resolve(env, o));
            const r = await this.callFunction(name, cargs);
            if (result) this.assign(env, result, r);
            break;
          }

          case "PRINT":
            await this.ux.callHost("PRINT", [val(0)]);
            break;

          case "JMP":
          case "GOTO":
            pc = jumpTarget(ops[0]);
            jumped = pc !== null;
            break;

          case "JZ":
          case "JMP_IF_ZERO":
            if (!toNumber(val(0))) {
              pc = jumpTarget(ops[1]);
              jumped = pc !== null;
            }
            break;

          case "JNZ":
          case "JMP_IF_NOT_ZERO":
            if (toNumber(val(0))) {
              pc = jumpTarget(ops[1]);
              jumped = pc !== null;
            }
            break;

          case "RET":
          case "RETURN":
            return ops.length ? val(0) : (result ? this.resolve(env, result) : undefined);

          default:
            await this.ux.callHost(op, ops.map(o => this.resolve(env, o)));
            break;
        }
        if (jumped) break;
      }

      if (!jumped) {
        const succ = Array.isArray(block.successors) ? block.successors : [];
        pc = succ.length ? toBlockId(blockMap, blocks, succ[0]) : null;
      }
    }

    return env.__return ?? 0;
  }

  async main() {
    const fn = this.functions.get("MAIN") || getFunctions(this.mir)[0];
    if (!fn) return this.ux.diag("MIR içinde çalıştırılacak fonksiyon yok", "UXB_MIR_NO_ENTRY");
    return await this.executeFunction(fn, []);
  }
}

export async function runUxbMirJson(mirJson, runtime = ux) {
  const executor = new UxbMirExecutor(mirJson, runtime);
  return await executor.main();
}
