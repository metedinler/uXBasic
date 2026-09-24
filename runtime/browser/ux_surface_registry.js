export const UXB_SURFACE_REGISTRY = {
  "ABS": {
    "category": "statements",
    "jsPolicy": "native_js_math",
    "wasmPolicy": "native_wasm_or_host",
    "handler": "ux.math",
    "reason": "math_builtin"
  },
  "ABSTRACT": {
    "category": "statements",
    "jsPolicy": "js_object_model",
    "wasmPolicy": "host_object_handle",
    "handler": "ux.oop",
    "reason": "oop_builtin"
  },
  "ADD": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "AND": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "ANY": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "API": {
    "category": "builtin_functions",
    "jsPolicy": "bridge_only",
    "wasmPolicy": "host_import",
    "handler": "ux.ffi",
    "reason": "ffi_builtin"
  },
  "APPEND": {
    "category": "builtin_functions",
    "jsPolicy": "browser_file_host",
    "wasmPolicy": "host_import",
    "handler": "ux.file",
    "reason": "file_builtin"
  },
  "AS": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "ASC": {
    "category": "statements",
    "jsPolicy": "native_js_string",
    "wasmPolicy": "host_string_import",
    "handler": "ux.string",
    "reason": "string_builtin"
  },
  "ASSERT": {
    "category": "statements",
    "jsPolicy": "js_exception_model",
    "wasmPolicy": "host_or_exception_proposal",
    "handler": "ux.errors",
    "reason": "error_builtin"
  },
  "ASSERT_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "ASSIGN_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "ATN": {
    "category": "statements",
    "jsPolicy": "native_js_math",
    "wasmPolicy": "native_wasm_or_host",
    "handler": "ux.math",
    "reason": "math_builtin"
  },
  "BALL": {
    "category": "statements",
    "jsPolicy": "external_runtime_decimal",
    "wasmPolicy": "host_import",
    "handler": "ux.highPrecision",
    "reason": "high_precision_builtin"
  },
  "BAND": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "BIGD": {
    "category": "statements",
    "jsPolicy": "external_runtime_decimal",
    "wasmPolicy": "host_import",
    "handler": "ux.highPrecision",
    "reason": "high_precision_builtin"
  },
  "BIGF": {
    "category": "statements",
    "jsPolicy": "external_runtime_decimal",
    "wasmPolicy": "host_import",
    "handler": "ux.highPrecision",
    "reason": "high_precision_builtin"
  },
  "BINARY": {
    "category": "builtin_functions",
    "jsPolicy": "browser_file_host",
    "wasmPolicy": "host_import",
    "handler": "ux.file",
    "reason": "file_builtin"
  },
  "BLOCK": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "BOR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "BXOR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "BYREF": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "BYTE": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "BYVAL": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "CALL": {
    "category": "statements",
    "jsPolicy": "bridge_only",
    "wasmPolicy": "host_import",
    "handler": "ux.ffi",
    "reason": "ffi_builtin"
  },
  "CALL_DLL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "CALL_EXPR": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "CALL_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "CAST": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "CDBL": {
    "category": "statements",
    "jsPolicy": "native_js_math",
    "wasmPolicy": "native_wasm_or_host",
    "handler": "ux.math",
    "reason": "math_builtin"
  },
  "CDECL": {
    "category": "statements",
    "jsPolicy": "bridge_only",
    "wasmPolicy": "host_import",
    "handler": "ux.ffi",
    "reason": "ffi_builtin"
  },
  "CG": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "CHR": {
    "category": "statements",
    "jsPolicy": "native_js_string",
    "wasmPolicy": "host_string_import",
    "handler": "ux.string",
    "reason": "string_builtin"
  },
  "CINT": {
    "category": "statements",
    "jsPolicy": "native_js_math",
    "wasmPolicy": "native_wasm_or_host",
    "handler": "ux.math",
    "reason": "math_builtin"
  },
  "CLASS": {
    "category": "statements",
    "jsPolicy": "js_object_model",
    "wasmPolicy": "host_object_handle",
    "handler": "ux.oop",
    "reason": "oop_builtin"
  },
  "CLASS_ACCESS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "CLASS_CONSTRUCTOR_DECL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "CLASS_DESTRUCTOR_DECL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "CLASS_METHOD_DECL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "CLASS_OPERATOR_DECL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "CLASS_PROPERTY_GET_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "CLASS_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "CLNG": {
    "category": "statements",
    "jsPolicy": "native_js_math",
    "wasmPolicy": "native_wasm_or_host",
    "handler": "ux.math",
    "reason": "math_builtin"
  },
  "CLOSE": {
    "category": "statements",
    "jsPolicy": "browser_file_host",
    "wasmPolicy": "host_import",
    "handler": "ux.file",
    "reason": "file_builtin"
  },
  "CLOSE_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "CLS": {
    "category": "statements",
    "jsPolicy": "browser_host",
    "wasmPolicy": "host_import",
    "handler": "ux.console",
    "reason": "console_builtin"
  },
  "CLS_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "CODEPTR": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "COLOR": {
    "category": "statements",
    "jsPolicy": "browser_host",
    "wasmPolicy": "host_import",
    "handler": "ux.console",
    "reason": "console_builtin"
  },
  "COLOR_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "CONST": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "CONST_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "COS": {
    "category": "statements",
    "jsPolicy": "native_js_math",
    "wasmPolicy": "native_wasm_or_host",
    "handler": "ux.math",
    "reason": "math_builtin"
  },
  "CSNG": {
    "category": "statements",
    "jsPolicy": "native_js_math",
    "wasmPolicy": "native_wasm_or_host",
    "handler": "ux.math",
    "reason": "math_builtin"
  },
  "DAY": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "DEC": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "DECLARE": {
    "category": "statements",
    "jsPolicy": "bridge_only",
    "wasmPolicy": "host_import",
    "handler": "ux.ffi",
    "reason": "ffi_builtin"
  },
  "DECORATOR": {
    "category": "statements",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "DEFBYT": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "DEFDBL": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "DEFEXT": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "DEFINT": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "DEFLNG": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "DEFSNG": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "DEFSTR": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "DEFTYPE_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "DEF_FN_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "DEF_TYPE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "DELETE_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "DICTCLEAR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "DICTGET": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "DICTHAS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "DICTLEN": {
    "category": "builtin_functions",
    "jsPolicy": "js_runtime_structure",
    "wasmPolicy": "host_or_linear_memory",
    "handler": "ux.collections",
    "reason": "collection_builtin"
  },
  "DICTSET": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "DIM": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "DIM_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "DIRNAMEFROMPATH": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "DIV": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "DLL": {
    "category": "builtin_functions",
    "jsPolicy": "bridge_only",
    "wasmPolicy": "host_import",
    "handler": "ux.ffi",
    "reason": "ffi_builtin"
  },
  "DOUBLE": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "DO_EACH_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "DO_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "END": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "END_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EOF": {
    "category": "statements",
    "jsPolicy": "browser_file_host",
    "wasmPolicy": "host_import",
    "handler": "ux.file",
    "reason": "file_builtin"
  },
  "EQ": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EVENT": {
    "category": "statements",
    "jsPolicy": "async_host_runtime",
    "wasmPolicy": "host_import",
    "handler": "ux.events",
    "reason": "event_builtin"
  },
  "EVENT_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "EXECALLOCCLASSINSTANCE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECAREDLLCALLINGCONVENTIONSCOMPATIBLE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECARRAYEXTENT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECARRAYRESIZEVAR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECBINARYOPERATORTOKENTOROUTINESUFFIX": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECBUILDFIELDPATH": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECBUILDROUTINEMAPFROMCLASS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECBUILDTOPLEVELLABELMAP": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECBUILDTOPLEVELROUTINEMAP": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECBUILDVTABLEMAP": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECBUILTINARGASINT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECBUILTINARGASTEXT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECBUILTINARGASTYPENAME": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECBUILTINGETARGNODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECBUILTINTEXTMIDCALL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECBUILTINTEXTSPACECALL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECBUILTINTEXTSTRINGCALL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECCANACCESSMETHOD": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECCANASSIGNCLASSTYPE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECCASEEXPRMATCHES": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECCHILDAT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "EXECCHILDCOUNT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "EXECCLAMPI32": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECCLASSALLOWSFRIENDCALLER": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECCLASSBASENAME": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECCLASSFIELDHASFLAG": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECCLASSHASFLAG": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECCLASSISORDERIVEDFROM": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECCLASSISORDERIVESFROM": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECCLASSMETHODACCESSTEXT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECCLASSMETHODHASFLAG": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECCLASSPROPERTYHASACCESSOR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECCOLLECTIONCREATE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECCOLLECTIONENSUREKIND": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECCOLLECTIONGETHANDLEARG": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECCOLLECTIONGETINTARG": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECCOLLECTIONGETTEXTARG": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECCOLLECTIONGETVALUEARG": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECCONFIGURECLASSSTORAGE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECCONSUMELOOPEXIT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "EXECCONTAINSINVALIDDLLCHARS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECDEBUGGETFFIX86RESOLVEDCOUNT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECDEBUGGETINPUTQUEUEREMAINING": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECDEBUGGETKEYQUEUEREMAINING": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECDEBUGGETLOCATEROW": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECDEBUGINPUTQUEUEPOP": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECDEBUGKEYQUEUEPOP": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECDICTCLEAR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECDICTFINDKEY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECDICTGET": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECDICTHAS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECDICTLEN": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECDICTSET": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECDLLCALLISALLOWLISTED": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECENSUREVAR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALBINARYVALUES": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALBUILTINCALL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALBUILTINCOLLECTIONCATEGORY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALBUILTINCOLLECTIONDICT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALBUILTINCOLLECTIONLIST": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALBUILTINCOLLECTIONSET": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALBUILTINFFICATEGORY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALBUILTINFILECATEGORY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALBUILTINKEYBOARDCATEGORY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALBUILTINLAYOUTCATEGORY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALBUILTINPEEKCATEGORY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALBUILTINPOINTERCATEGORY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALBUILTINSCALARCATEGORY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALBUILTINTIMERANDOMCATEGORY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALCALL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALCONST": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALDEF": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALDIM": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALDLLARGASMIXEDSLOT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALDLLCALLCORE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALEXPRESSION": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "EXECEVALMETHODCALL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALNODE": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "EXECEVALNODEASTEXT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "EXECEVALPIPEINVOKE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALREDIM": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALSETSTRINGSIZE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALSTRINGLITERAL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEVALUSERCALL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECEXCEPTIONBUILDMESSAGE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECFFINORMALIZETYPETOKEN": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECFFIPARSEARGTYPELIST": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECFIELDNODETYPENAME": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECFIELDPATHREADIDENT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECFIELDPATHSKIPINDEXES": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECFIELDZEROVALUE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECFINDAGGREGATEFIELDNODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECFINDAGGREGATENODEBYNAME": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECFINDCHILDBYKIND": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECFINDCLASSDECLNODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECFINDCLASSMETHODDECL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECFINDCLASSNODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECFINDCLASSPROPERTYACCESSORBODY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECFINDNODENAMESPACE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECFINDNODENAMESPACEREC": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECFINDRUNTIMEVTABLECLASSBYHANDLE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECFINDRUNTIMEVTABLECLASSINDEX": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECFINDRUNTIMEVTABLEHANDLE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECFINDVAR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECFINDVTABLEROUTINEIDX": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECFINDX86RESOLVEDPROC": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECFINDX86RESOLVERENTRYINDEX": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECFINDX86SYMPTRMAPINDEX": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECFORMATFILEERROR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECGETACTIVEFFIABINAME": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECGETARRAYELEMENT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECGETCLASSBASETYPEBYNAME": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECGETCLASSBASETYPENAME": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECGETFFIPOLICYMODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECGETFFIPOLICYPATH": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECGETFFIRESOLVERMODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECGETFFIRESOLVERPATH": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECGETVAR": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "EXECGETVARADDR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECGETVARVALUE": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "EXECHANDLEIFEXITREQUEST": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECHASDLLPATHSEGMENTS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECHASHTEXT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECINFERCALLERCLASS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECINFERRECEIVERCLASSTYPE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECINVOKECLASSCTORIFPRESENT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECINVOKECLASSDTORIFPRESENT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECINVOKEROUTINEBYINDEX": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECINVOKEROUTINEBYPREPAREDARGS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECISABSOLUTEDLLPATH": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECISALLOWEDDLLSIGNATURE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECISBUILTINCALLNAME": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECISCLASSDERIVEDFROM": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECISCTORSELFTYPESUPPORTED": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECISDLLCALLINGCONVENTION": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECISEXPRESSIONNODEKIND": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECISROUTINEMETADATANODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECISSTMTNODE": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "EXECLABELINDEXOF": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECLISTADD": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECLISTCLEAR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECLISTGET": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECLISTLEN": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECLISTREMOVE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECLISTSET": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECMAGICOPERATORROUTINENAMEBYSUFFIX": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECMAGICROUTINEDUNDERALIAS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECNORMALIZEDLLNAME": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECNORMALIZEFFIHASHTOKEN": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECNORMALIZEFFISIGNERTOKEN": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECNORMALIZETYPENAME": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECOPERATORTOKENTOROUTINESUFFIX": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECPARAMDECLTYPENAME": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECPARSEBOUNDRANGE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECPARSEFFIALLOWLISTLINE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECPOLICYDENYCODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECPOLICYDENYPHASE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECREADFIELDVALUE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECREGISTERDEFFNSTATEMENT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECREGISTERROUTINEDEF": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRESOLVEFIELDACCESS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRESOLVEFIELDPOLICY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRESOLVEINSTANCEOFOBJECTCLASS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRESOLVEMAGICROUTINEINHIERARCHY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRESOLVEMETHODROUTINEINDEX": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRESOLVEMETHODROUTINEINHIERARCHY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRESOLVEOPERATORROUTINEINHIERARCHY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRESOLVERUNTIMECLASSBYOBJECTADDR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRESOLVETHISMEIDENTADDR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRESOLVETHISMEIDENTVALUE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRESOLVEX86INTEROPTARGET": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECROL32": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECROR32": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECROUTINEINDEXOF": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECROUTINENODEHASRETURNTYPE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECROUTINEPARAMCOUNT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNASSERTSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNASSIGNSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNBLOCKCHILDREN": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNCLASSPROPERTYGETBODY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNCLASSPROPERTYSETBODY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNCLOSESTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNCOLORSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNDECLDIRECTIVESTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNDELETESTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNDOEACHSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNDOSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNFLOWSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNFOREACHSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNFORSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNGETSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNIFSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNINCDECSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNINPUTFILESTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNINPUTSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNIOFILESTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNLOCATESTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNMEMCOPYBSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNMEMCOPYDSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNMEMCOPYWSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNMEMFILLBSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNMEMFILLDSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNMEMFILLWSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNMEMORYCORESTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNOPENSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNPOKEBSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNPOKEDSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNPOKESSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNPOKEWSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNPRINTSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNPROGRAMSCOPEDTORS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNPUTSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNRANDOMIZESTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNSEEKSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNSELECTCASEBODY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNSELECTELSEBODY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNSELECTSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNSETNEWOFFSETSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "EXECRUNTAILSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNTHROWSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNTRYPART": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECRUNTRYSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECSETADD": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECSETARRAYELEMENT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECSETCLEAR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECSETFIND": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECSETHAS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECSETLEN": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECSETREMOVE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECSLOTBLOCKKIND": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECSLOTFIND": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECSLOTNORMALIZEKIND": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECSLOTREADHEADERID": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECSLOTREGISTERBLOCK": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECSLOTRUNBLOCKBODY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECSLOTRUNCONTROLSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECSLOTRUNSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECSLOTTARGETINFO": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECSLOTTRIGGER": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECSLOTTRIGGERPIPEVALUE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECSPLITMETHODCALLNAME": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECSTATICFIELDFINDINDEX": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECSTATICFIELDREAD": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECTIMERUNITSCALE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECTRYEVALCALLEXPRASTEXT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECTRYEVALDEFFNCALL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECTRYEVALOVERLOADEDBINARY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECTRYEXTRACTDEFFNDECLARATION": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECTRYINVOKEDIRECTX86I32": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECTRYINVOKEMAGICFIELDGET": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECTRYINVOKEMAGICFIELDSET": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECTRYINVOKERESOLVEDX64I32": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECTRYINVOKERESOLVEDX64MIXED": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECTRYINVOKERESOLVEDX86I32": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECTRYPARSEALIASDLLTARGET": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECTRYREADDLLARGTYPELIST": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECTRYRESOLVEALIASDLLTARGET": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECTRYRESOLVEARRAYACCESS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECTRYRESOLVEBINARYRECEIVER": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECTRYRESOLVEMAGICFIELDRECEIVER": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECTRYRESOLVERUNTIMECLASSBYOBJECTADDR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECTYPEELEMSIZEBYTES": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECVALIDATECLASSCTORSIGNATURE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECVALIDATECLASSDTORSIGNATURE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECVALIDATEDLLMARSHALARG": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECVALUETOFLOAT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECVALUETOINTEGER": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "EXECVALUETOSTRING": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "EXECWRITEFIELDVALUE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECX64DISPATCHMIXEDINVOKE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXECX64EVALARGS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "EXIT_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "EXP": {
    "category": "statements",
    "jsPolicy": "native_js_math",
    "wasmPolicy": "native_wasm_or_host",
    "handler": "ux.math",
    "reason": "math_builtin"
  },
  "EXPR_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "F128": {
    "category": "statements",
    "jsPolicy": "external_runtime_decimal",
    "wasmPolicy": "host_import",
    "handler": "ux.highPrecision",
    "reason": "high_precision_builtin"
  },
  "F32": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "F64": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "F80": {
    "category": "statements",
    "jsPolicy": "external_runtime_decimal",
    "wasmPolicy": "host_import",
    "handler": "ux.highPrecision",
    "reason": "high_precision_builtin"
  },
  "FADD": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FDIV": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFICALLCHILDAT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFICALLCHILDCOUNT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFICALLCOLLECTENTRIES": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFICALLCOLLECTNODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFICALLCSTRINGESCAPE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFICALLISDLLCONVENTION": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFICALLNASMSTUBTEXT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFICALLPLANCSV": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFICALLREADDLLENTRY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFICALLRESOLVERCSV": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFICALLRESOLVERCTEXT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFIESCAPEPOWERSHELLLITERAL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFIEXTRACTHASHFROMDLLPATH": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFIEXTRACTSIGNERFROMDLLPATH": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFIREADFIRSTNONEMPTYLINE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFIRESOLVEDLLPATH": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFIRUNPOWERSHELLCAPTURE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFIWRITETEXTFILE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFIX86CALLCHILDAT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFIX86CALLCHILDCOUNT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFIX86CALLCOLLECTENTRIES": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFIX86CALLCOLLECTNODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFIX86CALLISDLLCONVENTION": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFIX86CALLPLANCSV": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFIX86CALLREADDLLENTRY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFIX86CLEANUPTYPE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFIX86NASMSTUBTEXT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFIX86RESOLVERCSV": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FFIX86WRITETEXTFILE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FIELD_EXPR": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "FINAL": {
    "category": "statements",
    "jsPolicy": "js_object_model",
    "wasmPolicy": "host_object_handle",
    "handler": "ux.oop",
    "reason": "oop_builtin"
  },
  "FIX": {
    "category": "statements",
    "jsPolicy": "native_js_math",
    "wasmPolicy": "native_wasm_or_host",
    "handler": "ux.math",
    "reason": "math_builtin"
  },
  "FLOAT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "FMUL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FOR": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "FOR_EACH_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "FOR_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "FSUB": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "FUNCTION": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "FUNCTION_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "GE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "GENERATECALL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "GENERATEEXPRESSION": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "GENERATEFOR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "GENERATEIF": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "GENERATELOCALDIM": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "GENERATEPRINT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "GENERATEROUTINE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "GENERATESTATEMENT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "GENERATEX64CODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "GETKEY": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "GETPROCADDRESS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "GET_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "GOSUB_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "GOTO_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "GT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "GX64ROUTINERETURNTYPES": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "I16": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "I32": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "I64": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "I8": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "IDENT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "IF": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "IF_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "IMPORT": {
    "category": "statements",
    "jsPolicy": "bridge_only",
    "wasmPolicy": "host_import",
    "handler": "ux.ffi",
    "reason": "ffi_builtin"
  },
  "INCDEC_EXPR": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "INCDEC_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "INCLUDE_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "INDEX": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "INDEX_EXPR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "INKEY": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "INLINECOLLECTX64BLOCKS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "INLINECONTAINSWORD": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "INLINEISKW": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "INLINEISOP": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "INLINEPARSEBODY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "INLINEPARSEHEADER": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "INLINEREADHEADERARG": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "INLINEVALIDATEBLOCK": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "INPUT": {
    "category": "statements",
    "jsPolicy": "browser_host",
    "wasmPolicy": "host_import",
    "handler": "ux.console",
    "reason": "console_builtin"
  },
  "INPUT_FILE_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "INPUT_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "INSTANCEOF": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "INT": {
    "category": "statements",
    "jsPolicy": "native_js_math",
    "wasmPolicy": "native_wasm_or_host",
    "handler": "ux.math",
    "reason": "math_builtin"
  },
  "INTEGER": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "JMP": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "JZ": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "KEYWORD_REF": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "LABEL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "LABEL_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "LCASE": {
    "category": "statements",
    "jsPolicy": "native_js_string",
    "wasmPolicy": "host_string_import",
    "handler": "ux.string",
    "reason": "string_builtin"
  },
  "LE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "LEN": {
    "category": "statements",
    "jsPolicy": "native_js_string",
    "wasmPolicy": "host_string_import",
    "handler": "ux.string",
    "reason": "string_builtin"
  },
  "LISTADD": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "LISTCLEAR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "LISTGET": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "LISTLEN": {
    "category": "builtin_functions",
    "jsPolicy": "js_runtime_structure",
    "wasmPolicy": "host_or_linear_memory",
    "handler": "ux.collections",
    "reason": "collection_builtin"
  },
  "LISTREMOVE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "LISTSET": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "LNOT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "LOADLIBRARYA": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "LOAD_ADDR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "LOAD_CONST": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "LOAD_FIELD": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "LOAD_INDEXED": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "LOAD_VAR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "LOCATE": {
    "category": "statements",
    "jsPolicy": "browser_host",
    "wasmPolicy": "host_import",
    "handler": "ux.console",
    "reason": "console_builtin"
  },
  "LOCATE_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "LOF": {
    "category": "statements",
    "jsPolicy": "browser_file_host",
    "wasmPolicy": "host_import",
    "handler": "ux.file",
    "reason": "file_builtin"
  },
  "LOG": {
    "category": "statements",
    "jsPolicy": "native_js_math",
    "wasmPolicy": "native_wasm_or_host",
    "handler": "ux.math",
    "reason": "math_builtin"
  },
  "LPTR": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "LT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "LTRIM": {
    "category": "statements",
    "jsPolicy": "native_js_string",
    "wasmPolicy": "host_string_import",
    "handler": "ux.string",
    "reason": "string_builtin"
  },
  "MEMCOPYB_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MEMCOPYD_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MEMCOPYW_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MEMFILLB_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MEMFILLD_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MEMFILLW_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "METHOD_DECL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MID": {
    "category": "statements",
    "jsPolicy": "native_js_string",
    "wasmPolicy": "host_string_import",
    "handler": "ux.string",
    "reason": "string_builtin"
  },
  "MIN": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "MIREXECUTE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MIRGENERATEFROMAST": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MIRX64ALIGN16": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MIRX64ARRAYLABEL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MIRX64COLLECTLOCALS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MIRX64CONDITIONCODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MIRX64EMITBUILTINONEARGRESULT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MIRX64EMITCALLINSTRUCTION": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MIRX64EMITFUNCTION": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MIRX64EMITINPUTCALL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MIRX64EMITINSTRUCTION": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MIRX64EMITPRINTVALUE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MIRX64EMITTERAVAILABLE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MIRX64FIELDKEY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MIRX64ISFLOATLITERAL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MIRX64KEYWORDCOUNTERPARTSTATUS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MIRX64SELECTENTRYFUNCTIONINDEX": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MIRX64TRACKDIMSTORAGE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MIRX64TRACKLOCALIFNEEDED": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MIRX64UPPER": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MOD": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "MOVE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MS": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "MUL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MUTABLE": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "NAMESPACE_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "NE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "NEG": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "NEW": {
    "category": "statements",
    "jsPolicy": "js_object_model",
    "wasmPolicy": "host_object_handle",
    "handler": "ux.oop",
    "reason": "oop_builtin"
  },
  "NEW_EXPR": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "NEXT_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "NOP": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "NOT": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "NS": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "NUMBER": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "OFF": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "OFFSETOF": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "ON": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "OPEN_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "OR": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "OUTPUT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "PARALEL": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "PARALEL_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "PARAM_DECL": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "PAREN_EXPR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "PEEKB": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "PEEKD": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "PEEKW": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "PIPE": {
    "category": "statements",
    "jsPolicy": "async_host_runtime",
    "wasmPolicy": "host_import",
    "handler": "ux.events",
    "reason": "event_builtin"
  },
  "PIPE_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "POKEB_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "POKED_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "POKES_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "POKEW": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "POKEW_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "PRINT": {
    "category": "statements",
    "jsPolicy": "browser_host",
    "wasmPolicy": "host_import",
    "handler": "ux.console",
    "reason": "console_builtin"
  },
  "PRINTLN": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "PRINT_SEP_COMMA": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "PRINT_SEP_SEMICOLON": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "PRINT_SEP_SPACE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "PRINT_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "PRIVATE": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "PROGRAM": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "PTR": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "PUBLIC": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "PUT_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "RANDOM": {
    "category": "builtin_functions",
    "jsPolicy": "browser_file_host",
    "wasmPolicy": "host_import",
    "handler": "ux.file",
    "reason": "file_builtin"
  },
  "RANDOMIZE": {
    "category": "statements",
    "jsPolicy": "native_js_math",
    "wasmPolicy": "native_wasm_or_host",
    "handler": "ux.math",
    "reason": "math_builtin"
  },
  "RANDOMIZE_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "REDIM": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "REDIM_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "RET": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "RETURN": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "RETURN_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "RND": {
    "category": "statements",
    "jsPolicy": "native_js_math",
    "wasmPolicy": "native_wasm_or_host",
    "handler": "ux.math",
    "reason": "math_builtin"
  },
  "ROL": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "ROR": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "RTRIM": {
    "category": "statements",
    "jsPolicy": "native_js_string",
    "wasmPolicy": "host_string_import",
    "handler": "ux.string",
    "reason": "string_builtin"
  },
  "SADD": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "SAVEDEPILOGLABEL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "SEEK_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "SELECT_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "SETADD": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "SETCLEAR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "SETHAS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "SETLEN": {
    "category": "builtin_functions",
    "jsPolicy": "js_runtime_structure",
    "wasmPolicy": "host_or_linear_memory",
    "handler": "ux.collections",
    "reason": "collection_builtin"
  },
  "SETNEWOFFSET_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "SETREMOVE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "SETSTRINGSIZE_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "SGN": {
    "category": "statements",
    "jsPolicy": "native_js_math",
    "wasmPolicy": "native_wasm_or_host",
    "handler": "ux.math",
    "reason": "math_builtin"
  },
  "SHL": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "SHORT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "SHR": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "SIN": {
    "category": "statements",
    "jsPolicy": "native_js_math",
    "wasmPolicy": "native_wasm_or_host",
    "handler": "ux.math",
    "reason": "math_builtin"
  },
  "SINGLE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "SIZEOF": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "SLOT_CONTROL_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "SLOT_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "SPACE": {
    "category": "statements",
    "jsPolicy": "native_js_string",
    "wasmPolicy": "host_string_import",
    "handler": "ux.string",
    "reason": "string_builtin"
  },
  "SQR": {
    "category": "statements",
    "jsPolicy": "native_js_math",
    "wasmPolicy": "native_wasm_or_host",
    "handler": "ux.math",
    "reason": "math_builtin"
  },
  "SQRT": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "STDCALL": {
    "category": "statements",
    "jsPolicy": "bridge_only",
    "wasmPolicy": "host_import",
    "handler": "ux.ffi",
    "reason": "ffi_builtin"
  },
  "STORE_FIELD": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "STORE_INDEXED": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "STORE_VAR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "STR": {
    "category": "statements",
    "jsPolicy": "native_js_string",
    "wasmPolicy": "host_string_import",
    "handler": "ux.string",
    "reason": "string_builtin"
  },
  "STRING": {
    "category": "statements",
    "jsPolicy": "native_js_string",
    "wasmPolicy": "host_string_import",
    "handler": "ux.string",
    "reason": "string_builtin"
  },
  "STRPTR": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "SUB": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "SUB_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "TAN": {
    "category": "statements",
    "jsPolicy": "native_js_math",
    "wasmPolicy": "native_wasm_or_host",
    "handler": "ux.math",
    "reason": "math_builtin"
  },
  "TERNARY_EXPR": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "THREAD": {
    "category": "statements",
    "jsPolicy": "async_host_runtime",
    "wasmPolicy": "host_import",
    "handler": "ux.events",
    "reason": "event_builtin"
  },
  "THREAD_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "THREAT": {
    "category": "statements",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "THROW_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "TIMER": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "TIMERNORMALIZEUNIT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "TRIGGER_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "TRY_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "TYPE_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "U64": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "UCASE": {
    "category": "statements",
    "jsPolicy": "native_js_string",
    "wasmPolicy": "host_string_import",
    "handler": "ux.string",
    "reason": "string_builtin"
  },
  "UNARY": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "US": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "USING_STMT": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "VAL": {
    "category": "statements",
    "jsPolicy": "native_js_math",
    "wasmPolicy": "native_wasm_or_host",
    "handler": "ux.math",
    "reason": "math_builtin"
  },
  "VARMAPPINGFINDINDEX": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "VARMAPPINGFORMATRBPREF": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "VARMAPPINGMAKEKEY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "VARMAPPINGTRYGETLOCALOFFSET": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "VARPTR": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "VMEMINRANGE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "VMEMPEEKB": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "VOID": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "X64": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64ALIGN16": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64BUILDFIELDPATH": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64BUILTINCALLSYMBOL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64CHILDAT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64CHILDCOUNT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64CLASSROUTINEHASBODY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64CLASSTYPEID": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64CLASSVTABLELABEL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64CODEGENASSEMBLEOUTPUT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64COLLECTDLLCALLPLAN": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64COMPACTBLANKLINES": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64COMPUTEDIMSLOTCOUNT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64COUNTROUTINEPARAMS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64CREATECSTRINGCONSTANT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64CREATEFLOATCONSTANT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64CSTRINGDBBYTES": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64DLLCALLARGSTARTPOS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64ELEMBYTESFORFLOATKIND": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITADDROFFIELDEXPR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITADDROFINDEXEDGLOBAL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITADDROFINDEXEDLOCAL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITADDROFVAR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITASSIGNSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITBLOCKSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITBUILTINCALL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITCALLNODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITCALLNODESPECIAL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITCALLNODETOXMM0": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITCALLNODETOXMM0AS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITCALLSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITCLASSDECLMETADATA": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITCLASSROUTINENODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITCLASSVTABLE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITCLOSESTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITCLSSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITCOLORSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITCOMPOUNDASSIGN": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITCONSTSTMTMETADATA": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITDECLARATIONMETADATA": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITDELETESTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITDIMSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITDLLCALLNODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITDOEACHSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITDOSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITEXITSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITEXPRSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITEXPRTORAX": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITEXPRTOXMM0": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITEXPRTOXMM0AS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITEXTFPADDROFEXPRTORAX": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITEXTFPASSIGNSTMTCORE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITEXTFPASSIGNTOPREPAREDADDRESS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITEXTFPPRINTEXPR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITEXTFPSTORELITERALTOADDRESS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITFIELDROOTADDRESS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITFLOATBINARYAS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITFOREACHSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITFORSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITFUNCTIONSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITGETSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITGOSUBSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITGOTOSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITIFSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITINCDECSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITINPUTFILESTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITINPUTSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITLABELSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITLOADFIELDEXPR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITLOADFLOATVARTOXMM0": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITLOADFLOATVARTOXMM0AS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITLOADINDEXEDGLOBAL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITLOADINDEXEDGLOBALXMM": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITLOADINDEXEDLOCAL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITLOADINDEXEDLOCALXMM": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITLOCATESTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITMEMCOPYSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITMEMFILLSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITNEWEXPR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITNEXTSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITNODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITOPENSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITPIPEINVOKE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITPOKESSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITPOKESTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITPRINTSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITPROGRAM": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITPUTSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITRANDOMIZESTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITRETURNSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITROUTINECALL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITRUNTIMEINSTANCEOFSUPPORT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITSEEKSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITSELECTSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITSETNEWOFFSETSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITSLOTLANEBODYROUTINE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITSLOTLANEROUTINES": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITSLOTLANESTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITSLOTLANESTMTCORE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITSTOREF80LITERALVAR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITSTOREFIELDEXPR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITSTOREFIELDFROMRHS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITSTOREFIELDFROMXMM0": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITSTOREINDEXEDGLOBAL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITSTOREINDEXEDGLOBALF80LITERAL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITSTOREINDEXEDGLOBALXMM": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITSTOREINDEXEDLOCAL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITSTOREINDEXEDLOCALF80LITERAL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITSTOREINDEXEDLOCALXMM": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITSTOREINTEGERFIELDEXPR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITSTOREXMM0TOFLOATVARAS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITSUBSTMT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITTYPEDECLMETADATA": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EMITUNKNOWNNODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64ENSUREGLOBALSYMBOL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64ENSURELOCALSLOT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64ENSURESYMBOL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64ENSUREVAR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EXPRRETURNSSTRING": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EXTFPSTRIDEBYTES": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EXTRACTPROPERTYTYPE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EXTRACTROUTINERETURNTYPE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64EXTRACTTYPENAMEFROMNODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64FFIARGCOUNTAT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64FIELDNODETYPENAME": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64FIELDPATHREADIDENT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64FIELDPATHSKIPINDEXES": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64FINDCHILDBYKIND": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64FINDCLASSDECLNODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64FINDCLASSMEMBERNODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64FINDCLASSMETHODDECLNODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64FINDCLASSOPERATORDECLNODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64FINDDECLAREDTYPENAME": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64FINDGLOBALSYMBOL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64FINDLOCAL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64FINDMETHODSLOTGLOBAL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64FINDOWNINGCLASSNAME": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64FINDPROPERTYACCESSORBODY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64FINDROUTINE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64FINDROUTINESYMBOLNAME": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64FINDSYMBOL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64FINDVTABLESLOT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64FLOATKINDTOEXTFPTYPENAME": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64FORMATRBPREF": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64GETCLASSBASETYPENAME": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64GETELEMBYTESFORDECLAREDTYPE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64GETELEMBYTESFORTYPE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64HASTOPLEVELGLOBALDECL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64INFERELEMBYTESFORNAME": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64INFERFLOATKINDOFEXPR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64INFERROUTINERECEIVERCLASS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64ISDLLCALLNODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64ISEXTFPKIND": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64ISFLOATKIND": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64ISSTMTKIND": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64ISSTMTLIKENODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64MAKESCOPEDKEY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64MODECODEFROMTEXT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64NEXTLABEL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64NODEHASRETURNTYPE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64NORMALIZEDATALINE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64NORMALIZETEXTLINE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64OPERATORTOKENTOROUTINESUFFIX": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64REGISTERCLASSVTABLE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64RESOLVECLASSROUTINENAME": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64RESOLVECURRENTRECEIVERCLASS": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64RESOLVEFIELDINFO": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64RESOLVEMETHODOWNERTYPE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64RESOLVEOPERATOROWNERTYPE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64RESOLVEPROPERTYACCESSORROUTINE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64SANITIZESYMBOL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64SCOPEDLABELSYMBOL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64SLOTACTIVESYMBOLNAME": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64SLOTCAPSYMBOLNAME": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64SLOTCOUNTSYMBOLNAME": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64SLOTLANEKINDFROMNODEKIND": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64SLOTNODEKINDFROMLANEKIND": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64SLOTRESOLVEDECLNODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64SLOTROUTINELABELFORNODE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64SLOTTRYCONSTHEADERID": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64SPLITMETHODCALLNAME": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64TOSTR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64TRYCONSTINTEXPR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64TRYEMITPROPERTYACCESSORLOAD": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64TRYEMITPROPERTYACCESSORSTOREFROMVALUE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64TRYEXTRACTINDEXEDTARGET": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64TRYFINDGLOBALINFO": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64TRYFINDLOCALINFO": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64TRYFINDLOCALOFFSET": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64TRYFINDSYMBOLLABEL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64TRYFINDTOPLEVELCONSTDECL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64TRYGETGLOBALELEMBYTES": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64TRYGETLOCALELEMBYTES": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64TRYGETNUMBERLITERAL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64TRYGETROUTINERETURNTYPE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64TRYGETROUTINESIGNATURE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64TRYGETVARTYPE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64TRYPARSEINTEGER": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64TRYRESOLVECALLRETURNTYPE": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64TRYRESOLVECONSTINT": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64TRYRESOLVECONSTINTEXPR": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64TYPETOFLOATKIND": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64UPPER": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X64VARTYPEKEY": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X86": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X86ISIDENTASCII": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X86REPLACEALL": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X86REPLACETOKEN": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "X86REWRITEFROMX64": {
    "category": "builtin_functions",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "XOR": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "YEAR": {
    "category": "builtin_functions",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "ARRAY": {
    "category": "statements",
    "jsPolicy": "js_runtime_structure",
    "wasmPolicy": "host_or_linear_memory",
    "handler": "ux.collections",
    "reason": "collection_builtin"
  },
  "DICT": {
    "category": "statements",
    "jsPolicy": "js_runtime_structure",
    "wasmPolicy": "host_or_linear_memory",
    "handler": "ux.collections",
    "reason": "collection_builtin"
  },
  "INTERFACE": {
    "category": "statements",
    "jsPolicy": "js_object_model",
    "wasmPolicy": "host_object_handle",
    "handler": "ux.oop",
    "reason": "oop_builtin"
  },
  "LIST": {
    "category": "statements",
    "jsPolicy": "js_runtime_structure",
    "wasmPolicy": "host_or_linear_memory",
    "handler": "ux.collections",
    "reason": "collection_builtin"
  },
  "SET": {
    "category": "statements",
    "jsPolicy": "js_runtime_structure",
    "wasmPolicy": "host_or_linear_memory",
    "handler": "ux.collections",
    "reason": "collection_builtin"
  },
  "TYPE": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "CATCH": {
    "category": "statements",
    "jsPolicy": "js_exception_model",
    "wasmPolicy": "host_or_exception_proposal",
    "handler": "ux.errors",
    "reason": "error_builtin"
  },
  "DIAGNOSTIC": {
    "category": "error_flow",
    "jsPolicy": "js_exception_model",
    "wasmPolicy": "host_or_exception_proposal",
    "handler": "ux.errors",
    "reason": "error_flow"
  },
  "ON ERROR": {
    "category": "error_flow",
    "jsPolicy": "js_exception_model",
    "wasmPolicy": "host_or_exception_proposal",
    "handler": "ux.errors",
    "reason": "error_flow"
  },
  "THROW": {
    "category": "statements",
    "jsPolicy": "js_exception_model",
    "wasmPolicy": "host_or_exception_proposal",
    "handler": "ux.errors",
    "reason": "error_builtin"
  },
  "TRY": {
    "category": "statements",
    "jsPolicy": "js_exception_model",
    "wasmPolicy": "host_or_exception_proposal",
    "handler": "ux.errors",
    "reason": "error_builtin"
  },
  "MUTEX": {
    "category": "event_thread_pipe_slot",
    "jsPolicy": "async_host_runtime",
    "wasmPolicy": "host_import",
    "handler": "ux.events",
    "reason": "async_browser_runtime"
  },
  "SLOT": {
    "category": "statements",
    "jsPolicy": "async_host_runtime",
    "wasmPolicy": "host_import",
    "handler": "ux.events",
    "reason": "event_builtin"
  },
  "CALL API": {
    "category": "ffi_forms",
    "jsPolicy": "bridge_only",
    "wasmPolicy": "host_import",
    "handler": "ux.ffi",
    "reason": "browser_cannot_direct_call_dll"
  },
  "CALL DLL": {
    "category": "ffi_forms",
    "jsPolicy": "bridge_only",
    "wasmPolicy": "host_import",
    "handler": "ux.ffi",
    "reason": "browser_cannot_direct_call_dll"
  },
  "GET": {
    "category": "statements",
    "jsPolicy": "browser_file_host",
    "wasmPolicy": "host_import",
    "handler": "ux.file",
    "reason": "file_builtin"
  },
  "INPUT #": {
    "category": "file_io",
    "jsPolicy": "browser_file_host",
    "wasmPolicy": "host_import",
    "handler": "ux.file",
    "reason": "browser_sandbox_file_api"
  },
  "OPEN": {
    "category": "statements",
    "jsPolicy": "browser_file_host",
    "wasmPolicy": "host_import",
    "handler": "ux.file",
    "reason": "file_builtin"
  },
  "PRINT #": {
    "category": "file_io",
    "jsPolicy": "browser_file_host",
    "wasmPolicy": "host_import",
    "handler": "ux.file",
    "reason": "browser_sandbox_file_api"
  },
  "PUT": {
    "category": "statements",
    "jsPolicy": "browser_file_host",
    "wasmPolicy": "host_import",
    "handler": "ux.file",
    "reason": "file_builtin"
  },
  "ASM": {
    "category": "inline_forms",
    "jsPolicy": "diagnostic_non_browser",
    "wasmPolicy": "diagnostic_non_browser",
    "handler": "ux.diag",
    "reason": "inline_native_not_browser_safe"
  },
  "END ASM": {
    "category": "inline_forms",
    "jsPolicy": "diagnostic_non_browser",
    "wasmPolicy": "diagnostic_non_browser",
    "handler": "ux.diag",
    "reason": "inline_native_not_browser_safe"
  },
  "INLINE": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "ALLOC": {
    "category": "memory_operations",
    "jsPolicy": "js_memory_model",
    "wasmPolicy": "linear_memory",
    "handler": "ux.memory",
    "reason": "memory"
  },
  "FREE": {
    "category": "memory_operations",
    "jsPolicy": "js_memory_model",
    "wasmPolicy": "linear_memory",
    "handler": "ux.memory",
    "reason": "memory"
  },
  "MEMCPY": {
    "category": "memory_operations",
    "jsPolicy": "js_memory_model",
    "wasmPolicy": "linear_memory",
    "handler": "ux.memory",
    "reason": "memory"
  },
  "PEEK": {
    "category": "memory_operations",
    "jsPolicy": "js_memory_model",
    "wasmPolicy": "linear_memory",
    "handler": "ux.memory",
    "reason": "memory"
  },
  "POKE": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "DELETE": {
    "category": "statements",
    "jsPolicy": "js_object_model",
    "wasmPolicy": "host_object_handle",
    "handler": "ux.oop",
    "reason": "oop_builtin"
  },
  "MIXIN": {
    "category": "statements",
    "jsPolicy": "js_object_model",
    "wasmPolicy": "host_object_handle",
    "handler": "ux.oop",
    "reason": "oop_builtin"
  },
  "OPERATOR": {
    "category": "statements",
    "jsPolicy": "js_object_model",
    "wasmPolicy": "host_object_handle",
    "handler": "ux.oop",
    "reason": "oop_builtin"
  },
  "PROPERTY": {
    "category": "statements",
    "jsPolicy": "js_object_model",
    "wasmPolicy": "host_object_handle",
    "handler": "ux.oop",
    "reason": "oop_builtin"
  },
  "SUPER": {
    "category": "oop_features",
    "jsPolicy": "js_object_model",
    "wasmPolicy": "host_object_handle",
    "handler": "ux.oop",
    "reason": "oop"
  },
  "THIS": {
    "category": "oop_features",
    "jsPolicy": "js_object_model",
    "wasmPolicy": "host_object_handle",
    "handler": "ux.oop",
    "reason": "oop"
  },
  "*": {
    "category": "operators",
    "jsPolicy": "native_js_expr",
    "wasmPolicy": "native_wasm_expr",
    "handler": "expr",
    "reason": "operator_compute"
  },
  "+": {
    "category": "operators",
    "jsPolicy": "native_js_expr",
    "wasmPolicy": "native_wasm_expr",
    "handler": "expr",
    "reason": "operator_compute"
  },
  "-": {
    "category": "operators",
    "jsPolicy": "native_js_expr",
    "wasmPolicy": "native_wasm_expr",
    "handler": "expr",
    "reason": "operator_compute"
  },
  "/": {
    "category": "operators",
    "jsPolicy": "native_js_expr",
    "wasmPolicy": "native_wasm_expr",
    "handler": "expr",
    "reason": "operator_compute"
  },
  "<": {
    "category": "operators",
    "jsPolicy": "native_js_expr",
    "wasmPolicy": "native_wasm_expr",
    "handler": "expr",
    "reason": "operator_compute"
  },
  "<=": {
    "category": "operators",
    "jsPolicy": "native_js_expr",
    "wasmPolicy": "native_wasm_expr",
    "handler": "expr",
    "reason": "operator_compute"
  },
  "<>": {
    "category": "operators",
    "jsPolicy": "native_js_expr",
    "wasmPolicy": "native_wasm_expr",
    "handler": "expr",
    "reason": "operator_compute"
  },
  "=": {
    "category": "operators",
    "jsPolicy": "native_js_expr",
    "wasmPolicy": "native_wasm_expr",
    "handler": "expr",
    "reason": "operator_compute"
  },
  ">": {
    "category": "operators",
    "jsPolicy": "native_js_expr",
    "wasmPolicy": "native_wasm_expr",
    "handler": "expr",
    "reason": "operator_compute"
  },
  ">=": {
    "category": "operators",
    "jsPolicy": "native_js_expr",
    "wasmPolicy": "native_wasm_expr",
    "handler": "expr",
    "reason": "operator_compute"
  },
  "BOOLEAN": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "U16": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "U32": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "U8": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "ALIAS": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "CASE": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "CONSTRUCTOR": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "DESTRUCTOR": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "DO": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "EACH": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "ELSE": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "ELSEIF": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "EXIT": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "FINALLY": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "FRIEND": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "GOSUB": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "GOTO": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "IMMUTABLE": {
    "category": "statements",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "IMPLEMENTS": {
    "category": "statements",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "IN": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "INC": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "INCLUDE": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "IS": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "KEYWORD": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "LOOP": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "MAGIC": {
    "category": "statements",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "MAIN": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "MEMCOPYB": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "MEMCOPYD": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "MEMCOPYW": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "MEMFILLB": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "MEMFILLD": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "MEMFILLW": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "METHOD": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "MODULE": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "NAMESPACE": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "NEXT": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "OBJECT": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "OP": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "OVERRIDE": {
    "category": "statements",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "PARALLEL": {
    "category": "statements",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "POKEB": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "POKED": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "POKES": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "PROTECTED": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "READONLY": {
    "category": "statements",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "RESTRICTED": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "SEALED": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "SEEK": {
    "category": "statements",
    "jsPolicy": "browser_file_host",
    "wasmPolicy": "host_import",
    "handler": "ux.file",
    "reason": "file_builtin"
  },
  "SELECT": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "SETNEWOFFSET": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "SETSTRINGSIZE": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "SIHIRLIMETOT": {
    "category": "statements",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "STATIC": {
    "category": "statements",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "STEP": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "THEN": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "TO": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "TRIGGER": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "UNTIL": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "USING": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  },
  "VIRTUAL": {
    "category": "statements",
    "jsPolicy": "diagnostic_surface_entry",
    "wasmPolicy": "diagnostic_surface_entry",
    "handler": "ux.diag",
    "reason": "matrix_missing_or_doc_entry"
  },
  "WHILE": {
    "category": "statements",
    "jsPolicy": "host_runtime_dispatch",
    "wasmPolicy": "host_import_if_called",
    "handler": "ux.callBuiltin",
    "reason": "generic_implemented_surface"
  }
};
