import fs from "node:fs";
import path from "node:path";
import { pathToFileURL } from "node:url";

globalThis.window = globalThis.window || { addEventListener() {} };

const root = path.resolve(process.argv[2] || ".");
const bridgeUrl = pathToFileURL(path.join(root, "runtime", "browser", "ux_wasm_bridge.js")).href;
const { loadUxWasm } = await import(bridgeUrl);
const bytes = fs.readFileSync(path.join(root, "tests", "libraries", "uxwasmrt", "reference_26_07", "add.wasm"));
const dataUrl = `data:application/wasm;base64,${bytes.toString("base64")}`;
const exportsObject = await loadUxWasm(dataUrl);
if (typeof exportsObject.ADD !== "function") throw new Error("ADD export missing");
if (exportsObject.ADD(10, 20) !== 30) throw new Error("ADD result mismatch");
if (globalThis.uxb?.wasm?.provider !== "browser-webassembly/core-i32") throw new Error("globalThis.uxb.wasm provider missing");
const hostSmoke = path.join(root, "tests", "libraries", "uxwasmrt", "core_i32_smoke.wasm");
if (fs.existsSync(hostSmoke)) {
  const hostBytes = fs.readFileSync(hostSmoke);
  const hostUrl = `data:application/wasm;base64,${hostBytes.toString("base64")}`;
  const hostExports = await loadUxWasm(hostUrl);
  if (hostExports.HOST_ABS(-7) !== 7) throw new Error("browser host_call4 ABS mismatch");
  const rngA = hostExports.HOST_RNG_SEED_NEXT(123456);
  const rngB = hostExports.HOST_RNG_SEED_NEXT(123456);
  if (rngA !== rngB) throw new Error("browser host RNG is not deterministic");
  let trapped = false;
  try { hostExports.HOST_SQRT(-1); } catch { trapped = true; }
  if (!trapped) throw new Error("browser invalid host math input did not trap");
}
console.log("UXWASM_BROWSER_BRIDGE_SMOKE_PASS");
