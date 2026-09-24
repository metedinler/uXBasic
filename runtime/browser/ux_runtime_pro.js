import { ux } from "./ux_runtime.js";
import "./ux_localhost_bridge.js";
import "./ux_oop_handles.js";
import "./ux_fp_bridge.js";
import "./ux_webgpu.js";

ux.callHost = async function (name, args = []) {
  const upper = String(name).toUpperCase();
  if (upper === "AI" || upper === "AI$" || upper === "AI_PROMPT") return await ux.ai.prompt(String(args[0] ?? ""));
  if (upper === "FP_ADD") return await ux.fp.op("add", args[0], args[1]);
  if (upper === "FP_SUB") return await ux.fp.op("sub", args[0], args[1]);
  if (upper === "FP_MUL") return await ux.fp.op("mul", args[0], args[1]);
  if (upper === "FP_DIV") return await ux.fp.op("div", args[0], args[1]);
  if (upper === "GPU_CLEAR") return await ux.gpuClear(Number(args[0]||0), Number(args[1]||0), Number(args[2]||0), Number(args[3]||1));
  if (ux.wasm && typeof ux.wasm[name] === "function") return ux.wasm[name](...args);
  if (ux.wasm && typeof ux.wasm[upper] === "function") return ux.wasm[upper](...args);
  throw new Error(`uXBasic host call is not bound: ${String(name)}`);
};
