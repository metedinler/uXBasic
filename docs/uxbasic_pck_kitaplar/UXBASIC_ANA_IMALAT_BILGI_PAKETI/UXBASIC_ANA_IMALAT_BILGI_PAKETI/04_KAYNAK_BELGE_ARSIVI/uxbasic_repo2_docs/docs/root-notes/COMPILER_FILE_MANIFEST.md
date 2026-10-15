# uXBasic Compiler File Manifest

Bu dosya, mimari analiz raporundaki modulerlestirme sirasini repo ustunden kanonik hale getirir.

## 1. Kanonik Dogal Sira

Raporun `4.x`, `5.x` ve `9.x` bolumlerine gore dogal sira:

1. `layout` ve runtime global-state daginikligini temizle
2. `memory_exec` dosyasini gorev bazli parcalara ayir
3. `mir.fbs` dosyasini model/lowering/evaluator/exporter ekseninde ayir
4. `code_generator.fbs` dosyasini expr/stmt/ffi/runtime/driver ekseninde ayir
5. Native x64 coverage sprinti ile parser/semantic/runtime/codegen parity aciklarini kapat

## 2. Uygulanan Durum

### `src/semantic/layout.fbs`

- Durum: `SPLIT`
- Not:
  - shared core ve path common dosyalarina ayrildi
  - root dosya artik aggregator gibi davraniyor

### `src/runtime/memory_exec.fbs`

- Durum: `SPLIT-IN-PROGRESS`
- Yapilanlar:
  - type/runtime state bloklari [exec_types.fbs](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/src/runtime/exec/exec_types.fbs)
  - state/value init yardimcilari [exec_state_value_utils.fbs](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/src/runtime/exec/exec_state_value_utils.fbs)
  - genel eval helperlari [exec_eval_support_helpers.fbs](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/src/runtime/exec/exec_eval_support_helpers.fbs)
  - FFI policy/resolver/invoke bloğu [exec_ffi_runtime.fbs](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/src/runtime/exec/exec_ffi_runtime.fbs)
  - slot yonetimi [exec_slot_manager.fbs](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/src/runtime/exec/exec_slot_manager.fbs)
- Sonraki bolumler:
  - `exec_expr_core`
  - `exec_stmt_core`
  - `exec_call_engine`
  - `exec_debug_host`

### `src/semantic/mir.fbs`

- Durum: `SPLIT-IN-PROGRESS`
- Yapilanlar:
  - model/opcode/declaration bloğu [mir_model.fbs](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/src/semantic/mir_model.fbs) dosyasina ayrildi
  - evaluator/value-engine bloğu [mir_evaluator.fbs](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/src/semantic/mir_evaluator.fbs) dosyasina ayrildi
  - pipeline exporter bloğu [mir_exporter_json.fbs](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/src/semantic/mir_exporter_json.fbs) dosyasina ayrildi
- Sonraki bolumler:
  - `mir_lowering_expr`
  - `mir_lowering_stmt`
  - opcode exporter yuzeyini de `mir_exporter_json` altinda toplamak

## 3. Hedef Parcalama Sinirlari

### `src/runtime/memory_exec.fbs`

- Hedef moduller:
  - `exec_context`
  - `exec_expr`
  - `exec_stmt`
  - `exec_calls`
  - `exec_objects`
  - `exec_arrays`
  - `exec_ffi`
  - `exec_debug`
- Satir hedefi:
  - ideal: `<= 900`
  - mutlak sinir: `<= 1000`

### `src/semantic/mir.fbs`

- Hedef moduller:
  - `mir_model`
  - `mir_builder`
  - `mir_lowering_expr`
  - `mir_lowering_stmt`
  - `mir_optimizer`
  - `mir_evaluator`
  - `mir_exporter_json`
  - `mir_helper_controlflow`

### `src/codegen/x64/code_generator.fbs`

- Hedef moduller:
  - `cg_context`
  - `cg_symbols`
  - `cg_emit_expr`
  - `cg_emit_stmt`
  - `cg_emit_calls`
  - `cg_emit_ffi`
  - `cg_emit_runtime`
  - `cg_emit_data`
  - `cg_emit_driver`
- Durum:
  - ilk split olarak [cg_context.fbs](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/src/codegen/x64/cg_context.fbs) ayrildi
  - emit-only lane artik tekrar stabil; sonraki split daha kucuk sinirla yapilacak

## 4. Coverage Sprint Baglantisi

Parcalama kendi basina hedef degil. Her parcalama adimi asagidaki coverage aciklarina baglanmali:

- `SELECT CASE`
- `DO/FOR`
- file I/O
- arrays
- `TYPE/CLASS`
- `CALL(API, ...)`
- slot ailesi: `EVENT/THREAD/PARALEL/PIPE`

## 5. Su Anki Sonraki Dogal Adim

1. `memory_exec` icinde expr/stmt/call bloklarini ayirmaya devam et
2. `mir.fbs` icinde lowering/exporter bolumlerini ayirmaya devam et
3. `code_generator.fbs` icinde bir sonraki guvenli split sinirini sec
4. `code_generator.fbs` icinde expr/stmt fallback diyagnostiklerini ayri yuzeye tasimayi dene
5. x64 coverage testlerini her splitten sonra tekrar kos
