# Apply UXB_TYPED_TASK_ROUTINES_REAL_20260728

This package contains:

- `UXB_TYPED_TASK_ROUTINES_REAL_20260728.patch`: unified Git patch
- `overlay/`: changed and newly added files with project-relative paths
- `MANIFEST.txt`: package file inventory
- `SHA256SUMS.txt`: integrity hashes
- `STATIC_VERIFY.txt`: static verification output

## Git method

Run in the root of the unmodified `uxb(28.07_2)` source tree:

```powershell
git apply --check .\UXB_TYPED_TASK_ROUTINES_REAL_20260728.patch
git apply .\UXB_TYPED_TASK_ROUTINES_REAL_20260728.patch
```

## Overlay method

Copy everything under `overlay` to the project root, preserving folders and
overwriting matching files.

## Build

```powershell
.\build_64.bat
```

## Test

```powershell
powershell -ExecutionPolicy Bypass -File `
  .\tests\typed_task_routines\run_typed_task_tests.ps1 `
  -Uxb .\bin\uxb.exe
```
