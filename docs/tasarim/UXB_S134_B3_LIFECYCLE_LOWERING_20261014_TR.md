# UXB S-134 B3 Lifecycle Lowering Karari

Tarih: 2026-10-14
Sorumlu: Codex
Durum: MIR canonical lowering ve MIR provider kabul yolu tamamlandi

## Kapsam

Birinci sinif kutuphane tipi manifestindeki `copy_model` degeri, derleyicinin
implicit sahiplik aktarimini belirler. Kaynakta acikca yazilan `TYPE.COPY`
cagrisi ise kutuphane hook'u olarak kalir; implicit lowering bu ada baglanmaz.

| copy_model | Canonical MIR transfer cagrisi |
|---|---|
| `clone` | `TYPE.CLONE(value)` |
| `retain` | `TYPE.RETAIN(value)` |
| `bitcopy` | implicit lifecycle cagrisi yok |

Bu karar `TEXT_VALUE` (`clone`) ve `TEXT_REF` (`retain`) ornekleriyle
uygulandi. Boylece canonical MIR sonraki optimizer ve backend'lerin manifesti
yeniden yorumlamasini gerektirmeden sahiplik eylemini acikca tasir.

## Uygulanan lowering yuzeyleri

- scalar degisken atamasi ve DIM baslangic aktarimi
- BYVAL parametre siniri
- typed FUNCTION RETURN siniri
- array element ve array-of-TYPE field kopya sinirlari
- explicit `RETURN`, `END`, uncaught `THROW` ve `ASSERT` donusleri
- exception propagation pass'inin sonradan ekledigi sentetik `RET`

Fonksiyon lifetime temizliginde local managed degiskenler ters bildirim
sirasiyla `TYPE.DROP` alir. BYVAL parametreler temizlenir; `BYREF` parametreler
caller storage alias'i oldugu icin temizlenmez. Explicit `DROP` sonrasi provider
degeri bosalttigi icin tekrar scope cleanup gelmesi no-op olur; payload sayaçlari
double drop gostermemelidir.

Array heap scope temizligi mevcut heap sahipligi yolunda korunmustur. Bu halka
array element ABI'sini yeniden icat etmez; scalar/function lifecycle cagrisini
canonical MIR'de aciklar.

## Kaynak degisiklikleri

- `src/semantic/library_type_contract.fbs`
  - `UXBLibraryTypeManagedTransferMember`
  - `UXBLibraryTypeNeedsManagedDrop`
- `src/semantic/mir.fbs`
  - managed `STORE_VAR` normalization'i manifest transfer member'ini kullanir
- `src/semantic/mir_lower_expr.fbs`
  - BYVAL ve RETURN `CLONE/RETAIN` secimini contract'tan alir
- `src/semantic/mir_lower_stmt.fbs`
  - array field transferi, function cleanup ve THROW/RETURN temizligi
- `src/semantic/mir_lower_stmt_core_split.fbs`
  - duplicate array-field lowering yolu ayni contract'a baglandi
- `src/semantic/mir_exc_pass.fbs`
  - exception propagation sentetik RET oncesi managed DROP ekler

## Kanit

- `build_64.ps1 -Force`: exit 0
- binary: `bin/uxb.exe`
- SHA256: `0A75EA56B356FBF17378BBF7B589E7ADC757D6160CAFBF93B167FE41132CE631`
- `tests/library_type_contract/run_library_type_tests.ps1`: **43/43 PASS**
- JSON MIR yapisal kontrolleri:
  - owned transfer: `TEXT_VALUE.CLONE`, implicit `TEXT_VALUE.COPY` yok
  - shared transfer: implicit `TEXT_REF.RETAIN`, explicit `TEXT_REF.CLONE`
  - typed return: `TEXT_VALUE.CLONE` ve `TEXT_VALUE.DROP`
  - exception propagation: sentetik RET oncesi `TEXT_VALUE.DROP`
- runtime propagation fixture: `caught`, `allocations=2`, `drops=2`, `live=0`

## Acik sinirlar

Bu belge MIR canonical/provider kabul yolunu kapatir; native x64, JS ve
WAT/WASM icin gercek managed provider ABI'si hala uygulanmis degildir. Bu
hedeflerde manifest/provider kapisi temiz red vermelidir. Sonraki halkalar:

1. B4 provider ABI registry'sini surum, paket, capability ve lifecycle
   operasyonlariyla genisletmek.
2. B5 ayni lifecycle oracle'ini native/JS/WASM gercek calisma testlerine
   tasimak veya hedef-adli acik redleri kanitlamak.
3. B6 nested managed field, BYREF/escape ve array element omur kabullerini
   genisletmek.

