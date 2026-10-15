#include → %%INCLUDE hatası geri alınmış. Bu iyi.

Ama AST JSON sorunu hâlâ duruyor. Artık sebep büyük ihtimalle şunlardan biri:

1. CLI argümanları doğru parse edilmiyor.
2. astJsonOut değişkeni dolmuyor.
3. ASTWriteJson çağrısına ulaşılmıyor.
4. Source parse başarısız ama hata ekrana/log’a net basılmıyor.
5. AST output path oluşturulamıyor.
6. Program sessiz çıkıyor.
Ne yapılmalı?

Şimdi başka yere dağılmadan sadece main.bas içinde --ast-json-out akışı izlenmeli.

Sıradaki kontrol sırası:

1. main.bas içinde --ast-json-out argümanı gerçekten yakalanıyor mu?
2. astJsonOut değişkeni doluyor mu?
3. sourceText okundu mu?
4. RTParseProgram / parse sonucu başarılı mı?
5. ps.ast.rootNode geçerli mi?
6. ASTWriteJson çağrılıyor mu?
7. ASTWriteJson dönüş değeri 0 mı 1 mi?
8. astJsonErr ne söylüyor?

Geçici debug satırları eklenmeli:

Print "[DEBUG] astJsonOut=" & astJsonOut
Print "[DEBUG] inputFile=" & inputFile
Print "[DEBUG] source length=" & Str(Len(sourceText))
Print "[DEBUG] parse ok=" & Str(parseOk)
Print "[DEBUG] root node=" & Str(ps.ast.rootNode)
Print "[DEBUG] ASTWriteJson result=" & Str(ok)
Print "[DEBUG] astJsonErr=" & astJsonErr
Kısa sonuç

Şu an 1 numaralı hata düzeltilmiş görünüyor:

PreprocessHashIncludes kaldırıldı.

Ama AST JSON üretim hattı hâlâ bozuk.

Şimdi yapılacak iş: main.bas içinde --ast-json-out hattına debug print koyup, programın hangi noktada sessizce düştüğünü bulmak.

PreprocessHashIncludes kaldırılması doğru.
Bu konu kapandı. #include ile %%INCLUDE asla otomatik çevrilmeyecek.

Şimdi seçilecek yol:

Karar: 2. yol değil, önce 1. yol

Yani hemen runtime’a dalmayın.

Önce şu yapılmalı:

--extract-src / harness-vs-source ayrımı

Çünkü şu an sorun şu:

test harness dosyası ≠ gerçek uXBasic kaynak dosyası

Sen 80_h8a...bas gibi test dosyasını CLI’ye verince compiler onu uXBasic program sanıyor. Oysa o dosya FreeBASIC test harness’ı olabilir; içinde src = "...basic kod..." var.

Bu yüzden önce dosya tipi ayrılmalı.

Uygulanacak kesin karar
1. main.bas içinde mod ayrımı yapılacak
mode_source
mode_harness
mode_extract_src
2. CLI davranışı şöyle olacak
uxbasic_cli.exe test.uxb --ast-json-out out/ast.json

Gerçek uXBasic kaynaksa:

doğrudan parse et → AST yaz

Harness ise:

hata ver:
Bu dosya FreeBASIC test harness. --extract-src kullan.

Şu komutla:

uxbasic_cli.exe tests\basicCodeTests\80_h8a_operator_numeric_parity.bas --extract-src --ast-json-out tests\basicCodeTests\out_probe_80\ast.json

Yapılacak:

harness içindeki src string’i çıkar
çıkan kodu parser’a ver
AST yaz
Neden runtime AST-dump şu an erken?

Çünkü runtime’a dalarsanız:

RTParseProgram
memory_exec
runtime parser
test harness
ASTWriteJson

hepsi birbirine karışır.

Şu anda önce basit gerçeklik lazım:

CLI hangi dosyayı parse ediyor?
O dosya gerçek uXBasic mi?
Yoksa FreeBASIC test harness mı?

Bu ayrım olmadan runtime dump temiz olmaz.

VSCode’a verilecek karar cümlesi

Şunu uygulat:

Karar: PreprocessHashIncludes kaldırılması doğru. Devamında runtime AST-dump’a geçme. Önce main.bas içine harness-vs-source ayrımı ve --extract-src modu ekle. 
FreeBASIC test harness dosyaları doğrudan uXBasic source gibi parse edilmeyecek.
--extract-src verilirse harness içindeki src string literal çözülecek, çıkan uXBasic kodu parse edilecek ve --ast-json-out bu AST’yi yazacak.
Sonra test komutu
cd /d C:\Users\mete\Downloads\BasicOyunSource\uXBasic_repo

build\uxbasic_cli.exe tests\basicCodeTests\80_h8a_operator_numeric_parity.bas --extract-src --ast-json-out tests\basicCodeTests\out_probe_80\ast.json

Beklenen:

tests\basicCodeTests\out_probe_80\ast.json oluşmalı

Bu geçmeden class/vtable/operator konusuna dönülmeyecek.
asagidaki isler de yapilacak
unutma!! bu compilerin eksiklikleri hamele 8 de kapatilacak.
Çok kritik bir noktaya bastın Mete abi — burada kafa karışması tamamen haklı 👍
Şimdi net ve teknik şekilde ayıralım:

---

## 🔴 1. `#include` nedir? (FreeBASIC tarafı)

`#include` = **FreeBASIC’in kendi preprocessor komutu**

```bas
#include "dosya.fbs"
```

Bu:

* Derleme zamanında çalışır
* FreeBASIC derleyicisi (`fbc`) tarafından işlenir
* Dosyayı fiziksel olarak koda ekler

👉 Bu **host language (FreeBASIC)** seviyesidir.

---

## 🟢 2. `%%INCLUDE` nedir? (uXBasic tarafı)

```bas
%%INCLUDE "file.bas"
```

Bu:

* uXBasic’in **kendi dili için yazılmış preprocessor komutu**
* Senin `lexer_preprocess.fbs` tarafından işlenir
* FreeBASIC bunu **tanımaz**

👉 Bu **senin compiler’ın frontend katmanı**

---

## ⚠️ Kritik ayrım

| Komut       | Kimin?    | Ne zaman çalışır                    |
| ----------- | --------- | ----------------------------------- |
| `#include`  | FreeBASIC | derleme zamanı (fbc)                |
| `%%INCLUDE` | uXBasic   | senin lexer/preprocessor aşamasında |

---

## 💥 Problem nerede çıktı?

Senin `main.bas` içinde şuna benzer bir şey olmuş:

```bas
%%INCLUDE "parser/parser_stmt.fbs"
```

Ama bu dosya:

* FreeBASIC tarafından derleniyor
* uXBasic preprocessor henüz çalışmamış

👉 Sonuç:

**fbc bunu tanımaz → hata verir veya yok sayar**

---

## 🔥 Neden yanlış?

Çünkü:

```text
FreeBASIC derlenirken:
   ↓
fbc çalışır
   ↓
# include çalışır
   ↓
program compile edilir

AMA

%%INCLUDE çalışmaz ❌
```

---

## 🧠 Doğru mimari

### ✔ Doğru kullanım

#### FreeBASIC kodunda:

```bas
#include "parser/parser_stmt.fbs"
```

#### uXBasic kullanıcı kodunda:

```basic
%%INCLUDE "lib/math.bas"
```

---

## ⚠️ src12’de yapılan değişim neden riskli?

Senin gördüğün:

> `#include` → `%%INCLUDE` çevrilmiş

Bu şu anlama gelir:

👉 **FreeBASIC include mekanizması kırılmış olabilir**

Çünkü:

* `main.bas` artık bağımlı dosyaları alamaz
* compiler eksik modülle derlenir
* garip runtime/AST hataları çıkar

---

## 🧨 Büyük hata tipi (çok önemli)

Bu tür bir değişim:

```bas
# include → %%INCLUDE
```

👉 Eğer yanlış yerde yapılırsa:

* parser yokmuş gibi davranır
* AST boş çıkar
* CLI probe AST üretmez (senin yaşadığın olay!)

---

## 🎯 Sana net teşhis

Senin şu sorununla **%100 bağlantılı:**

> AST dosyası oluşmuyor

Çünkü:

👉 Parser dosyaları aslında compile edilmemiş olabilir

---

## 🔍 Nasıl test edersin (çok net)

`main.bas` içine geçici olarak şunu koy:

```bas
Print "PARSER LOADED"
```

ve parser dosyasının içine:

```bas
Print "PARSER FILE ACTIVE"
```

Eğer ikinci yazmıyorsa:

👉 include çalışmıyor demektir

---

## 🔧 Doğru çözüm

Şu kuralı **asla bozma:**

```text
FreeBASIC dosyalarında:
    SADECE #include

uXBasic dilinde:
    SADECE %%INCLUDE
```

---

## 🔥 Sonuç (net)

* `#include` = compiler’ı kurar
* `%%INCLUDE` = dil kullanıcı kodunu işler

👉 Bunları karıştırmak:

> compiler’ı sessizce bozar (en tehlikeli bug)

---

Mete abi, VSCode notunda görünen işlem şu: `main.bas` içine `PreprocessHashIncludes` eklenmiş ve `#include` satırları `%%INCLUDE`’e çevrilmeye çalışılmış; sonra bunun test harness dosyalarını bozduğu yine notta yazıyor. 

Ben `src10 → src12` statik karşılaştırmasını yaptım. Ana değişen dosyalar:

```text
main.bas
semantic/semantic_pass.fbs
semantic/mir.fbs
semantic/mir_model.fbs
semantic/mir_evaluator.fbs
semantic/layout/layout_type_table.fbs
runtime/exec/exec_types.fbs
runtime/exec/exec_class_layout_helpers.fbs
runtime/exec/exec_eval_support_helpers.fbs
runtime/exec/exec_call_dispatch_helpers.fbs
codegen/x64/cg_context.fbs
codegen/x64/code_generator.fbs
```

## 1. En büyük hata: `main.bas` içindeki `#include → %%INCLUDE`

### Hatalı bölüm — `src12/main.bas`, yaklaşık 165

```bas
Private Function PreprocessHashIncludes(ByRef src As String) As String
...
If Len(trimmed) >= 8 And UCase(Left(trimmed, 8)) = "#INCLUDE" Then
    outText &= "%%INCLUDE " & rest & Chr(10)
```

### Neden yanlış?

Çünkü iki ayrı dünya karıştırılmış:

```text
FreeBASIC compiler dosyalarında: #include
uXBasic kullanıcı kodunda:      %%INCLUDE
```

`#include` FreeBASIC’in kendi derleme zamanı komutudur.
`%%INCLUDE` uXBasic’in lexer/preprocessor komutudur.

Test harness dosyalarında FreeBASIC tarzı `#include` olabilir. Bunları kör şekilde `%%INCLUDE` yapmak, uXBasic parser’a FreeBASIC compiler kaynaklarını yedirmeye çalışır. Bu da AST üretimini bozabilir.

### Doğrusu

Bu fonksiyon ya tamamen kaldırılmalı ya da sadece **uXBasic kaynak modu** için kontrollü çalışmalı.

Daha güvenli doğru yaklaşım:

```bas
' HATALI:
sourceText = PreprocessHashIncludes(sourceText)

' DOĞRU:
' FreeBASIC harness dosyasını uXBasic kaynak gibi parse etme.
' Eğer dosya test harness ise doğrudan statik AST parse yapılmamalı.
```

## 2. `main.bas` AST JSON klasörü oluşturma kısmı kısmen doğru ama Windows’a bağımlı

### Bölüm — `src12/main.bas`, yaklaşık 490

```bas
mkCmd = "cmd /c mkdir " & Chr(34) & astJsonParent & Chr(34)
Shell mkCmd
```

### Sorun

Bu sadece Windows için çalışır. Ayrıca `Shell` sonucunu kontrol etmiyor.

### Daha doğru mantık

```bas
If Dir(astJsonParent) = "" Then
    ' platform bağımlı olmayan mkdir helper kullanılmalı
    ' veya Shell sonucu kontrol edilmeli
End If
```

Bu ölümcül hata değil, ama CLI güvenilirliği için zayıf.

## 3. Semantic vtable slot eklemesi yarım ama fikir doğru

### Yeni bölüm — `semantic/semantic_pass.fbs`, yaklaşık 893–1061

```bas
CLASS_METHOD_DECL nodes with child "CLASS_METHOD_SLOT"
```

### Doğru tarafı

Virtual/override metodlara slot vermek gerekli. Bu, class dispatch için doğru yöndür.

### Riskli tarafı

Bu semantic AST’ye yeni child node ekliyor:

```bas
slotNode = ASTNewNode(ps.ast, "CLASS_METHOD_SLOT", ...)
ASTAddRoleChild ps.ast, ch, slotNode, "VTABLE_SLOT"
```

Ama parser, AST exporter, MIR, runtime ve x64 aynı node’u tutarlı yorumlamazsa sistem kırılır.

### Eksik kontrol

Şu kontroller net değil:

```text
Base class cycle var mı?
Aynı method iki kez slot alıyor mu?
Override olmayan method base virtual’ı sessiz eziyor mu?
Interface methodları slot sistemine dahil mi?
Destructor/constructor slot dışı tutuluyor mu?
```

## 4. Layout tarafında `__vptr` eklenmiş, doğru ama tüm katmanlar aynı anlamı kullanmıyor

### Bölüm — `semantic/layout/layout_type_table.fbs`, yaklaşık 184

```bas
If UCase(Trim(ps.ast.nodes(declNode).kind)) = "CLASS_STMT" Then
    AddLayoutField("__vptr", "POINTER", 0, 8, 8, ...)
    curOffset = 8
End If
```

### Doğru tarafı

Class nesnesinin başına vtable pointer koymak doğru mimaridir.

### Büyük sorun

Runtime tarafında aynı `__vptr` gerçek pointer gibi değil, class index gibi kullanılmış.

Runtime:

```bas
VMemPokeD(objectBase, classIdx)
VMemPokeD(objectBase + 4, 0)
```

x64:

```asm
lea rdx, [rel CLASS_VTBL]
mov [rax], rdx
```

Yani:

```text
Interpreter: __vptr = class index
x64:         __vptr = gerçek vtable adresi
```

