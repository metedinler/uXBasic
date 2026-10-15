# uXBasic Native Runtime Yama 6 Teknik Raporu

## Sonuç

Güncel kaynak ağacındaki lexer/parser/MIR task yüzeyi, mevcut 256 girişli `ExecState.slotTable` ile gerçek native runtime C ABI'ye bağlandı. Önceki stub bridge kaldırıldı; function pointer çağrıları, callback bağlama, DLL yaşam döngüsü ve senkron fallback uygulandı.

## Önemli tasarım kararları

1. Yeni ve bağımsız bir `TaskTable` oluşturulmadı. Var olan AST runtime tablosu tek kaynak olarak korundu.
2. Public slot parametreleri `Integer` kullanır; 0..255 kontrolü çağrı sınırında yapılır.
3. Task tür kodları kaynak gerçekliğiyle uyumludur: EVENT=1, PIPE=2, THREAD=3, PARALEL=4.
4. Native yürütme gövdeyi kaybetmez. DLL callback çalıştıramazsa mevcut AST/MIR senkron gövdesi yürütülür.
5. THREAD/PARALEL ilk sürümde deterministik `join/wait` semantiğine sahiptir; detached ve sonucu kaybolan iş üretilmez.
6. libuv ve oneTBB dil yüzeyi değil, aynı `uxb_runtime.dll` ABI'sinin backendleridir.

## Native backendler

- std: zorunlu ve bağımlılıksız fallback.
- libuv: `uv_queue_work` ve loop yürütmesi.
- oneTBB: `oneapi::tbb::task_group`; thread üst sınırı `UXB_TBB_THREADS`.
- auto: derlenmiş backendlerden ortam değişkenine ve kullanılabilirliğe göre seçim.

## SHELL

Windows native uygulaması `CreateProcessA`, anonim pipe, stdout/stderr reader threadleri, timeout ve `TerminateProcess` kullanır. Parser/MIR/AST seçenekleri korunur. Browser/JS/WASM politikası bu yamada değiştirilmemiştir; native olmayan hedefler fail-closed kalmalıdır.

## Testler

Statik ve yerel doğrulamalar:

- Kaynak kapısı: 227/227 PASS
- Wrapper–C ABI: 542 çağrı, 0 hata, max arite 8
- Klasör doktoru: 89/89 PASS
- Python syntax: PASS
- C++ std runtime: `-Wall -Wextra -Werror` PASS
- Native callback smoke: PIPE 21 -> 42 PASS

Windows'ta çalıştırılacak yeni testler:

- `check_yama6_runtime_dll.py`: export, init/shutdown, callback, slot 255/256, OFF, PIPE ve SHELL capture.
- `run_yama6_interpreter_tests.py`: `run` ve `int` fiilleriyle EVENT, PIPE, THREAD, PARALEL, OFF ve SHELL.

## Dürüst sınırlamalar

- Windows FreeBASIC compiler build'i bu Linux ortamında çalıştırılmadı.
- MIR task gövdesi deterministik label yürütmesini korur; MIR callback'i native worker thread içine taşınmamıştır.
- THREAD/PARALEL native callback'i AST tarafında gerçek backend thread/task üzerinde çalışır, fakat çağrı sonucu beklenir.
- libuv/oneTBB varyantlarının Windows link ve runtime sonucu kullanıcı sisteminde test edilmelidir.
