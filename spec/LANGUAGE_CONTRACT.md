# uXbasic Language Contract (R2)

## Core Rules
- QB 7.1 style syntax, strict declarations.
- Type suffix identifiers are supported for legacy compatibility (`$`, `%`, `&`, `!`, `#`).
- Predeclare `SUB/FUNCTION` with `DECLARE`.
- Includes in header region.
- Arrays are 0-based by default.

## Inline Model
- Old forms (`_ASM`, `ASM_SUB`, `ASM_FUNCTION`) are replaced by:
  - `INLINE(language, programId, kind, params)`
  - `END INLINE`

## Operators (delta)
- Added: `++`, `--`, `+=`, `-=`, `*=`, `/=`, `\\=`, `=+`, `=-`, `**`, `@`
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

## Win11 Low-Level Boundary Notes
- Win11 user-mode ortaminda port I/O (`INP/OUT*`), interrupt (`INT/INT16/SETVECT`) ve dogrudan fiziksel bellek etkisi veren islemler kernel/surucu katmani olmadan gercek runtime etkisiyle calistirilamaz.
- Bu komut aileleri parser kapsamina alinabilir; ancak kernel katmani eklenmeden runtime etkisi iddia edilmez.

## Low-Level Safe Subset (Current Parser Coverage)
- Statement parser coverage: `INC var`, `DEC var`, `POKEB addr, val`, `MEMCOPYB src, dst, n`, `MEMFILLB addr, val, n`
- Intrinsic call coverage: `VARPTR(v)`, `SADD(text)`, `CODEPTR(sub)`, `LPTR(label)`, `PEEKB(addr)`, `CPUFLAGS()`