Bu çok önemli mimari tutarsızlık.

### Doğrusu

Ya ikisi de gerçek vtable pointer kullanmalı:

```text
__vptr = vtable address
```

Ya da interpreter için ayrı metadata alanı olmalı:

```text
__vptr_runtime_class_index ayrı
__vptr gerçek vtable pointer ayrı
```

## 5. Runtime vtable map eklenmiş ama method eşleşmesi kırılgan

### Bölüm — `runtime/exec/exec_eval_support_helpers.fbs`, yaklaşık 119

```bas
ExecBuildVTableMap
```

### Sorunlu mantık

Key şu şekilde kuruluyor:

```bas
key = className & "_" & UCase(Trim(implMethod(i)))
```

Ama override durumunda `className` derived class, implementer ise base veya derived olabilir. Sonra lookup tarafında suffix ile aranıyor:

```bas
If Right(key, needSuffix) = "_" & mUpper Then
```

Bu çalışabilir ama kırılgan. Aynı method adı farklı inheritance zincirlerinde karışabilir.

### Doğrusu

VTable entry key şu olmalı:

```text
dispatchClass + slot
```

Method adı yardımcı bilgi olmalı, ana lookup değil.

Yani:

```bas
vtableEntryDispatchClass(eidx) = className
vtableEntrySlot(eidx) = i
vtableEntryImplRoutine(eidx) = implOwner & "_" & implMethod
```

## 6. MIR tarafında `__VT_SLOT__` eklenmiş ama receiver runtime type yok

### Bölüm — `semantic/mir_evaluator.fbs`, yaklaşık 2036

```bas
If Left(fnName, 12) = "__VT_SLOT__:" Then
```

### Sorun

Token şuna benziyor:

```text
__VT_SLOT__:CLASS:slot
```

Ama gerçek virtual dispatch için gereken şey:

```text
receiver nesnesinin runtime class type’ı
```

Şu an call adı içine class gömülmüş. Bu, polymorphism’i zayıflatır. Örneğin:

```basic
DIM a AS Animal
a = NEW Dog
a.Speak()
```

Burada slot Dog vtable’dan çözülmeli. Ama MIR token `Animal:slot` olarak kaldıysa Dog override çalışmayabilir.

### Doğrusu

MIR call şöyle modellenmeli:

```text
MIR_CALL_VIRTUAL receiver, slot
```

Yani function name string içine `__VT_SLOT__` gömmek geçici hack’tir.

## 7. x64 codegen’de class size hatası sessizce bastırılmış

### Hatalı değişim — `codegen/x64/code_generator.fbs`, yaklaşık 4478 ve 6336

```bas
If classSize <= 0 Then classSize = 8
```

### Bu çok tehlikeli

`classSize <= 0` gerçek hata demektir. Layout çözülememiştir. Bunu 8’e düşürmek compiler’ı susturur ama runtime memory corruption üretir.

### Doğrusu

```bas
If classSize <= 0 Then
    errText = "x64-codegen: class layout invalid / unresolved: " & classTypeName
    Return 0
End If
```

Bu kesin geri alınmalı.

## 8. x64 vtable emit var ama label garanti değil

### Bölüm — `codegen/x64/code_generator.fbs`, yaklaşık 84

```bas
vtblLabel = className & "_VTBL"
X64EmitData cg, vtblLabel & ": dq ..."
```

### Sorun

Sonra allocation’da:

```asm
lea rdx, [rel classTypeName_VTBL]
mov [rax], rdx
```

Eğer `classTypeName` casing farklıysa veya vtable daha önce emit edilmediyse NASM/link hatası çıkar.

### Doğrusu

Label üretimi merkezi olmalı:

```bas
Private Function X64ClassVTableLabel(ByRef className As String) As String
    Return "__uxb_vtbl_" & LCase(Sanitize(className))
End Function
```

Ve her yerde aynı helper kullanılmalı.

## 9. Operator overload hook erken ve tehlikeli eklenmiş

### Bölüm — `codegen/x64/code_generator.fbs`, yaklaşık 4756

```bas
' Operator-overload hook: if LHS is class instance and class defines OP_ADD/ADD
```

### Sorun

Compiler henüz F80, class layout, vtable, receiver dispatch tam değilken operator overload eklemek erken. Bu kod:

```bas
a + b
```

ifadesini class method call’a çevirmeye çalışıyor. Ama type inference tam değilse yanlış method çağırır veya stack/register düzenini bozar.

### Doğrusu

Şimdilik kapatılmalı veya semantic flag arkasına alınmalı:

```bas
If cg.enableOperatorOverload <> 0 Then
   ...
End If
```

## 10. x64 virtual call güvenli değil

### Bölüm — `codegen/x64/code_generator.fbs`, yaklaşık 7129

```asm
mov rax, rcx
mov rax, [rax]
mov rax, [rax + slot*8]
call rax
```

### Eksik kontroller

Şunlar yok:

```text
rcx null mı?
[rcx] valid vtable mı?
slot entry 0 mı?
method signature uyumlu mu?
return type uyumlu mu?
```

Debug build için en azından null kontrol olmalı.

## Net sonuç

`src12`, `src10` üzerine gerçek bir “temiz ilerleme” değil; daha çok **vtable/class dispatch denemesi + AST JSON/harness düzeltme denemesi** olmuş.

En kritik geri alınacak / düzeltilecek yerler:

```text
1. main.bas PreprocessHashIncludes kaldırılmalı veya devre dışı bırakılmalı.
2. #include → %%INCLUDE otomatik dönüşümü yapılmamalı.
3. x64 classSize <= 0 Then classSize = 8 geri alınmalı.
4. Interpreter __vptr ile x64 __vptr aynı anlama getirilmeli.
5. MIR __VT_SLOT__ string hack’i kalıcı tasarım sayılmamalı.
6. Operator overload hook kapatılmalı.
7. VTable label üretimi merkezi helper’a bağlanmalı.
```

Şu an yapılacak en doğru iş:

```text
AŞAMA 1 — Hasar kontrolü
src12’den PreprocessHashIncludes kaldır.
classSize=8 fallback’i kaldır.
operator overload hook’u kapat.

AŞAMA 2 — Çekirdek test
PRINT 1
DIM i AS I32
DIM x AS F64
TYPE field
CLASS without virtual
CLASS virtual sadece semantic

AŞAMA 3 — VTable yeniden
Önce semantic slot.
Sonra interpreter dispatch.
Sonra MIR dispatch.
En son x64 dispatch.
```

Kısaca: **src12’deki en tehlikeli hata `#include` ile `%%INCLUDE`’ün karıştırılması ve x64 class layout hatasının 8 byte ile susturulmasıdır.**
## 10 hatayı düzeltmek için kesin yol haritası

### 1. `#include → %%INCLUDE` hatası

`main.bas` içindeki otomatik dönüşüm tamamen kaldırılacak.

**Kural:**

```text
FreeBASIC compiler kaynaklarında:
#include

uXBasic kullanıcı kaynaklarında:
%%INCLUDE
```

**Yapılacak:**

```text
main.bas
  - PreprocessHashIncludes fonksiyonu kaldırılacak.
  - sourceText = PreprocessHashIncludes(sourceText) satırı kaldırılacak.
```

**Doğru sistem:**

```text
.bas test harness dosyası FreeBASIC ise uXBasic parser’a verilmez.
uXBasic test kaynağı ayrı .uxb / .bas dosyası olarak parser’a verilir.
Harness içindeki src string’i parse edilecekse ayrı extractor/test runner yazılır.
```

---

### 2. AST JSON / test harness ayrımı

`--ast-json-out` yalnızca gerçek uXBasic kaynak dosyasının AST’sini yazmalı.

**Yapılacak:**

```text
main.bas
  - input dosyası FreeBASIC harness mı, uXBasic kaynak mı ayırt edilecek.
  - Harness dosyası tespit edilirse statik parser’a verilmez.
```

**Gerekli ayrım:**

```text
mode=source
mode=harness
mode=extract-src
```

**Doğru CLI davranışı:**

```text
uxbasic_cli.exe program.uxb --ast-json-out out/ast.json
    → program.uxb AST yazılır.

uxbasic_cli.exe tests/.../80_h8a.bas --ast-json-out out/ast.json
    → hata: harness dosyası doğrudan AST parse edilemez.

uxbasic_cli.exe tests/.../80_h8a.bas --extract-src --ast-json-out out/ast.json
    → harness içindeki src string’i çıkarılır ve onun AST’si yazılır.
```

---

### 3. `classSize <= 0 Then classSize = 8` hatası

Bu fallback kesin kaldırılacak.

**Hatalı mantık:**

```bas
If classSize <= 0 Then classSize = 8
```

**Doğru mantık:**

```bas
If classSize <= 0 Then
    errText = "x64-codegen: unresolved class layout: " & classTypeName
    Return 0
End If
```

**Yapılacak dosyalar:**

```text
codegen/x64/code_generator.fbs
semantic/layout/layout_type_table.fbs
semantic/semantic_pass.fbs
```

**Gerekli garanti:**

```text
CLASS layout yoksa x64 codegen başlamaz.
TYPE/CLASS field offset yoksa codegen başlamaz.
__vptr offset kesin 0 olmalı.
object size semantic/layout tarafından kesin hesaplanmalı.
```

---

### 4. `__vptr` anlamı interpreter ve x64 arasında eşitlenecek

Şu an tehlikeli ayrım var:

```text
Interpreter: __vptr = class index
x64:         __vptr = vtable address
```

Bu kabul edilmeyecek.

**Kesin karar:**

```text
__vptr her backend’de gerçek vtable pointer anlamına gelecek.
```

**Yapılacak:**

```text
runtime/exec/exec_types.fbs
runtime/exec/exec_class_layout_helpers.fbs
runtime/exec/exec_eval_support_helpers.fbs
codegen/x64/code_generator.fbs
semantic/layout/layout_type_table.fbs
```

**Runtime model:**

```text
object + 0 = __vptr
object + 8 = ilk kullanıcı field
```

**Interpreter için çözüm:**

Interpreter fiziksel pointer kullanamıyorsa tablo handle kullanacak ama adı `__vptr` olmayacak.

```text
__vptr             = gerçek/soyut vtable referansı
__class_meta_id    = sadece interpreter iç metadata id
```

**Object allocation sonrası:**

```text
obj.__vptr = VTableOf(RuntimeClass)
obj.__class_meta_id = RuntimeClassId   ; sadece interpreter gerekiyorsa
```

---

### 5. VTable label üretimi merkezileştirilecek

Aynı class için farklı label üretilmeyecek.

**Yeni helper:**

```bas
Private Function X64ClassVTableLabel(ByRef className As String) As String
    Dim s As String
    s = X64SanitizeSymbol(LCase(Trim(className)))
    Return "__uxb_vtbl_" & s
End Function
```

**Yapılacak:**

```text
codegen/x64/cg_context.fbs
codegen/x64/code_generator.fbs
```

**Tüm kullanım noktaları aynı helper’a bağlanacak:**

```text
vtable emit
object allocation
virtual call
debug dump
external symbol list
```

---

### 6. Virtual metot ve sihirli metot adlandırması

Kesin söz dizimi ayrılacak.

```text
Virtual / internal dispatch metotları:
<__isim__>

Sihirli metotlar:
<isim>
```

**Örnek:**

```text
<__init__>       internal constructor binding
<__del__>        internal destructor binding
<__vcall__>      internal virtual dispatch helper
<__str__>        internal stringify dispatch helper

<add>            operator +
<sub>            operator -
<mul>            operator *
<div>            operator /
<eq>             =
<lt>             <
<index>          []
<setindex>       [] =
<call>           callable object
<str>            user-level string conversion
```

**Yapılacak:**

```text
lexer/lexer_keyword_table.fbs
parser/parser_stmt.fbs
parser/parser_expr.fbs
semantic/semantic_pass.fbs
semantic/mir.fbs
codegen/x64/code_generator.fbs
runtime/exec/*
```

**Kural:**

```text
<__...__> compiler/runtime iç protokol.
<...> kullanıcıya açık magic/operator metodu.
Normal method ismi ile magic method ismi çakışmayacak.
```

---

### 7. Class ve OOP sistemi tam yol haritası

OOP sistemi 8 katmanda tamamlanacak.

#### 7.1 Parser katmanı

Desteklenecek:

```basic
CLASS Animal
    FIELD name AS STRING
    VIRTUAL FUNCTION <str>() AS STRING
    VIRTUAL SUB Speak()
END CLASS

CLASS Dog EXTENDS Animal
    OVERRIDE SUB Speak()
    FUNCTION <add>(other AS Dog) AS Dog
END CLASS
```

Parser node’ları:

```text
CLASS_STMT
CLASS_EXTENDS
CLASS_FIELD_DECL
CLASS_METHOD_DECL
CLASS_METHOD_ATTR
CLASS_METHOD_NAME
CLASS_METHOD_PARAMS
CLASS_METHOD_RET
CLASS_METHOD_BODY
```

#### 7.2 AST katmanı

Her class node şunları taşıyacak:

```text
className
baseClassName
fieldList
methodList
constructorList
destructorList
interfaceList
sourceLocation
```

Her method node şunları taşıyacak:

```text
ownerClass
methodName
normalizedName
isVirtual
isOverride
isStatic
isConstructor
isDestructor
isMagic
magicKind
returnType
paramTypes
slotIndex
```

#### 7.3 Semantic katmanı

Zorunlu kontroller:

```text
Base class var mı?
Inheritance cycle var mı?
Field adı çakışıyor mu?
Method overload imzası çakışıyor mu?
Override edilen method gerçekten virtual mı?
Override signature birebir uyumlu mu?
Constructor virtual olamaz.
Destructor slot almaz; ayrı lifecycle protokolüdür.
Magic method signature doğru mu?
Abstract/interface method implement edilmiş mi?
```

#### 7.4 Layout katmanı

Nesne layout:

```text
offset 0: __vptr
offset 8: base fields
offset N: derived fields
alignment: max(field alignment, pointer alignment)
```

Zorunlu tablolar:

```text
ClassLayoutTable
FieldOffsetTable
MethodSymbolTable
VTableLayoutTable
InterfaceDispatchTable
```

#### 7.5 MIR katmanı

String hack kaldırılacak.

Yanlış:

