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

const ux = globalThis.ux;

// Generated by uXBasic JS backend.
// Source: docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb

const __uxbUser = Object.create(null);
const __uxbGlobals = Object.create(null);
__uxbGlobals["SKOR"] = 0;

async function MAIN() {
  const vars = Object.create(null);
  Object.defineProperty(vars, "SKOR", { enumerable: true, get: () => __uxbGlobals["SKOR"], set: value => { __uxbGlobals["SKOR"] = value; } });
  let pc = "B0";
  while (pc !== null) {
    switch (pc) {
    case "B0":
    // block 0 first-src docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:5:1
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:5:1 LOAD_CONST lexeme="DIM"
      vars["__T9"] = 0;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:5:1 STORE_VAR lexeme="DIM"
      vars["SKOR"] = vars["__T9"];
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:6:19 LOAD_CONST lexeme="18"
      vars["__T11"] = 18;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:6:23 LOAD_CONST lexeme="4"
      vars["__T12"] = 4;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:6:26 LOAD_CONST lexeme="2"
      vars["__T13"] = 2;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:6:8 CALL lexeme="teslimskor"
      if (__uxbUser["TESLIMSKOR"]) {vars["__T10"] = await __uxbUser["TESLIMSKOR"](vars["__T11"], vars["__T12"], vars["__T13"]); } else {vars["__T10"] = await ux.callHost("TESLIMSKOR", [vars["__T11"], vars["__T12"], vars["__T13"]]); }
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:6:8 STORE_VAR lexeme="teslimskor"
      vars["SKOR"] = vars["__T10"];
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:7:15 LOAD_CONST lexeme="154"
      vars["__T14"] = 154;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:7:15 EQ lexeme="154"
      vars["__T15"] = ((vars["SKOR"]) === (vars["__T14"]) ? -1 : 0);
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:7:13 LOAD_CONST lexeme="="
      vars["__T16"] = 0;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:7:13 NE lexeme="="
      vars["__T17"] = ((vars["__T15"]) !== (vars["__T16"]) ? -1 : 0);
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:7:13 JZ lexeme="="
      if (!(vars["__T17"])) { pc = "B2"; continue; }
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:7:13 JMP lexeme="="
      pc = "B1"; continue;
      pc = "B1"; break;
    case "B1":
    // block 1 first-src docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:9:13
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:9:13 LOAD_CONST lexeme="960"
      vars["__T20"] = 960;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:9:18 LOAD_CONST lexeme="540"
      vars["__T21"] = 540;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:9:1 CALL lexeme="CALL"
      if (__uxbUser["SCREEN"]) { await __uxbUser["SCREEN"](vars["__T20"], vars["__T21"]); } else { await ux.callHost("SCREEN", [vars["__T20"], vars["__T21"]]); }
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:10:1 CALL lexeme="CLS"
      ux.cls();
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:11:15 LOAD_CONST lexeme="24"
      vars["__T22"] = 24;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:11:19 LOAD_CONST lexeme="24"
      vars["__T23"] = 24;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:11:23 LOAD_CONST lexeme="912"
      vars["__T24"] = 912;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:11:28 LOAD_CONST lexeme="72"
      vars["__T25"] = 72;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:11:1 CALL lexeme="CALL"
      if (__uxbUser["FILLRECT"]) { await __uxbUser["FILLRECT"](vars["__T22"], vars["__T23"], vars["__T24"], vars["__T25"]); } else { await ux.callHost("FILLRECT", [vars["__T22"], vars["__T23"], vars["__T24"], vars["__T25"]]); }
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:12:15 LOAD_CONST lexeme="24"
      vars["__T26"] = 24;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:12:19 LOAD_CONST lexeme="120"
      vars["__T27"] = 120;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:12:24 LOAD_CONST lexeme="280"
      vars["__T28"] = 280;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:12:29 LOAD_CONST lexeme="160"
      vars["__T29"] = 160;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:12:1 CALL lexeme="CALL"
      if (__uxbUser["FILLRECT"]) { await __uxbUser["FILLRECT"](vars["__T26"], vars["__T27"], vars["__T28"], vars["__T29"]); } else { await ux.callHost("FILLRECT", [vars["__T26"], vars["__T27"], vars["__T28"], vars["__T29"]]); }
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:13:15 LOAD_CONST lexeme="340"
      vars["__T30"] = 340;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:13:20 LOAD_CONST lexeme="120"
      vars["__T31"] = 120;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:13:25 LOAD_CONST lexeme="280"
      vars["__T32"] = 280;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:13:30 LOAD_CONST lexeme="160"
      vars["__T33"] = 160;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:13:1 CALL lexeme="CALL"
      if (__uxbUser["FILLRECT"]) { await __uxbUser["FILLRECT"](vars["__T30"], vars["__T31"], vars["__T32"], vars["__T33"]); } else { await ux.callHost("FILLRECT", [vars["__T30"], vars["__T31"], vars["__T32"], vars["__T33"]]); }
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:14:15 LOAD_CONST lexeme="656"
      vars["__T34"] = 656;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:14:20 LOAD_CONST lexeme="120"
      vars["__T35"] = 120;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:14:25 LOAD_CONST lexeme="280"
      vars["__T36"] = 280;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:14:30 LOAD_CONST lexeme="160"
      vars["__T37"] = 160;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:14:1 CALL lexeme="CALL"
      if (__uxbUser["FILLRECT"]) { await __uxbUser["FILLRECT"](vars["__T34"], vars["__T35"], vars["__T36"], vars["__T37"]); } else { await ux.callHost("FILLRECT", [vars["__T34"], vars["__T35"], vars["__T36"], vars["__T37"]]); }
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:15:11 LOAD_CONST lexeme="48"
      vars["__T38"] = 48;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:15:15 LOAD_CONST lexeme="68"
      vars["__T39"] = 68;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:15:19 LOAD_CONST lexeme="uXBasic Kargo Operasyon Panosu"
      vars["__T40"] = "uXBasic Kargo Operasyon Panosu";
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:15:1 CALL lexeme="CALL"
      if (__uxbUser["TEXT"]) { await __uxbUser["TEXT"](vars["__T38"], vars["__T39"], vars["__T40"]); } else { await ux.callHost("TEXT", [vars["__T38"], vars["__T39"], vars["__T40"]]); }
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:16:11 LOAD_CONST lexeme="48"
      vars["__T41"] = 48;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:16:15 LOAD_CONST lexeme="168"
      vars["__T42"] = 168;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:16:20 LOAD_CONST lexeme="Teslim: 18"
      vars["__T43"] = "Teslim: 18";
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:16:1 CALL lexeme="CALL"
      if (__uxbUser["TEXT"]) { await __uxbUser["TEXT"](vars["__T41"], vars["__T42"], vars["__T43"]); } else { await ux.callHost("TEXT", [vars["__T41"], vars["__T42"], vars["__T43"]]); }
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:17:11 LOAD_CONST lexeme="364"
      vars["__T44"] = 364;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:17:16 LOAD_CONST lexeme="168"
      vars["__T45"] = 168;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:17:21 LOAD_CONST lexeme="Gecikme: 4"
      vars["__T46"] = "Gecikme: 4";
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:17:1 CALL lexeme="CALL"
      if (__uxbUser["TEXT"]) { await __uxbUser["TEXT"](vars["__T44"], vars["__T45"], vars["__T46"]); } else { await ux.callHost("TEXT", [vars["__T44"], vars["__T45"], vars["__T46"]]); }
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:18:11 LOAD_CONST lexeme="680"
      vars["__T47"] = 680;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:18:16 LOAD_CONST lexeme="168"
      vars["__T48"] = 168;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:18:21 LOAD_CONST lexeme="Hasar: 2"
      vars["__T49"] = "Hasar: 2";
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:18:1 CALL lexeme="CALL"
      if (__uxbUser["TEXT"]) { await __uxbUser["TEXT"](vars["__T47"], vars["__T48"], vars["__T49"]); } else { await ux.callHost("TEXT", [vars["__T47"], vars["__T48"], vars["__T49"]]); }
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:19:7 CALL lexeme="skor"
      ux.print(vars["SKOR"]);
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:19:7 CALL lexeme="skor"
      ux.println();
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:20:7 LOAD_CONST lexeme="HIBRIT_PANO_PASS"
      vars["__T50"] = "HIBRIT_PANO_PASS";
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:20:7 CALL lexeme="HIBRIT_PANO_PASS"
      ux.print(vars["__T50"]);
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:20:7 CALL lexeme="HIBRIT_PANO_PASS"
      ux.println();
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:20:7 RET lexeme="HIBRIT_PANO_PASS"
      return vars["__RESULT__"];
      pc = "B2"; break;
    case "B2":
    // block 2 first-src docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:7:13
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:7:13 LOAD_CONST lexeme="="
      vars["__T18"] = "ASSERT failed [line 7:1]";
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:7:13 STORE_VAR lexeme="="
      vars["__MIR_EXC_VALUE"] = vars["__T18"];
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:7:13 LOAD_CONST lexeme="="
      vars["__T19"] = 1;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:7:13 STORE_VAR lexeme="="
      vars["__MIR_EXC_ACTIVE"] = vars["__T19"];
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:7:13 RET lexeme="="
      return vars["__RESULT__"];
      pc = null; break;
    default:
      pc = null; break;
    }
  }
}

