# UXB S-134 B4.1 Provider Operation ABI Kapi Karari

Tarih: 2026-10-14
Sorumlu: Codex
Durum: Uygulandi ve dogrulandi

## Amac

Birinci sinif kutuphane tipi manifesti bir `TYPE.OPERATION` uyesini ilan
edebilir. Provider registry'sinde yalniz provider adinin kayitli olmasi,
provider'in o tipi ve o uyeyi gercekten uyguladigi anlamina gelmez. B4.1,
MIR provider dispatch'inden once uc baglayici kapisi siraya koyar:

1. hedef/provider kaydi var mi,
2. provider bu statik tipi destekliyor mu,
3. provider bu operasyonu uyguluyor mu.

Ilk iki kapinin gecilmesi ucuncu kapinin atlanmasina izin vermez. Boylece
manifestte bulunan fakat provider'da olmayan bir uye, generic runtime yoluna
veya sessiz placeholder koda dusmez.

## Uygulanan registry matrisi

`UXBLibraryTypeProviderSupportsOperation` hedefe, provider'a, tipe ve uye
adinin normalize edilmis haline bakar.

| Provider | Tip | Desteklenen operasyon grubu |
|---|---|---|
| `OWNED_TEXT_REFERENCE` | `TEXT_VALUE`, `TEXT_REF` | `CONSTRUCT`, `COPY`, `RETAIN`, `CLONE`, `DROP`, `NORMALIZE`, `TOSTRING` |
| `RATIONAL_REFERENCE` | `RATIONAL` | `COPY`, `CLONE`, `RETAIN`, `DROP`, `TOSTRING`, `ADD`, `SUB`, `MUL`, `DIV`, `EQ`, `NE`, `LT`, `LE`, `GT`, `GE` |

Bu tablo mevcut MIR provider implementasyonunun gercek ABI'sidir. Ornegin
manifestte ilan edilmis `RATIONAL.CMP`, `RATIONAL.CONSTRUCT`, `RATIONAL.NORMALIZE`
ve `RATIONAL.HASH` uyeleri bu reference provider tarafindan henuz
uygulanmadigi icin acikca reddedilir. Bu, manifesti sessizce yok saymaktan
daha guvenlidir; sonraki provider implementasyonu tabloya bilincli olarak
eklenebilir.

## Canonical tani

Desteklenmeyen uye su canonical iletiyle durur:

`UXB_LIBTYPE_PROVIDER_OPERATION_UNAVAILABLE: library type provider operation unavailable: RATIONAL.CMP via RATIONAL_REFERENCE`

Structured diagnostics:

- `code`: `UXB_LIBTYPE_PROVIDER_OPERATION_UNAVAILABLE`
- `layer`: `library_type`
- `phase`: `provider_call`
- `message_en` ve `message_tr`: ayni `TYPE.OPERATION via PROVIDER` ayrintisini tasir
- `related_surface` ve `details`: provider cagrisinin ayni ayrintisini tasir
- `hint_en` ve `hint_tr`: operasyonu uygulayan provider kullanma yonlendirmesi

Boylece `MISSING`, `TYPE_MISMATCH`, `UNAVAILABLE` ve operation ABI reddi ayni
library-type tani zarfi ailesindedir; operation reddi provider kayitli oldugu
halde uye uygulanmadigi durumdur.

## Kaynak ve test kaniti

- `src/semantic/library_type_contract.fbs`: operation registry kapisi
- `src/interpreter/mir/mir_interp_library_type.fbs`: provider dispatch oncesi kontrol
- `src/common/error_system_adim45.fbs`: katalog ve canonical inference
- `src/main_output_contract_bridge.fbs`: iki dilli structured tani
- `tests/library_type_contract/rational_libtype_unsupported_operation.uxb`: negatif runtime fiksturu
- `tests/library_type_contract/test_library_type_contract.bas`: operation matrisi birim kontrolleri
- `tests/diagnostics/run_s500_libtype_diagnostic_consistency_tests.ps1`: structured tani kontrolu

Kanit:

- `build_64.ps1 -Force`: exit 0
- `tests/library_type_contract/run_library_type_tests.ps1`: **44/44 PASS**
- `run_s500_libtype_diagnostic_consistency_tests.ps1`: **3/3 PASS**
- `RATIONAL.CMP`: MIR runtime exit 13, canonical operation code, `provider_call`

## Kapsam siniri ve sonraki is

Bu halka operasyon registry'sini ve fail-closed MIR dispatch'ini kapatir.
Manifestte parse edilen `version`, `dependencies` ve `capabilities` alanlari
henuz paket cozucusu veya target capability solver tarafindan zorunlu
uygunluk kosulu olarak denetlenmiyor. Native/JS/WASM provider'lari da hala
gercek runtime implementasyonu degil; bu hedeflerde mevcut karar hedef-adli
`UXB_LIBTYPE_PROVIDER_UNAVAILABLE` acik reddidir.

Sonraki halka B4.2: provider paket surumu/dependency/capability metadata'sini
target registry ile baglamak. Ardindan B5: ayni lifecycle ve operation
oracle'ini native, JS ve WASM provider'larina tasimak veya bu hedefler icin
ayni canonical acik ret matrisini korumak.
