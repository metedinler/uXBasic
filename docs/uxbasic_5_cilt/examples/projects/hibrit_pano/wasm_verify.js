"use strict";

const fs = require("node:fs");
const path = require("node:path");

const wasmPath = process.argv[2];
if (!wasmPath) throw new Error("WASM dosya yolu gerekli");

const bytes = fs.readFileSync(path.resolve(wasmPath));
const imports = {
  ux: {
    host_call4() { return 0; },
    print_i32() {},
    print_f64() {}
  }
};
WebAssembly.instantiate(bytes, imports).then(({ instance }) => {
  const fn =
    instance.exports.TESLIMSKOR ||
    instance.exports.teslimskor ||
    instance.exports._TESLIMSKOR;
  if (typeof fn !== "function") {
    throw new Error(`TESLIMSKOR export bulunamadi: ${Object.keys(instance.exports).join(",")}`);
  }
  const actual = fn(18, 4, 2);
  if (actual !== 154) {
    throw new Error(`TESLIMSKOR beklenen=154 gercek=${actual}`);
  }
  console.log("HIBRIT_WASM_PASS");
}).catch(error => {
  console.error(error.stack || String(error));
  process.exitCode = 1;
});