```text
CALL "__VT_SLOT__:Class:3"
```

Doğru MIR opcode:

```text
MIR_NEW_OBJECT className
MIR_CALL_METHOD receiver, methodId
MIR_CALL_VIRTUAL receiver, slotIndex, signatureId
MIR_CALL_MAGIC receiver, magicKind, args
MIR_GET_FIELD receiver, fieldId
MIR_SET_FIELD receiver, fieldId, value
MIR_INSTANCEOF receiver, classId
MIR_CAST_OBJECT receiver, targetClassId
MIR_DESTROY_OBJECT receiver
```

#### 7.6 Interpreter katmanı

Runtime tabloları:

```text
RuntimeClassTable
RuntimeVTable
RuntimeMethodTable
RuntimeObjectHeader
RuntimeInterfaceMap
```

Object header:

```text
__vptr
__class_meta_id
__refcount / flags
```

Virtual call:

```text
receiver null kontrolü
runtime class bulunur
slot okunur
method target bulunur
signature kontrol edilir
call dispatch yapılır
```

#### 7.7 x64 codegen katmanı

Üretilecek:

```asm
; object allocation
call __uxb_alloc
mov [rax + 0], __uxb_vtbl_Dog
```

Virtual call:

```asm
test rcx, rcx
jz __uxb_null_object_error
mov rax, [rcx + 0]
test rax, rax
jz __uxb_null_vtable_error
mov rax, [rax + slot*8]
test rax, rax
jz __uxb_null_vslot_error
call rax
```

#### 7.8 Test katmanı

Zorunlu testler:

```text
class_empty
class_field_i32
class_field_f64
class_inheritance_field_offset
class_method_direct_call
class_virtual_call_base_ref
class_override_signature_fail
class_constructor
class_destructor
class_magic_add
class_magic_str
class_null_virtual_call
```

---

### 8. `__VT_SLOT__` string hack’i gerçek MIR opcode’a çevrilecek

**Mevcut geçici yapı kaldırılacak:**

```text
__VT_SLOT__:Class:slot
```

**Yeni yapı:**

```text
MIR_CALL_VIRTUAL
  receiverReg
  slotIndex
  signatureId
  resultReg
```

**Yapılacak dosyalar:**

```text
semantic/mir_model.fbs
semantic/mir.fbs
semantic/mir_evaluator.fbs
runtime/exec/exec_call_dispatch_helpers.fbs
codegen/x64/code_generator.fbs
```

**Zorunlu veri:**

```text
receiver expression
declared receiver type
runtime receiver type
slot index
method signature id
return type
argument registers
```

---

### 9. Operator overload kancası tamamlanacak

Kapatılmayacak. Tamamlanacak.

#### 9.1 Magic method tablosu

```text
+        → <add>
-        → <sub>
*        → <mul>
/        → <div>
\        → <idiv>
MOD      → <mod>
**       → <pow>
=        → <eq>
<>       → <ne>
<        → <lt>
<=       → <le>
>        → <gt>
>=       → <ge>
AND      → <and>
OR       → <or>
XOR      → <xor>
NOT      → <not>
[]       → <index>
[]=      → <setindex>
CALL     → <call>
STRING   → <str>
```

#### 9.2 Semantic resolution

Her binary operator için sıra:

```text
1. Primitive + primitive ise normal operator.
2. Class + primitive ise lhs.<op>(rhs) aranır.
3. Primitive + class ise rhs.<rop>(lhs) aranır.
4. Class + class ise lhs.<op>(rhs) aranır.
5. Yoksa semantic hata.
```

Gerekli reverse magic:

```text
<radd>
<rsub>
<rmul>
<rdiv>
<req>
<rlt>
```

#### 9.3 AST dönüşümü

Parser operator node üretir:

```text
BINARY_EXPR '+'
```

Semantic bunu çözer:

```text
BINARY_EXPR primitive
```

veya:

```text
MAGIC_CALL_EXPR
  receiver
  magicKind=<add>
  args=[rhs]
```

#### 9.4 MIR üretimi

```text
MIR_CALL_MAGIC receiver, MAGIC_ADD, args
```

#### 9.5 Interpreter uygulaması

```text
receiver null kontrolü
magic method lookup
signature kontrolü
call dispatch
return type kontrolü
```

#### 9.6 x64 uygulaması

Class magic call da normal method call gibi üretilecek:

```text
direct magic call
veya virtual magic call
```

Eğer magic method virtual ise:

```text
MIR_CALL_VIRTUAL receiver, slot
```

Eğer final/nonvirtual ise:

```text
MIR_CALL_METHOD directSymbol
```

#### 9.7 Zorunlu testler

```basic
CLASS Vec2
    FIELD x AS F64
    FIELD y AS F64

    FUNCTION <add>(other AS Vec2) AS Vec2
    END FUNCTION

    FUNCTION <str>() AS STRING
    END FUNCTION
END CLASS

DIM a AS Vec2
DIM b AS Vec2
DIM c AS Vec2
c = a + b
PRINT c
```

---

### 10. x64 virtual call güvenli hale getirilecek

#### 10.1 Ön şart

x64 virtual call yalnızca şu bilgiler varsa üretilecek:

```text
receiver type resolved
slot index resolved
vtable label emitted
method signature known
return ABI known
argument ABI known
```

#### 10.2 Null kontrol

Üretilecek asm:

```asm
test rcx, rcx
jz __uxb_raise_null_object

mov rax, [rcx + 0]
test rax, rax
jz __uxb_raise_null_vtable

mov r11, [rax + slot*8]
test r11, r11
jz __uxb_raise_null_vslot

call r11
```

#### 10.3 Slot sınır kontrolü debug modda

```asm
cmp slot, VTABLE_SLOT_COUNT
jae __uxb_raise_vslot_oob
```

#### 10.4 Signature guard debug modda

VTable entry yanında signature id tutulacaksa:

```text
vtable:
  dq method_ptr
  dq signature_id
```

Alternatif:

```text
debug_vtable_signature_table:
  dq sig0, sig1, sig2
```

#### 10.5 Register kuralı

Win64 ABI:

```text
RCX = this
RDX = arg1
R8  = arg2
R9  = arg3
stack = sonraki argümanlar
shadow space = 32 byte
stack alignment = 16 byte
```

#### 10.6 Return kuralı

```text
I32/U32/I64/U64/PTR/OBJECT → RAX
F32/F64                  → XMM0
F80                      → şimdilik x64 virtual call’da yasak veya x87 protokolü tamamlanana kadar semantic hata
STRING                   → runtime string handle / pointer
STRUCT/CLASS value       → hidden return pointer
```

#### 10.7 Hata rutinleri

Runtime’a eklenecek:

```text
__uxb_raise_null_object
__uxb_raise_null_vtable
__uxb_raise_null_vslot
__uxb_raise_vslot_oob
__uxb_raise_bad_signature
```

#### 10.8 x64 testler

```text
virtual_base_call
virtual_derived_override
virtual_null_object
virtual_missing_slot
virtual_signature_mismatch_debug
virtual_return_i32
virtual_return_f64
virtual_with_two_args
```

---

## Uygulama sırası

```text
1. main.bas include/harness ayrımı düzeltilecek.
2. classSize fallback kaldırılacak.
3. layout table kesinleştirilecek.
4. __vptr anlamı tekleştirilecek.
5. magic method isim standardı uygulanacak.
6. semantic method table kurulacak.
7. semantic vtable layout kurulacak.
8. MIR_CALL_VIRTUAL opcode eklenecek.
9. MIR_CALL_MAGIC opcode eklenecek.
10. interpreter virtual dispatch tamamlanacak.
11. interpreter magic/operator dispatch tamamlanacak.
12. x64 vtable label helper eklenecek.
13. x64 object allocation header yazımı düzeltilecek.
14. x64 safe virtual call üretilecek.
15. operator overload x64 call path tamamlanacak.
16. destructor/constructor lifecycle tamamlanacak.
17. test matrisi yazılacak.
18. tüm eski testler yeniden çalıştırılacak.
```

bu yukaridaki yazi 10 maddelik 8a-3 alt plani bunun icin todo yaptin. buradan yararlanarak is yapmaya devam et.


simdi bir karisiklik oldu
bulgularin dogru 
compiler coverage hamle 1 den 24 e kadar planlama var.
biz bu planin 8 inci maddesindeyiz
compiler coveragede yazmayabilir ancak ben bu 8. maddeyi 8a, 8b, 8c diye ayirdim.
sonra sana 8a planini verdim.
ama o plan yapilirken compiler coktu.
o zaman 10 maddelik bir plan daha hazirladim ve 8A nin kaldigimiz maddesine 10 alt madde ilave ettik. simdi bu o on alt maddenin saniyorum 3. maddesini yaptik yada yapiyoruz.
dogrusu su ki sen calisirken goreceksin baska bir ajani daha calisma alaninda calistiriyorum. sana guvenmedigimden degil. onun isi ayri.
sen onun yaptiklarina saygi duy.
o da sana saygi duyacak.
one bana su an hangi is icindesin soyle.
sonra tum test matrisini calistirman elzem ise bu onerdigin gorevleri yap.
asagidaki plan sana yardimci olmasi icin ilave bilgi niteliginde verildi.
todo da 15 is var ve 6 tanesi bitti . sonrakilaer gecelim ve isimizi yapalim duzgun ve kaliteli sekilde eksikleri bulup onarmaliyiz.
cunku ana planin sonraki asamalari bu 10 onarim ve 15 todo ile 8a, (biliyorsun) 8b(bilmiyorsun daha vermedim), 8c (bilmiyorsun daha vermedim) bu asamalarin kesin bir sekilde tamamlanmis olmasindan geciyor.
ama benimde bir kisitim var token, tokenim az. eger turkce dusunce akisin token harcatacaksa buna uyma. eger tum test matrisini ve fallback laer tespit icin okuma harici akilli bir plan yapar ve az token harcarsan cok iyi olur. ben senin daha hizli is yapman icin disaridan sana kod destegi veriyorum. umarim bunlar senin isine yariyordur. yaramiyorsa bana ilk once buna cevap vererek soyle bileyim. sonra eger benden sonraki adimlar icin kod destegi istersen yapabilirim. diger ajana is vermemi istersen bana soyle hemen ona is yaptirayim.

Şu an karışıklık oldu. 8A planı ile Hamle 2/3 planını ayır.

Önce sadece 8A-2 durumunu raporla:
- code_generator.fbs içinde classSize <= 0 fallback kaldırıldı mı?
- Hangi satırlar değişti?
- Build geçti mi?
- Class allocation testi geçti mi?
- AST/parser regression geçti mi?

Sonra 8A-3’e geçmeden bekle.
Tüm raporu Türkçe ver.

 kod gerçekliğine göre 8A-3 ve 8A-4 şöyle olmalı. Bunlar “hamle” değil; **8A içindeki alt işler**.

---

# 8A-3 — `__vptr` anlamını tekleştirme

## Mevcut sorun

`src13` içinde class nesnesinin başındaki `__vptr` iki farklı anlamda kullanılıyor.

x64 tarafında:

```asm
lea rdx, [rel CLASS_VTBL]
mov [rax], rdx
```

Yani:

```text
__vptr = gerçek vtable adresi
```

Interpreter/runtime tarafında ise:

```bas
VMemPokeD(objectBase, classIdx)
VMemPokeD(objectBase + 4, 0)
```

Yani:

```text
__vptr = runtime class index
```

Bu mimari olarak yanlış. Aynı alan iki backend’de iki farklı anlam taşıyamaz.

## 8A-3 hedefi

Kesin karar:

```text
__vptr = vtable referansı
```

Interpreter fiziksel pointer kullanamıyorsa, bu referans “vtable handle” olacak. Ama class index doğrudan `__vptr` gibi kullanılmayacak.

## Güncellenecek dosyalar

```text
src/runtime/exec/exec_types.fbs
src/runtime/exec/exec_eval_support_helpers.fbs
src/runtime/exec/exec_class_layout_helpers.fbs
src/runtime/exec/exec_call_dispatch_helpers.fbs
```

## Kod planı

### 1. Runtime vtable handle alanı eklenecek

`exec_types.fbs` içinde runtime vtable alanlarının yanına şunlar eklenecek:

```bas
vtableClassHandles(Any) As UInteger
vtableNextHandle As UInteger
```

Yani bu bloğun yanına:

```bas
vtableClassNames(Any) As String
vtableClassSlotCounts(Any) As Integer
vtableClassSlotStart(Any) As Integer
vtableClassCount As Integer
```

şu eklenmeli:

```bas
vtableClassHandles(Any) As UInteger
vtableNextHandle As UInteger
```

### 2. VTable map oluşturulurken handle atanacak

`exec_eval_support_helpers.fbs` içinde `ExecBuildVTableMap` başında reset eklenecek:

```bas
Erase es.runtime.vtableClassHandles
es.runtime.vtableNextHandle = &h1000
```

Class kayıt edilirken:

```bas
If es.runtime.vtableClassCount = 0 Then
    ReDim es.runtime.vtableClassNames(0)
    ReDim es.runtime.vtableClassSlotCounts(0)
    ReDim es.runtime.vtableClassSlotStart(0)
    ReDim es.runtime.vtableClassHandles(0)
Else
    ReDim Preserve es.runtime.vtableClassNames(es.runtime.vtableClassCount)
    ReDim Preserve es.runtime.vtableClassSlotCounts(es.runtime.vtableClassCount)
    ReDim Preserve es.runtime.vtableClassSlotStart(es.runtime.vtableClassCount)
    ReDim Preserve es.runtime.vtableClassHandles(es.runtime.vtableClassCount)
End If
```

Sonra:

```bas
es.runtime.vtableClassHandles(classIdx) = es.runtime.vtableNextHandle
es.runtime.vtableNextHandle += 8
```

### 3. Yardımcı lookup fonksiyonları eklenecek

`exec_class_layout_helpers.fbs` içine:

