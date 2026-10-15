# Cilt I: uXBasic Dil, Tip Sistemi ve Araç Zinciri

## Kitabın amacı

Bu cilt, uXBasic kaynak dosyasının nasıl yazıldığını ve aynı kaynağın lexer,
parser, semantik analiz, HIR/MIR, yorumlayıcı ve hedef backend yollarından nasıl
geçirildiğini öğretir. Okur bölüm sonunda:

- `.bas`, `.uxb` ve `.uxm` kaynaklarını doğru seçebilir;
- değişken, tip, operatör, yordam ve kontrol akışı yazabilir;
- AST ve MIR yorumlayıcılarını ayrı ayrı çalıştırabilir;
- x64 NASM, JavaScript, browser, WAT ve WASM artifact'i isteyebilir;
- JSON ve log dosyalarını gerçek kanıt olarak denetleyebilir.

## 1. Derleyiciyi tanıma

Ana derleyici kaynak girişi `src/main.bas` dosyasıdır. Dağıtım yürütülebiliri
`bin/uxb.exe` altında bulunur. `compiler/wrappers/uxb_main_wrapper.bas`,
`src/main.bas` dosyasını derlemeye bağlayan FreeBASIC sarmalayıcısıdır.

Temel include sırası özetle şöyledir:

1. ortak yardımcılar ve runtime entegrasyonu;
2. CLI ve önişlemci;
3. lexer, parser ve AST;
4. semantik analiz, tip bağlama ve layout;
5. HIR/MIR üretimi ve doğrulaması;
6. AST/MIR yorumlayıcı;
7. x64, JS, browser ve WAT/WASM backend'leri;
8. artifact, rapor ve program giriş katmanı.

Bu sıra önemlidir. Örneğin lexer'a eklenen bir kelime parser tarafından
karşılanmıyorsa dil özelliği tamamlanmış değildir.

## 2. Windows 11 x64 ortamı

Önerilen çalışma dizini:

```powershell
Set-Location C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb
```

Derleyici sürümü ve yardım:

```powershell
.\bin\uxb.exe ver
.\bin\uxb.exe hlp
```

FreeBASIC ile derleyiciyi üretmek için kök script:

```powershell
.\build_64.bat
```

Script'in asıl işi `compiler/scripts/build_uxb_main_64.ps1` içindedir. Release
ve x86 atlama seçimleri doğrudan PowerShell script'inde bulunur:

```powershell
powershell -ExecutionPolicy Bypass -File .\compiler\scripts\build_uxb_main_64.ps1 `
  -Root (Get-Location).Path -Release -SkipX86
