# PEEK/POKE, MEMCOPY/MEMFILL ve VIRTUAL sistemi incelemesi

Tarih: 2026-09-14

## Doğrulama fixture'ı

`tests/coordination_20260914_virtual_memory_matrix.uxb` şu yolları birlikte deniyor:

- `VIRTUAL 64K, 2M`
- RAM başlangıcı ve RAM/disk sınırı çevresinde `POKED`/`PEEKD`
- `MEMFILLB`
- overlap-safe `MEMCOPYB`
- disk uzantısındaki `1 MiB` adresi

AST sonucu başarılıdır ve son disk uzantısı değeri `314159` okunur. Canonical-MIR aynı kaynakta `memory store failed` ile durur; bunun nedeni `VIRTUAL_STMT` için canonical MIR lowering/interpreter adımının bulunmaması ve MIR runtime'ın varsayılan sabit 1 MiB alanı kullanmasıdır. Native x64 derlemesi başarılıdır fakat aynı son erişimde `0` üretip exit 0 verir; bu, out-of-range VIRTUAL erişiminin native helper'da hata olarak propagasyon yapılmadığını gösterir.

## Mevcut mimari

Kodda aynı kavram için dört ayrı bellek yolu bulunuyor:

1. **AST VIRTUAL yolu:** `src/runtime/memory_vm.fbs` içindeki `VMemState`; RAM `data()` + isteğe bağlı Windows memory-mapped disk uzantısı. `VMemByteAt` tek adres çözüm noktasıdır. `VIRTUAL` deyimi ve `--virtual=<ram>[,<disk>]` burada çalışır.
2. **Canonical-MIR runtime yolu:** `src/runtime/memory/runtime_memory.fbs`; `gUXBRuntimeVirtualMemory(0 To 1048575)` sabit 1 MiB dizidir. `VMemState` veya disk mapping ile bağlı değildir.
3. **MIR-x64 yolu:** `src/codegen/x64/mir_x64_context.fbs`; her üretilen program için `.bss` içinde `__uxb_mem_space: times 1048576 db 0` ve sabit 1 MiB sınırı vardır. `VIRTUAL` mode burada yalnız bu alanı seçer.
4. **Eski sparse runtime yolu:** `gUXBRuntimeMemoryCells()`; bazı düşük arity runtime çağrıları hâlâ adres/değer hücrelerini ayrı tabloda tutar.

Bu, tek bir `MemoryRef/MemoryRegion` sözleşmesi yerine birbirinden habersiz depolama ve adres çözümleyicileri olduğu anlamına gelir.

## Bulgular

### Kritik — canonical-MIR `VIRTUAL_STMT` kayboluyor

Parser `VIRTUAL_STMT` üretir (`src/parser/parser/parser_stmt_basic.fbs:412-452`) ve AST yürütücüsü bunu `VMemInit` ile uygular (`src/runtime/exec/exec_stmt_memory_core.fbs:865,917-944`). Ancak `src/semantic/mir_lower_stmt.fbs` ve `mir_lower_stmt_core_split.fbs` içinde `Case "VIRTUAL_STMT"` yoktur. Canonical MIR JSON'da da `VIRTUAL` için bir MIR instruction oluşmaz. Sonuç: `VIRTUAL 64K, 2M` canonical-MIR'de etkisizdir; runtime varsayılan 1 MiB alanı kullanır.

### Kritik — canonical-MIR runtime disk uzantısını hiç görmüyor

`src/runtime/memory/runtime_memory.fbs:14-15,27-28,78-101` yalnızca sabit `gUXBRuntimeVirtualMemory` ve `UXB_RUNTIME_VMEM_SIZE=1048576` kullanır. `src/runtime/memory_vm.fbs` içindeki `diskBasePtr`/`diskBytes` bu path'e bağlanmamıştır. Bu yüzden AST'de çalışan RAM+disk modeli MIR'de mevcut değildir.

### Kritik — native x64 VIRTUAL hataları sessizce yutuluyor

`src/codegen/x64/mir_x64_context.fbs:354-369` sanal adres `1048576` veya üstünde ise `xor eax,eax` ile başarısızlık döndürür. Çağıran MIR store/load kodu bu hata durumunu program seviyesinde raporlamaz; store dönüşü yok sayılır, load ise `0` olarak değişkene yazılır. Fixture native x64'te build exit 0 ve son değer `0` verdi. AST ve MIR yorumlayıcıları ise hata döndürüyor. Bu, güvenlik açısından fail-closed görünse de dil semantiği açısından sessiz yanlış sonuçtur.

### Yüksek — AST yorumlayıcının native adres ABI'si 32 bit

`src/runtime/exec/exec_state_value_utils.fbs:190-236,258-289` içindeki `ExecNative*` fonksiyonları adres ve uzunluk için `UInteger` alıyor. `exec_stmt_memory_core.fbs` de adresleri `Integer`/`CUInt(...)` ile geçiriyor. Native x64 süreç adresleri 64 bit olduğundan 4 GiB üzerindeki `VARPTR`/DLL adresleri kesilir. Canonical-MIR runtime tarafı `ULongInt` kullanırken AST native yolu aynı sözleşmeyi kullanmıyor.

