**uXBasic Resmî Teknik Kitabı** 
 **kaynak kod gerçekliğine dayanan, akıcı, öğretici, teknik ve kitap gibi yazılmış tek belge üretme işi** 
Aşağıdaki 20 adım bizim ana yol haritamızdır. 
Bugün **1. adımdan başlıyoruz**.

---

# uXBasic Resmî Teknik Kitabı — 20 Adımlık Yazım Planı

## 1. Adım — Kitabın kimliği ve yazım yasası kurulacak

İlk iş kitabın ne olduğunu, ne olmadığını ve hangi kaynak baskısına dayandığını net yazmak.

Kitap adı:

```text
uXBasic Resmî Teknik Kitabı
12.06_1 Çalışan Kaynak Baskısı
```

Alt başlık:

```text
Dil, Preprocessor, AST, MIR, Runtime, JS/WASM/WAT, x64 ve Yan Araçlar
```

Bu bölümde şu kabul açıkça yazılacak:

```text
Bu kitapta uXBasic özellikleri çalışır kabul edilir. Ancak her özellik aynı katmandan çalışmaz. Bazı komutlar doğrudan AST yorumlayıcıda, bazıları MIR yorumlayıcıda, bazıları preprocess aşamasında, bazıları runtime servisleriyle, bazıları da MIR tabanlı JS, WAT/WASM veya x64 kod üretim hattı üzerinden anlam kazanır.
```

Bu bölüm kitabın “anayasa” bölümüdür.

---

## 2. Adım — Eski PCK belgeleri parçalanacak

Şu belgeler bölüm bölüm ayrılacak:

```text
pck_tek_kitap.md
pck_src30_05_5_guncel.md
pck1_cilt1_src30_05_5.md
pck2_komut_siniflari_genis.md
pck3_cilt3_degisken_veri_nesne_hook_wrapper.md
pck4_cilt4_kutuphaneler_runtime.md
pck5_cilt5_web_ai_analiz.md
pck6_cilt6_ai_egitim.md
```

Ama bunlar aynen birleştirilmeyecek. Her başlık şu sınıflara ayrılacak:

```text
Alınacak
Düzeltilecek
Kaynakla karşılaştırılacak
Tekrar olduğu için silinecek
Yeni kitapta ek bölüme taşınacak
```

---

## 3. Adım — Tekrar eden boş cümleler temizlenecek

Özellikle tablolardaki şu tip cümleler yasaklanacak:

```text
Bu komut gelişmiş işlem yapar.
Bu sözcük özel görev üstlenir.
Bu yapı programlamada kullanılır.
Bu komut sistemin çalışmasına yardım eder.
```

Bunların yerine her satıra gerçek görev yazılacak.

Örnek:

Yanlış:

```text
FOR döngü kurmak için kullanılır.
```

Doğru:

```text
FOR, sayısal sayaçla tekrar eden işlem kurar. Başlangıç, bitiş ve isteğe bağlı STEP değeriyle çalışır; NEXT satırında sayaç ilerler.
```

---

## 4. Adım — 12.06_1 kaynak yüzeyi çıkarılacak

Ana kaynak olarak şu dosyalar esas alınacak:

```text
lexer_keyword_table.fbs
parser_stmt_registry.fbs
ast_node_kinds.fbs
parser_adim08_operator_contract.fbs
runtime_service_ids.fbs
runtime_service_catalog.fbs
cli_help.fbs
cli_registry_adim41.fbs
project_pack_manifest.json
surface_coverage.csv
uxb_library_registry.csv
```

Buradan şu listeler çıkarılacak:

```text
Anahtar kelimeler
Komutlar
Fonksiyonlar
Operatörler
Veri tipleri
Veri yapıları
Preprocessor komutları
Runtime servisleri
CLI anahtarları
AST node adları
MIR opcode aileleri
```

---

## 5. Adım — Komutlar öğrenme sırasına göre dizilecek

Alfabetik liste kitabın sonunda olacak. Ana kitapta sıra şöyle olacak:

```text
PRINT
DIM / AS / CONST
Operatörler
IF
FOR / DO / WHILE
FUNCTION / SUB
Diziler
TYPE
CLASS / MAGIC
NAMESPACE / MODULE / USING / ALIAS
INCLUDE / IMPORT
Dosya işlemleri
CALL(DLL) / CALL(API)
Preprocessor
Backend hedefleri
Test sistemi
```