```bas
Private Function ExecFindRuntimeVTableClassIndex(ByRef es As ExecState, ByRef classTypeName As String) As Integer
    Dim classUpper As String
    classUpper = UCase(Trim(classTypeName))

    Dim ci As Integer
    For ci = 0 To es.runtime.vtableClassCount - 1
        If es.runtime.vtableClassNames(ci) = classUpper Then Return ci
    Next ci

    Return -1
End Function

Private Function ExecFindRuntimeVTableHandle(ByRef es As ExecState, ByRef classTypeName As String, ByRef handleOut As UInteger) As Integer
    Dim ci As Integer
    ci = ExecFindRuntimeVTableClassIndex(es, classTypeName)
    If ci = -1 Then
        handleOut = 0
        Return 0
    End If

    handleOut = es.runtime.vtableClassHandles(ci)
    If handleOut = 0 Then Return 0

    Return 1
End Function

Private Function ExecFindRuntimeVTableClassByHandle(ByRef es As ExecState, ByVal handleValue As UInteger, ByRef classNameOut As String) As Integer
    Dim ci As Integer
    For ci = 0 To es.runtime.vtableClassCount - 1
        If es.runtime.vtableClassHandles(ci) = handleValue Then
            classNameOut = es.runtime.vtableClassNames(ci)
            Return 1
        End If
    Next ci

    classNameOut = ""
    Return 0
End Function
```

### 4. `ExecConfigureClassStorage` düzeltilecek

Mevcut yanlış blok:

```bas
' initialize object's vptr (store runtime class index in low dword)
Dim classIdx As Integer
classIdx = -1
Dim ci As Integer
For ci = 0 To es.runtime.vtableClassCount - 1
    If es.runtime.vtableClassNames(ci) = UCase(Trim(classTypeName)) Then
        classIdx = ci
        Exit For
    End If
Next ci
If classIdx <> -1 Then
    VMemPokeD(objectBase, classIdx)
    VMemPokeD(objectBase + 4, 0)
End If
```

Doğru blok:

```bas
' initialize object's __vptr as runtime vtable handle
Dim vtblHandle As UInteger
If ExecFindRuntimeVTableHandle(es, classTypeName, vtblHandle) = 0 Then
    errText = "DIM: missing runtime vtable for " & UCase(Trim(classTypeName))
    Return 0
End If

VMemPokeD(objectBase, CInt(vtblHandle))
VMemPokeD(objectBase + 4, 0)
```

### 5. `ExecAllocClassInstance` düzeltilecek

Mevcut yanlış blok:

```bas
' initialize vptr for interpreter (store class index)
Dim classIdx As Integer
classIdx = -1
Dim ci As Integer
For ci = 0 To es.runtime.vtableClassCount - 1
    If es.runtime.vtableClassNames(ci) = classUpper Then
        classIdx = ci
        Exit For
    End If
Next ci
If classIdx <> -1 Then
    VMemPokeD(objectBase, classIdx)
    VMemPokeD(objectBase + 4, 0)
End If
```

Doğru blok:

```bas
' initialize object's __vptr as runtime vtable handle
Dim vtblHandle As UInteger
If ExecFindRuntimeVTableHandle(es, classUpper, vtblHandle) = 0 Then
    errText = "exec: NEW missing runtime vtable for " & classUpper
    Return 0
End If

VMemPokeD(objectBase, CInt(vtblHandle))
VMemPokeD(objectBase + 4, 0)
```

### 6. Dispatch tarafı handle okuyabilir hale getirilecek

`exec_call_dispatch_helpers.fbs` içinde yeni fonksiyon:

```bas
Private Function ExecResolveReceiverRuntimeClass(ByRef es As ExecState, ByVal receiverAddr As UInteger, ByRef classNameOut As String) As Integer
    Dim handleValue As UInteger
    handleValue = CUInt(VMemPeekD(receiverAddr))

    If handleValue = 0 Then
        classNameOut = ""
        Return 0
    End If

    Return ExecFindRuntimeVTableClassByHandle(es, handleValue, classNameOut)
End Function
```

Sonra method dispatch içinde receiver type sadece `declType/runtimeClassType` ile değil, mümkünse `__vptr` handle ile doğrulanacak.

Geçici güvenli sıra:

```bas
Dim receiverRuntimeType As String
receiverRuntimeType = ""

If receiverAddrOut <> 0 Then
    ExecResolveReceiverRuntimeClass(es, CUInt(receiverAddrOut), receiverRuntimeType)
End If

If receiverRuntimeType <> "" Then
    receiverType = receiverRuntimeType
End If
```

## 8A-3 testleri

En az şu testler istenecek:

```text
1. CLASS A : END CLASS
   DIM a AS A
   → object[0] vtable handle 0 değil.

2. a = NEW A
   → NEW ile üretilen object[0] vtable handle 0 değil.

3. CLASS Base / CLASS Child EXTENDS Base
   DIM x AS Child
   → x.__vptr Child vtable handle olmalı.

4. Interpreter method dispatch:
   Child override varsa base değil Child implementasyonu çağrılmalı.
```

---

# 8A-4 — x64 vtable label üretimini merkezileştirme

## Mevcut sorun

`src13` içinde vtable label şu şekilde elle kuruluyor:

```bas
vtblLabel = className & "_VTBL"
```

Allocation tarafında da ayrı ayrı:

```bas
lea rdx, [rel " & classTypeName & "_VTBL]
```

ve:

```bas
lea rdx, [rel " & declTypeName & "_VTBL]
```

Bu tehlikeli çünkü:

```text
className farklı casing ile gelirse label bozulur.
className içinde namespace/symbol karakteri varsa NASM label bozulur.
emit ve kullanım yerleri farklı string üretirse link hatası çıkar.
```

## 8A-4 hedefi

Tek merkez:

```bas
X64ClassVTableLabel(className)
```

Her yerde bu kullanılacak.

## Güncellenecek dosyalar

```text
src/codegen/x64/code_generator.fbs
src/codegen/x64/cg_context.fbs
```

## Kod planı

### 1. Label helper eklenecek

`code_generator.fbs` üst helper bölümüne ekle:

```bas
Private Function X64SanitizeSymbolPart(ByRef rawText As String) As String
    Dim s As String
    s = Trim(rawText)

    Dim outText As String
    outText = ""

    Dim i As Integer
    For i = 1 To Len(s)
        Dim ch As String
        ch = Mid(s, i, 1)

        If (ch >= "A" And ch <= "Z") Or (ch >= "a" And ch <= "z") Or (ch >= "0" And ch <= "9") Or ch = "_" Then
            outText &= ch
        Else
            outText &= "_"
        End If
    Next i

    If outText = "" Then outText = "anon"

    Dim firstCh As String
    firstCh = Left(outText, 1)
    If firstCh >= "0" And firstCh <= "9" Then
        outText = "_" & outText
    End If

    Return outText
End Function

Private Function X64ClassVTableLabel(ByRef classNameRaw As String) As String
    Dim classPart As String
    classPart = X64SanitizeSymbolPart(X64Upper(Trim(classNameRaw)))
    Return "__uxb_vtbl_" & classPart
End Function
```

Eğer `X64SanitizeSymbol` zaten varsa, yeni fonksiyon ona bağlanabilir. Ama `src13` gerçekliğinde doğrudan bu helper en güvenli çözümdür.

### 2. VTable emit yeri değiştirilecek

Mevcut:

```bas
Dim vtblLabel As String
vtblLabel = className & "_VTBL"
```

Doğru:

```bas
Dim vtblLabel As String
vtblLabel = X64ClassVTableLabel(className)
```

### 3. `NEW_EXPR` allocation değiştirilecek

Mevcut:

```bas
X64EmitText cg, "    lea rdx, [rel " & classTypeName & "_VTBL]"
X64EmitText cg, "    mov [rax], rdx"
```

Doğru:

```bas
Dim vtblLabel As String
vtblLabel = X64ClassVTableLabel(classTypeName)

X64EmitText cg, "    lea rdx, [rel " & vtblLabel & "]"
X64EmitText cg, "    mov [rax], rdx"
```

### 4. `DIM class default allocation` değiştirilecek

Mevcut:

```bas
X64EmitText cg, "    lea rdx, [rel " & declTypeName & "_VTBL]"
X64EmitText cg, "    mov [rax], rdx"
```

Doğru:

```bas
Dim vtblLabel As String
vtblLabel = X64ClassVTableLabel(declTypeName)

X64EmitText cg, "    lea rdx, [rel " & vtblLabel & "]"
X64EmitText cg, "    mov [rax], rdx"
```

### 5. `X64RegisterClassVTable` aynı helper’a bağlanacak

Emit edilen label ile kullanılan label aynı helper’dan çıkmalı.

Yani `X64EmitClassVTable` dışında hiçbir yerde:

```bas
"_VTBL"
```

kalmamalı.

Arama koşulu:

```text
grep "_VTBL" src/codegen/x64/code_generator.fbs
```

Beklenen:

```text
Sadece helper fonksiyon içinde veya yorumlarda kalabilir.
```

### 6. `cg_context.fbs` declare eklenebilir

Eğer helper başka x64 dosyalarından kullanılacaksa `cg_context.fbs` içine:

```bas
Declare Function X64ClassVTableLabel(ByRef classNameRaw As String) As String
```

Ama sadece `code_generator.fbs` içinde kullanılacaksa gerek yok.

## 8A-4 testleri

Şu testler istenecek:

```text
1. CLASS A / DIM a AS A
   ASM içinde __uxb_vtbl_A label olmalı.

2. CLASS Dog / a = NEW Dog
   allocation içinde lea rdx, [rel __uxb_vtbl_DOG] olmalı.

3. grep:
   code_generator.fbs içinde className & "_VTBL" kalmamalı.
   declTypeName & "_VTBL" kalmamalı.
   classTypeName & "_VTBL" kalmamalı.

4. build:
   fbc build PASS.

5. x64 codegen:
   NASM/link aşamasında undefined DOG_VTBL gibi eski label hatası olmamalı.
```

---

# Uygulama sırası

## Önce 8A-3

Çünkü `__vptr` anlamı netleşmeden label merkezi yapmak eksik kalır.

Sıra:

```text
8A-3.1 exec_types.fbs runtime vtable handle alanları
8A-3.2 ExecBuildVTableMap handle atama
8A-3.3 ExecFindRuntimeVTableHandle helper
8A-3.4 ExecConfigureClassStorage düzeltme
8A-3.5 ExecAllocClassInstance düzeltme
8A-3.6 receiver dispatch handle doğrulama
8A-3.7 build + interpreter class/new test
```

## Sonra 8A-4

```text
8A-4.1 X64ClassVTableLabel helper
8A-4.2 X64EmitClassVTable label değişimi
8A-4.3 NEW_EXPR vptr emit değişimi
8A-4.4 DIM class default allocation vptr emit değişimi
8A-4.5 grep "_VTBL" kontrolü
8A-4.6 build + x64 class allocation test
```

---

# Verilecek iş emri

Şunu aynen verebilirsin:

```text
8A-3’e geç. Bu “hamle” değil, 8A alt işi.

Amaç: __vptr anlamını interpreter/runtime ve x64 arasında tekleştirmek.
src13 gerçekliğinde runtime şu anda objectBase’e classIdx yazıyor:
VMemPokeD(objectBase, classIdx)
VMemPokeD(objectBase + 4, 0)

Bu yanlış. __vptr artık class index değil runtime vtable handle olacak.

Yap:
1. exec_types.fbs içine vtableClassHandles() ve vtableNextHandle alanlarını ekle.
2. ExecBuildVTableMap içinde bu handle dizisini resetle ve her class’a &h1000’den başlayan benzersiz handle ata.
3. ExecFindRuntimeVTableClassIndex, ExecFindRuntimeVTableHandle, ExecFindRuntimeVTableClassByHandle helper’larını ekle.
4. ExecConfigureClassStorage ve ExecAllocClassInstance içinde classIdx yazmayı kaldır; yerine vtable handle yaz.
5. Method dispatch sırasında receiverAddr varsa object[0] handle’dan runtime class çözmeyi dene; bulunursa receiverType olarak bunu kullan.
6. Build al.
7. DIM class ve NEW class içeren küçük interpreter testleri çalıştır.
8. AST/parser regression testini tekrar çalıştır.
9. Değişen dosyaları ve test sonuçlarını raporla.

8A-3 bittikten sonra beklemeden 8A-4’e geç.

8A-4 amaç: x64 vtable label üretimini merkezileştirmek.
1. code_generator.fbs içine X64SanitizeSymbolPart ve X64ClassVTableLabel helper’larını ekle.
2. X64EmitClassVTable içinde vtblLabel = className & "_VTBL" kullanımını kaldır, X64ClassVTableLabel kullan.
3. NEW_EXPR allocation’da classTypeName & "_VTBL" kullanımını kaldır, X64ClassVTableLabel(classTypeName) kullan.
4. DIM class default allocation’da declTypeName & "_VTBL" kullanımını kaldır, X64ClassVTableLabel(declTypeName) kullan.
5. grep "_VTBL" ile eski string üretimi kalmadığını doğrula.
6. Build al.
7. Class allocation içeren x64 codegen testini çalıştır.
8. Undefined *_VTBL label hatası oluşmadığını raporla.
```
#include → %%INCLUDE hatası geri alınmış. Bu iyi.

Ama AST JSON sorunu hâlâ duruyor. Artık sebep büyük ihtimalle şunlardan biri:

1. CLI argümanları doğru parse edilmiyor.
2. astJsonOut değişkeni dolmuyor.
3. ASTWriteJson çağrısına ulaşılmıyor.
4. Source parse başarısız ama hata ekrana/log’a net basılmıyor.
5. AST output path oluşturulamıyor.
6. Program sessiz çıkıyor.
Ne yapılmalı?

Şimdi başka yere dağılmadan sadece main.bas içinde --ast-json-out akışı izlenmeli.

Sıradaki kontrol sırası:

1. main.bas içinde --ast-json-out argümanı gerçekten yakalanıyor mu?
2. astJsonOut değişkeni doluyor mu?
3. sourceText okundu mu?
4. RTParseProgram / parse sonucu başarılı mı?
5. ps.ast.rootNode geçerli mi?
6. ASTWriteJson çağrılıyor mu?
7. ASTWriteJson dönüş değeri 0 mı 1 mi?
8. astJsonErr ne söylüyor?

Geçici debug satırları eklenmeli:

