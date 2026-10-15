# ADIM50 Master V1 - kanonik yüzey ve yeniden kurma sistemi

Bu paket 1/5 hamlesidir. Amaç önce zemini düzeltmektir: son kaynak gövdesi korunur, fakat hatalı yüzey sözcükleri temizlenir.

## Kesin karar

- `PARALEL` gerçek komuttur. `PARALLEL` alias değildir.
- `THREAD` gerçek komuttur. `THREAT` alias değildir.
- `MAGIC` gerçek komuttur. `SIHIRLIMETOT` alias değildir.

## Uygulanan işlem

Ana gövde: `src_31_05_3_ADIM50_RECOVERED.zip`

Aktif FreeBasic kaynaklarında şu düzeltmeler yapıldı:

- `ASTK_PARALLEL_STMT` -> `ASTK_PARALEL_STMT`
- `MIR_PARALLEL_HINT` -> `MIR_PARALEL_HINT`
- surface contract listelerinden `PARALLEL`, `THREAT`, `SIHIRLIMETOT` kaldırıldı
- lexer keyword tablosundan `parallel`, `threat`, `sihirlimetot` kaldırıldı

Değişen aktif kaynak dosyası sayısı: **28**
Kanonik taramada kalan aktif yanlış yüzey satırı: **14**

## Bundan sonraki 4 hamle

2. hamle: FFI/DLL/API/CALL/DECLARE/IMPORT sözleşmesini tek hatta bağlama.
3. hamle: AST -> Semantic -> MIR -> Runtime -> x64/JS/WASM yüzey paritesi.
4. hamle: OOP, MAGIC, EVENT, THREAD, PARALEL, SLOT, PIPE yaşam döngüsü.
5. hamle: test runner, release gate, no-fake/no-placeholder, temiz ADIM50 kaynak paketi.
