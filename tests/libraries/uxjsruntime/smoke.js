globalThis.add = function add(a, b) { return a + b; };
globalThis.uxbMain = async function uxbMain() {
  const runtimeInfo = await globalThis.uxb.host.call("UXB_RUNTIME_INFO", []);
  globalThis.uxb.console.println("UXJSRT_GLOBALTHIS_UXB_PASS");
  return {
    marker: "UXJSRT_GLOBALTHIS_UXB_PASS",
    provider: globalThis.uxb.provider.name,
    quickjsVersion: globalThis.uxb.provider.version,
    sum: globalThis.add(10, 20),
    runtimeInfo
  };
};