Print "[DEBUG] astJsonOut=" & astJsonOut
Print "[DEBUG] inputFile=" & inputFile
Print "[DEBUG] source length=" & Str(Len(sourceText))
Print "[DEBUG] parse ok=" & Str(parseOk)
Print "[DEBUG] root node=" & Str(ps.ast.rootNode)
Print "[DEBUG] ASTWriteJson result=" & Str(ok)
Print "[DEBUG] astJsonErr=" & astJsonErr
Kısa sonuç

Şu an 1 numaralı hata düzeltilmiş görünüyor:

PreprocessHashIncludes kaldırıldı.

Ama AST JSON üretim hattı hâlâ bozuk.

Şimdi yapılacak iş: main.bas içinde --ast-json-out hattına debug print koyup, programın hangi noktada sessizce düştüğünü bulmak.

PreprocessHashIncludes kaldırılması doğru.
Bu konu kapandı. #include ile %%INCLUDE asla otomatik çevrilmeyecek.

Şimdi seçilecek yol:

Karar: 2. yol değil, önce 1. yol

Yani hemen runtime’a dalmayın.

Önce şu yapılmalı:

--extract-src / harness-vs-source ayrımı

Çünkü şu an sorun şu:

test harness dosyası ≠ gerçek uXBasic kaynak dosyası

Sen 80_h8a...bas gibi test dosyasını CLI’ye verince compiler onu uXBasic program sanıyor. Oysa o dosya FreeBASIC test harness’ı olabilir; içinde src = "...basic kod..." var.

Bu yüzden önce dosya tipi ayrılmalı.

Uygulanacak kesin karar
1. main.bas içinde mod ayrımı yapılacak
mode_source
mode_harness
mode_extract_src
2. CLI davranışı şöyle olacak
uxbasic_cli.exe test.uxb --ast-json-out out/ast.json

Gerçek uXBasic kaynaksa:

doğrudan parse et → AST yaz

Harness ise:

hata ver:
Bu dosya FreeBASIC test harness. --extract-src kullan.

Şu komutla:

uxbasic_cli.exe tests\basicCodeTests\80_h8a_operator_numeric_parity.bas --extract-src --ast-json-out tests\basicCodeTests\out_probe_80\ast.json

Yapılacak:

harness içindeki src string’i çıkar
çıkan kodu parser’a ver
AST yaz
Neden runtime AST-dump şu an erken?

Çünkü runtime’a dalarsanız:

RTParseProgram
memory_exec
runtime parser
test harness
ASTWriteJson

hepsi birbirine karışır.

Şu anda önce basit gerçeklik lazım:

CLI hangi dosyayı parse ediyor?
O dosya gerçek uXBasic mi?
Yoksa FreeBASIC test harness mı?

Bu ayrım olmadan runtime dump temiz olmaz.

VSCode’a verilecek karar cümlesi

Şunu uygulat:

Karar: PreprocessHashIncludes kaldırılması doğru. Devamında runtime AST-dump’a geçme. Önce main.bas içine harness-vs-source ayrımı ve --extract-src modu ekle. 
FreeBASIC test harness dosyaları doğrudan uXBasic source gibi parse edilmeyecek.
--extract-src verilirse harness içindeki src string literal çözülecek, çıkan uXBasic kodu parse edilecek ve --ast-json-out bu AST’yi yazacak.
Sonra test komutu
cd /d C:\Users\mete\Downloads\BasicOyunSource\uXBasic_repo

build\uxbasic_cli.exe tests\basicCodeTests\80_h8a_operator_numeric_parity.bas --extract-src --ast-json-out tests\basicCodeTests\out_probe_80\ast.json

Beklenen:

tests\basicCodeTests\out_probe_80\ast.json oluşmalı

Bu geçmeden class/vtable/operator konusuna dönülmeyecek.
asagidaki isler de yapilacak
unutma!! bu compilerin eksiklikleri hamele 8 de kapatilacak.
Çok kritik bir noktaya bastın Mete abi — burada kafa karışması tamamen haklı 👍
Şimdi net ve teknik şekilde ayıralım:

---

## 🔴 1. `#include` nedir? (FreeBASIC tarafı)

`#include` = **FreeBASIC’in kendi preprocessor komutu**

```bas
#include "dosya.fbs"
```

Bu:

* Derleme zamanında çalışır
* FreeBASIC derleyicisi (`fbc`) tarafından işlenir
* Dosyayı fiziksel olarak koda ekler

👉 Bu **host language (FreeBASIC)** seviyesidir.

---

## 🟢 2. `%%INCLUDE` nedir? (uXBasic tarafı)

```bas
%%INCLUDE "file.bas"
```

Bu:

* uXBasic’in **kendi dili için yazılmış preprocessor komutu**
* Senin `lexer_preprocess.fbs` tarafından işlenir
* FreeBASIC bunu **tanımaz**

👉 Bu **senin compiler’ın frontend katmanı**

---

## ⚠️ Kritik ayrım

| Komut       | Kimin?    | Ne zaman çalışır                    |
| ----------- | --------- | ----------------------------------- |
| `#include`  | FreeBASIC | derleme zamanı (fbc)                |
| `%%INCLUDE` | uXBasic   | senin lexer/preprocessor aşamasında |

---

## 💥 Problem nerede çıktı?

Senin `main.bas` içinde şuna benzer bir şey olmuş:

```bas
%%INCLUDE "parser/parser_stmt.fbs"
```

Ama bu dosya:

* FreeBASIC tarafından derleniyor
* uXBasic preprocessor henüz çalışmamış

👉 Sonuç:

**fbc bunu tanımaz → hata verir veya yok sayar**

---

## 🔥 Neden yanlış?

Çünkü:

```text
FreeBASIC derlenirken:
   ↓
fbc çalışır
   ↓
# include çalışır
   ↓
program compile edilir

AMA

%%INCLUDE çalışmaz ❌
```

---

## 🧠 Doğru mimari

### ✔ Doğru kullanım

#### FreeBASIC kodunda:

```bas
#include "parser/parser_stmt.fbs"
```

#### uXBasic kullanıcı kodunda:

```basic
%%INCLUDE "lib/math.bas"
```

---

## ⚠️ src12’de yapılan değişim neden riskli?

Senin gördüğün:

> `#include` → `%%INCLUDE` çevrilmiş

Bu şu anlama gelir:

👉 **FreeBASIC include mekanizması kırılmış olabilir**

Çünkü:

* `main.bas` artık bağımlı dosyaları alamaz
* compiler eksik modülle derlenir
* garip runtime/AST hataları çıkar

---

## 🧨 Büyük hata tipi (çok önemli)

Bu tür bir değişim:

```bas
# include → %%INCLUDE
```

👉 Eğer yanlış yerde yapılırsa:

* parser yokmuş gibi davranır
* AST boş çıkar
* CLI probe AST üretmez (senin yaşadığın olay!)

---

## 🎯 Sana net teşhis

Senin şu sorununla **%100 bağlantılı:**

> AST dosyası oluşmuyor

Çünkü:

👉 Parser dosyaları aslında compile edilmemiş olabilir

---

## 🔍 Nasıl test edersin (çok net)

`main.bas` içine geçici olarak şunu koy:

```bas
Print "PARSER LOADED"
```

ve parser dosyasının içine:

```bas
Print "PARSER FILE ACTIVE"
```

Eğer ikinci yazmıyorsa:

👉 include çalışmıyor demektir

---

## 🔧 Doğru çözüm

Şu kuralı **asla bozma:**

```text
FreeBASIC dosyalarında:
    SADECE #include

uXBasic dilinde:
    SADECE %%INCLUDE
```

---

## 🔥 Sonuç (net)

* `#include` = compiler’ı kurar
* `%%INCLUDE` = dil kullanıcı kodunu işler

👉 Bunları karıştırmak:

> compiler’ı sessizce bozar (en tehlikeli bug)

---

Mete abi, VSCode notunda görünen işlem şu: `main.bas` içine `PreprocessHashIncludes` eklenmiş ve `#include` satırları `%%INCLUDE`’e çevrilmeye çalışılmış; sonra bunun test harness dosyalarını bozduğu yine notta yazıyor. 

Ben `src10 → src12` statik karşılaştırmasını yaptım. Ana değişen dosyalar:

```text
main.bas
semantic/semantic_pass.fbs
semantic/mir.fbs
semantic/mir_model.fbs
semantic/mir_evaluator.fbs
semantic/layout/layout_type_table.fbs
runtime/exec/exec_types.fbs
runtime/exec/exec_class_layout_helpers.fbs
runtime/exec/exec_eval_support_helpers.fbs
runtime/exec/exec_call_dispatch_helpers.fbs
codegen/x64/cg_context.fbs
codegen/x64/code_generator.fbs
```

## 1. En büyük hata: `main.bas` içindeki `#include → %%INCLUDE`

### Hatalı bölüm — `src12/main.bas`, yaklaşık 165

```bas
Private Function PreprocessHashIncludes(ByRef src As String) As String
...
If Len(trimmed) >= 8 And UCase(Left(trimmed, 8)) = "#INCLUDE" Then
    outText &= "%%INCLUDE " & rest & Chr(10)
```

### Neden yanlış?

Çünkü iki ayrı dünya karıştırılmış:

```text
FreeBASIC compiler dosyalarında: #include
uXBasic kullanıcı kodunda:      %%INCLUDE
```

`#include` FreeBASIC’in kendi derleme zamanı komutudur.
`%%INCLUDE` uXBasic’in lexer/preprocessor komutudur.

Test harness dosyalarında FreeBASIC tarzı `#include` olabilir. Bunları kör şekilde `%%INCLUDE` yapmak, uXBasic parser’a FreeBASIC compiler kaynaklarını yedirmeye çalışır. Bu da AST üretimini bozabilir.

### Doğrusu

Bu fonksiyon ya tamamen kaldırılmalı ya da sadece **uXBasic kaynak modu** için kontrollü çalışmalı.

Daha güvenli doğru yaklaşım:

```bas
' HATALI:
sourceText = PreprocessHashIncludes(sourceText)

' DOĞRU:
' FreeBASIC harness dosyasını uXBasic kaynak gibi parse etme.
' Eğer dosya test harness ise doğrudan statik AST parse yapılmamalı.
```

## 2. `main.bas` AST JSON klasörü oluşturma kısmı kısmen doğru ama Windows’a bağımlı

### Bölüm — `src12/main.bas`, yaklaşık 490

```bas
mkCmd = "cmd /c mkdir " & Chr(34) & astJsonParent & Chr(34)
Shell mkCmd
```

### Sorun

Bu sadece Windows için çalışır. Ayrıca `Shell` sonucunu kontrol etmiyor.

### Daha doğru mantık

```bas
If Dir(astJsonParent) = "" Then
    ' platform bağımlı olmayan mkdir helper kullanılmalı
    ' veya Shell sonucu kontrol edilmeli
End If
```

Bu ölümcül hata değil, ama CLI güvenilirliği için zayıf.

## 3. Semantic vtable slot eklemesi yarım ama fikir doğru

### Yeni bölüm — `semantic/semantic_pass.fbs`, yaklaşık 893–1061

```bas
CLASS_METHOD_DECL nodes with child "CLASS_METHOD_SLOT"
```

### Doğru tarafı

Virtual/override metodlara slot vermek gerekli. Bu, class dispatch için doğru yöndür.

### Riskli tarafı

Bu semantic AST’ye yeni child node ekliyor:

```bas
slotNode = ASTNewNode(ps.ast, "CLASS_METHOD_SLOT", ...)
ASTAddRoleChild ps.ast, ch, slotNode, "VTABLE_SLOT"
```

Ama parser, AST exporter, MIR, runtime ve x64 aynı node’u tutarlı yorumlamazsa sistem kırılır.

### Eksik kontrol

Şu kontroller net değil:

```text
Base class cycle var mı?
Aynı method iki kez slot alıyor mu?
Override olmayan method base virtual’ı sessiz eziyor mu?
Interface methodları slot sistemine dahil mi?
Destructor/constructor slot dışı tutuluyor mu?
```

## 4. Layout tarafında `__vptr` eklenmiş, doğru ama tüm katmanlar aynı anlamı kullanmıyor

### Bölüm — `semantic/layout/layout_type_table.fbs`, yaklaşık 184

```bas
If UCase(Trim(ps.ast.nodes(declNode).kind)) = "CLASS_STMT" Then
    AddLayoutField("__vptr", "POINTER", 0, 8, 8, ...)
    curOffset = 8
End If
```

### Doğru tarafı

Class nesnesinin başına vtable pointer koymak doğru mimaridir.

### Büyük sorun

Runtime tarafında aynı `__vptr` gerçek pointer gibi değil, class index gibi kullanılmış.

Runtime:

```bas
VMemPokeD(objectBase, classIdx)
VMemPokeD(objectBase + 4, 0)
```

x64:

```asm
lea rdx, [rel CLASS_VTBL]
mov [rax], rdx
```

Yani:

```text
Interpreter: __vptr = class index
x64:         __vptr = gerçek vtable adresi
```

Bu çok önemli mimari tutarsızlık.

### Doğrusu

Ya ikisi de gerçek vtable pointer kullanmalı:

```text
__vptr = vtable address
```

Ya da interpreter için ayrı metadata alanı olmalı:

```text
__vptr_runtime_class_index ayrı
__vptr gerçek vtable pointer ayrı
```

## 5. Runtime vtable map eklenmiş ama method eşleşmesi kırılgan

### Bölüm — `runtime/exec/exec_eval_support_helpers.fbs`, yaklaşık 119

```bas
ExecBuildVTableMap
```

### Sorunlu mantık

Key şu şekilde kuruluyor:

```bas
key = className & "_" & UCase(Trim(implMethod(i)))
```

Ama override durumunda `className` derived class, implementer ise base veya derived olabilir. Sonra lookup tarafında suffix ile aranıyor:

```bas
If Right(key, needSuffix) = "_" & mUpper Then
```

Bu çalışabilir ama kırılgan. Aynı method adı farklı inheritance zincirlerinde karışabilir.

### Doğrusu

VTable entry key şu olmalı:

```text
dispatchClass + slot
```

Method adı yardımcı bilgi olmalı, ana lookup değil.

Yani:

```bas
vtableEntryDispatchClass(eidx) = className
vtableEntrySlot(eidx) = i
vtableEntryImplRoutine(eidx) = implOwner & "_" & implMethod
```