Yani okuyucu dili adım adım öğrenecek.

---

## 6. Adım — Her komut için standart anlatım kalıbı kurulacak

Her komut şu sırayla anlatılacak:

```text
Komut adı
Kısa görev
Syntax
Parametreler
Temel örnek
Beklenen çıktı
Birlikte kullanıldığı komutlar
Gelişmiş örnek
Derleyici katmanı
İlgili test veya xtestx örneği
```

Örnek kalıp:

```text
DIM

Görev:
Bellekte isimli değişken veya dizi alanı açar.

Syntax:
DIM ad AS tip
DIM ad(boyut) AS tip

Temel örnek:
DIM yas AS I32 = 20
PRINT yas

Beklenen çıktı:
20
```

---

## 7. Adım — Örnekler testlerden alınacak ama geliştirilecek

Ana örnek kaynakları:

```text
xtestx/project_packs
xtestx expected testleri
pck belgelerindeki iyi örnekler
src ile uyumlu yeni geliştirilmiş örnekler
```

Her örnek gerçek uXBasic sözdizimine uygun olacak. Örnekler “süs” değil, öğretme aracı olacak.

---

## 8. Adım — Her önerinin kod karşılığı yazılacak

Kitapta “şöyle yapılabilir” deyip bırakmak yok.

Yanlış:

```text
Diziler ölçüm verilerini saklamak için kullanılabilir.
```

Doğru:

```basic
DIM sicaklik(3) AS I32
sicaklik(1) = 18
sicaklik(2) = 21
sicaklik(3) = 19

DIM i AS I32
DIM toplam AS I32 = 0

FOR i = 1 TO 3
    toplam = toplam + sicaklik(i)
NEXT i

PRINT toplam
```

Beklenen çıktı:

```text
58
```

---

## 9. Adım — AST, MIR ve backend mimarisi doğru anlatılacak

Bu bölüm özellikle önemli.

Kitapta şu açıklama temel alınacak:

```text
AST, kaynak kodun anlam ağacıdır. Parser kaynak kodu AST’ye çevirir. AST interpreter doğrudan bu ağaç üzerinden çalışabilir.

MIR ise hedef üretim omurgasıdır. MIR interpreter MIR üzerinden çalışır. JS, WAT/WASM ve x64 üretim hattı MIR seviyesinden destek alır. x64 kod üretimi MIR seviyesindedir; gerektiğinde AST’den kaynak anlamı ve yüksek seviye bilgi alır.
```

Yanlış anlatım yapılmayacak:

```text
Her şey AST’den çalışır.
```

Doğru anlatım:

```text
AST anlamı taşır; MIR hedefe inmeyi sağlar.
```

---

## 10. Adım — Preprocessor ayrı bir mini dil gibi yazılacak

Preprocessor bölümü sadece liste olmayacak.

Şu ailelerle anlatılacak:

```text
%%SET / %%DEFINE / %%UNDEF
%%IF / %%ELIF / %%ELSE / %%ENDIF
%%FOR / %%FOREACH / %%REPEAT
%%TARGET / %%OUTDIR / %%PLATFORM
%%HTML_BEGIN / %%JS_BEGIN / %%CSS_BEGIN
%%WAT_BEGIN / %%WAT_IMPORT / %%WAT_EXPORT
%%ASSET_ROOT / %%ASSET_FILE / %%ASSET_COPY
%%MANIFEST_SET / %%JSON_SET
%%ALLOW_RAW_JS / %%ALLOW_RAW_WAT
```

Örnek:

```basic
%%SET MOD = "WEB"
%%TARGET WEB
%%OUTDIR "dist/demo"

%%IF MOD == "WEB"
PRINT "WEB_HEDEFI"
%%ENDIF
```

---

## 11. Adım — Operatörler ayrı güçlü bölüm olacak

Şu aileler ayrı ayrı anlatılacak:

```text
Aritmetik
Karşılaştırma
Mantıksal
Bit işlemleri
Logic16 operatörleri
Atama operatörleri
Pipe operatörü
Üçlü koşul operatörü
```

Örnek:

```basic
DIM a AS I32 = 12
DIM b AS I32 = 5

PRINT a AND b
PRINT a OR b
PRINT a XOR b
PRINT a SHL 1
```

---

## 12. Adım — Veri tipleri ve veri yapıları ayrı cheat sheet olacak

Kitap içinde anlatılacak, sonunda ayrıca hızlı başvuru olacak.

