# UXB typed task routines — real patch

Patch ID: `UXB_TYPED_TASK_ROUTINES_REAL_20260728`

This document describes the source changes actually present in the accompanying
Git patch and overlay ZIP. It replaces the earlier, incorrect claim that a
39-file patch had already been produced.

## Language contract

`EVENT`, `PIPE`, `THREAD` and `PARALEL` accept ordinary typed local parameters:

```uxbasic
EVENT CompilerEvent(message AS STRING, phase AS I32)
    PRINT message
END EVENT

PIPE Normalize(value AS I32) AS I32
    Normalize = I32(value)
END PIPE
```

The complete normal statement parser is used for their bodies. `INPUT`,
`OUTPUT` and `RETURN` remain compatible spellings, but they are optional:

```uxbasic
PIPE A(value AS I32) AS I32
    A = value * 2
END PIPE

PIPE B(value AS I32) AS I32
    RETURN value * 2
END PIPE

PIPE C(value AS I32) AS I32
    OUTPUT = INPUT * 2
END PIPE
```

Within a `PIPE`, its declared name and `OUTPUT` refer to one result cell. The
last assignment wins. `INPUT` is a local compatibility alias for the first
bound argument; it is not the console `INPUT` statement.

## Implemented source layers

- shared typed parameter grammar in the parser
- semantic task signature, target-kind and arity checks
- direct named task resolution without a mandatory `SLOT` table
- primary AST runtime local call frames and all-argument binding
- independent AST interpreter registration, local frames and full-body execution
- one shared primary-runtime scalar conversion path for type-name calls and
  typed parameter/result binding
- MIR synthetic typed task functions and direct calls carrying all arguments
- MIR `PIPE` result alias normalization, including nested control flow
- legacy native SLOT ABI v1 retained only for compatible parameterless calls

## Deliberate safety decisions

`BYREF` task parameters are rejected. A real asynchronous `THREAD` or `PARALEL`
needs an ownership/lifetime contract before references can cross worker
boundaries safely.

Typed or multi-argument tasks do not pass through the old native ABI v1, because
that ABI carries only one narrow payload. They use a normal local routine frame.
This prevents silent narrowing and global `INPUT`/`OUTPUT` races.

## Current limitations

- No tagged-value/native task ABI v2 is implemented.
- Typed `THREAD` and `PARALEL` therefore use the local synchronous routine path;
  this patch does not claim true asynchronous typed execution.
- MIR instructions provide sixteen operand positions, so a direct task call can
  carry at most fifteen explicit arguments plus the function name.
- Direct AST-to-x64 typed task emission was not separately redesigned. The
  covered native route is MIR-to-x64 through ordinary typed MIR calls.
- The package was not compiled with FreeBASIC in the assistant container because
  `fbc` was unavailable there. Static structure and clean patch application were
  validated; the supplied PowerShell test runner must be run after rebuilding on
  the user's FreeBASIC 1.10.1 Windows environment.

## Apply

From the root of the original `uxb(28.07_2)` tree:

```powershell
Copy-Item .\UXB_TYPED_TASK_ROUTINES_REAL_20260728.patch .

git apply --check .\UXB_TYPED_TASK_ROUTINES_REAL_20260728.patch
git apply .\UXB_TYPED_TASK_ROUTINES_REAL_20260728.patch
```

Without Git, copy the overlay ZIP contents over the project root while
preserving paths.

## Build and test

```powershell
.\build_64.bat

powershell -ExecutionPolicy Bypass -File `
  .\tests\typed_task_routines\run_typed_task_tests.ps1 `
  -Uxb .\bin\uxb.exe
```

Optional MIR x64 emission:

```powershell
powershell -ExecutionPolicy Bypass -File `
  .\tests\typed_task_routines\run_typed_task_tests.ps1 `
  -Uxb .\bin\uxb.exe `
  -EmitMirX64
```
