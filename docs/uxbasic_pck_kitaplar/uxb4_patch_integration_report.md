# uxb(4).zip patch integration audit

Bu rapor, gönderilen paketlerdeki dosyaların `uxb(4).zip` kaynak ağacına işlenip işlenmediğini statik dosya-yolu ve SHA-256 içerik karşılaştırmasıyla kontrol eder.

## Özet

| package          |   normalized_files |   present_in_uxb4 |   identical |   different |   missing | integration_status   |
|:-----------------|-------------------:|------------------:|------------:|------------:|----------:|:---------------------|
| wasm_master      |                 79 |                57 |          45 |          12 |        22 | partial              |
| extlibs_p1       |                 23 |                 0 |           0 |           0 |        23 | not_integrated       |
| extlibs_p2p4     |                 64 |                 0 |           0 |           0 |        64 | not_integrated       |
| target_patch     |                 30 |                 0 |           0 |           0 |        30 | not_integrated       |
| target_completed |                 32 |                 0 |           0 |           0 |        32 | not_integrated       |
| matrix_complete  |                 76 |                 0 |           0 |           0 |        76 | not_integrated       |
| webgpu_pro       |                 94 |                 0 |           0 |           0 |        94 | not_integrated       |

## Kritik sonuç

- `UXB_EXTLIBS_P1...` ve `UXB_EXTLIBS_P2_P4...` paketleri `extlibs/...` yolu olarak **kaynağa işlenmemiş** görünüyor.

- Dört browser/JS/WASM patch paketi (`TARGET_PATCH`, `TARGET_PATCH_COMPLETED`, `MATRIX_COMPLETE`, `WEBGPU_PRO`) **kaynağa işlenmemiş** görünüyor.

- `UxBasiC_Wasm-master` paketi **kısmen** işlenmiş: 79 normalleştirilmiş dosyadan 57'si kaynakta var, 45'i birebir aynı, 12'si farklı sürüm, 22'si eksik.

- `uxb(4).zip` içinde yalnız eski/ayrı bir JSON tabanlı JS/WASM köprüsü var: `tools/uxb_js_transpiler_wasm_backend.py`, `compiler/scripts/run_emit_js_transpiler.bat`, `compiler/scripts/run_emit_wasm_backend.bat`.

- `uxb(4).zip` içinde `src/codegen/js/`, `src/codegen/wasm/`, `runtime/browser/`, `tests/browser/`, `tests/wasm/`, `extlibs/` dizinleri yok.


## Kaynakta mevcut JS/WASM izleri

- `tools/uxb_js_transpiler_wasm_backend.py`
- `docs/UXAIMATH_EXTERNAL_DEPENDENCIES.json`
- `docs/UXB_MIMARI_NOTU_BACKENDS_CLI_JSON_I18N.md`
- `docs/UXDATAFRAME_EXTERNAL_DEPENDENCIES.json`
- `docs/UXDATASET_EXTERNAL_DEPENDENCIES.json`
- `docs/UXLLAMA_EXTERNAL_DEPENDENCIES.json`
- `docs/UXNN3_EXTERNAL_DEPENDENCIES.json`
- `docs/UXNN_EXTERNAL_DEPENDENCIES.json`
- `docs/UXONNX2_EXTERNAL_DEPENDENCIES.json`
- `docs/UXONNX_EXTERNAL_DEPENDENCIES.json`
- `docs/UXTENSOR_EXTERNAL_DEPENDENCIES.json`
- `docs/WASM_PUBLISH_RELEASE_NOTLARI.md`
- `libs/uxb_library_registry.json`
- `vscode-extension/language-configuration.json`
- `vscode-extension/package-lock.json`
- `vscode-extension/package.json`
- `vscode-extension/src/extension.js`
- `vscode-extension/src/uxbCommandContract.js`
- `vscode-extension/src/uxbCommandRunner.js`
- `vscode-extension/src/uxbDashboardProvider.js`
- `vscode-extension/syntaxes/uxbasic.tmLanguage.json`
- `src/semantic/mir_exporter_json.fbs`
- `src/semantic/mir_full_exporter_json.fbs`
- `src/semantic/mir_module_exporter_json.fbs`
- `ide/uxb_ide_command_contract.json`
- `compiler/scripts/create_wasm_publish_release.bat`
- `compiler/scripts/run_emit_js_transpiler.bat`
- `compiler/scripts/run_emit_wasm_backend.bat`
- `compiler/scripts/run_layer_json.ps1`
- `i18n/en.json`
- `i18n/tr.json`

