# uxb Overlay Module Manifest

wrapper,hook,primary_targets
uxb_ast_bundle_wrapper.fbs,uxb_ast_hook.fbs,uxb/src/parser/*
uxb_hir_bundle_wrapper.fbs,uxb_hir_hook.fbs,uxb/src/semantic/hir.fbs
uxb_mir_bundle_wrapper.fbs,uxb_mir_hook.fbs,uxb/src/semantic/mir.fbs
uxb_runtime_bundle_wrapper.fbs,uxb_runtime_hook.fbs,uxb/src/runtime/*
uxb_codegen_bundle_wrapper.fbs,uxb_codegen_hook.fbs,uxb/src/codegen/*
uxb_frontend_bundle_wrapper.fbs,uxb_global_noop_hook.fbs,uxb/src/build/interop_manifest.fbs
uxb_main_wrapper.bas,uxb_global_noop_hook.fbs,uxb/src/main.bas
