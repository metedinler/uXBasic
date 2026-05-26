import { ux } from "./ux_runtime.js";

ux.audio = {
  ctx: null,
  ensure() {
    if (!this.ctx) this.ctx = new (window.AudioContext || window.webkitAudioContext)();
    return this.ctx;
  },
  beep(freq = 440, ms = 120) {
    const ctx = this.ensure();
    const osc = ctx.createOscillator();
    const gain = ctx.createGain();
    osc.frequency.value = Number(freq);
    gain.gain.value = 0.05;
    osc.connect(gain).connect(ctx.destination);
    osc.start();
    setTimeout(() => osc.stop(), Number(ms));
  }
};