Veri tipleri:

```text
I8, I16, I32, I64
U8, U16, U32, U64
F32, F64, F80, F128
BIGI, BIGINT, BIGD, BIGF, BALL
BOOLEAN
STRING
OBJECT
PTR, STRPTR
```

Veri yapıları:

```text
ARRAY
LIST
DICT
SET
TYPE
CLASS
INTERFACE
MODULE
NAMESPACE
```

---

## 13. Adım — TYPE, CLASS, MAGIC bölümü güçlü yazılacak

Bu bölüm uXBasic’in modern yüzünü gösterecek.

Sıra:

```text
TYPE veri taşır.
CLASS veri + davranış taşır.
INTERFACE davranış sözleşmesi tanımlar.
MAGIC özel nesne davranışı kurar.
```

Örnek:

```basic
TYPE Nokta
    x AS I32
    y AS I32
END TYPE

DIM p AS Nokta
p.x = 10
p.y = 20

PRINT p.x + p.y
```

---

## 14. Adım — INCLUDE, IMPORT, CALL farkı kesin yazılacak

Bu bölümde karışıklık olmayacak.

Kesin kural:

```text
INCLUDE uXBasic dosyası ekler.
IMPORT(C/CPP/ASM) derleme zamanı dış kaynak ekler.
IMPORT DLL/API değildir.
CALL(DLL) DLL çağrı rotasıdır.
CALL(API) API/servis çağrı rotasıdır.
DECLARE LIB ALIAS dış fonksiyon imzası tanımlar.
```

Örnek:

```basic
IMPORT(C, "native/math.c")
IMPORT(CPP, "native/engine.cpp")
IMPORT(ASM, "native/fast.asm")

PRINT "DIS_KAYNAK_EKLENDI"
```

---

## 15. Adım — Runtime servisleri ve dış dünya bölümü yazılacak

Bu bölümde şunlar anlatılacak:

```text
Dosya işlemleri
Bellek işlemleri
CALL(DLL)
CALL(API)
JSON
REGEX
WEB
REST
SHELL / EXEC varsa dış komut rotası
```

Her dış çağrı örneğinde güvenlik notu olacak ama boş nasihat olmayacak.

Yanlış:

```text
Dış DLL kullanırken dikkatli olun.
```

Doğru:

```text
DLL çağrısında fonksiyon adı, çağrı biçimi ve parametre tipleri yanlış verilirse program yanlış adrese, yanlış veriyle gider. Bu yüzden DECLARE LIB ALIAS satırı CALL(DLL) satırından önce yazılır.
```

---

## 16. Adım — JS, WAT/WASM ve x64 bölümü yazılacak

Bu bölümde backend mantığı anlatılacak.

Ana cümle:

```text
uXBasic kaynak kodu, hedefe göre farklı üretim yollarına iner. JS, WAT/WASM ve x64 üretiminde MIR ana omurgadır. AST ise kaynak anlamını taşıyan üst katmandır.
```

Örnek web bloğu:

```basic
%%TARGET WEB
%%OUTDIR "dist/app"

%%HTML_BEGIN "index.html" BODY
<h1>uXBasic Web</h1>
%%HTML_END

%%JS_BEGIN "program.js" RUNTIME
console.log("uXBasic");
%%JS_END

PRINT "WEB_ROUTE"
```

---

## 17. Adım — Yan araçlar ve test runner bölümü yazılacak

Şu komutlar kitapta mutlaka yer alacak:

```powershell
.\build_64.bat
```

```powershell
python xtestx\_runners\run_xtestx_project_packs.py --root . --tests xtestx --uxb .\bin\uxb.exe
```

```powershell
python xtestx\_runners\run_xtestx_expected_tests.py --root . --tests xtestx --uxb .\bin\uxb.exe
```

```powershell
python uxb_derin_analiz.py
```

Bu bölüm geliştiriciye “nasıl doğrularım?” sorusunun cevabını verecek.

---

## 18. Adım — Cheat sheet ekleri hazırlanacak

Kitabın sonunda ayrı hızlı başvuru bölümleri olacak:

```text
Komut cheat sheet
Fonksiyon cheat sheet
Preprocessor cheat sheet
Operatör cheat sheet
Veri tipi cheat sheet
Veri yapısı cheat sheet
CLI cheat sheet
Backend cheat sheet
Yanlış keyword düzeltme cheat sheet
```

Yanlış keyword tablosu özellikle konacak:

| Yanlış         | Doğru     |
| -------------- | --------- |
| `THREAT`       | `THREAD`  |
| `PARALLEL`     | `PARALEL` |
| `SIHIRLIMETOT` | `MAGIC`   |

---

## 19. Adım — Kitap dili tekleştirilecek

Yazım dili şu olacak:

```text
Saf Türkçe
Teknik ama anlaşılır
Genç programcıya hitap eden
Boş cümlesiz
Örnekli
Akıcı
Paragrafları birbirine bağlı
```

Her bölüm şöyle akacak:

```text
Önce fikir
Sonra syntax
Sonra küçük örnek
Sonra daha güçlü örnek
Sonra birlikte kullanılan komutlar
Sonra derleyici katmanı
Sonra hızlı özet
```

---

## 20. Adım — Tek kitap üretilecek

Son çıktı:

```text
docs_build/uxbasic_resmi_teknik_kitap_12_06_1.md
docs_build/uxbasic_resmi_teknik_kitap_12_06_1.html
docs_build/uxbasic_resmi_teknik_kitap_12_06_1.pdf
```

Belge tek dosya olacak ama düzenli başlıklarla kitap gibi okunacak.

---

# Şimdi 1. Adımı Başlatıyoruz

Aşağıdaki metin kitabın ilk bölümü olacak. Bunu doğrudan yeni kitabın başına koyacağız.

---

# uXBasic Resmî Teknik Kitabı

## 12.06_1 Çalışan Kaynak Baskısı

uXBasic, BASIC dilinin anlaşılır yazım biçimini modern derleyici mimarisiyle birleştiren çok hedefli bir programlama dilidir. Bu dilde amaç yalnızca birkaç komutu çalıştırmak değildir. Amaç; kaynak koddan başlayıp preprocess, lexer, parser, AST, semantic denetim, MIR, runtime servisleri ve hedef kod üretimine kadar uzanan tam bir programlama sistemi kurmaktır.

Bu kitap, uXBasic’in `12.06_1` çalışan kaynak baskısı temel alınarak hazırlanır. Bu baskıda derleme hattı çalışır durumdadır ve `xtestx project packs` testleri başarıyla tamamlanmıştır. Bu nedenle kitapta uXBasic’in dil yüzeyi çalışır kabul edilir. Ancak burada önemli bir ayrım vardır: her özellik aynı katmandan çalışmaz. Bazı özellikler doğrudan AST yorumlayıcı üzerinden yürür, bazıları MIR yorumlayıcıda anlam kazanır, bazıları preprocess aşamasında kaynak kodu dönüştürür, bazıları runtime servislerine bağlanır, bazıları da JS, WAT/WASM veya x64 kod üretim hattında kullanılır.

Bu ayrımı bilmek, uXBasic’i doğru anlamanın anahtarıdır. Çünkü uXBasic yalnızca bir komut listesi değildir. Bir komutun yazılış biçimi kadar, o komutun derleyicinin hangi katmanında temsil edildiği de önemlidir. Örneğin `IF` komutu kaynak kodda karar yapısıdır; parser onu AST düğümüne dönüştürür, semantic katman koşul ifadesini denetler, MIR katmanı dallanma yapısına indirir, yorumlayıcı veya hedef kod üreticisi de bu kararı çalıştırılabilir hale getirir.

Aynı şekilde `PRINT` yalnızca ekrana yazı basan basit bir komut gibi görünür. Fakat derleyici açısından `PRINT`, ifade çözümleme, tip dönüştürme, runtime çıktı servisi ve hedefe göre farklı üretim yolları taşıyan bir komuttur. AST yorumlayıcıda doğrudan çıktı üretirken, MIR hattında runtime çağrısına dönüşebilir; JS hedefinde `console` veya browser çıktısına, x64 hedefinde ise native runtime servis çağrısına bağlanabilir.

Bu kitapta her komut bu yüzden üç düzeyde anlatılır:

```text
1. Programcı bu komutu nasıl yazar?
2. Komut hangi işi yapar?
3. Derleyici ve runtime içinde hangi yoldan çalışır?
```

Bu yaklaşım kitabı sıradan bir komut kataloğundan ayırır. Okuyucu yalnızca `DIM x AS I32` yazmayı öğrenmez; aynı zamanda bu satırın değişken adı, tip bilgisi, kapsam, bellek alanı ve hedef üretim açısından ne anlama geldiğini de kavrar.

