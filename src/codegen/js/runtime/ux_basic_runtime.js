/* uXBasic browser runtime bridge - ux namespace.
   This file is deliberately small. It trusts only manifest allow-lists.
*/
export async function bootUxBasic(manifestUrl = "manifest.json", options = {}) {
  const ux = new UxBasicRuntime(options);
  await ux.loadManifest(manifestUrl);
  return ux;
}

export class UxBasicRuntime {
  constructor(options = {}) {
    this.options = options;
    this.manifest = {};
    this.exports = new Map();
    this.printHandlers = [];
    this.stateStore = new Map();
    this.eventHandlers = new Map();
    this.objectClasses = new Map();
    this.wasmInstance = null;
  }

  async loadManifest(url) {
    const response = await fetch(url, { credentials: "same-origin" });
    if (!response.ok) throw new Error(`manifest load failed: ${response.status}`);
    this.manifest = await response.json();
    return this.manifest;
  }

  getManifestValue(path, fallback = undefined) {
    const parts = String(path).split(".").filter(Boolean);
    let cur = this.manifest;
    for (const p of parts) {
      if (!cur || typeof cur !== "object" || !(p in cur)) return fallback;
      cur = cur[p];
    }
    return cur;
  }

  hasCapability(name) {
    return !!this.getManifestValue(`capabilities.${name}`, false);
  }

  requireCapability(name) {
    if (!this.hasCapability(name)) throw new Error(`UXB_CAPABILITY_DENIED:${name}`);
  }

  registerBasic(name, fn) {
    const spec = this.getManifestValue(`exports.${name}`, null);
    if (!spec || spec.callableFromJs !== true) throw new Error(`BASIC_EXPORT_NOT_ALLOWED:${name}`);
    this.exports.set(name, fn);
  }

  hasBasic(name) {
    return this.exports.has(name) && !!this.getManifestValue(`exports.${name}`, null);
  }

  async callBasic(name, args = []) {
    const spec = this.getManifestValue(`exports.${name}`, null);
    if (!spec || spec.callableFromJs !== true) throw new Error(`BASIC_EXPORT_NOT_ALLOWED:${name}`);
    const fn = this.exports.get(name);
    if (typeof fn !== "function") throw new Error(`BASIC_EXPORT_NOT_REGISTERED:${name}`);
    return await fn(...args);
  }

  print(text) {
    const s = String(text);
    for (const h of this.printHandlers) h(s);
  }

  println(text) {
    this.print(`${text}\n`);
  }

  onPrint(handler) {
    this.printHandlers.push(handler);
    return () => { this.printHandlers = this.printHandlers.filter(h => h !== handler); };
  }

  set(key, value) { this.stateStore.set(key, value); }
  get(key, fallback = undefined) { return this.stateStore.has(key) ? this.stateStore.get(key) : fallback; }
  merge(obj) { for (const [k, v] of Object.entries(obj || {})) this.set(k, v); }
  toJSON() { return Object.fromEntries(this.stateStore.entries()); }

  on(name, handler) {
    if (!this.eventHandlers.has(name)) this.eventHandlers.set(name, []);
    this.eventHandlers.get(name).push(handler);
  }

  emit(name, payload) {
    for (const h of this.eventHandlers.get(name) || []) h(payload);
  }

  async api(alias, body = undefined) {
    const ep = this.getManifestValue(`api.${alias}`, null);
    if (!ep) throw new Error(`API_ENDPOINT_NOT_ALLOWED:${alias}`);
    const method = String(ep.method || "GET").toUpperCase();
    const init = { method, credentials: "same-origin", headers: {} };
    if (body !== undefined) {
      init.headers["Content-Type"] = "application/json";
      init.body = JSON.stringify(body);
    }
    const r = await fetch(ep.url, init);
    const ct = r.headers.get("content-type") || "";
    if (ct.includes("application/json")) return await r.json();
    return await r.text();
  }

  registerClass(className, slots = [], ctor = "", dtor = "", base = "", ctorParamCount = 0) {
    const name = String(className || "OBJECT").toUpperCase();
    this.objectClasses.set(name, {
      slots: Array.isArray(slots) ? slots.slice() : [],
      ctor: String(ctor || "").toUpperCase(),
      dtor: String(dtor || "").toUpperCase(),
      base: String(base || "").toUpperCase(),
      ctorParamCount: Math.max(0, Number(ctorParamCount) | 0)
    });
    return 1;
  }

