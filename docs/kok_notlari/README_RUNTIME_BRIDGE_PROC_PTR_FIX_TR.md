# UXB Runtime Bridge procPtr Fix

Bu küçük yama yalnız `src/runtime/native/uxb_runtime_bridge.fbs` dosyasındaki FreeBASIC sözdizimi kırığını düzeltir.

## Kök sebep

FreeBASIC içinde `ProcPtr` yerleşik bir ifadedir. `UXBRuntimeTriggerByPtr` fonksiyonunda parametre adı `procPtr` seçildiği için derleyici bu ismi normal değişken gibi okumadı ve fonksiyon tanımı bozuldu. İlk hata:

```text
error 59: Illegal specification, at parameter 1 (procPtr) of UXBRuntimeTriggerByPtr()
```

Bu bozulma yüzünden takip eden `uxb_task_trigger`, `uxb_thread_start`, `uxb_pipe_run`, `uxb_parallel_run`, `uxb_shell_run` ve `uxb_runtime_integration.fbs` fonksiyonları da sanki başka fonksiyonun içindeymiş gibi `Illegal inside functions` hatası verdi.

## Düzeltme

`procPtr` parametre adı `nativeProc` yapıldı. Ayrıca aynı satırdaki `Or` koşulu iki ayrı güvenli kontrole bölündü ve function pointer cast satırı açık atama biçimine çevrildi.

Değiştirilen tek kaynak dosyası:

```text
src/runtime/native/uxb_runtime_bridge.fbs
```

## Uygulama

ZIP içeriğini doğrudan mevcut `uxb` kök klasörüne aç ve üzerine yazmaya izin ver.
