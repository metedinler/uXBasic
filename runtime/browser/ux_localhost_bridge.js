import { ux } from "./ux_runtime.js";

ux.bridge = {
  endpoint: globalThis.uxLocalBridgeEndpoint || "http://127.0.0.1:8765",
  token: globalThis.uxLocalBridgeToken || "",
  enabled: true,

  async call(path, payload = {}) {
    if (!this.enabled) throw new Error("uXBasic localhost bridge disabled");
    const headers = {"Content-Type": "application/json"};
    if (this.token) headers["X-UXB-Token"] = this.token;
    const res = await fetch(this.endpoint + path, {method: "POST", headers, body: JSON.stringify(payload)});
    const data = await res.json();
    if (!data.ok) throw new Error(data.error || "bridge call failed");
    return data;
  },

  async health() {
    const res = await fetch(this.endpoint + "/health");
    return await res.json();
  }
};

ux.callFfi = async function (dll, fn, args = []) {
  return (await ux.bridge.call("/api/ffi/call-dll", {dll, function: fn, args})).result;
};
