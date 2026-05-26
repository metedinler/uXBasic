import { ux } from "./ux_runtime.js";

export async function loadUxWasm(path, imports = {}) {
  const defaultImports = {
    ux: {
      print_i32(value) { ux.print(value); },
      print_f64(value) { ux.print(value); },
      host_call0(id) { ux.print(`[wasm host_call0 ${id}]`); return 0; },
      host_call1(id, a0) { ux.print(`[wasm host_call1 ${id}] ${a0}`); return 0; },
      host_call2(id, a0, a1) { ux.print(`[wasm host_call2 ${id}] ${a0},${a1}`); return 0; }
    }
  };
  const merged = {
    ...defaultImports,
    ...imports,
    ux: {...defaultImports.ux, ...(imports.ux || {})}
  };

  let result;
  try {
    result = await WebAssembly.instantiateStreaming(fetch(path), merged);
  } catch (streamErr) {
    const r = await fetch(path);
    const bytes = await r.arrayBuffer();
    result = await WebAssembly.instantiate(bytes, merged);
  }

  ux.wasm = result.instance.exports;
  return ux.wasm;
}

export async function loadUxWasmFromManifest(manifestPath = "./wasm_manifest.json") {
  const manifest = await (await fetch(manifestPath)).json();
  const modulePath = manifest.module || manifest.wasm || "./program.wasm";
  return await loadUxWasm(modulePath);
}
