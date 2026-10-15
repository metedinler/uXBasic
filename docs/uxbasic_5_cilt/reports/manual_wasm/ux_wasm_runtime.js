(() => {
const write = (v) => { const t=String(v); if(typeof process!=='undefined'&&process.stdout) process.stdout.write(t); else if(globalThis.ux) globalThis.ux.print(t); else console.log(t); };
const newline = () => { if(typeof process!=='undefined'&&process.stdout) process.stdout.write('\n'); else if(globalThis.ux&&globalThis.ux.println) globalThis.ux.println(); else console.log(''); };
const hostCall4 = (id,a,b,c,d) => {
  switch(id|0) {
    case 1: write(a|0); return a|0; case 1000: newline(); return 0;
    case 3: return (Date.now()/1000)|0; case 4: return (Math.random()*2147483647)|0; case 5: return a|0;
    case 10: return Math.abs(a|0)|0; case 11: return Math.sqrt(a|0)|0; case 12: return Math.sin(a|0)|0; case 13: return Math.cos(a|0)|0;
    case 14: return Math.tan(a|0)|0; case 15: return Math.atan(a|0)|0; case 16: return Math.log(a|0)|0; case 17: return Math.exp(a|0)|0;
  }
  if(typeof globalThis.uxbHostCall4==='function') return globalThis.uxbHostCall4(id,a,b,c,d)|0;
  throw new Error('uXBasic WASM host import is not bound: id='+id);
};
globalThis.uxbWasmImports = { ux: {
  host_call4: hostCall4,
  print_i32: (v) => write(v|0),
  print_f64: (v) => write(Number(v)),
  timer: () => Math.floor(Date.now())|0,
  rnd: () => Math.floor(Math.random()*2147483647)|0
}};
})();