### Yüksek — NATIVE `POKES`/`PEEKS` hedefler arasında eşit değil

AST `ExecRunPokeSStmt` içinde `NATIVE` açıkça reddediliyor (`exec_stmt_memory_core.fbs:548-564`). Canonical-MIR `UXBRuntimeMemoryWriteSequence` ve `ReadSequence` de NATIVE mode'u reddediyor (`runtime_memory.fbs:159-179`). Buna karşılık MIR-x64 canonical sequence emitter'ları NATIVE mode için native adres çözümlemeye çalışıyor (`mir_x64_runtime_emit_helpers.fbs:175-193`). Aynı söz diziminin üç backend'de farklı kabul edilmesi tasarım sözleşmesiyle uyumsuzdur.

### Yüksek — 1 MiB sınırı ve varsayılan model x64'te iki yerde kopyalanmış

MIR-x64 `.asm` helper'larında `1048576` sabiti çok sayıda yerde tekrarlanıyor (`mir_x64_context.fbs:337,359,479,518,568,606`). AST VIRTUAL boyutu değişse bile üretilen native programın VIRTUAL alanı büyümüyor. `--virtual` CLI değeri de yalnız `ExecRunMemoryProgram` tarafından okunuyor (`memory_exec.fbs:4149-4192`); native MIR build path bu değeri kullanmıyor.

### Orta — taşma ve kısmi işlem riskleri

- `VMemCopyW/D` genişlik çarpımını `UInteger` üzerinde yapıyor (`memory_vm.fbs:327-337`); taşma kontrolü yok.
- AST native `MEMCOPYW/D` ve `MEMFILLW/D` çağrılarında `CUInt(len * width)` kullanılıyor (`exec_stmt_memory_core.fbs:600-654,693-746`); 32 bit sarma mümkün.
- `VMemFillW/D` elemanları tek tek yazıyor; sınır hatasında işlem kısmen uygulanmış olabilir (`memory_vm.fbs:352-374`). Runtime `UXBRuntimeMemoryFillMode` toplam aralığı önce kontrol ederek bu açıdan daha tutarlı.
- `ExecParseByteSizeLiteral` boyut çarpımında taşma kontrolü yapmıyor (`exec_stmt_memory_core.fbs:875-913`).

### Orta — doğrulama sözleşmesi backend kapasitesiyle uyuşmuyor

MIR memory verifier width `8` kabul ediyor (`src/mir/verify/mir_verify_memory.fbs`), fakat MIR-x64 canonical load/store/copy/fill emitter'ları yalnız `1,2,4` genişliklerini kabul ediyor (`mir_x64_runtime_emit_helpers.fbs:125-170`). Böyle bir MIR doğrulanmış olsa bile x64 aşamasında geçersizleşebilir.

## Sağlam kalan kararlar

- `MEMCOPY*` kanonik sıra lowering ve MIR yorumlayıcıda `dst,src,count`; AST/x64 yardımcılarında da bu sıraya uyarlanmış durumda.
- `MEMCOPY` overlap için memmove mantığı kullanıyor.
- `MEMFILL` B/W/D genişliklerine göre çalışıyor.
- AST `VIRTUAL` RAM + disk mapping tek `VMemByteAt` üzerinden adres çözüyor ve sınırları kontrol ediyor.
- LIST/DICT/SET ham contiguous array olarak ele alınmıyor; bu ayrım korunmalı.

## Önerilen düzeltme sırası

1. Tek canonical `MemoryRegion/MemoryRef` sözleşmesi tanımla; AST `VMemState`, MIR runtime ve native x64 aynı mode/region semantiğini kullansın.
2. Canonical MIR'a `MIR_VIRTUAL_INIT` (veya eşdeğer) ekle; RAM boyutu, disk boyutu ve hata sonucu açık operandlar olsun. MIR interpreter bunu `VMemInit`/ortak runtime'a bağlasın.
3. Native x64 için VIRTUAL alanını sabit `.bss` yerine runtime'dan ayrılmış bir bölgeye bağla veya `--virtual` değerini build/runtime sözleşmesine taşı. Başarısız load/store için gerçek hata propagation ekle.
4. AST native bellek adres/uzunluk tiplerini `ULongInt`/64 bit yap; `CUInt` dönüşümlerini kaldır ve overflow kontrolü ekle.
5. `POKES/PEEKS` için NATIVE desteğinin tasarım kararını açıkça kilitle; kabul edilecekse AST, MIR runtime ve x64 aynı davranışı vermeli.
6. Verifier genişliklerini emitter kapasitesiyle eşleştir; B/W/D dışı genişlik ya desteklenmeli ya da doğrulama aşamasında reddedilmeli.

## Sonuç

PEEK/POKE, MEMCOPY ve MEMFILL komutlarının temel B/W/D yolları çalışıyor; ancak VIRTUAL RAM+disk tasarımı bugün yalnız AST yorumlayıcıda gerçek. Canonical-MIR'de `VIRTUAL_STMT` ve disk uzantısı eksik, native x64'te ise sabit 1 MiB alan ve sessiz sınır hatası var. Bu nedenle sistemin "üç backend'de ortak NATIVE/VIRTUAL bellek modeli" olarak tamamlandığı söylenemez.
