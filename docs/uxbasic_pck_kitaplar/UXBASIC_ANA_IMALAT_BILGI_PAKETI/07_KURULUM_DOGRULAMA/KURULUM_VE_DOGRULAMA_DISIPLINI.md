# Bundan Sonra Kullanılacak Kurulum ve Doğrulama Disiplini

## 1. Kaynak seçimi

Yeni imalat tabanı olarak önce `src_31_05_3_ADIM50_MASTER_V2.zip` açılmalıdır. Eski ZIP’lerden dosya komple ezme yapılmayacak; gerekirse bu bilgi paketindeki tablolarla sembol/fragman taşınacaktır.

## 2. Yasak komutlar

Kurtarma ve inceleme bitmeden:

```powershell
git clean -fd
git clean -fdx
git reset --hard
Remove-Item -Recurse
```

kullanılmamalıdır.

## 3. İlk statik kontroller

- Aktif kaynakta `PARALLEL`, `THREAT`, `SIHIRLIMETOT` olmamalı.
- `PARALEL`, `THREAD`, `MAGIC` bulunmalı.
- `UXB_TARGET_WAT`, `UXB_TARGET_X86`, FFI registry sembolleri bulunmalı.
- Missing include = 0 olmalı.

## 4. Derleme/test sırası

1. FreeBasic build.
2. Lexer keyword negative suite.
3. Preprocessor fail-close suite.
4. Adım45 error center gate.
5. Operator/Logic16 suite.
6. FFI/native fail-close for JS/WASM.
7. Full surface suite.
8. CLI output contract gate.

## 5. Raporlama

Her test JSON/CSV/MD rapor üretmeli; placeholder rapor başarı sayılmamalı.
