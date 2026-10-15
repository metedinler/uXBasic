# Cheat Sheetler ve Hızlı Başvuru

Bu bölüm kitabın sonunda yer alır. Ana kitap öğrenme sırasıyla yazılır; cheat sheetler ise hızlı bulma sırasıyla düzenlenir.

## Komut aileleri

| Aile | Komutlar |
|---|---|
| Değişken | `DIM`, `AS`, `CONST`, `REDIM`, `DEFINT`, `DEFLNG`, `DEFSTR`, `DEFEXT` |
| Akış | `IF`, `THEN`, `ELSEIF`, `ELSE`, `SELECT`, `CASE`, `END` |
| Döngü | `FOR`, `TO`, `STEP`, `NEXT`, `DO`, `LOOP`, `WHILE`, `UNTIL`, `WEND` |
| Fonksiyon | `FUNCTION`, `SUB`, `RETURN`, `DECLARE`, `CALL`, `BYVAL`, `BYREF` |
| Nesne | `TYPE`, `CLASS`, `INTERFACE`, `MAGIC`, `CONSTRUCTOR`, `DESTRUCTOR`, `NEW`, `DELETE` |
| Modül | `NAMESPACE`, `MODULE`, `USING`, `ALIAS`, `MAIN` |
| Dosya | `OPEN`, `PRINT #`, `INPUT #`, `CLOSE`, `GET`, `PUT`, `SEEK` |
| Dış bağlantı | `DECLARE LIB ALIAS`, `CALL(DLL)`, `CALL(API)`, `IMPORT(C/CPP/ASM)` |

## Veri tipleri

| Tip | Görev |
|---|---|
| `I8`, `I16`, `I32`, `I64` | İşaretli tam sayı ailesi. |
| `U8`, `U16`, `U32`, `U64` | İşaretsiz tam sayı ailesi. |
| `F32`, `F64`, `F80`, `F128` | Kayan nokta ve geniş duyarlık ailesi. |
| `BIGI`, `BIGINT` | Büyük tam sayı ailesi. |
| `BIGD`, `BIGF`, `BALL` | Büyük/uzun duyarlıklı ondalık aile. |
| `BOOLEAN` | Mantıksal değer. |
| `STRING` | Metin. |
| `OBJECT` | Nesne. |
| `PTR`, `STRPTR` | İşaretçi ve metin işaretçisi yüzeyi. |
| `ARRAY`, `LIST`, `DICT`, `SET` | Koleksiyon tip yüzeyi. |

## Operatör aileleri

| Aile | Operatörler |
|---|---|
| Aritmetik | `+`, `-`, `*`, `/`, `\`, `MOD`, `**` |
| Karşılaştırma | `=`, `==`, `<>`, `!=`, `<`, `<=`, `>`, `>=` |
| Mantık | `AND`, `OR`, `NOT`, `XOR` |
| Logic16 | `NAND`, `NOR`, `XNOR`, `NXOR`, `EQV`, `EQA`, `IFF`, `IMP`, `CIMP`, `NIMP`, `NCIMP`, `IDA`, `IDB`, `NOTA`, `NOTB` |
| Kaydırma | `SHL`, `SHR`, `ROL`, `ROR`, `<<`, `>>` |
| Atama | `=`, `+=`, `-=`, `*=`, `/=`, `%=`, `<<=`, `>>=`, `**=` |
| Pipe | `|>` |
| Üçlü | `?:` |

## Yanlış keyword düzeltmeleri

| Yanlış | Doğru | Not |
|---|---|---|
| `THREAT` | `THREAD` | İş parçacığı/yürütme işi yüzeyi. |
| `PARALLEL` | `PARALEL` | uXBasic kanonik keyword kararı. |
| `SIHIRLIMETOT` | `MAGIC` | Sınıf özel davranış sözleşmesi. |

## Kaynak gerçekliği kısa sayılar

| Alan | Sayı |
|---|---:|
| Lexer keyword/yüzey sözcüğü | 220 |
| Statement dispatch girişi | 79 |
| AST node sabiti | 142 |
| Runtime service ID | 83 |
| CLI seçenek adı | 167 |
| Project pack | 30 |
