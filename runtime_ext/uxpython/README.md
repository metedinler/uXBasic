# uXBasic Python bridge

`uxpython.dll` embeds an installed CPython runtime without requiring Python C headers or import libraries at build time. The DLL resolves the CPython API dynamically at runtime.

Runtime discovery order:

1. `UXPYTHON_DLL` environment variable.
2. A versioned Python runtime DLL under `python_home`.
3. A versioned Python runtime DLL available through the process DLL search path.

The public uXBasic surface is `include/modules/uxpython.uxmh`. Python objects never cross the ABI as raw `PyObject*` pointers. They are stored in a generation-checked handle table owned by the bridge.

Build only this library:

```powershell
.\build_libraries.ps1 -Library uxpython -StrictRuntime
```

Run the complete smoke test:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\compiler\scripts\run_library_uxpython_smoke.ps1 `
  -Root .
```

No lexer, parser or language keyword changes are required. A uXBasic program includes the module and calls ordinary functions such as `PythonOpen`, `PythonImport`, `PythonGet`, `PythonCall`, and `PythonCallModule`.
