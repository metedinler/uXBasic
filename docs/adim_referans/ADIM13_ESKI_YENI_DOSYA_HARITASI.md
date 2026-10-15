# Adım 13 Eski Kod / Yeni Kod Haritası

## Typed açıklaması

`typed` kelimesi “tip bilgili” demektir. Eski kodda backend çoğu local değişkeni sadece isim olarak görüyordu:

```freebasic
fn.localVars(i) = "A"
```

Bu backend için eksiktir. Yeni Adım 11 modelinde değişkenin tipi de tutulur:

```freebasic
fn.localInfo(i).name = "A"
fn.localInfo(i).typeName = "I32"
fn.localInfo(i).typeInfo.sizeBytes = 4
```

Adım 13 x64 backend bu bilgiyi kullanır. `F64` için XMM, `I32/I64` için integer register/slot, `STRING/PTR` için pointer/handle route seçilir.

## Değişim tablosu

| Dosya | Eski durum | Yeni yapılacak |
|---|---|---|
| `src/backend/common/backend_target.fbs` | x86 target bilinmiyor | `UXB_TARGET_X86` ekle |
| `src/backend/backend_step6.fbs` | x64/js/wasm dispatch var, x86 yok | x86 include + `Case UXB_TARGET_X86` ekle |
| `src/backend/backend_cli_args.fbs` | yok | yeni dosya, dağınık CLI booleanlarını backend modeline toplar |
| `src/backend/backend_context_builder.fbs` | yok | `UXBBackendCliArgs` → `UXBBackendContext` çevirir |
| `src/backend/backend_pipeline_gate.fbs` | yok | MIR gate + target gate + ABI/registry gate çalıştırır |
| `src/backend/backend_pipeline.fbs` | yok | tek native backend giriş kapısıdır |
| `src/backend/backend_native_report_writer.fbs` | yok | adim8 CSV/JSON raporlarını yazar |
| `src/codegen/x64/mir_x64_context.fbs` | slotta `sizeBytes/typeName` zaten var | değiştirme; yeni helper bu alanları doldurur |
| `src/codegen/x64/mir_x64_codegen.fbs` | `MIRX64EnsureLocalSlot` I64 fallback kullanıyor | include ekle, param/local slotlarda `MIRX64EnsureTypedLocalSlot` kullan |
| `src/codegen/x64/mir_x64_typed_locals.fbs` | yok | yeni typed local/param slot helperları |
| `src/codegen/x64/mir_x64_abi_gate.fbs` | yok | Win64 ABI ön kontrolü |
| `src/codegen/x64/mir_x64_emit_registry_adim13.fbs` | yok | opcode emitter karar gate’i |
| `src/codegen/x86/code_generator.fbs` | AST/x64 rewrite tabanlı eski yol | korunur, silinmez |
| `src/codegen/x86/x86_backend_step6.fbs` | yok | MIRModule tabanlı step6 x86 route |
| `src/codegen/x86/x86_emit_registry.fbs` | yok | x86 implemented/unsupported karar tablosu |
| `src/main_program_entry*.fbs` | doğrudan x64 emit çağrıları var | MIR hazırlandıktan sonra `UXBBackendRunPipeline` çağrısı ekle |

## Ezme / merge kararı

Yeni dosyalar kopyalanır. Mevcut dosyalar komple ezilmez. Snippet dosyalarındaki değişiklikler merge edilir.