## 6. MIR tarafında `__VT_SLOT__` eklenmiş ama receiver runtime type yok

### Bölüm — `semantic/mir_evaluator.fbs`, yaklaşık 2036

```bas
If Left(fnName, 12) = "__VT_SLOT__:" Then
```

### Sorun

Token şuna benziyor:

```text
__VT_SLOT__:CLASS:slot
```

Ama gerçek virtual dispatch için gereken şey:

```text
receiver nesnesinin runtime class type’ı
```

Şu an call adı içine class gömülmüş. Bu, polymorphism’i zayıflatır. Örneğin:

```basic
DIM a AS Animal
a = NEW Dog
a.Speak()
```

Burada slot Dog vtable’dan çözülmeli. Ama MIR token `Animal:slot` olarak kaldıysa Dog override çalışmayabilir.

### Doğrusu

MIR call şöyle modellenmeli:

```text
MIR_CALL_VIRTUAL receiver, slot
```

Yani function name string içine `__VT_SLOT__` gömmek geçici hack’tir.

## 7. x64 codegen’de class size hatası sessizce bastırılmış

### Hatalı değişim — `codegen/x64/code_generator.fbs`, yaklaşık 4478 ve 6336

```bas
If classSize <= 0 Then classSize = 8
```

### Bu çok tehlikeli

`classSize <= 0` gerçek hata demektir. Layout çözülememiştir. Bunu 8’e düşürmek compiler’ı susturur ama runtime memory corruption üretir.

### Doğrusu

```bas
If classSize <= 0 Then
    errText = "x64-codegen: class layout invalid / unresolved: " & classTypeName
    Return 0
End If
```

Bu kesin geri alınmalı.

## 8. x64 vtable emit var ama label garanti değil

### Bölüm — `codegen/x64/code_generator.fbs`, yaklaşık 84

```bas
vtblLabel = className & "_VTBL"
X64EmitData cg, vtblLabel & ": dq ..."
```

### Sorun

Sonra allocation’da:

```asm
lea rdx, [rel classTypeName_VTBL]
mov [rax], rdx
```

Eğer `classTypeName` casing farklıysa veya vtable daha önce emit edilmediyse NASM/link hatası çıkar.

### Doğrusu

Label üretimi merkezi olmalı:

```bas
Private Function X64ClassVTableLabel(ByRef className As String) As String
    Return "__uxb_vtbl_" & LCase(Sanitize(className))
End Function
```

Ve her yerde aynı helper kullanılmalı.

## 9. Operator overload hook erken ve tehlikeli eklenmiş

### Bölüm — `codegen/x64/code_generator.fbs`, yaklaşık 4756

```bas
' Operator-overload hook: if LHS is class instance and class defines OP_ADD/ADD
```

### Sorun

Compiler henüz F80, class layout, vtable, receiver dispatch tam değilken operator overload eklemek erken. Bu kod:

```bas
a + b
```

ifadesini class method call’a çevirmeye çalışıyor. Ama type inference tam değilse yanlış method çağırır veya stack/register düzenini bozar.

### Doğrusu

Şimdilik kapatılmalı veya semantic flag arkasına alınmalı:

```bas
If cg.enableOperatorOverload <> 0 Then
   ...
End If
```

## 10. x64 virtual call güvenli değil

### Bölüm — `codegen/x64/code_generator.fbs`, yaklaşık 7129

```asm
mov rax, rcx
mov rax, [rax]
mov rax, [rax + slot*8]
call rax
```

### Eksik kontroller

Şunlar yok:

```text
rcx null mı?
[rcx] valid vtable mı?
slot entry 0 mı?
method signature uyumlu mu?
return type uyumlu mu?
```

Debug build için en azından null kontrol olmalı.

## Net sonuç

`src12`, `src10` üzerine gerçek bir “temiz ilerleme” değil; daha çok **vtable/class dispatch denemesi + AST JSON/harness düzeltme denemesi** olmuş.

En kritik geri alınacak / düzeltilecek yerler:

```text
1. main.bas PreprocessHashIncludes kaldırılmalı veya devre dışı bırakılmalı.
2. #include → %%INCLUDE otomatik dönüşümü yapılmamalı.
3. x64 classSize <= 0 Then classSize = 8 geri alınmalı.
4. Interpreter __vptr ile x64 __vptr aynı anlama getirilmeli.
5. MIR __VT_SLOT__ string hack’i kalıcı tasarım sayılmamalı.
6. Operator overload hook kapatılmalı.
7. VTable label üretimi merkezi helper’a bağlanmalı.
```

Şu an yapılacak en doğru iş:

```text
AŞAMA 1 — Hasar kontrolü
src12’den PreprocessHashIncludes kaldır.
classSize=8 fallback’i kaldır.
operator overload hook’u kapat.

AŞAMA 2 — Çekirdek test
PRINT 1
DIM i AS I32
DIM x AS F64
TYPE field
CLASS without virtual
CLASS virtual sadece semantic

AŞAMA 3 — VTable yeniden
Önce semantic slot.
Sonra interpreter dispatch.
Sonra MIR dispatch.
En son x64 dispatch.
```

Kısaca: **src12’deki en tehlikeli hata `#include` ile `%%INCLUDE`’ün karıştırılması ve x64 class layout hatasının 8 byte ile susturulmasıdır.**
## 10 hatayı düzeltmek için kesin yol haritası

### 1. `#include → %%INCLUDE` hatası

`main.bas` içindeki otomatik dönüşüm tamamen kaldırılacak.

**Kural:**

```text
FreeBASIC compiler kaynaklarında:
#include

uXBasic kullanıcı kaynaklarında:
%%INCLUDE
```

**Yapılacak:**

```text
main.bas
  - PreprocessHashIncludes fonksiyonu kaldırılacak.
  - sourceText = PreprocessHashIncludes(sourceText) satırı kaldırılacak.
```

**Doğru sistem:**

```text
.bas test harness dosyası FreeBASIC ise uXBasic parser’a verilmez.
uXBasic test kaynağı ayrı .uxb / .bas dosyası olarak parser’a verilir.
Harness içindeki src string’i parse edilecekse ayrı extractor/test runner yazılır.
```

---

### 2. AST JSON / test harness ayrımı

`--ast-json-out` yalnızca gerçek uXBasic kaynak dosyasının AST’sini yazmalı.

**Yapılacak:**

```text
main.bas
  - input dosyası FreeBASIC harness mı, uXBasic kaynak mı ayırt edilecek.
  - Harness dosyası tespit edilirse statik parser’a verilmez.
```

**Gerekli ayrım:**

```text
mode=source
mode=harness
mode=extract-src
```

**Doğru CLI davranışı:**

```text
uxbasic_cli.exe program.uxb --ast-json-out out/ast.json
    → program.uxb AST yazılır.

uxbasic_cli.exe tests/.../80_h8a.bas --ast-json-out out/ast.json
    → hata: harness dosyası doğrudan AST parse edilemez.

uxbasic_cli.exe tests/.../80_h8a.bas --extract-src --ast-json-out out/ast.json
    → harness içindeki src string’i çıkarılır ve onun AST’si yazılır.
```

---

### 3. `classSize <= 0 Then classSize = 8` hatası

Bu fallback kesin kaldırılacak.

**Hatalı mantık:**

```bas
If classSize <= 0 Then classSize = 8
```

**Doğru mantık:**

```bas
If classSize <= 0 Then
    errText = "x64-codegen: unresolved class layout: " & classTypeName
    Return 0
End If
```

**Yapılacak dosyalar:**

```text
codegen/x64/code_generator.fbs
semantic/layout/layout_type_table.fbs
semantic/semantic_pass.fbs
```

**Gerekli garanti:**

```text
CLASS layout yoksa x64 codegen başlamaz.
TYPE/CLASS field offset yoksa codegen başlamaz.
__vptr offset kesin 0 olmalı.
object size semantic/layout tarafından kesin hesaplanmalı.
```

---

### 4. `__vptr` anlamı interpreter ve x64 arasında eşitlenecek

Şu an tehlikeli ayrım var:

```text
Interpreter: __vptr = class index
x64:         __vptr = vtable address
```

Bu kabul edilmeyecek.

**Kesin karar:**

```text
__vptr her backend’de gerçek vtable pointer anlamına gelecek.
```

**Yapılacak:**

```text
runtime/exec/exec_types.fbs
runtime/exec/exec_class_layout_helpers.fbs
runtime/exec/exec_eval_support_helpers.fbs
codegen/x64/code_generator.fbs
semantic/layout/layout_type_table.fbs
```

**Runtime model:**

```text
object + 0 = __vptr
object + 8 = ilk kullanıcı field
```

**Interpreter için çözüm:**

Interpreter fiziksel pointer kullanamıyorsa tablo handle kullanacak ama adı `__vptr` olmayacak.

```text
__vptr             = gerçek/soyut vtable referansı
__class_meta_id    = sadece interpreter iç metadata id
```

**Object allocation sonrası:**

```text
obj.__vptr = VTableOf(RuntimeClass)
obj.__class_meta_id = RuntimeClassId   ; sadece interpreter gerekiyorsa
```

---

### 5. VTable label üretimi merkezileştirilecek

Aynı class için farklı label üretilmeyecek.

**Yeni helper:**

```bas
Private Function X64ClassVTableLabel(ByRef className As String) As String
    Dim s As String
    s = X64SanitizeSymbol(LCase(Trim(className)))
    Return "__uxb_vtbl_" & s
End Function
```

**Yapılacak:**

```text
codegen/x64/cg_context.fbs
codegen/x64/code_generator.fbs
```

**Tüm kullanım noktaları aynı helper’a bağlanacak:**

```text
vtable emit
object allocation
virtual call
debug dump
external symbol list
```

---

### 6. Virtual metot ve sihirli metot adlandırması

Kesin söz dizimi ayrılacak.

```text
Virtual / internal dispatch metotları:
<__isim__>

Sihirli metotlar:
<isim>
```

**Örnek:**

```text
<__init__>       internal constructor binding
<__del__>        internal destructor binding
<__vcall__>      internal virtual dispatch helper
<__str__>        internal stringify dispatch helper

<add>            operator +
<sub>            operator -
<mul>            operator *
<div>            operator /
<eq>             =
<lt>             <
<index>          []
<setindex>       [] =
<call>           callable object
<str>            user-level string conversion
```

**Yapılacak:**

```text
lexer/lexer_keyword_table.fbs
parser/parser_stmt.fbs
parser/parser_expr.fbs
semantic/semantic_pass.fbs
semantic/mir.fbs
codegen/x64/code_generator.fbs
runtime/exec/*
```

**Kural:**

```text
<__...__> compiler/runtime iç protokol.
<...> kullanıcıya açık magic/operator metodu.
Normal method ismi ile magic method ismi çakışmayacak.
```

---

### 7. Class ve OOP sistemi tam yol haritası

OOP sistemi 8 katmanda tamamlanacak.

#### 7.1 Parser katmanı

Desteklenecek:

```basic
CLASS Animal
    FIELD name AS STRING
    VIRTUAL FUNCTION <str>() AS STRING
    VIRTUAL SUB Speak()
END CLASS

CLASS Dog EXTENDS Animal
    OVERRIDE SUB Speak()
    FUNCTION <add>(other AS Dog) AS Dog
END CLASS
```

Parser node’ları:

```text
CLASS_STMT
CLASS_EXTENDS
CLASS_FIELD_DECL
CLASS_METHOD_DECL
CLASS_METHOD_ATTR
CLASS_METHOD_NAME
CLASS_METHOD_PARAMS
CLASS_METHOD_RET
CLASS_METHOD_BODY
```

#### 7.2 AST katmanı

Her class node şunları taşıyacak:

```text
className
baseClassName
fieldList
methodList
constructorList
destructorList
interfaceList
sourceLocation
```

Her method node şunları taşıyacak:

```text
ownerClass
methodName
normalizedName
isVirtual
isOverride
isStatic
isConstructor
isDestructor
isMagic
magicKind
returnType
paramTypes
slotIndex
```

#### 7.3 Semantic katmanı

Zorunlu kontroller:

```text
Base class var mı?
Inheritance cycle var mı?
Field adı çakışıyor mu?
Method overload imzası çakışıyor mu?
Override edilen method gerçekten virtual mı?
Override signature birebir uyumlu mu?
Constructor virtual olamaz.
Destructor slot almaz; ayrı lifecycle protokolüdür.
Magic method signature doğru mu?
Abstract/interface method implement edilmiş mi?
```

#### 7.4 Layout katmanı

Nesne layout:

```text
offset 0: __vptr
offset 8: base fields
offset N: derived fields
alignment: max(field alignment, pointer alignment)
```

Zorunlu tablolar:

```text
ClassLayoutTable
FieldOffsetTable
MethodSymbolTable
VTableLayoutTable
InterfaceDispatchTable
```

#### 7.5 MIR katmanı

String hack kaldırılacak.

Yanlış:

```text
CALL "__VT_SLOT__:Class:3"
```

Doğru MIR opcode:

```text
MIR_NEW_OBJECT className
MIR_CALL_METHOD receiver, methodId
MIR_CALL_VIRTUAL receiver, slotIndex, signatureId
MIR_CALL_MAGIC receiver, magicKind, args
MIR_GET_FIELD receiver, fieldId
MIR_SET_FIELD receiver, fieldId, value
MIR_INSTANCEOF receiver, classId
MIR_CAST_OBJECT receiver, targetClassId
MIR_DESTROY_OBJECT receiver
```

#### 7.6 Interpreter katmanı

Runtime tabloları:

```text
RuntimeClassTable
RuntimeVTable
RuntimeMethodTable
RuntimeObjectHeader
RuntimeInterfaceMap
```

Object header:

```text
__vptr
__class_meta_id
__refcount / flags
```

Virtual call:

```text
receiver null kontrolü
runtime class bulunur
slot okunur
method target bulunur
signature kontrol edilir
call dispatch yapılır
```

#### 7.7 x64 codegen katmanı

Üretilecek:

```asm
; object allocation
call __uxb_alloc
mov [rax + 0], __uxb_vtbl_Dog
```

Virtual call:

```asm
test rcx, rcx
jz __uxb_null_object_error
mov rax, [rcx + 0]
test rax, rax
jz __uxb_null_vtable_error
mov rax, [rax + slot*8]
test rax, rax
jz __uxb_null_vslot_error
call rax
```

