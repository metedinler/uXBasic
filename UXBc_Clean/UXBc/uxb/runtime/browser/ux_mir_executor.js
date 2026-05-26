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

export class UxbMirExecutor {
  constructor(mir, runtime = ux) {
    this.mir = mir;
    this.ux = runtime;
    this.functions = new Map();
    for (const fn of getFunctions(mir)) {
      this.functions.set(String(fn.name || "main").toUpperCase(), fn);
    }
  }

  resolve(env, token) {
    if (token === null || token === undefined) return null;
    const s = String(token);
    if (isStringLiteral(s)) return unquote(s);
    if (isNumberLiteral(s)) return Number(s);
    if (Object.prototype.hasOwnProperty.call(env, s)) return env[s];
    if (Object.prototype.hasOwnProperty.call(this.ux.globals, s)) return this.ux.globals[s];
    return s;
  }

  assign(env, name, value) {
    if (!name) return value;
    env[String(name)] = value;
    return value;
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
    for (let i = 0; i < params.length; i++) env[String(params[i])] = args[i] ?? 0;
    const locals = Array.isArray(fn.locals) ? fn.locals : [];
    for (const l of locals) if (!Object.prototype.hasOwnProperty.call(env, String(l))) env[String(l)] = 0;

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

          case "ADD": this.assign(env, result, toNumber(val(0)) + toNumber(val(1))); break;
          case "SUB": this.assign(env, result, toNumber(val(0)) - toNumber(val(1))); break;
          case "MUL": this.assign(env, result, toNumber(val(0)) * toNumber(val(1))); break;
          case "DIV": this.assign(env, result, toNumber(val(0)) / toNumber(val(1))); break;
          case "IDIV": this.assign(env, result, Math.trunc(toNumber(val(0)) / toNumber(val(1)))); break;
          case "MOD": this.assign(env, result, toNumber(val(0)) % toNumber(val(1))); break;

          case "EQ": this.assign(env, result, val(0) == val(1) ? 1 : 0); break;
          case "NE": this.assign(env, result, val(0) != val(1) ? 1 : 0); break;
          case "LT": this.assign(env, result, toNumber(val(0)) < toNumber(val(1)) ? 1 : 0); break;
          case "LE": this.assign(env, result, toNumber(val(0)) <= toNumber(val(1)) ? 1 : 0); break;
          case "GT": this.assign(env, result, toNumber(val(0)) > toNumber(val(1)) ? 1 : 0); break;
          case "GE": this.assign(env, result, toNumber(val(0)) >= toNumber(val(1)) ? 1 : 0); break;

          case "AND": this.assign(env, result, (toNumber(val(0)) && toNumber(val(1))) ? 1 : 0); break;
          case "OR": this.assign(env, result, (toNumber(val(0)) || toNumber(val(1))) ? 1 : 0); break;
          case "NOT": this.assign(env, result, !toNumber(val(0)) ? 1 : 0); break;

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
            pc = Number(ops[0]);
            jumped = true;
            break;

          case "JZ":
          case "JMP_IF_ZERO":
            if (!toNumber(val(0))) { pc = Number(ops[1]); jumped = true; }
            break;

          case "JNZ":
          case "JMP_IF_NOT_ZERO":
            if (toNumber(val(0))) { pc = Number(ops[1]); jumped = true; }
            break;

          case "RET":
          case "RETURN":
            return ops.length ? val(0) : (result ? env[result] : undefined);

          default:
            await this.ux.callHost(op, ops.map(o => this.resolve(env, o)));
            break;
        }
        if (jumped) break;
      }

      if (!jumped) {
        const succ = Array.isArray(block.successors) ? block.successors : [];
        pc = succ.length ? Number(succ[0]) : null;
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
