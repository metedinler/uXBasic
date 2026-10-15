# uXBasic Surface Lifecycle Gate

Status: **FAIL**

## Summary
- schema_version: uxb-surface-lifecycle-1
- surface_count: 268
- route_counts:
  - AST_INTERPRETER: 50
  - MIR_TO_TARGET_BACKEND: 137
  - NATIVE_ONLY_WITH_TARGET_DIAGNOSTIC: 6
  - COMPILE_TIME_PREPROCESS: 46
  - RUNTIME_SERVICE: 21
  - DIRECT_NATIVE_AST_CODEGEN: 8
- status_counts:
  - IMPLEMENTED: 3433
  - MISSING: 1571
  - WASM_UNSUPPORTED: 151
  - RUNTIME_CALL: 141
  - NATIVE_ONLY: 100
  - COMPILE_TIME_ONLY: 176
  - NOT_APPLICABLE: 311
  - JS_ONLY: 5
  - BROWSER_ONLY: 8
- blocker_count: 222
- target_backend_blocker_count: 137
- fake_implemented_count: 91
- strict: True
- status: FAIL

## Gate Rules
- Her lexer/surface öğesi için lifecycle_route dolu olacak.
- MISSING, BROKEN, boş hücre ve PARTIAL hedef backendlerde kabul edilmez.
- WASM_UNSUPPORTED yalnızca açık diagnostic + negatif test varsa kabul edilir.
- final_decision=IMPLEMENTED ise bütün zorunlu route kapıları kanıtlı olmalıdır.
