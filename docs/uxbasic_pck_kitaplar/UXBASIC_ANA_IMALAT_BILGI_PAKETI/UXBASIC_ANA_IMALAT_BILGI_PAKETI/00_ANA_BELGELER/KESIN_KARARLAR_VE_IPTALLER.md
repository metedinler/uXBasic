# Kesin Kabul ve İptal Edilen Kararlar

## Kesin kabul edilenler

1. `PARALEL` doğru komuttur; `PARALLEL` alias değildir.
2. `THREAD` doğru komuttur; `THREAT` alias değildir.
3. `MAGIC` doğru sihirli metot yüzeyidir; `SIHIRLIMETOT` kaldırılmıştır.
4. `IMPORT` yalnız derleme zamanı kaynak ekleme içindir: `IMPORT(C,...)`, `IMPORT(CPP,...)`, `IMPORT(ASM,...)`.
5. DLL/API çağrısı `DECLARE ... LIB ... ALIAS ...` ve `CALL(DLL/API,...)` hattından yürür.
6. Web/JS/WASM hedefleri native DLL/API yüzeyini sessiz kabul edemez; fail-close gerekir.
7. Hata merkezi Adım45 çizgisi korunacaktır.
8. Operator/Logic16 sözleşmesi tüm katmanlarda aynı olmalıdır.
9. Testler dummy/placeholder değil gerçek çıktı üretmelidir.
10. UXBasic çekirdeği gereksiz komut şişirmeden dış kütüphane ve modüllerle genişlemelidir.

## İptal edilen / yanlış kabul edilenler

| Yanlış karar | Neden iptal |
|---|---|
| `PARALLEL` aliası | Kullanıcı kararı: doğru Türkçe yüzey `PARALEL`; alias istemiyor. |
| `THREAT` | Yazım hatası; doğru `THREAD`. |
| `SIHIRLIMETOT` | Eski deneme; doğru yüzey `MAGIC`. |
| `IMPORT DLL/API/LIB` | Dil yüzeyini karıştırır; DLL/API çağrısı `DECLARE/CALL` hattındadır. |
| Güvenlik için aşırı kontrol | Kullanıcı tercihi: az ama doğru yerde kontrol. |
| Her şeyi core komut yapmak | Çekirdek komut planlandığı kadar kalacak; kütüphane/DLL/API ile genişleyecek. |
| Dosya/klasör komple ezerek kurtarma | Adım50 sonrası yalnız seçici patch/fragman veya doğrulanmış master zip kullanılmalı. |

## Açık kalan ama karar gerektirenler

- WAT hedefi aktif üretim mi olacak, yoksa WASM debug text çıktısı mı kalacak?
- `INKEY` ve `GETKEY` davranış ayrımı testte netleştirilecek: biri anlık/sürekli, biri beklemeli tek tuş.
- LIST/DICT/SET için tüm backendlerde gerçek davranış mı, yoksa unsupported matrix mi?
- F80/F128 harici runtime paketlenmesi hangi DLL setiyle yapılacak?
