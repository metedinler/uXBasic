"use strict";

const path = require("node:path");

const calls = [];
const context2d = {
  clearRect(...args) { calls.push(["clearRect", ...args]); },
  fillRect(...args) { calls.push(["fillRect", ...args]); },
  fillText(...args) { calls.push(["fillText", ...args]); }
};
const canvas = {
  id: "ux-canvas",
  width: 0,
  height: 0,
  getContext(kind) {
    return kind === "2d" ? context2d : null;
  }
};

global.document = {
  body: { appendChild() {} },
  getElementById(id) { return id === "ux-canvas" ? canvas : null; },
  createElement(kind) {
    if (kind !== "canvas") throw new Error(`Beklenmeyen DOM elemani: ${kind}`);
    return canvas;
  }
};

const generatedProgram = process.argv[2];
if (!generatedProgram) throw new Error("Uretilen app.js yolu gerekli");
require(path.resolve(generatedProgram));

setImmediate(() => {
  const header = calls.some(call =>
    call[0] === "fillText" &&
    call[1] === "uXBasic Kargo Operasyon Panosu" &&
    call[2] === 48 &&
    call[3] === 68
  );
  const cards = calls.filter(call => call[0] === "fillRect").length;
  if (canvas.width !== 960 || canvas.height !== 540 || !header || cards < 4) {
    console.error(JSON.stringify({ canvas: [canvas.width, canvas.height], calls }));
    process.exitCode = 1;
    return;
  }
  console.log("HIBRIT_BROWSER_PASS");
});
