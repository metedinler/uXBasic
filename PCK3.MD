# uXBasic Programcinin Cep ve Muhendislik Kitabi (PCK3)

Bu belge, PCK2 merkez alinarak hazirlandi.
Hedef: yeni baslayandan compiler gelistiricisine net yol sunmak.

## Icindekiler

1. Hedef, kapsam, yontem
2. Yazim kurallari ve dil sozlesmesi
3. Anahtar kelime siniflari (tablo + aciklama)
4. Temel syntax ve calisma ornekleri
5. Runtime hata kodlari ve fail-fast modeli
6. uXBasic mimarisi: modul modul calisma mantigi
7. Sifirdan compiler kurma dersi (uXBasic odakli yol)
8. Kod sertlestirme kurallari
9. Proje ornekleri: tahmin oyunu, mini tetris, basit noron
10. Kisaltmalar ve teknik terimler (TR + EN)

## 1) Hedef, Kapsam, Yontem

- Bu belge PCK2 icerigindeki dogru bolumleri derler.
- Anlatim modeli: tablo + madde + kod.
- Referans: src/main.bas, src/parser, src/semantic, src/runtime, src/build.

Okuma sirasi: yazim kurallari -> anahtar kelime siniflari -> temel syntax -> hata modeli -> mimari -> compiler kurma dersi -> proje ornekleri.

## 2) Yazim Kurallari ve Dil Sozlesmesi

### 2.1 Identifier kurali

- Baslangic: harf veya _
- Devam: harf, rakam veya _
- Pratik regex: [A-Za-z_][A-Za-z0-9_]*

Sonuc:

- x%, name$, pid& gibi son ekli adlar strict profilde kabul edilmez.
- Tip belirtimi AS TYPE ile yapilir.

### 2.2 Tip ve syntax disiplini

- Builtin tipler: I8/U8/I16/U16/I32/U32/I64/U64/F32/F64/F80/BOOLEAN/STRING.
- Yapisal tipler: ARRAY/TYPE/CLASS/LIST/DICT/SET.
- STRING * N gibi eski notasyon parser gerceginde temel yol degildir.

### 2.3 Kodlama standardi

- Kisa satirlar, acik isimler, tek sorumluluklu SUB/FUNCTION.
- Her kritik bloktan once 1 satirlik niyet yorumu.
- Fail-fast: hata aninda acik mesaj + erken cikis.

## 3) Anahtar Kelime Siniflari

### 3.1 Siniflandirma tablosu

| Sinif | Anahtar kelimeler / yapilar | Amac |
|---|---|---|
| Akis | IF, ELSEIF, ELSE, END IF, SELECT CASE, CASE, FOR, DO, LOOP, GOTO, GOSUB, RETURN, EXIT, END | Kontrol akisi |
| Deklarasyon | CONST, DIM, REDIM, TYPE, CLASS, DECLARE, SUB, FUNCTION, DEFINT..DEFBYT, SETSTRINGSIZE | Veri ve prosedur tanimi |
| OOP | CLASS, METHOD, CONSTRUCTOR, DESTRUCTOR, EXTENDS, INTERFACE, IMPLEMENTS, THIS, ME, CALL | Nesne modeli |
| I/O | PRINT, INPUT, OPEN, CLOSE, GET, PUT, SEEK, LOCATE, COLOR, CLS, LOF, EOF | Ekran ve dosya islemleri |
| Bellek | PEEKB/W/D, POKEB/W/D, MEMCOPYB/W/D, MEMFILLB/W/D, VARPTR, SADD, LPTR, CODEPTR, SIZEOF, OFFSETOF | Dusuk seviye kontrol |
| Preprocess | INCLUDE, IMPORT, INLINE...END INLINE, %% komutlari | Derleme oncesi yonetim |
| Fonksiyon | LEN, MID, STR, VAL, ABS, INT, SQR, SIN, COS, TAN, ATN, EXP, LOG, RND, TIMER | Hazir hesap ve yardimci fonksiyonlar |
| Operator | + - * / \\ MOD ** << >> = <> < > <= >= AND XOR OR NOT @ ve bilesik atamalar | Ifade degerlendirme |

### 3.2 Metin icinde aciklama

Akis komutlari karar ve tekrar mekanigidir. Deklarasyon komutlari veri modelini kurar. OOP davranisi siniflarda toplar. I/O komutlari dis dunya ile bag kurar. Bellek komutlari hizlidir; sinir kontrolu zorunludur.

## 4) Temel Syntax ve Calisma Ornekleri

### 4.1 Kosul ve dongu