#### 7.8 Test katmanı

Zorunlu testler:

```text
class_empty
class_field_i32
class_field_f64
class_inheritance_field_offset
class_method_direct_call
class_virtual_call_base_ref
class_override_signature_fail
class_constructor
class_destructor
class_magic_add
class_magic_str
class_null_virtual_call
```

---

### 8. `__VT_SLOT__` string hack’i gerçek MIR opcode’a çevrilecek

**Mevcut geçici yapı kaldırılacak:**

```text
__VT_SLOT__:Class:slot
```

**Yeni yapı:**

```text
MIR_CALL_VIRTUAL
  receiverReg
  slotIndex
  signatureId
  resultReg
```

**Yapılacak dosyalar:**

```text
semantic/mir_model.fbs
semantic/mir.fbs
semantic/mir_evaluator.fbs
runtime/exec/exec_call_dispatch_helpers.fbs
codegen/x64/code_generator.fbs
```

**Zorunlu veri:**

```text
receiver expression
declared receiver type
runtime receiver type
slot index
method signature id
return type
argument registers
```

---

### 9. Operator overload kancası tamamlanacak

Kapatılmayacak. Tamamlanacak.

#### 9.1 Magic method tablosu

```text
+        → <add>
-        → <sub>
*        → <mul>
/        → <div>
\        → <idiv>
MOD      → <mod>
**       → <pow>
=        → <eq>
<>       → <ne>
<        → <lt>
<=       → <le>
>        → <gt>
>=       → <ge>
AND      → <and>
OR       → <or>
XOR      → <xor>
NOT      → <not>
[]       → <index>
[]=      → <setindex>
CALL     → <call>
STRING   → <str>
```

#### 9.2 Semantic resolution

Her binary operator için sıra:

```text
1. Primitive + primitive ise normal operator.
2. Class + primitive ise lhs.<op>(rhs) aranır.
3. Primitive + class ise rhs.<rop>(lhs) aranır.
4. Class + class ise lhs.<op>(rhs) aranır.
5. Yoksa semantic hata.
```

Gerekli reverse magic:

```text
<radd>
<rsub>
<rmul>
<rdiv>
<req>
<rlt>
```

#### 9.3 AST dönüşümü

Parser operator node üretir:

```text
BINARY_EXPR '+'
```

Semantic bunu çözer:

```text
BINARY_EXPR primitive
```

veya:

```text
MAGIC_CALL_EXPR
  receiver
  magicKind=<add>
  args=[rhs]
```

#### 9.4 MIR üretimi

```text
MIR_CALL_MAGIC receiver, MAGIC_ADD, args
```

#### 9.5 Interpreter uygulaması

```text
receiver null kontrolü
magic method lookup
signature kontrolü
call dispatch
return type kontrolü
```

#### 9.6 x64 uygulaması

Class magic call da normal method call gibi üretilecek:

```text
direct magic call
veya virtual magic call
```

Eğer magic method virtual ise:

```text
MIR_CALL_VIRTUAL receiver, slot
```

Eğer final/nonvirtual ise:

```text
MIR_CALL_METHOD directSymbol
```

#### 9.7 Zorunlu testler

```basic
CLASS Vec2
    FIELD x AS F64
    FIELD y AS F64

    FUNCTION <add>(other AS Vec2) AS Vec2
    END FUNCTION

    FUNCTION <str>() AS STRING
    END FUNCTION
END CLASS

DIM a AS Vec2
DIM b AS Vec2
DIM c AS Vec2
c = a + b
PRINT c
```

---

### 10. x64 virtual call güvenli hale getirilecek

#### 10.1 Ön şart

x64 virtual call yalnızca şu bilgiler varsa üretilecek:

```text
receiver type resolved
slot index resolved
vtable label emitted
method signature known
return ABI known
argument ABI known
```

#### 10.2 Null kontrol

Üretilecek asm:

```asm
test rcx, rcx
jz __uxb_raise_null_object

mov rax, [rcx + 0]
test rax, rax
jz __uxb_raise_null_vtable

mov r11, [rax + slot*8]
test r11, r11
jz __uxb_raise_null_vslot

call r11
```

#### 10.3 Slot sınır kontrolü debug modda

```asm
cmp slot, VTABLE_SLOT_COUNT
jae __uxb_raise_vslot_oob
```

#### 10.4 Signature guard debug modda

VTable entry yanında signature id tutulacaksa:

```text
vtable:
  dq method_ptr
  dq signature_id
```

Alternatif:

```text
debug_vtable_signature_table:
  dq sig0, sig1, sig2
```

#### 10.5 Register kuralı

Win64 ABI:

```text
RCX = this
RDX = arg1
R8  = arg2
R9  = arg3
stack = sonraki argümanlar
shadow space = 32 byte
stack alignment = 16 byte
```

#### 10.6 Return kuralı

```text
I32/U32/I64/U64/PTR/OBJECT → RAX
F32/F64                  → XMM0
F80                      → şimdilik x64 virtual call’da yasak veya x87 protokolü tamamlanana kadar semantic hata
STRING                   → runtime string handle / pointer
STRUCT/CLASS value       → hidden return pointer
```

#### 10.7 Hata rutinleri

Runtime’a eklenecek:

```text
__uxb_raise_null_object
__uxb_raise_null_vtable
__uxb_raise_null_vslot
__uxb_raise_vslot_oob
__uxb_raise_bad_signature
```

#### 10.8 x64 testler

```text
virtual_base_call
virtual_derived_override
virtual_null_object
virtual_missing_slot
virtual_signature_mismatch_debug
virtual_return_i32
virtual_return_f64
virtual_with_two_args
```

---

## Uygulama sırası

```text
1. main.bas include/harness ayrımı düzeltilecek.
2. classSize fallback kaldırılacak.
3. layout table kesinleştirilecek.
4. __vptr anlamı tekleştirilecek.
5. magic method isim standardı uygulanacak.
6. semantic method table kurulacak.
7. semantic vtable layout kurulacak.
8. MIR_CALL_VIRTUAL opcode eklenecek.
9. MIR_CALL_MAGIC opcode eklenecek.
10. interpreter virtual dispatch tamamlanacak.
11. interpreter magic/operator dispatch tamamlanacak.
12. x64 vtable label helper eklenecek.
13. x64 object allocation header yazımı düzeltilecek.
14. x64 safe virtual call üretilecek.
15. operator overload x64 call path tamamlanacak.
16. destructor/constructor lifecycle tamamlanacak.
17. test matrisi yazılacak.
18. tüm eski testler yeniden çalıştırılacak.
```

cli  astin olusmamasi cok onemli. bunun arastirilip sebeblerinin duzeltilmesi gerekli. 

HAMLE 8A DEVAM — RESET YOK.

Geri alma yapma.
Yeni büyük özellik ekleme.
Inheritance/interface/vtable genişletme yok.
Büyük dosya parçalama yok.

Önce CLI AST output problemini çöz.

1. build/uxbasic_cli_probe.exe şu komutla EXIT=0 veriyor ama ast.json üretmiyor:
   build/uxbasic_cli_probe.exe tests/basicCodeTests/80_h8a_operator_numeric_parity.bas --ast-json-out tests/basicCodeTests/out_probe_80/ast.json

2. src/main.bas içinde --ast-json-out argümanının gerçekten nasıl işlendiğini oku.
3. Output klasörü yoksa oluşturuluyor mu kontrol et.
4. Gerekirse önce out_probe_80 klasörünü oluşturup tekrar dene.
5. Eğer main.bas output klasörü oluşturmuyorsa:
   --ast-json-out path parent klasörünü otomatik oluşturacak küçük fix ekle.
6. Eğer arg formatı farklıysa:
   gate scriptini gerçek CLI arg formatına göre düzelt.
7. test80 için ast.json oluşmadan başka teste geçme.

Sonra Hamle 3 x64 memory:
8. x64 memory testlerini bul:
   run_x64_codegen_memory_emit
   run_x64_codegen_emit
   26_matrix_memory_intrinsics.bas
9. POKES/MEMCOPY/MEMFILL/SETNEWOFFSET x64 emit eksiklerini kapat.
10. Hamle 3 DONE olmadan Hamle 4’e geçme.

Sonra Hamle 4:
11. F32/F64 native gerçek float hattını test et.
12. F80 için açık diagnostic ver.
13. F64 integer kırpma varsa düzelt.
14. 81/82/87 testlerini sırayla çalıştır.

Sonra Hamle 5:
15. string builtin, PRINT, TIMER, RND, INKEY/GETKEY, TYPE field/array parity testlerini çalıştır.
16. Eksik varsa minimal patch yap.

Son olarak:
17. Hamle 6 ve 7 regression:
   60–63 class tests
   ctor/dtor/THIS/DELETE tests
   AST/MIR/x64 tekrar çalıştır.
18. Coverage ve yapilanlar.md sadece geçen testler için güncelle.

sirayla isleri yap.

HAMLE 8A PATCH MODE.

AÇIKLAMA YAZMA.
PLAN YAZMA.
SADECE KODU UYGULA.

KAPSAM:
Hamle 4 Floating point
Hamle 5 TYPE layout + field access
Hamle 6 CLASS basic object model
Hamle 7 ctor/dtor/method/THIS/DELETE
bunlardan kalan PARTIAL/DOC-DRIFT/TODO noktalarını kapat.

YASAK:
- inheritance/interface/vtable genişletme yok.
- büyük dosya parçalama yok.
- manifest güncelleme yok.
- yeni syntax yok.
- F80 sessiz F64 fallback yok.
1. Eklenecek test dosyaları

Şunları oluştur:

tests/basicCodeTests/80_h8a_operator_numeric_parity.bas
tests/basicCodeTests/81_h8a_float_f64_native_parity.bas
tests/basicCodeTests/82_h8a_f80_diagnostic.bas
tests/basicCodeTests/83_h8a_string_builtin_native_parity.bas
tests/basicCodeTests/84_h8a_timer_rnd_inkey_smoke.bas
tests/basicCodeTests/85_h8a_redim_preserve_native_parity.bas
tests/basicCodeTests/86_h8a_array_type_class_indexed_parity.bas
tests/basicCodeTests/87_h8a_print_float_string_parity.bas
80_h8a_operator_numeric_parity.bas
DIM a AS I32
DIM b AS I32
DIM c AS I32

a = 7
b = 3

PRINT a + b
PRINT a - b
PRINT a * b
PRINT a \ b
PRINT a MOD b
PRINT a AND b
PRINT a OR b
PRINT a XOR b
PRINT NOT 0

c = 1
INC c
PRINT c
DEC c
PRINT c

END
81_h8a_float_f64_native_parity.bas
DIM a AS F64
DIM b AS F64
DIM c AS F64

a = 1.5
b = 2.25
c = a + b
PRINT c
PRINT b - a
PRINT a * b
PRINT b / a
PRINT SQR(9.0)
PRINT SIN(1.0)

END
82_h8a_f80_diagnostic.bas
DIM x AS F80
x = 1.5
PRINT x
END

Beklenen: x64 native backend açık diagnostic verecek. Sessiz F64 fallback yasak.

83_h8a_string_builtin_native_parity.bas
DIM s AS STRING
s = "  AbC  "

PRINT LEN(s)
PRINT UCASE(s)
PRINT LCASE(s)
PRINT LTRIM(s)
PRINT RTRIM(s)
PRINT MID(s, 3, 3)
PRINT SPACE(3) + "X"
PRINT STRING(3, "B")

END
84_h8a_timer_rnd_inkey_smoke.bas
RANDOMIZE 1

PRINT RND(1)
PRINT TIMER()
PRINT INKEY()
PRINT GETKEY()

END

Burada deterministik olmayan değerler için sadece “crash yok / numeric veya string çıktı var” smoke kabul edilecek.

85_h8a_redim_preserve_native_parity.bas
DIM a(0 TO 2) AS I32

a(0) = 11
a(1) = 22
a(2) = 33

REDIM PRESERVE a(0 TO 4)

a(3) = 44
a(4) = 55

PRINT a(0)
PRINT a(1)
PRINT a(2)
PRINT a(3)
PRINT a(4)

END
86_h8a_array_type_class_indexed_parity.bas
TYPE Point
    x AS I32
    y AS I32
END TYPE

CLASS Box
    v AS I32
END CLASS

DIM p(0 TO 1) AS Point
DIM b AS Box

p(0).x = 10
p(0).y = 20
p(1).x = 30
p(1).y = 40

b = NEW Box
b.v = 50

PRINT p(0).x
PRINT p(0).y
PRINT p(1).x
PRINT p(1).y
PRINT b.v

DELETE b

END
87_h8a_print_float_string_parity.bas
DIM a AS F64
DIM s AS STRING

a = 3.5
s = "uxbasic"

PRINT a
PRINT s
PRINT "value="; a
PRINT "name="; s

END
2. src/codegen/x64/code_generator.fbs yamaları

Şu fonksiyonlar varsa tamamlanacak, yoksa aynı isimle eklenecek:

X64FloatKindFromType
X64EmitExprToXmm0
X64EmitFloatBinary
X64EmitF80Unsupported
X64EmitPrintFloat
X64EmitStoreFieldFromRhs
X64EmitAssignStmt
X64EmitLoadFieldExpr
X64EmitStoreFieldExpr

Ekle:

Enum UXFloatKind
    UX_FLOAT_NONE = 0
    UX_FLOAT_F32  = 1
    UX_FLOAT_F64  = 2
    UX_FLOAT_F80  = 3
End Enum

Private Function X64FloatKindFromType(ByRef typeName As String) As Integer
    Dim t As String
    t = UCase(Trim(typeName))

    If t = "SINGLE" OrElse t = "F32" Then Return UX_FLOAT_F32
    If t = "DOUBLE" OrElse t = "F64" Then Return UX_FLOAT_F64
    If t = "F80" Then Return UX_FLOAT_F80

    Return UX_FLOAT_NONE
End Function

Private Function X64EmitF80Unsupported(ByRef errText As String) As Integer
    errText = "x64-codegen: F80 native arithmetic/print is not implemented; silent F64 fallback is forbidden"
    Return 0
End Function

X64EmitExprToXmm0 içinde kesin kural:

