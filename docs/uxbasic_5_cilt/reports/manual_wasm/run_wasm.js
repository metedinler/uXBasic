const fs = require('fs');
const path = require('path');
require(path.join(__dirname, 'ux_wasm_runtime.js'));
const bytes = fs.readFileSync(path.join(__dirname, "skor.wasm"));
WebAssembly.instantiate(bytes, globalThis.uxbWasmImports).then(({instance}) => {
  const entry = instance.exports["MAIN"];
  if (typeof entry !== 'function') throw new Error('WASM entry export missing: MAIN');
  entry();
}).catch((error) => { console.error(error); process.exitCode = 1; });
