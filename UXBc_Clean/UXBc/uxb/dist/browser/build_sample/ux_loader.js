import { ux } from "./ux_runtime.js";
import { runUxbMirJson } from "./ux_mir_executor.js";

export async function loadAndRunMir(path) {
  const mir = await (await fetch(path)).json();
  return await runUxbMirJson(mir, ux);
}
