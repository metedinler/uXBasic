# uXBasic FreeBASIC A Grubu Standart Kütüphaneleri

Bu paket `uxb(25.07).zip` düzeni incelenerek hazırlanmış, mevcut kaynakların üzerine açılan yeni dosya paketidir. Compiler çekirdeği ve mevcut kütüphaneler değiştirilmez.

## Modüller ve kapsam

| Modül | Kapsam |
|---|---|
| `uxsystem` | Makine/kullanıcı, dizinler, ortam değişkenleri, CPU, mimari, bellek, yönetici, süreç/thread kimliği, ekran |
| `uxfs` | Dosya/klasör varlığı, oluşturma, silme, kopyalama, taşıma, boyut, özellikler, metin I/O, dizin enumeration |
| `uxpath` | Birleştirme, tam/normalize yol, dosya adı, dizin, uzantı, stem, uzantı değiştirme, kök içinde kalma testi |
| `uxprocess` | CreateProcess, bekleme, durum, exit code, PID, sonlandırma, ShellExecute, senkron çalışma |
| `uxlog` | Altı log seviyesi, minimum seviye, boyuta bağlı tek yedek rotasyonu, flush ve close |
| `uxconfig` | Windows INI tabanlı string/I64/F64/boolean okuma-yazma, silme ve varlık testi |
| `uxdatetime` | Unix ms, FILETIME, monotonic sayaç, UTC/local format, UTC parse, fark/toplama ve sleep |
| `uxuuid` | UUID v4 üretme, nil, doğrulama, normalize, eşitlik ve parantezsiz biçim |

## ABI kuralları

- DLL sınırında FreeBASIC `STRING` nesnesi taşınmaz.
- Metin girişi `STRPTR`, metin çıkışı DLL içindeki geçici `ZSTRING PTR` olarak döner.
- Handle'lar `U64` ile taşınır.
- Açılan her `Enum`, `Process`, `Log` veya `Config` handle kapatılmalıdır.
- Metin döndüren bir sonraki fonksiyon aynı modülün önceki geçici metin sonucunu değiştirebilir; sonuç uzun tutulacaksa uXBasic değişkenine hemen kopyalanmalıdır.

## Tek build komutu

ZIP'i uXBasic köküne açtıktan sonra:

```powershell
.\BUILD_UXB_FREEBASIC_A_GROUP.bat -Clean
```

Yalnız DLL üretmek, testleri atlamak:

```powershell
.\BUILD_UXB_FREEBASIC_A_GROUP.bat -Clean -SkipTests
```

Belirli modüller:

```powershell
.\BUILD_UXB_FREEBASIC_A_GROUP.bat -Modules uxsystem,uxfs,uxpath
```

Build sistemi mevcut `tools\FreeBASIC-1.10.1-win64` aracını kullanır. Farklı derleyici için:

```powershell
$env:UXB_FBC = "C:\FreeBASIC\fbc64.exe"
```

## Test komutları

Betik otomatik olarak çalıştırır:

```powershell
bin\uxb.exe par tests\libraries\freebasic_a_group\freebasic_a_group_smoke.uxb
bin\uxb.exe int tests\libraries\freebasic_a_group\freebasic_a_group_smoke.uxb
bin\uxb.exe int tests\libraries\freebasic_a_group\freebasic_a_group_smoke.uxb --interpreter-backend MIR
```

Raporlar:

```text
reports\libraries\freebasic_a_group\<tarih_saat>\
```

## Bilinçli sınırlar

Bu v1, A grubunun belirlenmiş genel uygulama sözleşmesini eksiksiz kapsar; bütün Win32 API'sini sarmalamaz. `uxprocess` stdout/stderr capture, `uxfs` recursive tree delete/copy ve `uxconfig` JSON/TOML sağlayıcıları sonraki ayrı modül sürümüdür. Bunları eksikmiş gibi sessiz bir sahte fonksiyonla göstermedik.

Bu Linux çalışma ortamında FreeBASIC Windows DLL'leri gerçek olarak derlenemedi. Windows makinedeki FBC derlemesi ve uXBasic AST/MIR testleri build betiğine bağlandı. İlk çalıştırmada build logları esas alınmalıdır.
