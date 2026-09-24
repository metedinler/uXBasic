async function uxbMain() {
  const info = await globalThis.uxb.host.call("UXB_RUNTIME_INFO", []);
  return {
    marker: "UXJSRT_HARDENED_SMOKE_PASS",
    provider: globalThis.uxb.provider.name,
    contractVersion: globalThis.uxb.contractVersion,
    runtimeInfo: info,
    sum: 10 + 20
  };
}
globalThis.uxbMain = uxbMain;