```basic
DIM x AS I32
x = 7

IF x > 10 THEN
    PRINT "buyuk"
ELSEIF x = 10 THEN
    PRINT "esit"
ELSE
    PRINT "kucuk"
END IF

FOR i AS I32 = 1 TO 3
    PRINT i
NEXT i
```

Aciklama:

- IF blogu tek bir karar agaci olusturur.
- FOR blogu sayaçli tekrar icin net ve guvenlidir.

### 4.2 SUB/FUNCTION ve veri gecisi

```basic
DECLARE FUNCTION Topla(a AS I32, b AS I32) AS I32

FUNCTION Topla(a AS I32, b AS I32) AS I32
    RETURN a + b
END FUNCTION

PRINT Topla(3, 4)
```

Aciklama:

- FUNCTION deger dondurur, SUB is yapar.
- Parametre tiplerini acik yazmak semantic hatalari erken yakalar.

### 4.3 Dosya I/O

```basic
OPEN "ornek.bin" FOR BINARY AS #1
PUT #1, 1, 123
SEEK #1, 1
DIM v AS I32
GET #1, v
CLOSE #1
PRINT v
```

Aciklama:

- OPEN/CLOSE kaynak yonetiminin temelidir.
- SEEK kayit yerini kontrol eder; yanlis konum fail-fast ile yakalanmalidir.

### 4.4 Bellek islemleri

```basic
POKED 7000, 42
PRINT PEEKD(7000)
MEMFILLB 7100, 16, 65
```

Aciklama:

- Bellek komutlari hizlidir fakat adres dogrulama ister.
- Guvenli aralik disina cikma durumunda hata dondurulmelidir.

## 5) Runtime Hata Kodlari ve Fail-Fast Modeli

### 5.1 Dosya hata kodlari (src/runtime/file_io.fbs)

| Kod | Sabit | Anlam |
|---|---|---|
| 7001 | UXB_FILE_ERR_BAD_CHANNEL | Gecersiz kanal |
| 7002 | UXB_FILE_ERR_CHANNEL_NOT_OPEN | Kanal acik degil |
| 7003 | UXB_FILE_ERR_CHANNEL_ALREADY_OPEN | Kanal zaten acik |
| 7004 | UXB_FILE_ERR_INVALID_MODE | Gecersiz mod |
| 7005 | UXB_FILE_ERR_INVALID_ARGUMENT | Gecersiz arguman |
| 7006 | UXB_FILE_ERR_MODE_NOT_READABLE | Okuma izni yok |
| 7007 | UXB_FILE_ERR_MODE_NOT_WRITABLE | Yazma izni yok |
| 7008 | UXB_FILE_ERR_SEEK_NOT_ALLOWED | Seek izinli degil |
| 7009 | UXB_FILE_ERR_SEEK_OUT_OF_RANGE | Seek aralik disi |
| 7010 | UXB_FILE_ERR_IO | Genel I/O hatasi |
| 7011 | UXB_FILE_ERR_EOF | Dosya sonu |
| 7012 | UXB_FILE_ERR_NOT_FOUND | Dosya bulunamadi |
| 7013 | UXB_FILE_ERR_ACCESS_DENIED | Erisim reddedildi |

### 5.2 FFI ve kontrol akisi kodlari (src/runtime/memory_exec.fbs)

| Kod | Sabit | Anlam |
|---|---|---|
| 9201-9205 | UXB_FFI_ERR_BAD_ARITY..BYREF_TARGET | DLL cagrisi imza/arguman hatalari |
| 9206 | UXB_FFI_ERR_POLICY_DENY | Politika reddi |
| 9207-9209 | UXB_FFI_ERR_DLL_PATH_SEGMENTS..INVALID_CHARS | DLL yol/karekter guvenlik hatasi |
| 9210-9215 | UXB_FFI_ERR_POLICY_* | Attestation/hash/signer politika hatalari |
| 9301 | UXB_CTRL_ERR_RETURN_WITHOUT_GOSUB | GOSUB disinda RETURN |

### 5.3 Fail-fast prensibi

- Hata saklanmaz, erken raporlanir.
- Mesaj formati: teknik sebep + kod.
- Cikis kodu semantigi src/main.bas ile tutarli tutulur.

## 6) uXBasic Mimarisi: Modul Modul Calisma Mantigi

### 6.1 Ust seviye akis (gercek pipeline)

1. Kaynak oku (LoadTextFile)
2. LexerInit
3. ParserInit + ParseProgram
4. SemanticAnalyze (opsiyonel semantic mode)
5. ExecRunMemoryProgram (opsiyonel execmem mode)
6. ResolveInteropManifestForSource + EmitInteropArtifacts (opsiyonel interop mode)
7. LegacyGetCommands (raporlama)