uXBasic’in hedef okuyucusu yalnızca hazır komut arayan kullanıcı değildir. Bu kitap, 17–25 yaş aralığında, biraz algoritma bilen, programlamaya meraklı, “bir dil nasıl çalışır?” sorusunu seven genç programcı için de yazılır. Bu yüzden anlatım sade Türkçe ile yapılır; fakat basitlik adına içerik boşaltılmaz. Her bölümde önce fikir verilir, sonra syntax yazılır, sonra çalışan örnek gösterilir, ardından aynı komutun başka komutlarla nasıl birleştiği açıklanır.

Bu kitapta gereksiz tekrar yapılmaz. Tablolarda her satır gerçek bir görev açıklar. “Bu komut özel işlem yapar” gibi kullanıcıya faydası olmayan cümleler kullanılmaz. Bir anahtar kelime varsa, onun görevi, yazım biçimi, birlikte çalıştığı yapılar ve örneği verilir. Bir öneri varsa, hemen altında kodla gösterilir. Bir backend anlatılıyorsa, AST, MIR, runtime ve hedef üretim ilişkisi açıkça belirtilir.

uXBasic’te kaynak kodun genel yolculuğu şöyledir:

```text
Kaynak dosya
    ↓
Preprocessor
    ↓
Lexer
    ↓
Parser
    ↓
AST
    ↓
Semantic denetim
    ↓
HIR / MIR
    ↓
AST Interpreter / MIR Interpreter / JS / WAT-WASM / x64
```

AST, kaynak kodun anlam ağacıdır. Parser kaynak kodu AST’ye çevirir. AST interpreter bu ağaç üzerinden doğrudan çalışabilir. MIR ise hedef üretim omurgasıdır. MIR interpreter MIR üzerinden çalışır. JS, WAT/WASM ve x64 üretim hattı MIR seviyesinden destek alır. x64 kod üretimi MIR seviyesindedir; gerektiğinde AST’den kaynak anlamı ve yüksek seviye bilgi alır.

Bu nedenle kitapta bir özellik anlatılırken “var mı yok mu?” sorusu yerine şu soru sorulur:

```text
Bu özellik hangi katmanda anlam kazanıyor?
```

Örneğin `IMPORT(C, "file.c")` bir DLL çağrısı değildir. Derleme zamanı C kaynağı ekleme yoludur. Buna karşılık `CALL(DLL, ...)` dış DLL fonksiyon rotasını kullanır. `DECLARE ... LIB ... ALIAS ...` ise dış fonksiyonun imzasını tanımlar. Bu üç yapı aynı aileye yakın görünse de görevleri farklıdır. Kitap boyunca bu ayrımlar açık tutulur.

Bu kitap sonunda okuyucu yalnızca uXBasic ile program yazmayı değil, aynı zamanda uXBasic’in nasıl düşündüğünü de öğrenmiş olur. Bir komutun syntaxını görür, örneğini çalıştırır, hangi test ailesinde geçtiğini takip eder, derleyici katmanındaki yerini öğrenir ve gerekirse kendi örneğini genişletebilir.

Bu yüzden bu belge bir not defteri değildir. Bu belge, uXBasic’in resmî teknik kitabıdır.

---

# 1. Adımın Dosya Yapısı

Bu metni üretim hattında şu dosyaya koyacağız:

```text
docs_src/00_kitap_kimligi_ve_yazim_yasasi.md
```

Önerilen klasör yapısı:

```text
docs_src/
  00_kitap_kimligi_ve_yazim_yasasi.md
  01_kaynak_gercekligi.md
  02_ilk_programlar.md
  03_degiskenler_ve_tipler.md
  04_operatorler.md
  05_akis_kontrolu.md
  06_fonksiyonlar.md
  07_veri_yapilari.md
  08_type_class_magic.md
  09_namespace_module_include_import.md
  10_preprocessor.md
  11_dosya_islemleri.md
  12_dis_cagrilar_runtime.md
  13_bellek_pointer.md
  14_big_sayi.md
  15_event_thread_pipe_paralel.md
  16_js_wat_wasm_x64.md
  17_cli_build_test.md
  18_yan_araclar.md
  19_cheat_sheetler.md
  20_ekler.md

docs_build/
  uxbasic_resmi_teknik_kitap_12_06_1.md
```

---

Bir sonraki adımda **2. Adım: eski PCK belgelerini parçalama ve tekrar temizleme sistemi** yazılacak.
