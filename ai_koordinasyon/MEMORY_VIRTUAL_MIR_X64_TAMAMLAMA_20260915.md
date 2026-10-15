# VIRTUAL bellek sistemi tamamlama raporu — Codex 3

Tarih: 15 Eylül 2026

## Sonuç

Claude’un AST tarafında kurduğu `VIRTUAL <ram>[, <disk>]` sözleşmesi Canonical-MIR ve native x64’e taşındı. Üç yürütme yolu aynı RAM + disk alanını kullanıyor; sanal alan başlangıçta varsayılan 1 MiB olsa da `VIRTUAL` deyimiyle yeniden boyutlandırılıyor. Native x64 tarafında Windows pagefile-backed memory mapping kullanılıyor ve adres sınırı dinamik toplam boyuta göre denetleniyor.

## Yapılan düzeltmeler

- `src/semantic/mir_lower_stmt_core_split.fbs`: `VIRTUAL_STMT` artık `MIR_VIRTUAL_INIT(ram,disk)` üretir.
- `src/mir/mir_registry.fbs`, `src/mir/verify/mir_verify_operands.fbs`, `src/mir/verify/mir_verify_memory.fbs`, `src/semantic/mir_opcode_signature.fbs`: yeni opkod registry, operand ve doğrulama sözleşmesine eklendi.
- `src/interpreter/mir/mir_interp_memory.fbs`: RAM/disk boyutlarını K/M/G/T sonekleriyle ayrıştırıp ortak `VMemInit` çağırır; bellek operandlarını U64 olarak taşır.
- `src/runtime/memory/runtime_memory.fbs`: Canonical-MIR VIRTUAL yükleme/yazma/kopyalama/doldurma/dizi işlemleri gerçek `memory_vm.fbs` alanına yönlendirildi. 8-byte yükleme/yazma/doldurma eklendi.
- `src/runtime/memory_vm.fbs`: `VMemPeekQ` ve `VMemPokeQ` eklendi.
- `src/codegen/x64/mir_x64_capability.fbs`, `mir_x64_opcode_surface_emitters.fbs`, `mir_x64_runtime_emit_helpers.fbs`: `MIR_VIRTUAL_INIT` için gerçek x64 rota ve 1/2/4/8-byte bellek yolları eklendi.
- `src/codegen/x64/mir_x64_context.fbs`: dinamik toplam boyutlu Windows mapping, dinamik sınır kontrolleri ve native bellek hatası bayrağı eklendi. Native x64 sınır hatası artık sessiz `0` değil, program çıkış kodu `1`dir.
- `src/codegen/x64/mir_x64_codegen.fbs`: ana program epilogunda bellek hata bayrağı çıkış koduna yansıtılır.

## Kanıt

Taze izole host derlemesi:

`tools/FreeBASIC-1.10.1-win64/fbc64.exe ... tests/coordination_20260913/s028_reports_host.bas` — PASS.

`tests/coordination_20260914_virtual_memory_matrix.uxb` şu işlemleri yapar: 64 KiB RAM + 2 MiB disk kurar; RAM başlangıcı, RAM sonu, disk başlangıcı, MEMFILLB, MEMCOPYB ve 1 MiB üzeri disk adresini okur.

- AST: `123456, 42, 99, 7, 7, 314159`, exit 0.
- Canonical-MIR: `123456, 42, 99, 7, 7, 314159`, exit 0.
- native x64: `123456, 42, 99, 7, 7, 314159`, exit 0.

`tests/coordination_20260915_virtual_memory_bounds.uxb` 128 KiB toplam alanın dışına yazar:

- AST: `exec: POKED out of range`, exit 1.
- Canonical-MIR: `memory store failed`, exit 1.
- native x64: derleme başarılı, program çıkış kodu 1; sınır dışı erişim sessiz yanlış sonuç üretmiyor.

Üretilen kanıt klasörleri: `reports/coordination_20260915/virtual_ast_fixed`, `virtual_mir_fixed`, `virtual_x64_width8`, `virtual_bounds_ast`, `virtual_bounds_mir`, `virtual_bounds_x64_2`.

## Kalan teknik sınır

AST’in genel `ExecValue`/değişken adres tablosu hâlâ 32-bit sanal adres alanına göre tasarlanmıştır; native dış pointer ifadelerinin 64-bit taşıması ayrı bir ABI refaktörüdür. VIRTUAL RAM/disk alanı ve Canonical-MIR/x64 bellek operasyonları bu turda gerçek ve sınır kontrollü çalışır.

Son kontrol: yeni host bin/uxb_codex_mem2.exe ile native x64 sınır testi gerçek runtime tanısı TR: bellek yazma sinirlari disinda veya adres gecersiz | EN: memory write out of range or invalid address ve exit 1 verdi; valid matrix yine exit 0.

İlave doğrulama klasörü: reports/coordination_20260915/virtual_bounds_x64_checked ve virtual_matrix_x64_checked. Yeni host in/uxb_codex_mem2.exe ile sınır hatası runtime tanısı basıp exit 1 verdi; geçerli matris exit 0.
Düzeltme: yeni host dosyası bin/uxb_codex_mem2.exe ile son kontrol yapıldı.
Son host doğrulaması: AST ve Canonical-MIR yeni bin/uxb_codex_mem2.exe ile aynı altı değeri üretti ve exit 0.