async function TESLIMSKOR(TESLIM, GECIKME, HASAR) {
  const vars = Object.create(null);
  Object.defineProperty(vars, "SKOR", { enumerable: true, get: () => __uxbGlobals["SKOR"], set: value => { __uxbGlobals["SKOR"] = value; } });
  vars["TESLIM"] = TESLIM;
  vars["GECIKME"] = GECIKME;
  vars["HASAR"] = HASAR;
  let pc = "B0";
  while (pc !== null) {
    switch (pc) {
    case "B0":
    // block 0 first-src docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:2:21
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:2:21 LOAD_CONST lexeme="10"
      vars["__T1"] = 10;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:2:21 MUL lexeme="10"
      vars["__T2"] = (vars["TESLIM"] * vars["__T1"]);
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:2:36 LOAD_CONST lexeme="3"
      vars["__T3"] = 3;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:2:36 MUL lexeme="3"
      vars["__T4"] = (vars["GECIKME"] * vars["__T3"]);
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:2:34 SUB lexeme="*"
      vars["__T5"] = (vars["__T2"] - vars["__T4"]);
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:2:48 LOAD_CONST lexeme="7"
      vars["__T6"] = 7;
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:2:48 MUL lexeme="7"
      vars["__T7"] = (vars["HASAR"] * vars["__T6"]);
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:2:46 SUB lexeme="*"
      vars["__T8"] = (vars["__T5"] - vars["__T7"]);
      // docs/uxbasic_5_cilt/examples/projects/hibrit_pano/main.uxb:2:38 RET lexeme="-"
      return vars["__T8"];
      pc = null; break;
    default:
      pc = null; break;
    }
  }
}

__uxbUser["MAIN"] = MAIN;
__uxbUser["TESLIMSKOR"] = TESLIMSKOR;

globalThis.uxbMain = MAIN;
MAIN().catch(err => { console.error(err); ux.println('uXBasic runtime error: ' + err.message); if (typeof process !== 'undefined' && process) process.exitCode = 1; else setTimeout(() => { throw err; }, 0); });