## Paket bazlı eksiklerden örnekler


### extlibs_p1

- identical: 0, different: 0, missing: 23

Eksik örnekler:
- `compiler/scripts/extlibs_p1_build_all.bat`
- `compiler/scripts/extlibs_p1_smoke.bat`
- `docs/EXTLIBS_P1_LLAMA_HTTP_REGEX_OS_STRINGX.md`
- `extlibs/http/build_http_winhttp_mingw.bat`
- `extlibs/http/uxb_http.bas`
- `extlibs/http/uxb_http.bi`
- `extlibs/http/uxb_http_winhttp.cpp`
- `extlibs/json/uxb_json_lite.bas`
- `extlibs/llama/README.md`
- `extlibs/llama/uxb_llama.bas`
- `extlibs/lua/UXB_LUA_BRIDGE_PLAN.md`
- `extlibs/os/uxb_os.bas`
- `extlibs/prolog/UXB_PROLOG_BRIDGE_PLAN.md`
- `extlibs/regex/build_regex_pcre2_mingw.bat`
- `extlibs/regex/uxb_regex.bas`

### extlibs_p2p4

- identical: 0, different: 0, missing: 64

Eksik örnekler:
- `compiler/scripts/extlibs_check_from_catalog.bat`
- `compiler/scripts/extlibs_install_from_catalog.bat`
- `compiler/scripts/extlibs_p2_p4_build_all.bat`
- `docs/EXTLIBS_P2_P4_PLAN.md`
- `docs/external_dependency_catalog.csv`
- `extlibs/README_EXTLIBS_P2_P4.md`
- `extlibs/archive/build_archive_bridge_vcpkg.bat`
- `extlibs/archive/uxb_zlib.bas`
- `extlibs/archive/uxb_zlib.bi`
- `extlibs/archive/uxb_zlib_bridge.c`
- `extlibs/audio/build_audio_bridge_vcpkg.bat`
- `extlibs/audio/uxb_audio.bas`
- `extlibs/audio/uxb_audio.bi`
- `extlibs/audio/uxb_audio_bridge.c`
- `extlibs/crypto/build_crypto_bridge_vcpkg.bat`

### target_patch

- identical: 0, different: 0, missing: 30

Eksik örnekler:
- `compiler/scripts/run_browser_hybrid_smoke.bat`
- `compiler/scripts/run_browser_js_smoke.bat`
- `compiler/scripts/run_wasm_smoke.bat`
- `docs/APPLY_BROWSER_TARGET_PATCH.md`
- `docs/BROWSER_TARGET_MASTER_PLAN.md`
- `runtime/browser/index.html`
- `runtime/browser/ux_ai_bridge.js`
- `runtime/browser/ux_audio.js`
- `runtime/browser/ux_canvas2d.js`
- `runtime/browser/ux_input.js`
- `runtime/browser/ux_loader.js`
- `runtime/browser/ux_runtime.js`
- `runtime/browser/ux_wasm_bridge.js`
- `src/codegen/js/js_emitter.fbs`
- `src/codegen/js/js_expr_emit.fbs`

### target_completed

- identical: 0, different: 0, missing: 32

Eksik örnekler:
- `compiler/scripts/run_browser_hybrid_smoke.bat`
- `compiler/scripts/run_browser_js_smoke.bat`
- `compiler/scripts/run_wasm_smoke.bat`
- `docs/APPLY_BROWSER_TARGET_PATCH.md`
- `docs/BROWSER_TARGET_COMPLETION_NOTES.md`
- `docs/BROWSER_TARGET_MASTER_PLAN.md`
- `runtime/browser/index.html`
- `runtime/browser/ux_ai_bridge.js`
- `runtime/browser/ux_audio.js`
- `runtime/browser/ux_canvas2d.js`
- `runtime/browser/ux_input.js`
- `runtime/browser/ux_loader.js`
- `runtime/browser/ux_runtime.js`
- `runtime/browser/ux_wasm_bridge.js`
- `src/codegen/js/js_emitter.fbs`

