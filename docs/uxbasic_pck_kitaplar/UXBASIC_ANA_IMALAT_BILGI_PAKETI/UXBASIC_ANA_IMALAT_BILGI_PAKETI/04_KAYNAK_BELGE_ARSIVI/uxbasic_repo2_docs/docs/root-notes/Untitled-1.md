

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



## 8A-3 planı: `__vptr` anlamını tekleştirme

Şimdi kod gerçekliğine göre 8A-3’e gelirsek:

`src15` içinde runtime tarafında hâlâ şu var:

```bas
VMemPokeD(objectBase, classIdx)
VMemPokeD(objectBase + 4, 0)
```

Bu iki yerde geçiyor:

```text
src/runtime/exec/exec_class_layout_helpers.fbs
```

Ama x64 tarafında şu mantık var:

```bas
lea rdx, [rel classTypeName_VTBL]
mov [rax], rdx
```

Yani runtime:

```text
__vptr = class index
```

x64:

```text
__vptr = vtable adresi
```

Bu yanlış. 8A-3’ün amacı bu farkı kapatmak.

## 8A-3 yapılacaklar

### 1. `exec_types.fbs`

Şu alanların yanına:

```bas
vtableClassNames(Any) As String
vtableClassSlotCounts(Any) As Integer
vtableClassSlotStart(Any) As Integer
vtableClassCount As Integer
```

şunlar eklenecek:

```bas
vtableClassHandles(Any) As UInteger
vtableNextHandle As UInteger
```

### 2. `exec_eval_support_helpers.fbs`

`ExecBuildVTableMap` içinde reset:

```bas
Erase es.runtime.vtableClassHandles
es.runtime.vtableNextHandle = &h1000
```

Class kayıt edilirken:

```bas
ReDim Preserve es.runtime.vtableClassHandles(es.runtime.vtableClassCount)
es.runtime.vtableClassHandles(classIdx) = es.runtime.vtableNextHandle
es.runtime.vtableNextHandle += 8
```

### 3. `exec_class_layout_helpers.fbs`

Şu blok kaldırılacak:

```bas
VMemPokeD(objectBase, classIdx)
VMemPokeD(objectBase + 4, 0)
```

Yerine:

```bas
Dim vtblHandle As UInteger
If ExecFindRuntimeVTableHandle(es, classTypeName, vtblHandle) = 0 Then
    errText = "exec: missing runtime vtable for " & UCase(Trim(classTypeName))
    Return 0
End If

VMemPokeD(objectBase, CInt(vtblHandle))
VMemPokeD(objectBase + 4, 0)
```

Aynısı `NEW` allocation tarafında da yapılacak.

### 4. Yardımcı fonksiyonlar

`exec_class_layout_helpers.fbs` veya ortak uygun bir runtime helper dosyasına:

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
    If ci < 0 Then
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

### 5. `exec_call_dispatch_helpers.fbs`

Virtual dispatch sırasında object başından handle okunacak:

```bas
Dim runtimeClassName As String
runtimeClassName = ""

If receiverAddr <> 0 Then
    Dim h As UInteger
    h = CUInt(VMemPeekD(receiverAddr))
    ExecFindRuntimeVTableClassByHandle es, h, runtimeClassName
End If

If runtimeClassName <> "" Then
    receiverType = runtimeClassName
End If
```

### 6. Test

Şu testler istenecek:

```text
CLASS A
END CLASS

DIM a AS A
```

Beklenen:

```text
object[0] sıfır değil.
```

Sonra:

```text
a = NEW A
```

Beklenen:

```text
NEW ile oluşan object[0] sıfır değil.
```

Sonra inheritance:

```text
CLASS Base
    VIRTUAL SUB Speak()
    END SUB
END CLASS

CLASS Dog EXTENDS Base
    OVERRIDE SUB Speak()
    END SUB
END CLASS
```

Beklenen:

```text
Dog instance Dog vtable handle taşımalı.
```

## Net sıradaki iş

Benim önerdiğim sıra:

```text
8A-2.5: merkezi çıktı/log sistemi
8A-3: __vptr runtime/x64 tekleştirme
8A-4: x64 vtable label helper merkezileştirme
```

Çünkü log sistemi düzelmeden 8A-3 gibi zor işlerde yine “ne oldu?” diye takip etmek zorlaşacak.

Copilot’a verilecek kısa iş emri:

```text
Önce 8A-2.5 olarak merkezi çıktı/log sistemini kur.
Debug’u kaldırma; doğru kanala taşı.
Normal bilgi ekrana + ana loga.
--quiet varsa ekrana basma.
--debug varsa ayrıntı debug loga.
Token dump sadece --debug-token-dump ile dosyaya.
ParserLog/ParserDiag doğrudan ayrı sistem olmasın; UxbDebug merkezini kullansın.
Sonra build + AST test yap.
Ardından 8A-3’e geç: __vptr runtime/x64 anlamını tekleştir.
```


sonra 8a3 den sonra, todo listeni olusturan 16 madde aslinda sana bira once verdigim bu 10 maddeden siradaki ise gec.