```

Tam derleme birkaç dakika sürebilir. Derleme süresi ve EXE büyüklüğü yalnız
başarı ölçütü değildir. Include grafiği, debug sembolleri, gömülü tablolar ve
aynı runtime'ın yinelenen bağlantısı ayrıca III. ciltte incelenir.

## 3. Kaynak dosya türleri

| Uzantı | Görev |
|---|---|
| `.bas` | Genel uXBasic kaynak dosyası |
| `.uxb` | uXBasic uygulama kaynağı |
| `.uxm` | Modül veya hedefe verilecek kaynak birimi |
| `.uxmh` | Include edilen genel başlık; doğrudan program gibi çalıştırılmaz |
| `.uxcli` | CLI komut/proje dosyası |

Başlık kullanımı:

```text
INCLUDE "include/modules/uxstats.uxmh"
```

`include/modules/*.uxmh` dosyaları `libsx/<modül>/<modül>.bas` dosyasına
yönlendiren genel başlıklardır. Aynı çözülmüş yolun yeniden eklenmesini
önişlemci include-once kaydı engeller.

## 4. CLI fiilleri

| Fiil | Katman veya sonuç |
|---|---|
| `lex` | önişleme ve token akışı |
| `par` | sözdizimi çözümleme |
| `ast` | AST ve sözleşme denetimi |
| `sem` | semantik analiz ve tip bağlama |
| `hir` | yüksek seviyeli ara gösterim |
| `mir` | orta seviyeli ara gösterim ve doğrulama |
| `int` | seçilen yorumlayıcıyla yürütme |
| `run` | program çalıştırma kolaylığı |
| `x64` | x64 NASM üretimi |
| `jsw` | JavaScript/browser üretimi |
| `wat` | WAT ve isteğe bağlı WASM üretimi |
| `bld` | x64 EXE derleme ve bağlama |
| `chk` | toplu doğrulama |
| `fmt` | biçim denetimi |
| `map` | kaynak haritası |
| `doc` | makine okunur belge artifact'i |
| `rel` | sürüm kapısı |
| `hlp`, `ver` | yardım ve sürüm |

AST ve MIR yorumlayıcıları:

```powershell
.\bin\uxb.exe int .\program.uxb --interpreter-backend AST
.\bin\uxb.exe int .\program.uxb --interpreter-backend MIR
```

Bu seçim `--x64-mode` değildir. `--interpreter-backend` yürütme motorunu,
`--codegen-source` ve x64 seçenekleri ise kod üretim yolunu seçer.

### 4.1 x64 NASM ve EXE

ASM dosyasını uXBasic derleyicisi üretir:

```powershell
.\bin\uxb.exe x64 .\program.uxb `
  --emit-x64-nasm `
  --emit-x64-nasm-out .\build\program.asm
```

EXE üretimi:

```powershell
.\bin\uxb.exe bld .\program.uxb `
  --build-x64 `
  --build-x64-out .\build\program.exe
```

Elle yazılmış ASM yalnız backend'i karşılaştırmalı sınamak için kullanılabilir.
Bir uXBasic programının native kanıtı, ASM'nin `uxb.exe` tarafından üretilmesi
ve aynı artifact zincirinden bağlanmasıdır.

### 4.2 JavaScript ve browser

```powershell
.\bin\uxb.exe jsw .\program.uxb `
  --emit-js `
  --js-out .\dist\program.js
```

Canvas/browser kaynağı:

```powershell
.\bin\uxb.exe jsw .\pano.uxb `
  --emit-browser `
  --emit-js `
  --html-out .\dist\index.html `
  --js-out .\dist\app.js `
  --manifest-out .\dist\manifest.json
```

### 4.3 WAT ve WASM

```powershell
.\bin\uxb.exe wat .\modul.uxm `
  --emit-wat `
  --emit-wasm `
  --wat-out .\dist\modul.wat `
  --wasm-out .\dist\modul.wasm `
  --wat2wasm=.\tools\wabt\bin\wat2wasm.exe
```

WAT backend'i desteklemediği veri için sahte sonuç üretmek yerine hata verir.
Özellikle string linear-memory düşürmesi tamamlanmamış bir yolda metin sabiti
görürse derleme durur. Sayısal modül ile browser metin katmanını ayırmak doğru
tasarımdır.

## 5. Program yapısı

Yordamlar `MAIN` dışında bildirilir. Uygulama başlangıcı:

```text
FUNCTION IkiKat(BYVAL deger AS I32) AS I32
    RETURN deger * 2
END FUNCTION

MAIN
    DIM sonuc AS I32
    sonuc = IkiKat(21)
    ASSERT sonuc = 42
    PRINT sonuc
END MAIN
```

Küçük kaynaklarda üst düzey deyimler de yürütülebilir. Büyük projelerde tek bir
`MAIN ... END MAIN` başlangıcı kapsam ve araç raporlarını daha anlaşılır kılar.

## 6. Adlar, yorumlar ve ayraçlar

- Anahtar sözcükler büyük/küçük harfe duyarsızdır.
- Değişken, yordam ve tip adlarında harf, sayı ve alt çizgi kullanılır.
- Tek tırnak satır yorumudur.
- Satır sonu temel deyim ayırıcısıdır; bazı yüzeylerde `:` aynı satırda ayırıcı
  olabilir.
- `$`, `%` ve `!` değişken tip son eki değildir.
- String yordam adını `$` ile yazan eski backend eş adları iç uygulamada
  görülebilir; yeni kullanıcı kodu son eksiz biçimi kullanır.

## 7. Çekirdek tip sistemi

### 7.1 Tam sayılar

| Tip | Boyut | İşaret |
|---|---:|---|
| `I8` | 1 byte | işaretli |
| `U8` | 1 byte | işaretsiz |
| `I16` | 2 byte | işaretli |
| `U16` | 2 byte | işaretsiz |
| `I32` | 4 byte | işaretli |
| `U32` | 4 byte | işaretsiz |
| `I64` | 8 byte | işaretli |
| `U64` | 8 byte | işaretsiz |

Dar tipe atamada açık dönüşüm gerekir:

```text
DIM bayrak AS U8
bayrak = U8(3)
```

Bu kural, `I32` sabitin sessizce kesilmesini engeller.

### 7.2 Kayan nokta ve geniş sayılar

| Tip | Uygulama |
|---|---|
| `F32` | 32 bit çekirdek kayan nokta |
| `F64` | 64 bit çekirdek kayan nokta |
| `F80` | genişletilmiş runtime |
| `F128` | genişletilmiş runtime |
| `BIGINT` / `BIGI` | büyük tam sayı runtime'ı |
| `BIGF` | büyük kayan nokta runtime'ı |
| `BIGD` | büyük ondalık runtime'ı |
| `BALL` | hata yarıçaplı/aralık benzeri geniş sayı runtime'ı |

`F8` ve `F16` genel dil tipi değildir. `F80` ve üzeri tiplerin hedef programda
çalışması ilgili runtime DLL'inin paketlenmesini gerektirir.

### 7.3 Diğer tipler

| Tip | Kullanım |
|---|---|
| `BOOLEAN` | `TRUE=-1`, `FALSE=0` mantıksal değer |
| `STRING` | metin |
| `PTR` | genel işaretçi |
| `STRPTR`, `WSTRPTR` | FFI metin işaretçisi |
| `OBJECT` | dinamik değer/nesne taşıma |
| `ARRAY` | dizi yüzeyi |
| `LIST`, `DICT`, `SET` | çekirdek koleksiyon tutacağı |
| kullanıcı `TYPE`/`CLASS` | yerleşimli yapı veya nesne |

### 7.4 Tip eş adları

`src/type_binding/type_rules.fbs` bazı FreeBASIC kökenli adları iç uyumluluk
için kanonik tiplere çevirir. Yeni uXBasic kodunda `INTEGER`, `LONG`,
`SINGLE`, `DOUBLE` yerine sırasıyla açık `I32`, uygun `I/U` genişliği ve
`F32/F64` kullanılmalıdır. ABI ve bellek yerleşimi bu açık adlarla okunur.

## 8. Bildirimler

```text
DIM sayac AS I32
DIM oran AS F64 = 0.25
DIM ad AS STRING
CONST EN_YUKSEK = 100
```

Çoklu boyut ve sınır sözdizimi parser tarafından `DIM`/`REDIM` bildirimlerinde
çözülür:

```text
DIM puanlar(0 TO 9) AS I32
REDIM puanlar(0 TO 99) AS I32
```

Kullanıcı tipi:

```text
TYPE Paket
    kod AS I32
    agirlik AS F64
    bayrak AS U8
END TYPE

DIM p AS Paket
p.kod = 7001
```

Yerleşim bilgileri:

```text
PRINT SIZEOF(Paket)
PRINT OFFSETOF(Paket, "agirlik")
```

## 9. Sayı sabitleri ve tabanlar

Lexer aşağıdaki sayı öneklerini tanır:

| Taban | Biçimler |
|---|---|
| onaltılık | `&HFF`, `0xFF` |
| sekizlik | `&O77`, `0o77` |
| ikilik | `&B1010`, `%B1010`, `0b1010` |
| onluk | öneksiz sayı |

`HEX`, `OCT` ve `BIN` sayıyı metinsel taban gösterimine dönüştüren yerel
fonksiyon yüzeyidir. `DEC` ise aynı bağlamda taban dönüştürücü değildir;
`DEC x` azaltma deyimidir.

## 10. Operatörler

### 10.1 Öncelik

Kaynak parser sözleşmesinde yüksekten düşüğe ana sıra:

1. üye, çağrı, indeks ve postfix;
2. `**`;
3. unary `++`, `--`, `+`, `-`, `@`, `!`, `~`, `NOT`;
4. `*`, `/`, `\`, `%`, `MOD`;
5. `+`, `-`;
6. `<<`, `>>`, `SHL`, `SHR`, `ROL`, `ROR`;
7. karşılaştırmalar;
8. bit düzeyi `&`, `XOR`/`^`, `|`;
9. mantıksal aileler;
10. `|>`;
11. `?:`;
12. atamalar.

### 10.2 Aritmetik

| Operatör | Anlam |
|---|---|
| `+ - *` | toplama, çıkarma, çarpma |
| `/` | kayan nokta bölme |
| `\` | tam sayı bölme |
| `%`, `MOD` | kalan |
| `**` | üs |
| `^` | XOR; üs değildir |

### 10.3 Karşılaştırma

`=`, `<>`, `<`, `<=`, `>`, `>=` temel biçimlerdir. İfade bağlamında `==`,
`!=` sırasıyla `=`, `<>` olarak kanonikleşir. Deyim sol tarafında `=`
atamadır.

### 10.4 Mantıksal ve bit düzeyi işlemler

`AND`, `OR`, `XOR` tip duyarlı ve eager işlemlerdir. `ANDALSO`, `ORELSE`,
`&&`, `||` kısa devre yoludur.

Geniş mantık ailesi:

| Aile | Adlar |
|---|---|
| ve | `AND`, `ANDALSO`, `NAND`, `NIMP`, `NCIMP` |
| eşdeğer | `XNOR`; eş adlar `NXOR`, `EQV`, `EQA`, `IFF` |
| veya | `OR`, `ORELSE`, `NOR`, `IMP`, `CIMP`, `IDA`, `IDB`, `NOTA`, `NOTB` |

`ZERO` ve `ONE`, mantık sözleşmesinde `FALSE` ve `TRUE` olarak
kanonikleşir.

### 10.5 Atama ve artırma

`+=`, `-=`, `*=`, `/=`, `\=`, `%=`, `&=`, `|=`, `^=`, `<<=`, `>>=`,
`**=`, `ROL=`, `ROR=` desteklenen bileşik biçimlerdir. Ayrıca:

```text
INC sayac
DEC sayac
```

## 11. Kontrol akışı

### 11.1 Koşul

```text
IF puan >= 80 THEN
    PRINT "YUKSEK"
ELSEIF puan >= 50 THEN
    PRINT "ORTA"
ELSE
    PRINT "DUSUK"
END IF
```

`SELECT CASE`, `CASE IS` ve `END SELECT` çoklu seçim yüzeyidir.

### 11.2 Döngüler

```text
FOR i = 0 TO 9 STEP 1
    PRINT i
NEXT

WHILE hazir = FALSE
    CALL Bekle()
WEND

DO
    sayac += 1
LOOP UNTIL sayac = 10
```

`FOR EACH ... IN`, `DO EACH`, `EXIT` ve ilgili sonlandırıcılar parser akış
modülünde ayrı yollarla ele alınır.

### 11.3 Hata akışı

```text
TRY
    ASSERT adet > 0
CATCH hata
    PRINT hata
FINALLY
    PRINT "KAPANIS"
END TRY
```

`THROW` hata üretir; `ASSERT` yanlış koşulda çalışmayı tanılı biçimde keser.
Test programlarında `ASSERT`, sessiz yanlış sonucu engelleyen temel araçtır.

## 12. Yordamlar

```text
SUB Kaydet(BYVAL kod AS I32)
    PRINT kod
END SUB

FUNCTION Topla(BYVAL a AS I32, BYVAL b AS I32) AS I32
    RETURN a + b
END FUNCTION
```

Parametre aktarımı:

- `BYVAL` değeri aktarır.
- `BYREF` çağıranın değişkenine başvuru aktarır.
- `CDECL` ve `STDCALL` dış çağrı düzenidir; normal uXBasic yordam bildirimiyle
  karıştırılmaz.

Normal çağrıların kabul edilen yüzeyleri:

```text
sonuc = Topla(3, 4)
CALL Topla(3, 4)
CALL(Topla, 3, 4)
```

Dış çağrı için `CALL(DLL,...)` ve `CALL(API,...)` IV. ciltte anlatılır.

## 13. Yerel fonksiyon kayıt tablosu

`src/type_binding/type_builtin_registry.fbs` mevcut tip dönüş sözleşmesinde 51
kayıt taşır:

| Grup | İşlevler | Dönüş |
|---|---|---|
| metin uzunluk/değer | `LEN`, `VAL`, `VALINT` | `I32`, `F64`, `I32` |
| metin üretimi | `STR`, `LEFT`, `RIGHT`, `MID`, `CHR` | `STRING` |
| metin arama | `INSTR`, `ASC` | `I32` |
| matematik | `ABS`, `SIN`, `COS`, `TAN`, `ATN`, `LOG`, `EXP`, `SQR`, `SQRT` | `F64` |
| rastgele/zaman | `RND`, `TIMER` | `F64` |
| sayı yardımcıları | `SGN`, `INT`, `CINT`, `CLNG` | `I32` |
| dönüşüm | `CSNG`, `CDBL` | `F64` |
| harf/boşluk | `LCASE`, `UCASE`, `TRIM`, `LTRIM`, `RTRIM` | `STRING` |
| konsol | `INPUT` | `STRING` |
| işaretçi | `STRPTR`, `WSTRPTR`, `PTR`, `CASTPTR`, `VARPTR`, `SADD` | işaretçi ailesi |
| geniş sayı | `BIGINIT`, `F80`, `F128`, `BIGF`, `BIGD`, `BALL` | ilgili runtime tipi |
| yerleşim | `SIZEOF`, `OFFSETOF` | `I32` |
| bellek okuma | `PEEK`, `PEEKB`, `PEEKW`, `PEEKD` | `I32/U8/U16/I32` |

Runtime ayrıca `FIX`, `SPACE`, `HEX`, `OCT`, `BIN`, `LOF`, `EOF`, `INKEY`,
`GETKEY`, koleksiyon çağrıları ve başka hizmetleri yönlendirir. Tip kayıt
tablosu ile runtime listesi arasındaki fark, derleyici geliştiricisinin III.
ciltte kapatacağı bir tutarlılık alanıdır.

## 14. Konsol ve dosya I/O

Konsol:

```text
PRINT "ADET="; adet
INPUT "KOD", kod
CLS
COLOR 15, 1
LOCATE 1, 1
```

Dosya:

```text
OPEN "rapor.txt" FOR OUTPUT AS #1
PRINT #1, "42"
CLOSE #1

DIM deger AS I32
OPEN "rapor.txt" FOR INPUT AS #2
INPUT #2, deger
CLOSE #2
```

`#1` bir tip son eki değil dosya kanalıdır. Kanal numarası sabit veya uygun
değişken olabilir. `OPEN` modları `INPUT`, `OUTPUT`, `APPEND`, `BINARY` ve
uyumlu kısa biçimler üzerinden runtime dosya katmanına iner. `GET`, `PUT`,
`SEEK`, `LOF`, `EOF` ikili ve konumlu erişim içindir.

## 15. Önişlemciye giriş

Kaynak önişlemci seçimi:

```text
%%PP A
```

veya:

```text
%%PP B
```

`%%PP` yalnız `A` veya `B` kabul eder. A hattı makro, koşul, include, meta,
asset ve hedef üretim komutlarını; B hattı paket/manifest/browser proje
yardımcılarını genişletir.

Basit A örneği:

```text
%%PP A
%%DEFINE KOLI_ADEDI 7
%%DEFINE BIRIM_UCRET 12
%%EVAL TOPLAM = KOLI_ADEDI * BIRIM_UCRET
DIM metaSonuc AS I32
metaSonuc = %%EVAL(TOPLAM)
```

Makro adları kaynak metninde değiştirilir. Çalışma zamanı değişkenine makroyla
aynı adı vermek, değişken adının da genişlemesine yol açar.

## 16. Artifact ve tanı dosyaları

Doğrulanmış temel örnek:

```powershell
.\bin\uxb.exe ast .\program.uxb `
  --ast-json-out .\reports\program.ast.json
```

Sonra:

```powershell
Get-Content .\reports\program.ast.json -Raw | ConvertFrom-Json | Out-Null
```

CLI registry'de görünmek tek başına artifact yazarı olduğu anlamına gelmez.
Örneğin mevcut kaynakta `--semantic-json-out` kaydı bulunurken doğrudan
semantic writer bağlantısı eksik kalabilir. III. cilt, registry, seçenek
ayrıştırma, pipeline ve writer bağlarını birlikte test etmeyi öğretir.

Önemli çıktı seçenekleri:

| Katman | Artifact |
|---|---|
| lexer | `--tokens-json-out`, `--preprocessed-out` |
| parser/AST | `--parser-json-out`, `--ast-json-out` |
| semantik | `--semantic-json-out`, `--symbol-table-json-out`, `--type-table-json-out` |
| layout | `--layout-report-json-out` |
| HIR/MIR | `--hir-json-out`, `--mir-full-json-out`, `--mir-verify-json-out` |
| x64 | `--emit-x64-nasm-out`, `--x64-codegen-policy-json-out` |
| web | `--js-out`, `--html-out`, `--wat-out`, `--wasm-out`, `--manifest-out` |
| genel | `--pipeline-json-out`, `--artifact-report-json-out`, `--log-out` |

## 17. Çalışan örnek: kargo ücreti

Tam kaynak:
[examples/cilt1/01_kargo_ucreti.uxb](examples/cilt1/01_kargo_ucreti.uxb)

Program, `I32` parametreli bir fonksiyonla ağırlık ve uzaklık ücretini
hesaplar. `\` kullanımı uzaklık payını tam sayı yapar. `ASSERT ucret = 79`,
matematiğin yalnız yazdırılmasını değil doğrulanmasını sağlar.

Çalıştırma:

```powershell
.\bin\uxb.exe int .\docs\uxbasic_5_cilt\examples\cilt1\01_kargo_ucreti.uxb `
  --interpreter-backend AST
.\bin\uxb.exe int .\docs\uxbasic_5_cilt\examples\cilt1\01_kargo_ucreti.uxb `
  --interpreter-backend MIR
```

## 18. Çalışan örnek: paket bayrakları

Tam kaynak:
[examples/cilt1/02_paket_bayraklari.uxb](examples/cilt1/02_paket_bayraklari.uxb)

Örnek `U8` açık dönüşümünü, `OR` ile bayrak birleştirmeyi ve `AND` ile bayrak
sınamayı gösterir. `ekspres` bitinin kapalı olduğu da ayrıca doğrulanır.

## 19. Çalışan örnek: önişlemci A

Tam kaynak:
[examples/cilt1/03_preprocessor_a.uxb](examples/cilt1/03_preprocessor_a.uxb)

Bu örnekte `%%EVAL` sonucu 84'tür. Kaynak önişleme çıktısını görmek için:

```powershell
.\bin\uxb.exe lex .\docs\uxbasic_5_cilt\examples\cilt1\03_preprocessor_a.uxb `
  --preprocessed-out .\reports\cilt1_preprocessed.uxb
```

Önişlenmiş dosyada `%%` komutlarının kalmaması ve `metaSonuc = 84` benzeri
gerçek kaynak oluşması beklenir.

## 20. Cilt sonu kontrol listesi

- Kanonik `I/U/F` tipleriyle bildirim yazabiliyor musunuz?
- `/`, `\`, `**` ve `^` farkını biliyor musunuz?
- `AND` ile `ANDALSO` farkını çalıştırarak gösterebiliyor musunuz?
- AST ve MIR yorumlayıcısını ayrı ayrı seçebiliyor musunuz?
- ASM'nin uXBasic derleyicisinden çıktığını kanıtlayabiliyor musunuz?
- İstenen JSON/ASM/JS/WAT dosyasının gerçekten oluştuğunu denetliyor musunuz?
- Pozitif testte beklenen değeri, negatif testte beklenen tanıyı sınadınız mı?

Bu soruların tümüne olumlu cevap verilmeden II. ciltteki birleşik dil
yüzeylerine geçilmemelidir.
