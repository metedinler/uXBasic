# Browser Target Matrix Coverage Report

- Language surface rows: 1122
- Keyword rows: 197

## Language categories
- builtin_functions: 837
- statements: 197
- operators: 17
- primitive_types: 12
- oop_features: 9
- file_io: 8
- data_structures: 7
- memory_operations: 6
- ffi_forms: 6
- console_io: 5
- event_thread_pipe_slot: 5
- error_flow: 5
- high_precision_types: 5
- inline_forms: 3

## JS policy counts
- diagnostic_surface_entry: 643
- host_runtime_dispatch: 256
- native_js_math: 36
- js_object_model: 22
- native_js_string: 22
- browser_file_host: 21
- bridge_only: 18
- native_js_expr: 17
- browser_host: 15
- external_runtime_decimal: 15
- js_runtime_structure: 14
- async_host_runtime: 12
- type_runtime: 12
- js_exception_model: 10
- js_memory_model: 6
- diagnostic_non_browser: 3

## WASM policy counts
- diagnostic_surface_entry: 643
- host_import_if_called: 256
- host_import: 81
- native_wasm_or_host: 36
- host_object_handle: 22
- host_string_import: 22
- native_wasm_expr: 17
- host_or_linear_memory: 14
- wasm_numeric_type: 11
- host_or_exception_proposal: 10
- linear_memory: 6
- diagnostic_non_browser: 3
- host_string: 1

## Karar
JS tarafı tüm dil yüzeyi için host/fallback/diagnostic registry taşır. WASM tarafı compute-only çekirdektir; browser/donanım/AI/dosya/FFI işlerini JS host import/bridge üzerinden alır.
