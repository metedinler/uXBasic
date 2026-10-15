# Yama 3 — SLOT ... END SLOT 0..255 görev/bağlama tablosu

Bu yama PCK kararına göre `SLOT ... END SLOT` yapısını çalışma bloğu olmaktan çıkarıp 0..255 arası görev/bağlama tablosu olarak yerleştirir.

Kanonik biçim:

```uxbasic
SLOT
    Kaydet 5 ON EVENT VeriGeldi
    Isci   6 ON THREAD SensorOku
    Hat    7 OFF PIPE Donustur
    Grup   8 ON PARALEL SahaIzleme
END SLOT
```

Kısa biçim de desteklenir; hedef türü semantic aşamada task tanımından çıkarılır:

```uxbasic
SLOT
    Kaydet 5 ON VeriGeldi
    Isci   6 OFF SensorOku
END SLOT
```

Kurallar:

- Slot id `0..255` aralığında olmalıdır; dışı hatadır.
- Hedef adı `EVENT`, `PIPE`, `THREAD`, `PARALEL` task tablolarında bulunmalıdır; yoksa hatadır.
- Açık tür verilirse hedefin gerçek türüyle uyuşmalıdır; uyuşmazsa hatadır.
- Aynı slot id veya ad tekrar kullanılırsa PCK kararı gereği ileride uyarı verilecek, runtime tarafında son gelen önceki kaydı ezecektir.
- Eski `SLOT EVENT <...>` kapasite biçimi bu yamada geriye uyumluluk için bırakılmıştır.

Değişen ana düğümler:

- `SLOT_TABLE_STMT`
- `SLOT_BIND_ENTRY`

Test:

```powershell
.\build_64.bat 2>&1 | Tee-Object -FilePath .\build_64_error.log
.\run_yama3_slot_tests.bat .\bin\uxb.exe
```
