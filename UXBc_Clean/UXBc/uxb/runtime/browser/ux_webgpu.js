import { ux } from "./ux_runtime.js";

function assertWebGPU() {
  if (!navigator.gpu) throw new Error("WebGPU desteklenmiyor. Canvas2D/WebGL fallback kullanılmalı.");
}

ux.webgpu = {
  adapter: null,
  device: null,
  context: null,
  format: null,
  canvas: null,
  ready: false,

  async init(canvas = null, options = {}) {
    assertWebGPU();
    this.canvas = canvas || ux.canvas || document.getElementById("ux-canvas") || document.createElement("canvas");
    if (!this.canvas.parentNode) document.body.appendChild(this.canvas);
    this.adapter = await navigator.gpu.requestAdapter({powerPreference: options.powerPreference || "high-performance"});
    if (!this.adapter) throw new Error("WebGPU adapter bulunamadı");
    this.device = await this.adapter.requestDevice({requiredFeatures: options.requiredFeatures || []});
    this.context = this.canvas.getContext("webgpu");
    this.format = navigator.gpu.getPreferredCanvasFormat();
    this.context.configure({device: this.device, format: this.format, alphaMode: "premultiplied"});
    this.ready = true;
    return this;
  },

  async ensure() { if (!this.ready) await this.init(); return this; },

  createBuffer(data, usage) {
    const arr = data instanceof ArrayBuffer ? new Uint8Array(data) : data;
    const buffer = this.device.createBuffer({size: (arr.byteLength + 3) & ~3, usage, mappedAtCreation: true});
    const dst = new Uint8Array(buffer.getMappedRange());
    dst.set(new Uint8Array(arr.buffer || arr));
    buffer.unmap();
    return buffer;
  },

  async clear(r = 0, g = 0, b = 0, a = 1) {
    await this.ensure();
    const encoder = this.device.createCommandEncoder();
    const view = this.context.getCurrentTexture().createView();
    const pass = encoder.beginRenderPass({colorAttachments: [{view, clearValue: {r,g,b,a}, loadOp: "clear", storeOp: "store"}]});
    pass.end();
    this.device.queue.submit([encoder.finish()]);
  },

  async computeVectorAdd(a, b) {
    await this.ensure();
    if (a.length !== b.length) throw new Error("computeVectorAdd length mismatch");
    const n = a.length;
    const A = new Float32Array(a), B = new Float32Array(b), OUT = new Float32Array(n);
    const usage = GPUBufferUsage.STORAGE | GPUBufferUsage.COPY_DST | GPUBufferUsage.COPY_SRC;
    const bufA = this.createBuffer(A, usage), bufB = this.createBuffer(B, usage);
    const bufOut = this.device.createBuffer({size: OUT.byteLength, usage});
    const read = this.device.createBuffer({size: OUT.byteLength, usage: GPUBufferUsage.COPY_DST | GPUBufferUsage.MAP_READ});
    const shader = this.device.createShaderModule({code: `
      @group(0) @binding(0) var<storage, read> a: array<f32>;
      @group(0) @binding(1) var<storage, read> b: array<f32>;
      @group(0) @binding(2) var<storage, read_write> out: array<f32>;
      @compute @workgroup_size(64)
      fn main(@builtin(global_invocation_id) gid: vec3<u32>) {
        let i = gid.x;
        if (i < ${n}u) { out[i] = a[i] + b[i]; }
      }`});
    const pipeline = this.device.createComputePipeline({layout: "auto", compute: {module: shader, entryPoint: "main"}});
    const bind = this.device.createBindGroup({layout: pipeline.getBindGroupLayout(0), entries: [
      {binding: 0, resource: {buffer: bufA}}, {binding: 1, resource: {buffer: bufB}}, {binding: 2, resource: {buffer: bufOut}}
    ]});
    const encoder = this.device.createCommandEncoder();
    const pass = encoder.beginComputePass();
    pass.setPipeline(pipeline); pass.setBindGroup(0, bind); pass.dispatchWorkgroups(Math.ceil(n / 64)); pass.end();
    encoder.copyBufferToBuffer(bufOut, 0, read, 0, OUT.byteLength);
    this.device.queue.submit([encoder.finish()]);
    await read.mapAsync(GPUMapMode.READ);
    const result = new Float32Array(read.getMappedRange().slice(0));
    read.unmap();
    return Array.from(result);
  },

  async drawRects(rects) {
    await this.ensure();
    // Professional fallback policy: for now use Canvas2D for text/rect batching if WebGPU renderer is not specialized.
    // This keeps behavior correct while WebGPU remains available for compute-heavy paths.
    if (!ux.ctx) ux.screen(this.canvas.width || 800, this.canvas.height || 600);
    for (const r of rects) ux.fillRect(r.x, r.y, r.w, r.h);
  }
};

ux.gpuAvailable = () => !!navigator.gpu;
ux.gpuInit = (...a) => ux.webgpu.init(...a);
ux.gpuClear = (...a) => ux.webgpu.clear(...a);
ux.gpuVectorAdd = (...a) => ux.webgpu.computeVectorAdd(...a);
