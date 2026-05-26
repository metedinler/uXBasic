import { ux } from "./ux_runtime.js";

class UxObjectHandleStore {
  constructor() {
    this.classes = new Map();
    this.objects = new Map();
    this.nextId = 1;
  }
  defineClass(name, spec = {}) {
    this.classes.set(String(name).toUpperCase(), {name, fields: spec.fields || {}, methods: spec.methods || {}, base: spec.base || null});
  }
  newObject(className, init = {}) {
    const key = String(className).toUpperCase();
    const spec = this.classes.get(key) || {name: className, fields: {}, methods: {}};
    const id = "obj_" + (this.nextId++);
    const fields = {...spec.fields, ...init};
    this.objects.set(id, {id, className: spec.name || className, fields, methods: spec.methods || {}});
    return id;
  }
  get(handle, field) {
    const obj = this.objects.get(handle); if (!obj) throw new Error("Object handle not found: " + handle);
    return obj.fields[field];
  }
  set(handle, field, value) {
    const obj = this.objects.get(handle); if (!obj) throw new Error("Object handle not found: " + handle);
    obj.fields[field] = value; return value;
  }
  call(handle, method, ...args) {
    const obj = this.objects.get(handle); if (!obj) throw new Error("Object handle not found: " + handle);
    const fn = obj.methods[method] || obj.methods[String(method).toUpperCase()];
    if (typeof fn !== "function") throw new Error(`Method not found: ${obj.className}.${method}`);
    return fn(obj, ...args);
  }
  delete(handle) { return this.objects.delete(handle); }
}

ux.oop = new UxObjectHandleStore();
ux.newObject = (...a) => ux.oop.newObject(...a);
ux.getField = (...a) => ux.oop.get(...a);
ux.setField = (...a) => ux.oop.set(...a);
ux.callMethod = (...a) => ux.oop.call(...a);
ux.deleteObject = (...a) => ux.oop.delete(...a);
