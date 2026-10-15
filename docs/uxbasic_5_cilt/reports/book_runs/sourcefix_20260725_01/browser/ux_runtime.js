globalThis.ux = globalThis.ux || (() => {
const ux = {
  out: [], pending: '', channel: 'screen', cursor: {row:1,col:1}, colorState: [], seed: 1, canvas: null, ctx: null,
  print: (...a) => { const text = a.map(v => String(v)).join(' '); ux.pending += text; return text; },
  println: (...a) => { const text = a.map(v => String(v)).join(' '); const line = ux.pending + text; ux.pending = ''; ux.out.push(line); if (ux.channel === 'screen') console.log(line); return line; },
  input: async (...a) => await ux.callHost('INPUT_PROMPT', a),
  cls: () => { ux.out.length = 0; if (ux.ctx && ux.canvas) ux.ctx.clearRect(0,0,ux.canvas.width,ux.canvas.height); return 0; },
  color: (...a) => { ux.colorState = a; return 0; },
  locate: (...a) => { ux.cursor = {row:a[0]||1, col:a[1]||1}; return 0; },
  randomize: (v=Date.now()) => { ux.seed = (Number(v)||1) >>> 0; return ux.seed; },
  rnd: () => { ux.seed = (1664525 * ux.seed + 1013904223) >>> 0; return ux.seed / 4294967296; },
  typeOf: (v) => Array.isArray(v) ? 'ARRAY' : (v === null ? 'VOID' : typeof v).toUpperCase(),
  sizeOf: (name) => { const k=String(name||'').toUpperCase(), m={I8:1,U8:1,BYTE:1,BOOLEAN:1,I16:2,U16:2,I32:4,U32:4,F32:4,I64:8,U64:8,F64:8,PTR:8,STRPTR:8,OBJECT:8,ANY:16,VARIANT:16,BIGINT:16,BIGF:32,BIGD:32,BALL:1}; if(!(k in m)) throw new Error('SIZEOF layout missing: '+k); return m[k]; },
  offsetOf: (...a) => { throw new Error('OFFSETOF requires emitted layout metadata'); },
  pointerOf: (kind, name) => { throw new Error('pointer values are not available on the JavaScript target'); },
  arrayNew: (n=0, fill=0) => Array(Number(n)||0).fill(fill),
  arrayLoad: (a,i) => (a && a[Number(i)|0]) ?? 0,
  arrayStore: (a,i,v) => { if (a) a[Number(i)|0] = v; return v; },
  objectNew: (...a) => ({__uxbClass:a[0]||'OBJECT'}),
  fieldLoad: (o,k) => o ? o[k] : undefined,
  fieldStore: (o,k,v) => { if (o) o[k]=v; return v; },
  screen: (w=800,h=600) => { if (typeof document==='undefined') throw new Error('SCREEN requires a browser DOM'); let c=document.getElementById('ux-canvas'); if(!c){ c=document.createElement('canvas'); c.id='ux-canvas'; document.body.appendChild(c); } c.width=Number(w)||800; c.height=Number(h)||600; ux.canvas=c; ux.ctx=c.getContext('2d'); if(!ux.ctx) throw new Error('Canvas2D context is unavailable'); return c; },
  fillRect: (x,y,w,h) => { if(!ux.ctx) ux.screen(); ux.ctx.fillRect(Number(x)||0,Number(y)||0,Number(w)||0,Number(h)||0); return 0; },
  text: (x,y,value) => { if(!ux.ctx) ux.screen(); ux.ctx.fillText(String(value??''),Number(x)||0,Number(y)||0); return 0; },
  builtin: (name,args=[]) => {
    name = String(name||'').toUpperCase(); const a=args;
    switch(name){
      case 'ABS': return Math.abs(Number(a[0]||0)); case 'SQR': case 'SQRT': return Math.sqrt(Number(a[0]||0));
      case 'SIN': return Math.sin(Number(a[0]||0)); case 'COS': return Math.cos(Number(a[0]||0)); case 'TAN': return Math.tan(Number(a[0]||0));
      case 'ATN': return Math.atan(Number(a[0]||0)); case 'LOG': return Math.log(Number(a[0]||0)); case 'EXP': return Math.exp(Number(a[0]||0));
      case 'FIX': case 'INT': case 'CINT': case 'CLNG': return Math.trunc(Number(a[0]||0)); case 'CSNG': case 'CDBL': case 'VAL': return Number(a[0]||0);
      case 'SGN': return Math.sign(Number(a[0]||0)); case 'RND': return ux.rnd(); case 'TIMER': return Date.now()/1000;
      case 'ASC': return String(a[0]||'').charCodeAt(0)||0; case 'CHR': return String.fromCharCode(Number(a[0]||0));
      case 'STR': return String(a[0]); case 'LEN': return String(a[0]??'').length;
      case 'LEFT': return String(a[0]??'').substring(0, Number(a[1]||0)); case 'RIGHT': { const s=String(a[0]??''); return s.substring(Math.max(0,s.length-Number(a[1]||0))); }
      case 'MID': return String(a[0]??'').substring(Math.max(0,Number(a[1]||1)-1), Math.max(0,Number(a[1]||1)-1)+Number(a[2]||String(a[0]??'').length));
      case 'INSTR': return String(a[0]??'').indexOf(String(a[1]??''))+1; case 'LCASE': return String(a[0]??'').toLowerCase(); case 'UCASE': return String(a[0]??'').toUpperCase();
      case 'LTRIM': return String(a[0]??'').replace(/^\\s+/,''); case 'RTRIM': return String(a[0]??'').replace(/\\s+$/,''); case 'TRIM': return String(a[0]??'').trim(); case 'SPACE': return ' '.repeat(Number(a[0]||0));
      case 'HEX': return Math.trunc(Number(a[0]||0)).toString(16).toUpperCase(); case 'OCT': return Math.trunc(Number(a[0]||0)).toString(8); case 'BIN': return Math.trunc(Number(a[0]||0)).toString(2);
      case 'ROL': return ((a[0] << a[1]) | (a[0] >>> (32-a[1])))|0; case 'ROR': return ((a[0] >>> a[1]) | (a[0] << (32-a[1])))|0; case 'POW': return Math.pow(Number(a[0]||0), Number(a[1]||0));
      case 'BIGINIT': { const k=String(a[0]??'').toUpperCase(), v=String(a[1]??'0'); if(k==='BIGI'||k==='BIGINT') return BigInt(v); throw new Error('BIGINIT '+k+' requires a real external precision runtime'); }
    } throw new Error('unsupported uXBasic builtin on JavaScript target: '+name);
  },
  callHost: async (name,args=[]) => { const n=String(name||'').toUpperCase(); switch(n){ case 'SCREEN': return ux.screen(args[0],args[1]); case 'CLS': return ux.cls(); case 'FILLRECT': return ux.fillRect(args[0],args[1],args[2],args[3]); case 'TEXT': return ux.text(args[0],args[1],args[2]); } const f=globalThis.__uxbHostCall; if(typeof f!=='function') throw new Error('UXB host binding missing: '+String(name)); return await f(String(name),args); }
};
return ux;
})();
