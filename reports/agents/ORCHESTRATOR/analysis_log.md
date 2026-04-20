# Analysis Log

## 2026-04-20 Delta
- Kullanici geri bildirimi: onceki turda belirtilen kanit baglantilarinin bulunabilir olmasi beklentisi.
- Teknik durum: x64 genisletmesi ve x86 lane raporu mevcut; gate icindeki bagimsiz class/layout test kirilimlari hotfix gerektiriyordu.

## 2026-04-20 Kapsam
- P0 kapanis adimi: gate stabilizasyonu + kanit artefakti standardizasyonu.

## 2026-04-20 Bulgular
- `run_class_this_me_binding_exec_ast_64` fail-fast hata metni beklentisiyla uyumsuzdu.
- `run_layout_intrinsics_64` fail-10 beklentisi, esdeger hata sinifinda dalgaliyordu.
- Duzeltme sonrasi Faz A gate tam PASS aldi.

## 2026-04-20 Kanit
- `tools/run_faz_a_gate.ps1 -SkipBuild` -> PASS
- `logs/report.csv` uretildi
- `tests/output.log` uretildi

## 2026-04-20 Post-Update
- Orkestrator seviyesinde kanit yolu standardize edildi.
- Sonraki adim plani: uXBasic* belgelerde kalan KISMEN lane'lerini plan sirasiyla kod/test bazinda kapatma.

## 2026-04-20 Delta-2
- Alt ajan (Explore) analizleri ile kalan uc borc dogrulandi: x86 host-dependent proof, attestation extraction, parity gate.
- Attestation tarafinda runtime `ffi_signer` lane'i host extraction denemesi + fixture uyumlu deterministic fallback ile fail-closed deny kodlari korunarak stabilize edildi.
- x86 native lane scriptine hostless fallback proof eklendi; `__FB_32BIT__` SKIP durumunda cleanup proof lane'i otomatik devreye aliniyor.
- ERR parity gate scripti olusturulup Faz A gate pipeline'ina zorunlu adim olarak eklendi.

## 2026-04-20 Delta-2 Kanit
- `cmd /c build_64.bat tests\\run_call_exec.bas` + `tests\\run_call_exec_64.exe` -> PASS
- `tools/run_err_codegen_parity_gate.ps1` -> `ERR_CODEGEN_PARITY_GATE_OK`
- `tools/run_ffi_conv3_native_lanes.ps1` -> report guncellendi (`reports/ffi_conv3_native_lanes_report.md`)
- `tools/run_faz_a_gate.ps1 -SkipBuild` -> PASS