If targetFloatKind = UX_FLOAT_F80 Then
    Return X64EmitF80Unsupported(errText)
End If

NUMBER literal için:

F32 → dd literal
F64 → dq literal
integer kırpma YOK
CLng/Val ile RAX’a düşürme YOK

BINARY içinde:

Eğer taraflardan biri F32/F64 ise:
    X64EmitFloatBinary kullan.
Eğer F80 ise:
    diagnostic ver.
Yoksa eski integer yol devam.

Field assignment için:

lhs FIELD_EXPR ve field type F32/F64 ise:
    rhs -> XMM0
    field address -> RAX
    F32: movss [rax], xmm0
    F64: movsd [rax], xmm0
F80 ise diagnostic.
3. src/semantic/type_binding.fbs

Şunu doğrula, bozulduysa düzelt:

F32/SINGLE size=4 align=4
F64/DOUBLE size=8 align=8
F80 size=10 align=8

F80 için 16 byte align yapma.

4. src/semantic/mir.fbs

mir: unsupported binary op, mir: unsupported expr kind, mir: unsupported assign op izlerini Hamle 8A testleri özelinde kapat.

Gerekli davranış:

F32/F64 binary op → MIR float op veya mevcut float evaluator yolu
F80 → unsupported diagnostic
indexed array assignment → STORE_INDEXED
field compound assignment → field load + op + store
5. src/semantic/mir_evaluator.fbs

F64 işlemler Double olarak kalacak. F32 işlemler Single hassasiyetine indirgenecek.

Kural:

F80 hesaplama Double ile yapılıp "OK" denmeyecek.
F80 unsupported diagnostic verecek.
6. src/runtime/exec/exec_eval_builtin_categories.fbs

Kontrol et:

SQR
SIN
COS
TAN
ATN
EXP
LOG
VAL
RND
TIMER

F64 dönebilenler integer’a kırpılmayacak.

7. PowerShell gate dosyası oluştur
tools/run_h8a_gate.ps1

İçerik:

param(
    [string]$Root = "."
)

Set-Location $Root

$tests = @(
    "80_h8a_operator_numeric_parity.bas",
    "81_h8a_float_f64_native_parity.bas",
    "82_h8a_f80_diagnostic.bas",
    "83_h8a_string_builtin_native_parity.bas",
    "84_h8a_timer_rnd_inkey_smoke.bas",
    "85_h8a_redim_preserve_native_parity.bas",
    "86_h8a_array_type_class_indexed_parity.bas",
    "87_h8a_print_float_string_parity.bas"
)

$failed = 0

foreach ($t in $tests) {
    $src = "tests/basicCodeTests/$t"
    $name = [System.IO.Path]::GetFileNameWithoutExtension($t)
    $out = "tests/basicCodeTests/out_h8a_$name"

    Write-Host "=== $t JSON ==="
    ./src/main_64.exe $src --ast-json-out "$out/ast.json"
    if ($LASTEXITCODE -ne 0) { $failed++ ; continue }

    Write-Host "=== $t AST ==="
    ./src/main_64.exe $src --execmem
    $astExit = $LASTEXITCODE

    Write-Host "=== $t MIR ==="
    ./src/main_64.exe $src --execmem --interpreter-backend MIR
    $mirExit = $LASTEXITCODE

    Write-Host "=== $t X64 BUILD ==="
    ./src/main_64.exe $src --build-x64 --build-x64-out $out
    $buildExit = $LASTEXITCODE

    if ($t -eq "82_h8a_f80_diagnostic.bas") {
        if ($buildExit -eq 0) {
            Write-Host "F80 diagnostic expected but build succeeded"
            $failed++
        }
        continue
    }

    if ($astExit -ne 0 -or $mirExit -ne 0 -or $buildExit -ne 0) {
        $failed++
        continue
    }

    if (Test-Path "$out/program.exe") {
        Write-Host "=== $t X64 RUN ==="
        & "$out/program.exe"
        if ($LASTEXITCODE -ne 0) { $failed++ }
    } else {
        Write-Host "Missing native program.exe"
        $failed++
    }
}

if ($failed -ne 0) {
    Write-Host "HAMLE 8A FAILED: $failed"
    exit 1
}

Write-Host "HAMLE 8A PASS"
exit 0
8. Belgeler

Testler geçmeden OK yazma. Coverage kuralı zaten “x64 run ve çıktı karşılaştırması olmadan OK yok” diyor.

Güncellenecek dosyalar:

COMPILER_COVERAGE.md
COMPILER_PARITY_MATRIX.md
MIR_STATUS.md
NATIVE_X64_STATUS.md
COMPILER_TODO.md
yapilanlar.md
9. Copilot’a son emir
Şimdi yukarıdaki dosyaları oluştur.
Sonra code_generator.fbs, mir.fbs, mir_evaluator.fbs, type_binding.fbs ve runtime builtin dosyalarını gerçek fonksiyon imzalarına göre yama.
Placeholder yazma.
Derlenmeyen kod bırakma.
tools/run_h8a_gate.ps1 çalıştır.
Geçmeyen testi OK yazma.
Rapor ver.

Kısa hüküm: Bu paket Hamle 8A’nın güvenli kapanış yamasıdır. Exact satır patch değil; çünkü senin son src11.zip içeriğini burada satır satır açıp doğrulayamıyorum. Ama fonksiyon adları, dosya adları ve kurallar coverage/kod loglarına göre uyumlu.

Bu yazi bilgilendirme icin verildi

 **Hamle 8A’nın adı şu olmalı:**

```text
Hamle 8A — Hamle 1–7 Kapanış Borçları ve Coverage Temizleme
```

**8A’da inheritance/interface/vtable genişletme yok.** Onlar **8B**.
**Büyük dosya parçalama + manifest güncelleme yok.** O da **8C**.

Coverage’a göre hâlâ Hamle 4 `IN-PROGRESS`, Hamle 5 `TODO`, Hamle 6 eski planda `TODO`, Hamle 7 de docs/release gate olarak `TODO` görünüyor. Ayrıca build/test tarafında standart katman bazlı runner yok, build report hardcoded partial ve native exit-code kontratı net değil.  

## src11’de gördüğüm açıklar

```text
code_generator.fbs = 7817 satır
mir.fbs = 3341 satır
mir_evaluator.fbs = 2689 satır
memory_exec.fbs = 2272 satır
semantic_pass.fbs = 1553 satır
```

Kodda hâlâ şu izler var:

```text
TODO: unsupported binary op
TODO: expression kind
TODO: emit node kind
unsupported statement in GenerateStatement
unsupported assignment operator
metadata-only for x64 emit
mir: unsupported binary op
mir: unsupported expr kind
mir: unsupported assign op
```

Yani **Hamle 8A’nın işi yeni özellik değil; eski PARTIAL / TODO / DOC-DRIFT temizliği.**

---

# Hamle 8A Planı

## 8A-1 — Coverage gerçekliği düzeltilecek

Önce `COMPILER_COVERAGE.md` içindeki eski durumlar güncellenecek.

Özellikle:

```text
Hamle 4: Operator + sayı + INCDEC
Hamle 5: Metin + ekran + zaman + tuş
Hamle 6: Interop/API/Event/Thread/Pipe/Slot eski planda karışmış
Hamle 7: Docs/Tests/Release Gate
```

Ama dikkat: Hamle 6 ve 7’de CLASS tarafında yapılan işler ayrıca not düşülecek. Hamle 6 basic class model testlerinin geçtiği önceki loglarda vardı; coverage’da bu yeni gerçeklik ayrı satıra işlenmeli.

## 8A-2 — Hamle 4 kapanışı

Kapatılacaklar:

```text
INC/DEC native indexed target
aritmetik operator edge-case
mantıksal / bitwise operator edge-case
ternary
pipe operator ayrı tutulacak
F32/F64 numeric parity
F80 diagnostic
SQR/SIN/COS/TAN/EXP/LOG native float kırpma kontrolü
```

Başarı kriteri:

```text
AST = MIR = x64 output
SKIP başarı sayılmayacak
MISSING başarı sayılmayacak
```

## 8A-3 — Hamle 5 kapanışı

Coverage’da Hamle 5 açık: string / ekran / zaman / tuş parity. 

Kapatılacaklar:

```text
LEN/MID/UCASE/LCASE/LTRIM/RTRIM/SPACE/STRING
CLS/COLOR/LOCATE
TIMER varyantları
RANDOMIZE/RND deterministik test
INKEY/GETKEY semantic ayrımı
PRINT string/float formatı
```

## 8A-4 — Native array / REDIM / TYPE regression

Coverage hâlâ `CONST/DIM/REDIM` native için PARTIAL diyor. 

Testler:

```text
global array
local array
REDIM
REDIM PRESERVE
array + TYPE field
array + CLASS field
indexed +=
```

## 8A-5 — F64/F80 temizliği

Coverage’daki eski notlarda float tarafı ciddi açık olarak yazılmış. Özellikle x64 native float kırpma ve F80 diagnostic önemli. 

Kural:

```text
F32/F64 gerçek XMM hattı
F80 sessiz F64’e düşmeyecek
F80 desteklenmiyorsa açık diagnostic
PRINT F64 doğru format
VAL/RND integer kırpma yapmayacak
```

## 8A-6 — Hamle 7 docs/test borcu

Hamle 7 release gate değil; şimdilik sadece **dokümantasyon ve coverage temizliği** yapılacak.

Güncellenecek:

```text
COMPILER_COVERAGE.md
COMPILER_PARITY_MATRIX.md
MIR_STATUS.md
NATIVE_X64_STATUS.md
COMPILER_TODO.md
yapilanlar.md
```

## 8A-7 — Yeni test seti

VSCode’a şu testleri eklettir:

```text
tests/basicCodeTests/80_h8a_operator_numeric_parity.bas
tests/basicCodeTests/81_h8a_float_f64_native_parity.bas
tests/basicCodeTests/82_h8a_f80_diagnostic.bas
tests/basicCodeTests/83_h8a_string_builtin_native_parity.bas
tests/basicCodeTests/84_h8a_timer_rnd_inkey_smoke.bas
tests/basicCodeTests/85_h8a_redim_preserve_native_parity.bas
tests/basicCodeTests/86_h8a_array_type_class_indexed_parity.bas
tests/basicCodeTests/87_h8a_print_float_string_parity.bas
```

---

# VSCode’a verilecek net iş emri

```text
HAMLE 8A BAŞLAT.

KAPSAM:
Hamle 1–7’den kalan PARTIAL / TODO / DOC-DRIFT işleri kapat.
Yeni inheritance/interface/vtable özelliği ekleme.
Büyük dosya parçalama yapma.
Manifest güncelleme yapma.
Bunlar Hamle 8B ve 8C’ye kalacak.

1. COMPILER_COVERAGE.md dosyasını oku.
2. src11 mevcut kodunu tara.
3. Şu kalıntıları listele:
   - TODO: unsupported binary op
   - TODO: expression kind
   - TODO: emit node kind
   - unsupported statement in GenerateStatement
   - unsupported assignment operator
   - metadata-only for x64 emit
   - mir: unsupported binary op
   - mir: unsupported expr kind
   - mir: unsupported assign op

4. Hamle 4 kapanışı:
   operator + sayı + INCDEC + F32/F64/F80 diagnostic testlerini tamamla.

5. Hamle 5 kapanışı:
   string builtin, PRINT, CLS/COLOR/LOCATE, TIMER, RND, INKEY/GETKEY native parity testlerini tamamla.

6. Array/REDIM native PARTIAL satırını kapat:
   global/local array, indexed assignment, REDIM PRESERVE, TYPE/CLASS field kombinasyonlarını test et.

7. F64 native kırpma varsa düzelt.
   F80 desteklenmiyorsa açık diagnostic üret.
   Sessiz F64 fallback yasak.

8. Testleri ekle:
   80_h8a_operator_numeric_parity.bas
   81_h8a_float_f64_native_parity.bas
   82_h8a_f80_diagnostic.bas
   83_h8a_string_builtin_native_parity.bas
   84_h8a_timer_rnd_inkey_smoke.bas
   85_h8a_redim_preserve_native_parity.bas
   86_h8a_array_type_class_indexed_parity.bas
   87_h8a_print_float_string_parity.bas

9. Her test için çalıştır:
   parse/json
   semantic
   AST runtime
   MIR runtime
   x64 build
   x64 run

10. SKIP başarı sayılmayacak.
    MISSING başarı sayılmayacak.
    RAN_EXIT_5 veya RAN_EXIT_10 başarı sayılmayacak.

11. Belgeleri güncelle:
   COMPILER_COVERAGE.md
   COMPILER_PARITY_MATRIX.md
   MIR_STATUS.md
   NATIVE_X64_STATUS.md
   COMPILER_TODO.md
   yapilanlar.md

12. Hamle 8A sonunda rapor ver:
   - Tam kapananlar
   - Kısmi kalanlar
   - Hamle 8B’ye devredenler
   - Hamle 8C’ye devredenler
```

## Kısa karar

**Hamle 8A = temizlik ve kapanış hamlesi.**
**Hamle 8B = inheritance/interface/vtable/operator overload genişletme.**
**Hamle 8C = code_generator/mir/memory_exec parçalama + manifest güncelleme.**


# VSCode’a verilecek net iş emri Bilgilendirmesini eksiksiz uygula. bu is icin sana  asagida yamalar icin yol gosterici , izlemen gereken iskelet ve kodlamanin nasil yapilacagini veriyorum. kaynak kodu acip okuyamadigi icin bu sefer sen kaynak koda gore isimlendirme ve isim secme ozgurlugune sahipsin. tek hamlede bitirmen cok onemli, bitiremezsen sonraki promtta bitirilecek.

Şu an vtable yarım.

ÖNCE:

1. semantic katmanda:
   class → method list oluştur
   method → slot index belirle

KURALLAR:
- base class slotları korunur
- override aynı slotu alır
- yeni method sona eklenir

2. layout:
   vtable slot sayısını kesinleştir

3. runtime:
   ExecInvokeRoutineByIndex kullan
   obj → vptr → slot → call

4. x64:
   indirect call zorunlu yap

Operator overload DURDUR.

ÖNCE vtable TAM OLSUN.
onerilen adimlara devam et.