  async objectNew(className = "OBJECT", ...args) {
    const name = String(className || "OBJECT").toUpperCase();
    const spec = this.objectClasses.get(name);
    if (!spec) throw new Error(`UXB_CLASS_NOT_REGISTERED: ${name}`);
    const object = { __uxbClass: name, __uxbVTable: spec.slots.slice() };
    const exportsTable = (globalThis.uxb && globalThis.uxb.exports) || {};

    const construct = async (classKey) => {
      const current = this.objectClasses.get(classKey);
      if (!current) throw new Error(`UXB_CLASS_NOT_REGISTERED: ${classKey}`);
      if (current.base) await construct(current.base);
      if (current.ctor) {
        const fn = exportsTable[current.ctor];
        if (typeof fn !== "function") throw new Error(`UXB_CONSTRUCTOR_NOT_FOUND: ${current.ctor}`);
        await fn(object, ...args.slice(0, current.ctorParamCount));
      }
    };

    await construct(name);
    return object;
  }

  fieldLoad(object, key) {
    return object ? object[key] : undefined;
  }

  fieldStore(object, key, value) {
    if (!object) throw new Error("UXB_OBJECT_TARGET_MISSING: fieldStore target is missing");
    object[key] = value;
    return value;
  }

  async callStaticMethod(target, args = []) {
    const exportsTable = (globalThis.uxb && globalThis.uxb.exports) || {};
    const fn = exportsTable[String(target).toUpperCase()];
    if (typeof fn !== "function") throw new Error(`UXB_STATIC_METHOD_NOT_FOUND: ${target}`);
    return await fn(...(Array.isArray(args) ? args : []));
  }

  async callMethod(object, target, args = []) {
    if (!object) throw new Error("UXB_OBJECT_TARGET_MISSING: callMethod target is missing");
    const exportsTable = (globalThis.uxb && globalThis.uxb.exports) || {};
    const fn = exportsTable[String(target).toUpperCase()];
    if (typeof fn !== "function") throw new Error(`UXB_METHOD_NOT_FOUND: ${target}`);
    return await fn(object, ...(Array.isArray(args) ? args : []));
  }

  async virtualCall(object, slot, args = []) {
    if (!object) throw new Error("UXB_OBJECT_TARGET_MISSING: virtualCall target is missing");
    const target = object.__uxbVTable && object.__uxbVTable[Number(slot) | 0];
    if (!target) throw new Error(`UXB_VTABLE_SLOT_MISSING: ${slot}`);
    return await this.callMethod(object, target, args);
  }

  async objectDelete(object) {
    if (!object || object.__uxbDeleted) return 0;
    const exportsTable = (globalThis.uxb && globalThis.uxb.exports) || {};
    const destroy = async (classKey) => {
      const spec = this.objectClasses.get(String(classKey || "").toUpperCase());
      if (!spec) throw new Error(`UXB_CLASS_NOT_REGISTERED: ${classKey}`);
      if (spec.dtor) {
        const fn = exportsTable[spec.dtor];
        if (typeof fn !== "function") throw new Error(`UXB_DESTRUCTOR_NOT_FOUND: ${spec.dtor}`);
        await fn(object);
      }
      if (spec.base) await destroy(spec.base);
    };
    await destroy(object.__uxbClass);
    object.__uxbDeleted = true;
    return 0;
  }

  assetUrl(name) {
    const assets = this.manifest.assets || [];
    const hit = assets.find(a => a.alias === name || a.target === name || a.source === name);
    if (!hit) throw new Error(`ASSET_NOT_FOUND:${name}`);
    return hit.target || hit.source;
  }

  async loadWasm(url = undefined, imports = {}) {
    const wasmUrl = url || this.getManifestValue("wasm.file", "program.wasm");
    const response = await fetch(wasmUrl);
    const bytes = await response.arrayBuffer();
    const result = await WebAssembly.instantiate(bytes, imports);
    this.wasmInstance = result.instance;
    globalThis.uxbWasmInstance = this.wasmInstance;
    return this.wasmInstance;
  }

  callWasm(name, ...args) {
    if (!this.wasmInstance) throw new Error("WASM_NOT_LOADED");
    const fn = this.wasmInstance.exports[name];
    if (typeof fn !== "function") throw new Error(`WASM_EXPORT_NOT_FOUND:${name}`);
    return fn(...args);
  }
}