### 6.2 Modul sorumluluk tablosu

| Modul | Ana dosyalar | Sistem mantigi |
|---|---|---|
| Giris | src/main.bas | Pipeline orkestrasyonu, cikis kodlari, log |
| Lexer | src/parser/lexer.fbs ve src/parser/lexer/* | Metni token dizisine cevirme |
| Parser | src/parser/parser.fbs ve src/parser/parser/* | Tokenlardan AST kurma |
| AST | src/parser/ast.fbs | Dugum havuzu ve agac baglari |
| Semantic | src/semantic/semantic_pass.fbs, type_binding.fbs, layout.fbs | Tip, kapsam, semantic dogrulama |
| Runtime cekirdek | src/runtime/memory_exec.fbs | AST yurutme, call dispatch, fail-fast |
| Runtime exec alt modulleri | src/runtime/exec/* | Akis, io, bellek, text, collection isleyicileri |
| Dosya katmani | src/runtime/file_io.fbs | Kanal/seek/get/put semantigi |
| Interop | src/build/interop_manifest.fbs, src/runtime/ffi_signer.fbs | Include/import manifest ve policy |
| Tani/yerellestirme | src/runtime/diagnostics.fbs, error_format.fbs, error_localization.fbs | Hata mesaji ve log standardi |

### 6.3 Her sistem nasil calisir

Lexer:
- Girdi metnini satir-sutun bilgisiyle tarar.
- Cikti: token listesi + lexer durum bilgisi.

Parser:
- Recursive-descent ile ifade ve komutlari ayrisir.
- Komut turune gore parser_stmt_* dosyalarina dispatch eder.
- Cikti: AST kok dugumu + parse hatalari.

Semantic:
- Sembol ve tip baglamini kurar.
- Bos type ref, gecersiz call/import/input gibi kurallari denetler.
- Cikti: yurutmeye hazir semantic-acik AST.

Runtime:
- AST dugumlerini degerlendirir.
- I/O, bellek, akis komutlarini exec alt modullerine yonlendirir.

Interop:
- INCLUDE/IMPORT bilgisini manifestte toplar.
- dist/interop altina artifact yazar.
- Policy uyumsuzlugunda fail-fast verir.

## 7) Sifirdan Compiler Kurma Dersi (uXBasic Yol Haritasi)

### 7.1 Asama plani

1. Dil cekirdegini sec: tipler, ifade kurallari, komut listesi.
2. Lexer yaz: token turleri + satir/sutun izleme.
3. Parser yaz: recursive-descent + AST modeli.
4. Semantic pass yaz: tip denetimi, kapsam kurallari, sozlesme kontrolu.
5. Runtime veya IR sec:
   - Hizli prototip icin AST interpreter.
   - Olcekleme icin MIR/SSA + codegen.
6. Hata modeli kur: kodlu, yerellestirilebilir, fail-fast.
7. Test katmani kur: parse fail, semantic fail, runtime fail, pozitif senaryo.

### 7.2 uXBasic icin tasarim kurallari

- Parser gercegi, dokumanin ustundedir.
- Yeni keyword icin lexer + parser + semantic + runtime + test birlikte guncellenir.
- Geriye uyumluluk gerekiyorsa legacy notu acik yazilir.

### 7.3 Kod sertlestirme (compiler engineering)

- Her dis girdide sanitization: path, symbol, arity, signature.
- Her pointer/bellek isleminde sinir ve tip dogrulamasi.
- Her file I/O adiminda kanal durumu kontrolu.
- Her kritik fonksiyonda tek cikis noktasi yerine anlamli hata kodu.
- Log formati standard olsun: kaynak, kod, sebep, etki.

## 8) Kod Sertlestirme Kurallari (Pratik Ceklist)

| Kural | Neden | Uygulama |
|---|---|---|
| Arity kontrolu | Yanlis cagriyi erken yakala | CALL(DLL), ctor/dtor, intrinsic |
| Tip kontrolu | Sessiz veri bozulmasini engelle | AS TYPE ve semantic pass |
| Path guvenligi | DLL/path saldirisini engelle | absolute/path-segment yasagi |
| Durum kontrolu | Runtime tutarlilik | kanal acik mi, seek aralikta mi |
| Kapsam kontrolu | Isim cakismasi ve yan etkiyi azalt | symbol table ve scope seviyesi |
| Test zorunlulugu | Regressioni engelle | her yeni ozellikte pozitif+negatif test |

## 9) Proje Ornekleri

Asagidaki ornekler ogreticidir: once calistir, sonra adim adim gelistir.

### 9.1 Sayi Tahmin Oyunu

```basic
RANDOMIZE TIMER
DIM hedef AS I32
DIM tahmin AS I32
DIM deneme AS I32

hedef = INT(RND * 100) + 1
PRINT "1-100 arasi bir sayi tuttum."

DO
    deneme = deneme + 1
    INPUT "Tahminin: "; tahmin

    IF tahmin < hedef THEN
        PRINT "Daha buyuk dene."
    ELSEIF tahmin > hedef THEN
        PRINT "Daha kucuk dene."
    ELSE
        PRINT "Bildin! Deneme sayisi: "; deneme
        EXIT DO
    END IF
LOOP
```

### 9.2 Mini Tetris Iskeleti (Derslik Surum)

```basic
TYPE Piece
    x AS I32
    y AS I32
END TYPE

DIM p AS Piece
p.x = 5
p.y = 0

DO
    CLS
    LOCATE p.y + 1, p.x + 1
    PRINT "[]"

    p.y = p.y + 1
    IF p.y > 20 THEN p.y = 0

    ' Basit dusme animasyonu
    FOR d AS I32 = 1 TO 30000
    NEXT d
LOOP
```

Not:
- Bu ornek tam oyun degildir; oyun dongusu, cakisama ve skor icin iskelet sunar.

### 9.3 Basit Yapay Zeka Noronu (Tek Noron)

```basic
FUNCTION Sigmoid(x AS F64) AS F64
    RETURN 1.0 / (1.0 + EXP(-x))
END FUNCTION

DIM w1 AS F64, w2 AS F64, b AS F64
DIM x1 AS F64, x2 AS F64
DIM net AS F64, y AS F64

w1 = 0.8
w2 = -0.4
b = 0.1

INPUT "x1: "; x1
INPUT "x2: "; x2

net = x1 * w1 + x2 * w2 + b
y = Sigmoid(net)

PRINT "Noron cikisi: "; y
```

Not:
- Bu model tek noronlu bir siniflandirici cekirdegi verir.
- Sonraki adim: veri dongusu ve agirlik guncelleme (gradient descent).

## 10) Teknik Terimler ve Kisaltmalar (TR + EN)

| Terim | Acilim (EN) | Kisa anlam |
|---|---|---|
| AST | Abstract Syntax Tree | Soyut sozdizimi agaci |
| HIR | High-level Intermediate Representation | Yuksek seviye ara temsil |
| MIR | Mid-level Intermediate Representation | Orta seviye ara temsil |
| VM | Virtual Machine | Sanal yurutme ortami |
| ABI | Application Binary Interface | Ikili cagrı sozlesmesi |
| FFI | Foreign Function Interface | Dis dil fonksiyon cagri arayuzu |
| IR | Intermediate Representation | Ara kod modeli |
| CFG | Control Flow Graph | Kontrol akis grafigi |
| SSA | Static Single Assignment | Tek atama tabanli IR formu |
| Lexer | Lexical Analyzer | Sozcuk/token cozumleyici |
| Parser | Syntax Analyzer | Sozdizimi cozumleyici |
| Semantic | Semantic Analyzer | Anlamsal dogrulama katmani |

## Kapanis

PCK3, PCK2'yi koruyup daha okunur ve teknik bir katman ekler.
Ana ilke: dokuman, compiler kod gercegine sadik kalir.

## EK-A: Yeni Hata Komutlari ve Compiler Koprusu

Bu ek, cekirdege alinacak yeni hata komutlarini muhendislik perspektifinden ozetler.

### A.1 Komut seti

1. `TRY/CATCH/FINALLY/END TRY`
2. `THROW code[, message[, detail]]`
3. `ASSERT expr[, message]`

### A.2 Hata nesnesi standardi

Tek ve ortak nesne: `ERROR`

Alanlar:

- `code`, `message`, `detail`
- `module_name`, `source_file`
- `line`, `column`
- `phase` (LEX/PARSE/SEMANTIC/RUNTIME/CODEGEN)

Amac:

1. Compiler tarafinda uretilen hata bilgisini programciya dogrudan acmak.
2. Runtime fail-fast ile compiler diagnostigini ayni modelde birlestirmek.
3. uXBasic icinden hata odakli akislari (loglama, fallback, telemetry) mumkun kilmak.

### A.3 MIR/Codegen etkisi

1. TRY/CATCH icin control-flow edge'leri eklenecek.
2. FINALLY blogu, her cikis yolunda garantili calisacak sekilde lower edilecek.
3. THROW, handler'a sicrayan bir control transfer olarak emit edilecek.
4. ASSERT, debug/release politika secimine gore trap/no-op veya runtime check uretecek.

Not:

- Bu bolum tasarim-kontrat katmanidir; kapanis kaniti test + matris lane'leriyle verilecektir.