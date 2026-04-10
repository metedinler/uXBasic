# uXbasic Language Contract (R2)

## Core Rules
- QB 7.1 style syntax, strict declarations.
- No variable/type suffix identifiers in declarations (e.g. `x$`, `n%`, `v!`).
- Command/intrinsic names use non-suffix form only (`INKEY`, `MID`, `STR`, `UCASE`, `LCASE`, `CHR`, `STRING`).
- Win11 x64 profile is the active development target.
- Predeclare `SUB/FUNCTION` with `DECLARE`.
- Includes in header region.
- Arrays are 0-based by default.

## Inline Model
- Old forms (`_ASM`, `ASM_SUB`, `ASM_FUNCTION`) are replaced by:
  - `INLINE(language, programId, kind, params)`
  - `END INLINE`
- Win11 x64 backend policy (minimum active semantic gate):
  - `language` must be one of: `x64`, `x86_64`, `amd64`
  - `programId` (assembler) must be one of: `nasm`, `masm`, `gas`
  - `kind` must be one of: `sub`, `function`, `proc`
  - `params` must include `abi=win64`, `preserve=...`, `stack=16`
  - If inline body contains `call`, `params` must also include `shadow=32`

## Operators (delta)
- Added: `++`, `--`, `+=`, `-=`, `*=`, `/=`, `\\=`, `=+`, `=-`, `**`, `@`
- Added: `AND`, `OR`, `XOR`, `MOD`, `SHL`, `SHR`, `ROL`, `ROR`, `<<`, `>>`
- `@` is pointer operator only.

## Timer
- `TIMER()`
- `TIMER(unit)` where unit in `ns, us, ms, s, min, h, day, year`
- `TIMER(startTick, endTick, unit)`

## Include/Import
- `INCLUDE "file.bas"`
- `IMPORT(<LANG>, "file")`
- Supported `<LANG>` values: `C`, `CPP`, `ASM`
- `INCLUDE` is resolved post-parse with include-once semantics.
- `INCLUDE` and `IMPORT` paths must stay within source root.
- `IMPORT` entries are emitted to build manifest/link artifacts for Win11 flow.

## Procedure Declarations
- `DECLARE SUB Name([param [AS TYPE], ...])`
- `DECLARE FUNCTION Name([param [AS TYPE], ...]) AS TYPE`
- `SUB Name([param [AS TYPE], ...]) ... END SUB`
- `FUNCTION Name([param [AS TYPE], ...]) AS TYPE ... END FUNCTION`

## Type and Constant Declarations
- `CONST Name = expr[, Name = expr ...]`
- `REDIM Name(bounds) AS TYPE[, Name(bounds) AS TYPE ...]`
- `TYPE Name ... END TYPE` with fields as `fieldName AS TYPE`

## Input Statements
- `INPUT target[, target ...]`
- `INPUT promptExpr; target[, target ...]`
- `INPUT #channelExpr, target[, target ...]`

## File I/O Advanced Standardization (Win11)
- `OPEN fileExpr FOR mode AS [#]channelExpr`
- `GET [#]channelExpr, targetExpr`
- `GET [#]channelExpr, posExpr, targetExpr`
- `GET [#]channelExpr, posExpr, bytesExpr, targetExpr`
- `PUT [#]channelExpr, sourceExpr`
- `PUT [#]channelExpr, posExpr, sourceExpr`
- `PUT [#]channelExpr, posExpr, bytesExpr, sourceExpr`
- `SEEK [#]channelExpr[, posExpr]`
- Channel contract:
  - Valid channel range is `1..255`.
  - A channel cannot be opened twice without `CLOSE`.
  - `BINARY` and `RANDOM` modes are the advanced read/write modes.
- Mode normalization:
  - `INPUT|IN|I` -> `INPUT`
  - `OUTPUT|OUT|O` -> `OUTPUT`
  - `APPEND|A` -> `APPEND`
  - `BINARY|BIN|B` -> `BINARY`
  - `RANDOM|RAND|R` -> `RANDOM`
- Runtime error codes are standardized in `src/runtime/file_io.fbs` with canonical categories:
  - bad channel, channel state, invalid mode/arg
  - mode read/write violations, seek violations
  - eof and os-level io/access/not-found mapping

## Default Type Declarations
- `DEFINT rangeList`
- `DEFLNG rangeList`
- `DEFSNG rangeList`
- `DEFDBL rangeList`
- `DEFEXT rangeList`
- `DEFSTR rangeList`
- `DEFBYT rangeList`
- `SETSTRINGSIZE expr`

## Program Termination
- `END`

## Numeric/Cast Intrinsics (Current)
- `CINT(expr)`
- `CLNG(expr)`
- `CDBL(expr)`
- `CSNG(expr)`
- `FIX(expr)`
- `SQR(expr)`
- `RND()` or `RND(expr)`
- `RANDOMIZE [seedExpr]` statement

## Memory Command Subset (Current)
- Intrinsics: `PEEKB(addr)`, `PEEKW(addr)`, `PEEKD(addr)`, `VARPTR(expr)`, `SADD(expr)`, `LPTR(label)`, `CODEPTR(proc)`
- Statements: `POKEB addr,val`, `POKEW addr,val`, `POKED addr,val`, `POKES addr,text`, `MEMCOPYB src,dst,n`, `MEMCOPYW src,dst,n`, `MEMCOPYD src,dst,n`, `MEMFILLB addr,val,n`, `MEMFILLW addr,val,n`, `MEMFILLD addr,val,n`, `SETNEWOFFSET var,newaddr`, `INC ident`, `DEC ident`
- Runtime is implemented through `memory_vm` and optional AST execution path `--execmem`.

## Win11 Port I/O Scope
- Port I/O commands (`INP*`, `OUT*`) are not in Win11 profile scope.
