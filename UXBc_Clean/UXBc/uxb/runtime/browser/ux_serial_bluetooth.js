import { ux } from "./ux_runtime.js";

ux.serial = {
  port: null,
  async open(options = {baudRate: 115200}) {
    if (!navigator.serial) return ux.diag("WebSerial desteklenmiyor.", "UXB_WEBSERIAL_MISSING");
    this.port = await navigator.serial.requestPort();
    await this.port.open(options);
    return 1;
  },
  async write(text) {
    if (!this.port) return ux.diag("Serial port açık değil.", "UXB_SERIAL_NOT_OPEN");
    const writer = this.port.writable.getWriter();
    await writer.write(new TextEncoder().encode(String(text)));
    writer.releaseLock();
    return 1;
  }
};

ux.bluetooth = {
  device: null,
  async request(filters = [{services: []}]) {
    if (!navigator.bluetooth) return ux.diag("WebBluetooth desteklenmiyor.", "UXB_WEBBLUETOOTH_MISSING");
    this.device = await navigator.bluetooth.requestDevice({acceptAllDevices: true, optionalServices: []});
    return this.device;
  }
};
