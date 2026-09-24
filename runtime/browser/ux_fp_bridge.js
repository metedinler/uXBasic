import { ux } from "./ux_runtime.js";
import "./ux_localhost_bridge.js";

ux.fp = {
  mode: globalThis.uxFpMode || "auto", // auto | js-number | bridge
  async op(op, a, b = "0") {
    if (this.mode === "js-number") {
      const x = Number(a), y = Number(b);
      if (op === "add" || op === "+") return String(x + y);
      if (op === "sub" || op === "-") return String(x - y);
      if (op === "mul" || op === "*") return String(x * y);
      if (op === "div" || op === "/") return String(x / y);
      if (op === "neg") return String(-x);
    }
    try {
      const r = await ux.bridge.call("/api/fp/op", {op, a: String(a), b: String(b)});
      return r.result;
    } catch (e) {
      if (this.mode === "bridge") throw e;
      const x = Number(a), y = Number(b);
      if (op === "add" || op === "+") return String(x + y);
      if (op === "sub" || op === "-") return String(x - y);
      if (op === "mul" || op === "*") return String(x * y);
      if (op === "div" || op === "/") return String(x / y);
      if (op === "neg") return String(-x);
      throw e;
    }
  }
};
