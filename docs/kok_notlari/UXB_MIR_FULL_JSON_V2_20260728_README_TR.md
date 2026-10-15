# uXBasic MIR Full JSON v2 yaması — 2026-07-28

Bu yama mevcut CLI seçeneğini değiştirmez:

```powershell
.\bin\uxb.exe .\program.uxb `
  --mir-full-json-out .\reports\program.mir.json `
  --quiet
```

Çıktı şeması `uxb-mir-full-json-2` olur. V1 alanları korunur ve yeni alanlar eklenir.

## Tamamlanan MIR JSON alanları

- `MIRModule.sourceFiles/sourceFileCount`
- `globalVarIsArray` ve nesne biçimli `global_symbols`
- Fonksiyon `entryBlock`, `blockCount`, parametre/yerel sayıları
- Fonksiyonun ham `declared_source` konumu ve ilk instruction’dan türetilen kullanılabilir `source`
- Blok `isEntry/isExit`, instruction/predecessor/successor sayıları
- Instruction `blockId`, `comment`, `flags`, `source_ast_node`
- Kaynak konumunda `offset`
- Kararlı, modül çapında instruction `id`
- Opcode min/max operand ve sonuç sözleşmesi
- Operand sıra, rol ve tip ipucu kayıtları
- FFI argüman başlangıcı ve sayısı
- Vtable sınıf adları, slot başlangıç/sayıları ve bütün entry eşlemeleri
- JSON hedef klasörü yoksa oluşturma

## Kaynak değişiklikleri

- `src/semantic/mir.fbs`
- `src/semantic/mir_tail.fbs`
- `src/semantic/mir_full_exporter_json.fbs`

## Yeni testler

- `tests/mir_full_json_v2/mir_full_json_v2_smoke.uxb`
- `tests/mir_full_json_v2/verify_mir_full_json_v2.py`
- `tests/mir_full_json_v2/run_mir_full_json_v2_smoke.ps1`
- `tests/mir_full_json_v2/README_TR.md`

## Uygulama

Zip'i uXBasic kök klasöründe açıp üzerine yazın:

```powershell
Expand-Archive `
  -LiteralPath .\UXB_MIR_FULL_JSON_V2_20260728_PATCH.zip `
  -DestinationPath . `
  -Force
```

## Test

Önce hızlı statik kontrol:

```powershell
python .\tests\mir_full_json_v2\verify_mir_full_json_v2.py --root .
```

Mevcut derlenmiş compiler ile, yeniden build yapmadan:

```powershell
pwsh .\tests\mir_full_json_v2\run_mir_full_json_v2_smoke.ps1 `
  -SkipBuild `
  -Uxb .\bin\uxb.exe
```

Tam build ve smoke:

```powershell
pwsh .\tests\mir_full_json_v2\run_mir_full_json_v2_smoke.ps1
```

Elle çalıştırma ve JSON doğrulama:

```powershell
.\bin\uxb.exe .\tests\mir_full_json_v2\mir_full_json_v2_smoke.uxb `
  --mir-full-json-out .\reports\mir_full_json_v2\mir_full_json_v2_smoke.json `
  --quiet

python .\tests\mir_full_json_v2\verify_mir_full_json_v2.py `
  --root . `
  --json .\reports\mir_full_json_v2\mir_full_json_v2_smoke.json
```

## Bu ortamda yapılan doğrulama

- Değişen kaynak alanlarının statik kapsam kontrolü: PASS
- Python test dosyasının sözdizimi: PASS
- Yama dosya yerleşimi ve hash manifesti: PASS
- FreeBASIC build: bu Linux çalışma ortamında `fbc` bulunmadığı için çalıştırılmadı; Windows üzerindeki yukarıdaki komut bunun gerçek build/smoke kapısıdır.
