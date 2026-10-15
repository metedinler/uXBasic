# TYPE_TABLE Feasibility (Win11 x64)

Bu belge, ProgramcininElKitabi icindeki "Basic Dilinin Calistirilabilir Ogeler" tablosunun derleyiciye eklenebilirlik analizidir.

## Kapsam
- Hedef profil: Win11 x64 (aktif).
- Kod tabani: FreeBASIC parser/AST cekirdegi.
- Not: Repoda `core.py` veya `interpreter.py` yok. Bu nedenle Python tip map'i dogrudan calisan parca degil, tasarim referansi olarak ele alinmalidir.

## Hizli Karar Ozeti

### Dogrudan eklenebilir (lexer/parser tarafinda dusuk risk)
- `STRING`
- `INTEGER`
- `LONG`
- `SINGLE`
- `DOUBLE`
- `BYTE`
- `SHORT`
- `CHAR`
- `LIST`
- `DICT`
- `SET`
- `TUPLE`
- `POINTER`
- `VOID`
- `ANY`
- `OBJECT`
- Veri yapisi adlari: `ARRAY`, `BARRAY`, `STRUCT`, `UNION`, `ENUM`, `FLAG`, `STACK`, `QUEUE`, `CLASS`

### Yeniden tanim gerektirir (belirsiz/yaniltici)
- `NONE`: Derleyici dili icinde `VOID`/`NULL` semantigi ile cakisir. Tek bir semantik secilmeli.
- `NAN`: Bu bir tip degil, floating deger durumudur.
- `TYPE` (veri yapisi olarak): Bu isim dilde zaten anahtar sozcuk olarak kullaniliyor.
- `YAPI` / `CLAZZ`: Esanlamli yerel adlar isteniyorsa alias politikasi net yazilmali.
- `FILE` -> `file`: Python'a ozgu adlandirma. Derleyici tarafinda runtime handle/sembolik tip olarak tanimlanmali.

### Guvenli degil / dogrudan eklenemez (simdiki cekirdekte)
- Python runtime'a bagli map'ler (`str`, `dict`, `set`, `object`, `float('nan')`) tek basina derleyicide calismaz.
- `Pointer` ve `file` gibi tanimlarin runtime temsil tipi belirlenmeden parsera eklenmesi eksik kalir.

## Neyi dogru bulduk?
- Tipleri iki tabloda ayirma fikri dogru: "deger tipleri" ve "veri yapilari".
- `POINTER`, `STRUCT`, `UNION`, `ENUM` gibi dusuk seviye kavramlari acikca adlandirmak dogru.
- `ANY/OBJECT` gibi genis kapsayici tipleri planlamak dogru, ama semantik kurali yazilmadan aktif edilmemeli.

## Neyi yanlis bulduk?
- Tip ile degeri karistirma (`NAN` tip degil deger durumudur).
- Derleyici tip sistemi ile Python runtime tiplerini birebir esit gosterme.
- Ayni anlami tasiyan fazla alias (`YAPI/STRUCT`, `CLASS/CLAZZ`) icin resmi alias politikasi olmamasi.

## Nasil uygulanir? (One-shot, guvenli)
1. `src/parser/lexer/lexer_keyword_table.fbs` icine sadece karari net tip anahtar sozcuklerini ekle.
2. `src/parser/parser/parser_shared.fbs` icinde tip token dogrulamasina "izinli tip listesi" filtresi ekle.
3. `tests/manifest.csv` icine her yeni tip icin en az 1 pozitif + 1 negatif parse testi ekle.
4. `tests/plan/command_compatibility_win11.csv` yerine tip matrisi icin yeni bir tablo (`tests/plan/type_compatibility_win11.csv`) ac.
5. Runtime gerektiren tipler (`POINTER`, `FILE`, `ANY/OBJECT`) parserda "planli" etiketiyle acilsin; calisan runtime gelmeden "implemented" denmesin.

## Enjeksiyon ve guvenlik notu
- Tip adlari sadece lexer keyword ve parser type-context icinde kabul edilmeli.
- Serbest metin/identifier alaniyla karismamasi icin type-context disinda reddedilmeli.
- Include/import path kurallari (source-root disina cikmama) aynen korunmali.