### matrix_complete

- identical: 0, different: 0, missing: 76

Eksik örnekler:
- `compiler/scripts/run_browser_from_source.bat`
- `compiler/scripts/run_browser_hybrid_smoke.bat`
- `compiler/scripts/run_browser_js_smoke.bat`
- `compiler/scripts/run_browser_json_build.bat`
- `compiler/scripts/run_browser_surface_contract.bat`
- `compiler/scripts/run_wasm_smoke.bat`
- `dist/browser/browser_target_gap_matrix.csv`
- `dist/browser/browser_target_gap_summary.json`
- `dist/browser/build_sample/browser_build_report.json`
- `dist/browser/build_sample/game.js`
- `dist/browser/build_sample/index.html`
- `dist/browser/build_sample/program.wat`
- `dist/browser/build_sample/sample_add.mir.json`
- `dist/browser/build_sample/ux_ai_bridge.js`
- `dist/browser/build_sample/ux_audio.js`

### webgpu_pro

- identical: 0, different: 0, missing: 94

Eksik örnekler:
- `compiler/scripts/run_browser_from_source.bat`
- `compiler/scripts/run_browser_hybrid_pro_smoke.bat`
- `compiler/scripts/run_browser_hybrid_smoke.bat`
- `compiler/scripts/run_browser_js_smoke.bat`
- `compiler/scripts/run_browser_json_build.bat`
- `compiler/scripts/run_browser_surface_contract.bat`
- `compiler/scripts/run_browser_toolchain_install.bat`
- `compiler/scripts/run_localhost_bridge.bat`
- `compiler/scripts/run_wasm_smoke.bat`
- `compiler/scripts/run_webgpu_smoke.bat`
- `dist/browser/browser_target_gap_matrix.csv`
- `dist/browser/browser_target_gap_summary.json`
- `dist/browser/build_sample/browser_build_report.json`
- `dist/browser/build_sample/game.js`
- `dist/browser/build_sample/index.html`

### wasm_master

- identical: 45, different: 12, missing: 22

Eksik örnekler:
- `dist/adim2/cli_pipeline_gate.csv`
- `dist/adim2/cli_pipeline_gate.json`
- `dist/adim2/cli_pipeline_gate.md`
- `dist/adim2/differential_gate.csv`
- `dist/adim2/differential_gate.json`
- `dist/adim2/differential_gate.md`
- `dist/adim2/extfp_runtime_gate.json`
- `dist/adim2/extfp_runtime_gate.md`
- `dist/adim2/toolchain_doctor.json`
- `dist/adim2/toolchain_doctor.md`
- `dist/step2/cli_pipeline_audit.json`
- `dist/step2/cli_pipeline_audit.md`
- `dist/step2/copilot_step4_mir_lowering_targets.md`
- `dist/step2/mir_opcode_contract_report.json`
- `dist/step2/mir_opcode_contract_report.md`
Farklı sürüm örnekleri:
- `compiler/scripts/create_wasm_publish_release.bat`
- `compiler/scripts/run_adim2_differential_gate.bat`
- `compiler/scripts/run_adim2_toolchain_gate.bat`
- `compiler/scripts/run_step3_project_runner.bat`
- `docs/ADIM2_TOOLCHAIN_CLI_DIFF_GATE.md`
- `docs/WASM_PUBLISH_RELEASE_NOTLARI.md`
- `src/semantic/mir_lower_expr.fbs`
- `src/semantic/mir_lower_stmt_core_split.fbs`
- `tools/uxb_cli_pipeline_gate.py`
- `tools/uxb_differential_project_runner.py`
- `tools/uxb_differential_runner.py`
- `tools/uxb_toolchain_doctor.py`

## Teknik hüküm

Bu kaynak dosyada library paketleri ve browser JS/WASM patch ailesi entegre görünmüyor. Mevcut kaynakta AI/dış kütüphane tarafında `runtime_ext/*` C/DLL kaynakları var; ancak yeni gönderilen `extlibs/...` BASIC wrapper/katalog paketleri yok. JS/WASM tarafında ise gerçek `src/codegen/js` ve `src/codegen/wasm` backend dosyaları yok; yalnız JSON bundle / C bridge proof-of-concept aracı var.
