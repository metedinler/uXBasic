# uXBasic ADIM36 Hata Analizi ve Yama Notu

Kaynak paket: `src(31.05_2).zip`  
Test sonuc paketi: `current.zip`

## Genel durum

`adim36_full_surface_results.csv` dosyasinda toplam 12 FAIL satiri goruldu. Zincir ozeti 94 test / 645 adim / 12 fail / 10 eksik cikti bildiriyor. Placeholder ve bozuk JSON sayisi 0; yani sorun rapor ureticiden degil, gercek fail-close ve tip baglama davranisindan geliyor.

## FAIL satirlari

| Test | Adim | Beklenen | Gelen | Yorum |
|---|---:|---:|---:|---|
| `45_GUI_WINAPI_SURFACE` | `NEG_NATIVE_JS` | 1 | 0 | ADIM44_NEGATIVE_FAIL_CLOSE: negative test unexpectedly passed |
| `45_GUI_WINAPI_SURFACE` | `NEG_NATIVE_WASM` | 1 | 0 | ADIM44_NEGATIVE_FAIL_CLOSE: negative test unexpectedly passed |
| `49_STRUCT_POINTER_IMPORT_MIX` | `04_SEMANTIC_TYPE_LAYOUT` | 0 | 1 | missing: reports/control/current/adim36_full_surface_chain/49_STRUCT_POINTER_IMPORT_MIX/SEM/04_symbol_table.json|reports/control/current/adim36_full_surface_chain/49_STRUCT_POINTER_IMPORT_MIX/SEM/04_type_table.json|reports/control/current/adim36_full_surface_chain/49_STRUCT_POINTER_IMPORT_MIX/SEM/04_layout_report.json|reports/control/current/adim36_full_surface_chain/49_STRUCT_POINTER_IMPORT_MIX/SEM/04_hir_inventory.json|reports/control/current/adim36_full_surface_chain/49_STRUCT_POINTER_IMPORT_MIX/SEM/04_semantic_diagnostics.json |
| `49_STRUCT_POINTER_IMPORT_MIX` | `05_MIR_LOWER` | 0 | 1 | missing: reports/control/current/adim36_full_surface_chain/49_STRUCT_POINTER_IMPORT_MIX/MIR/05_mir.json|reports/control/current/adim36_full_surface_chain/49_STRUCT_POINTER_IMPORT_MIX/MIR/05_mir_opt_report.json |
| `49_STRUCT_POINTER_IMPORT_MIX` | `06_MIR_VERIFY` | 0 | 1 | missing: reports/control/current/adim36_full_surface_chain/49_STRUCT_POINTER_IMPORT_MIX/VERIFY/06_mir_verify.json |
| `49_STRUCT_POINTER_IMPORT_MIX` | `08_X64_BACKEND` | 0 | 1 | missing: reports/control/current/adim36_full_surface_chain/49_STRUCT_POINTER_IMPORT_MIX/X64/08_program_x64.asm|reports/control/current/adim36_full_surface_chain/49_STRUCT_POINTER_IMPORT_MIX/X64/08_x64_policy.json |
| `99_ALIAS_CYCLE` | `NEG_PREPROCESSOR` | 1 | 0 | ADIM44_NEGATIVE_FAIL_CLOSE: negative test unexpectedly passed |
| `101_PREPROCESSOR_ASSERT_FAIL` | `NEG_PREPROCESSOR` | 1 | 0 | ADIM44_NEGATIVE_FAIL_CLOSE: negative test unexpectedly passed |
| `102_RAW_JS_WITHOUT_GATE` | `NEG_PREPROCESSOR` | 1 | 0 | ADIM44_NEGATIVE_FAIL_CLOSE: negative test unexpectedly passed |
| `103_BAD_PATH_ASSET_ESCAPE` | `NEG_PREPROCESSOR` | 1 | 0 | ADIM44_NEGATIVE_FAIL_CLOSE: negative test unexpectedly passed |
| `104_WAT_IMPORT_MISSING_BINDING` | `NEG_PREPROCESSOR` | 1 | 0 | ADIM44_NEGATIVE_FAIL_CLOSE: negative test unexpectedly passed |
| `105_BIGINT_DECIMAL_STRING_NEG` | `NEG_SEMANTIC` | 1 | 0 | ADIM44_NEGATIVE_FAIL_CLOSE: negative test unexpectedly passed |


## Kok neden yorumu

### 1. `45_GUI_WINAPI_SURFACE` native yuzey web hedefinde kaciyor

Preprocessed kaynakta WinAPI `DECLARE ... LIB "user32.dll" ALIAS "MessageBoxA"` var:

```basic
DECLARE FUNCTION MessageBoxA LIB "user32.dll" ALIAS "MessageBoxA" (
    BYVAL hwnd AS PTR,
    BYVAL text AS STRING,
    BYVAL caption AS STRING,
    BYVAL flags AS I32
) AS I32
PRINT "GUI_WINAPI_SURFACE"
```

AST dugumunde bu bilgi `value/op` alaninda degil, `typeName` alaninda `LIB=user32.dll` olarak tasiniyor. Mevcut `backend_native_surface_scan.fbs` sadece `value` ve `op` alanlarina baktigi icin JS/WASM kapisi bunu native-only olarak yakalamiyor. Bu nedenle NEG_NATIVE_JS ve NEG_NATIVE_WASM adimlari hatali sekilde 0 cikisla geciyor.

**Yama:** native surface scanner artik `typeName`, `symbolName` ve `lexemeSnippet` alanlarini da tarar. `DECLARE ... LIB`, `ALIAS`, `CALL(DLL/API)` ve `IMPORT(C/CPP/ASM)` web hedeflerinde fail-close olur.

