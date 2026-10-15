# uXBasic motor sorumluluk ve parity sözleşmesi

Tarih: 2026-09-16  
Amaç: Aynı `.uxb` kaynağının farklı yürütme yollarında aynı dil sonucunu üretmesini ve her komutun tek bir kanonik sahibi olmasını sağlamak.

## Motorlar

| Motor | Görevi | Kanonik girdisi | Başarı ölçütü |
|---|---|---|---|
| AST yorumlayıcı | Kaynak AST'yi doğrudan çalıştırır; hızlı semantik/runtime probe | AST + ortak runtime sözleşmesi | Dil sonucu ve hata kodu |
| Canonical MIR yorumlayıcı | AST semantic çıktısını opcode sözleşmesiyle çalıştırır | Canonical MIR | AST ile aynı değer/hata |
| MIR-x64 | Canonical MIR'i native x64 ABI'ye üretir | Verified MIR | MIR sonucu ve exit davranışı |
| AST-x64 | Eski/doğrudan AST native backend; compatibility yolu | AST | MIR-x64 ile aynı sonuç; destek yoksa build-time capability hatası |
| JS/Node | Canonical çağrıları JS runtime'a taşır | Canonical MIR/JS emitter | Host/runtime sonucu ve hata sözleşmesi |
| WASM/WAT | Canonical çağrıları WAT/WASM import/runtime'a taşır | Canonical MIR/WAT emitter | `wat2wasm` doğrulaması ve runtime sonucu |

## Tekil otorite

1. Parser AST biçimi syntax otoritesidir.
2. Semantic/type binding tür, conversion, inheritance ve overload otoritesidir.
3. Canonical MIR opcode ve operand biçimi backend'lerin tek yürütme sözleşmesidir.
4. Ortak runtime contract hata kodlarını, bellek sınırlarını, collection handle'larını ve object lifetime davranışını tanımlar.
5. Backend capability/readiness kapısı, desteklenmeyen yapıyı assembler/WAT aşamasına bırakmadan bildirir.

## Her yeni komut için zorunlu kayıt

- Parser AST node ve operand şekli.
- Semantic type/conversion kuralı.
- Canonical MIR opcode ve verifier kuralı.
- AST, MIR, JS/WASM, MIR-x64 ve AST-x64 rotaları.
- Başarı çıktısı, hata kodu ve sınır testi.
- Tek bir parity probe ve sonuç JSON'u.
- İkincil/legacy yol varsa açıkça `compatibility` olarak işaretlenmesi.

## Bu turdaki ölçülen durum

- OOP core (`THIS/ME/SUPER`, upcast, virtual, lifetime): 5 motor × 5 probe PASS.
- Recursive local frame: 5 motor × 1 probe PASS.
- LISTGET numeric: AST/MIR/JS/MIR-x64 PASS; AST-x64 collection symbol route açık.
- LISTGET → I32 assignment: beş motorun tamamı aynı `TYPE_OBJECT to TYPE_I32` semantic reddini veriyor; ortak typed-collection/unbox kuralı gerekiyor.
- Dynamic `DIM arr(n)`: MIR-x64 compile-time literal kısıtı açık.
- BYREF alias ve compound assignment: ayrı aktif sahiplikte, parity kapanmadı.

Bu sözleşme, bir düzeltmenin yalnızca tek motorda çalışmasını tamamlanma olarak kabul etmez.