### 2. `49_STRUCT_POINTER_IMPORT_MIX` `SIZEOF` tip baglama eksigi

Kaynak:

```basic
IMPORT(C, "tests/adim36_full_surface/imports/c/add_i32.c")
TYPE BUFFER
    P AS PTR
    N AS I32
END TYPE
DIM B AS BUFFER
B.P = 0
B.N = SIZEOF(BUFFER)
PRINT VARPTR(B)
```

Semantic logundaki ana hata:

```text
INFO: uXBasic calistirildi
WARN: [WARN][SEMANTIC] UXB_SEMANTIC_FAILED: semantic-step3: type: assignment requires explicit cast TYPE_OBJECT to TYPE_I32
ERROR: Anlamsal analiz basarisiz: Isletim hatasi | ham: semantic-step3: type: assignment requires explicit cast TYPE_OBJECT to TYPE_I32
```

Sorun `B.N = SIZEOF(BUFFER)` satirinda. Parser bunu `SIZEOF_EXPR` degil `CALL_EXPR/SIZEOF` olarak tasidigi durumda `UXBStep3BuiltinReturnType()` `SIZEOF` icin donus tipi vermiyor ve ifade `TYPE_OBJECT` gibi goruluyor. I32 alana OBJECT atanmis gibi hata uretiliyor. Bu ilk semantic fail oldugu icin MIR, VERIFY ve X64 adimlari da zincirleme eksik cikti uretiyor.

**Yama:** `SIZEOF` ve `OFFSETOF` builtin donus tipi `TYPE_I32` yapildi. Ayrica pointer adres fonksiyonlari icin `VARPTR`, `SADD`, `LPTR`, `CODEPTR` donus tipi `TYPE_PTR` eklendi.

### 3. Negatif preprocessor testleri fail-close degil

Asagidaki negatif testler 1 cikis beklerken 0 cikisla gecmis:

- `99_ALIAS_CYCLE`
- `101_PREPROCESSOR_ASSERT_FAIL`
- `102_RAW_JS_WITHOUT_GATE`
- `103_BAD_PATH_ASSET_ESCAPE`
- `104_WAT_IMPORT_MISSING_BINDING`

Gozlenen davranis: hata uretilmesi gereken meta direktifler ya sadece veri modeline ekleniyor ya da sessizce yutuluyor. Ornek olarak alias cycle testinde token sonucu sadece `B` kalmis; dongu yakalanmamis. `ASSERT_META` tarafinda eski kosul evaluator'u `0 == 1` gibi ifadeleri yeterince kesin ele almiyor. RAW JS/WAT bloklari `%%ALLOW_RAW_JS/WAT ON` kontrolu olmadan kabul ediliyor. Asset path `..` kacisi ve WAT import host binding eksigi fail-close etmiyor.

**Yama:**

- `%%ALIAS` icin basit identifier zincirlerinde cycle detection eklendi.
- `%%ASSERT_META` artik ADIM34 kosul evaluator'u `LexerMetaEvalAnyCondition34()` ile calisir.
- `%%JS_BEGIN` icin `allowRawJs`, `%%WAT_BEGIN` icin `allowRawWat` zorunlu yapildi.
- `%%ASSET_*` icin `safePaths` acikken bos yol, `..`, surucu yolu, UNC yolu ve shell kacis karakterleri fatal hata yapar.
- `%%WAT_IMPORT` icin `requireHostBinding` acikken alias + signature zorunlu hale getirildi; eksikse fatal hata uretilir.

### 4. `105_BIGINT_DECIMAL_STRING_NEG` semantic gate zayif

Bu testte `BIGINIT(BIGI/BIGINT, "ondalik string", 0)` benzeri bir kullanim negatif olmali. Mevcut semantic sadece BIGINIT tur ailesini secip `TYPE_BIGINT` donduruyor; string literal iceriginin BIGINT icin tam sayi olup olmadigini denetlemiyor. Bu yuzden diagnostics JSON `ok:true` donmus.

**Yama:** `BIGINIT` BIGI/BIGINT kolunda ikinci arguman string literal ise yalniz `[+|-]?[0-9]+` kabul edilir. Nokta, us, bos string veya sayi disi karakter semantic hata uretir: `type: BIGINIT BIGINT expects integer decimal string`.

## Degisen kaynak dosyalari

- `src/backend/backend_native_surface_scan.fbs`
- `src/parser/lexer/lexer_preprocess.fbs`
- `src/type_binding/type_check_call.fbs`
- `src/type_binding/type_infer_expr.fbs`

## Beklenen test etkisi

Bu yamadan sonra 12 FAIL satirinin beklenen etkisi:

- `45_GUI_WINAPI_SURFACE / NEG_NATIVE_JS`, `NEG_NATIVE_WASM`: native-only DECLARE web hedefinde yakalanir, beklenen 1 cikis uretir.
- `49_STRUCT_POINTER_IMPORT_MIX`: semantic gecmeli; buna bagli MIR, VERIFY ve X64 eksik ciktilari duzelmeli.
- `99`, `101`, `102`, `103`, `104`: preprocessor negatif testleri fatal hata ile kapanmali.
- `105`: semantic negatif test BIGINT decimal-string ihlaliyle kapanmali.

## Uygulama

Paket icindeki `files/` klasoru dogrudan `src/` altina kopyalanacak tam dosyalari icerir. Istersen `apply_patch_to_src.bat` veya `apply_patch_to_src.ps1` dosyasini, `src` klasorunun ust dizininde calistirabilirsin.

Not: Bu ortamda FreeBasic compiler / Windows wrapper calistirilamadigi icin tam derleme-test tekrarini burada kosamadim. Yama statik kaynak karsilastirma ve test loglarindaki kok nedenlere gore hazirlandi.
