# uXBasiC / uxb Kaynak Kod Mimari ve Kod-Gerçekliği Analizi

Bu rapor, `/mnt/data/uxb.zip` içindeki `uxb/` ağacının statik incelemesine dayanır. Kod çalıştırılmamıştır; dosya yapısı, include zinciri, CLI yüzeyi, test çıktıları, TODO/unsupported izleri ve mevcut mimari belgeler incelenmiştir.

## 1. Kısa hüküm

`uxb.zip`, basit bir örnek proje değil; FreeBASIC ile yazılmış, katmanları ayrılmış ciddi bir BASIC-benzeri compiler/interpreter altyapısıdır. Kod ağacında lexer, preprocessor, parser, AST, semantic pass, HIR/MIR, AST/MIR interpreter, x64 NASM codegen, x86 dönüştürme denemesi, FFI/interop artifact üretimi, native build pipeline, JSON artifact sistemi ve overlay/switchboard yapısı vardır.

Ancak proje tam ürün gibi değil, hızlı büyümüş bir compiler laboratuvarı gibi görünür. En güçlü taraf frontend + AST/semantic + runtime/test zenginliği; en riskli taraf MIR/x64 parity, x64 codegen kapsama eksikleri, x86 backend’in gerçek backend değil x64 rewrite olması, JSON’ların bir kısmının gerçek IR dump değil yüzey/envanter raporu olmasıdır.

## 2. Dosya istatistiği

- `src/` içinde `.bas/.fbs` kaynak dosyası: 101
- `src/` FreeBASIC kaynak satırı: yaklaşık 49.427 satır
- `tests/` altında `.bas` test/harness dosyası: 264
- Zip genelinde `.exe` çıktısı: 240
- Zip genelinde `.json` çıktı/artefact: 209
- Zip genelinde `.asm/.obj` çıktı: 394
- Zip genelinde `.bat`: 538
- Zip genelinde `.md`: 130

Bu rakamlar, kaynak kodla birlikte çok büyük miktarda geçmiş build/test çıktısının da paket içinde durduğunu gösterir.

## 3. Temel kaynak ağacı

```text
uxb/
  README.md
  compiler/
    hooks/
    wrappers/
    scripts/
  manifests/
  src/
    main.bas
    main_program_entry.fbs
    main_program_entry_part2.fbs
    parser/
      token_kinds.fbs
      lexer.fbs
      lexer/*.fbs
      ast.fbs
      parser.fbs
      parser/*.fbs
    semantic/
      type_binding.fbs
      layout.fbs
      layout/*.fbs
      hir.fbs
      mir_model.fbs
      mir.fbs
      mir_lower*.fbs
      mir_evaluator*.fbs
      mir_exporter_json.fbs
      semantic_pass*.fbs
    runtime/
      diagnostics.fbs
      error_format.fbs
      error_localization.fbs
      file_io.fbs
      memory_vm.fbs
      memory_exec.fbs
      exec/*.fbs
    codegen/
      x64/*.fbs
      x64/helpers/*.fbs
      x64/stmt_emitters/*.fbs
      x86/*.fbs
    build/
      interop_manifest.fbs
      interop_manifest_emit_helpers.fbs
      main_frontend_include_bundle.fbs
      main_runtime_include_bundle.fbs
      x64_build_pipeline.fbs
  tests/
    basicCodeTests/
    ast/
    fixtures/
    probes/
    ...
```

## 4. Aktif giriş dosyası

Gerçek ana compiler girişi:

```text
uxb/src/main.bas
```

Overlay girişi:

```text
uxb/compiler/wrappers/uxb_main_wrapper.bas
```

Wrapper sadece no-op hook’u include edip ana `src/main.bas` dosyasını çağırır. Bu nedenle kod gerçeğinde asıl kaynak hâlâ `src/` altındadır; `compiler/` altı geçiş/overlay katmanıdır.

## 5. Ana include zinciri

`src/main.bas` doğrudan şu katmanları içine alır:

```text
runtime/diagnostics.fbs
parser/token_kinds.fbs
parser/lexer.fbs
parser/ast.fbs
parser/parser.fbs
semantic/hir.fbs
semantic/mir.fbs
semantic/semantic_pass.fbs
build/interop_manifest.fbs
codegen/x64/code_generator.fbs
codegen/x86/code_generator.fbs
build/main_runtime_include_bundle.fbs
codegen/x64/ffi_call_backend.fbs
codegen/x86/ffi_call_backend.fbs
codegen/x64/inline_backend.fbs
build/x64_build_pipeline.fbs
main_program_entry.fbs
```

Yani tek `main.bas` derlendiğinde aslında parser, AST, semantic, runtime, MIR, x64/x86 codegen, interop ve build pipeline dosyaları aynı FreeBASIC compilation unit içine girer.

## 6. Çalışma hattı

Kavramsal akış:

```text
kaynak .bas/.uxb
  ↓
lexer + preprocessor
  ↓
parser
  ↓
AST pool
  ↓
semantic pass + HIR semantic checks
  ↓
opsiyonel AST JSON / HIR inventory / MIR surface JSON
  ↓
opsiyonel AST interpreter
  ↓
opsiyonel MIR build + MIR optimizer + MIR interpreter
  ↓
opsiyonel x64 NASM codegen
  ↓
opsiyonel x64 build pipeline
  ↓
interop/FFI artifact üretimi
```

## 7. CLI yüzeyi

Kodda ve manifestlerde görülen temel modlar:

```text
--execmem --interpreter-backend AST
--execmem --interpreter-backend MIR
--ast-json-out <path>
--hir-json-out <path>
--mir-pipeline-json-out <path>
--mir-opcodes-json-out <path>
--artifact-report-json-out <path>
--emit-x64-nasm --emit-x64-nasm-out <path>
--codegen [--codegen-source AST|MIR]
--build-x64 [--build-x64-out <dir>] [--codegen-source AST|MIR]
--interop
--validate-all
--extract-src
--debug
--trace
--quiet
--debug-token-dump
--log-out
--debug-log-out
```

Overlay switchboard modları:

```text
json-all
interp-ast
interp-mir
emit-x64
codegen-x64
build-x64
interop
build-compiler-x64
build-compiler-x86
native-toolchain-auto
matrix-all
```

## 8. Katman analizi

### 8.1 Lexer / preprocessor

Lexer iki katmanlıdır:

1. `lexer_preprocess.fbs`: macro/directive/include/conditional preprocessing.
2. `lexer_driver.fbs` + readers: tokenizasyon.

Keyword tablosu BASIC, OOP, FFI, memory, file, math, console ve collection yüzeyini tanır. Örnek keyword alanları: `IF/SELECT/FOR/DO`, `SUB/FUNCTION/CALL`, `TYPE/CLASS/INTERFACE`, `INCLUDE/IMPORT`, `OPEN/CLOSE/GET/PUT/SEEK`, `POKE/MEMCOPY/MEMFILL`, `INLINE`, `ARRAY/LIST/DICT/SET`, `F32/F64/F80`, `PTR/STRPTR`.

### 8.2 Parser / AST

Parser registry tabanlıdır. `parser_stmt_registry.fbs` içinde handler id sistemi vardır. Statement ailesi geniştir:

- Basic: PRINT, INLINE, CALL, DELETE
- Flow: IF, SELECT, FOR, FOR EACH, DO, DO EACH, GOTO, GOSUB, RETURN, EXIT, END, TRY, THROW, ASSERT
- Declaration: DECLARE, SUB, FUNCTION, CONST, DIM, REDIM, TYPE, CLASS, INTERFACE, NAMESPACE, MODULE, MAIN, USING, ALIAS, DEFxxx, SETSTRINGSIZE, INCLUDE, IMPORT
- IO/console/memory: INPUT, OPEN, CLOSE, GET, PUT, SEEK, LOCATE, COLOR, CLS, INC, DEC, RANDOMIZE, POKE*, MEMCOPY*, MEMFILL*, SETNEWOFFSET
- Event/pipe: EVENT, THREAD, PARALEL/PARALLEL, PIPE, SLOT, ON, OFF, TRIGGER

AST modeli hem eski binary-tree alanlarını (`left/right`) hem de yeni genel child-list yapısını (`firstChild/nextSibling/parent/role`) birlikte taşır. Bu geriye uyumluluk için iyi ama codegen/runtime tarafında çift sözleşme doğurur.

### 8.3 Semantic / type binding / layout

Semantic katmanda ciddi doğrulamalar vardır:

- Type refs
- Class/mixin/decorator contracts
- Call nodes
- Import nodes
- Input nodes
- Slot lane nodes
- IF/SELECT
- Error flow
- Routine nodes
- Const nodes
- NEW/DIM/DELETE/class assignments
- Constant folding
- Overload resolution
- Reachability
- THIS/ME
- Class modifier/property/operator/magic/override/interface contracts
- VTable slot assignment

Type binding tarafında I8/U8/I16/U16/I32/U32/I64/U64/F32/F64/F80/BOOLEAN/STRING/PTR/ARRAY/TYPE/CLASS/LIST/DICT/SET gibi türler tanınıyor. Pointer size 8 kabul edilmiş; yani 64-bit merkezli bir model var.

### 8.4 HIR/MIR

MIR model gerçek bir modül modeline sahiptir:

- `MIRModule`
- `MIRFunction`
- `MIRBasicBlock`
- `MIRIRInstruction`
- `MIREvaluatorState`
- `MIRValue`
- array storage, variable binding, call stack, vtable metadata.

Opcode yüzeyi:

```text
LOAD_CONST, LOAD_VAR, STORE_VAR,
LOAD_INDEXED, STORE_INDEXED,
ADD, SUB, MUL, DIV,
FADD, FSUB, FMUL, FDIV,
MOD, NEG, FNEG,
EQ, NE, LT, LE, GT, GE,
AND, OR, XOR, SHL, SHR, ROL, ROR, NOT,
CALL, RET, JMP, JZ, JNZ, LABEL,
NEW, DIM, REDIM, CONST, DEF_TYPE, SETSTRINGSIZE
```

Kod gerçeği açısından önemli nokta: Mevcut JSON exporter tam MIR instruction dump üretmiyor; `mir_pipeline_json` daha çok aşama listesi, `mir_opcodes_json` ise opcode yüzeyi veriyor. Gerçek MIR module/instruction JSON exporter eksik.

### 8.5 Runtime / AST interpreter

Runtime `memory_exec.fbs` merkezlidir. Çok geniştir ve şu dosyaları içine alır:

- file_io
- diagnostics/error formatting/localization
- ffi signer/runtime
- exec state value utils
- collections
- eval helpers/text helpers
- slot manager
- class layout helpers
- builtin categories
- call dispatch
- flow, file IO, memory core statement executors

AST runtime geniş ve pratik görünüyor. Ancak `unsupported call`, `unsupported node kind`, `DEF FN not implemented`, placeholder/no-op kayıtları var. Bu katman güçlü ama tüm dil yüzeyi için tamamlanmış kabul edilmemeli.

### 8.6 MIR interpreter

MIR evaluator vardır ve çalıştırma modu `--execmem --interpreter-backend MIR` ile seçilir. Fakat MIR lowering ve evaluator yüzeyi AST runtime kadar geniş görünmüyor. Parity hedefi için MIR’i kanonik IR yapmak gerekir.

### 8.7 x64 codegen

x64 codegen en büyük teknik dosyalardan biridir. `code_generator.fbs` yaklaşık 4768 satırdır. Yardımcılar ve statement emitter dosyalarıyla birlikte ciddi bir native NASM hattı kurulmuş. F32/F64 için XMM hattı izleri, F80 için veri/store denemeleri, class/vtable, slot lane, FFI stub, memory intrinsics, IO ve flow emitleri vardır.

Ancak codegen içinde birçok `unsupported` ve `known limit` izi vardır. Üretilen status raporlarında x64 lane “partial, statement-oriented native emit + import/ffi/link pipeline” olarak tanımlanmış. Bu, x64 hattının gerçek ama tüm dil yüzeyini kapsamadığı anlamına gelir.

### 8.8 x86 backend

`src/codegen/x86/code_generator.fbs`, gerçek bağımsız x86 backend değildir. x64 NASM çıktısını metinsel olarak x86’ye çevirmeye çalışan bir rewrite katmanıdır. Register isimlerini, qword/dq gibi öğeleri değiştirir. Bu sadece deneysel/yardımcı kabul edilmeli.

### 8.9 Interop / FFI

Interop manifest ve artifact üretimi oldukça gelişmiş. Include/import/toolchain bilgisi, object/link rsp, makefile, env bat, FFI x64/x86 plan CSV ve stub emission yapıları vardır. Ancak FFI runtime tarafında bazı yollar report-only/no-op/policy blocked olarak işaretlenmiş. Yani FFI artifact üretimi güçlü; gerçek runtime çağrı kapsamı sınırlı olabilir.

### 8.10 Overlay / switchboard

`uxb/compiler` altı esas kaynak değil, geçiş/izleme overlay katmanı:

- hooks: no-op izleme hook’ları
- wrappers: AST/HIR/MIR/runtime/codegen bundle wrapper’ları
- scripts: build, JSON export, switchboard, artifact organizer

Bu overlay’in değeri büyük: mevcut kaynak kodu bozmadan yeni disiplinli akışı kurmaya yarar.

## 9. Kod-gerçekliği değerlendirmesi

### Güçlü gerçekler

1. Compiler tek dosya `src/main.bas` üzerinden büyük include zinciriyle derlenebilecek şekilde kurulmuş.
2. Frontend geniş: lexer, preprocessor, parser registry, çok sayıda statement handler var.
3. AST modeli gerçek ve JSON export var.
4. Semantic pass ciddi doğrulama yapıyor.
5. HIR/MIR modelleri var.
6. AST runtime geniş ve çok sayıda feature’ı yürütmeye aday.
7. x64 NASM emitter gerçek; sadece plan değil.
8. x64 build pipeline object/link/artifact rapor düzeyine kadar inmiş.
9. FFI/interop artifact üretimi güçlü.
10. Test ve geçmiş matrix çıktıları çok zengin.

### Zayıf / dikkat edilmesi gereken gerçekler

1. `--codegen-source MIR` gerçek MIR→x64 codegen gibi çalışmıyor; MIR build/opt doğrulandıktan sonra yine AST emitter’a dönüyor.
2. MIR JSON gerçek instruction dump değil, pipeline/opcode surface JSON.
3. x86 backend gerçek backend değil, x64 rewrite.
4. x64 codegen tüm dil yüzeyini kapsamıyor; birçok unsupported hata yolu var.
5. AST node yapısı eski `left/right` ve yeni child-list arasında çift sözleşme taşıyor.
6. Runtime içinde placeholder/no-op/unsupported izleri var.
7. Test klasörü içinde kaynak testlerle birlikte çok sayıda eski exe/json/asm/obj/log çıktısı duruyor; kaynak/çıktı ayrımı bulanık.
8. Overlay iyi ama henüz no-op hook ağırlıklı; aktif instrumentation değil.
9. Bazı JSON raporları “implemented” yazıyor ama gerçek feature parity garantisi vermiyor.
10. Çok fazla geçmiş matrix/out klasörü var; en güncel durumun hangisi olduğu ayrı manifestle sabitlenmeli.

## 10. Bu sistemi nasıl kullanabiliriz?

TCC/OTCC bağlamı dışında en doğru kullanım, uXBasiC’i “syntax’tan bağımsız compiler çekirdeği” olarak ele almaktır.

### 10.1 uXBasiC’i dil çekirdeği olarak kullanmak

uXBasiC’in asıl değeri BASIC syntax’ı değil; şu alt sistemlerdir:

- token/keyword normalization
- expression parser
- statement parser registry
- AST pool
- type binding
- semantic contracts
- layout/type table
- MIR model
- interpreter backend
- artifact/report JSON düzeni
- native codegen altyapısı
- test/matrix/quality gate modeli

Bu nedenle uXBasiC, farklı yüzey diller için ortak compiler çekirdeği olabilir.

### 10.2 UXM ile ilişki

UXM çok düşük seviye tape/stack/data/servis dili. uXBasiC ise daha yüksek seviyeli, BASIC/OOP/FFI/semantic zenginliğe sahip. Bu iki sistemi karıştırmadan bağlamanın yolu:

```text
UXM frontend  → UXM UIR
uXB frontend  → uXB AST/MIR
             → ortak artifact/diagnostic/test modeli
             → ortak runtime/codegen hedefleri
```

uXBasiC’in parser’ını UXM’e doğrudan çevirmek gerekmez. Ama uXBasiC’in şu parçaları UXM için kullanılabilir:

- JSON artifact standardı
- diagnostics/error localization modeli
- switchboard/run_layer_json sistemi
- semantic quality gate mantığı
- test matrix formatı
- x64 build pipeline disiplinleri
- FFI/import/link artifact üretim prensipleri
- type/layout yaklaşımı, özellikle UXM servisleri büyürse

### 10.3 uXBasiC’i üst seviye DSL olarak kullanmak

uXBasiC, UXM için yüksek seviyeli “makro/host dil” olabilir:

```text
uXBasiC yüksek seviye program
    ↓
semantic/type/layout
    ↓
MIR veya özel UXM lowering
    ↓
UXM script/servis çağrıları
```

Bu yol, UXM’i makineye yakın ara dil gibi kullanır; uXBasiC ise okunabilir üst dil olur.

### 10.4 uXBasiC’i test/rapor motoru olarak kullanmak

uXBasiC’in mevcut matrix ve JSON sistemi, UXM için kalite kapısı olarak kullanılabilir:

```text
kaynak test
  ↓
AST JSON
  ↓
semantic/HIR/MIR report
  ↓
AST interpreter sonucu
  ↓
MIR interpreter sonucu
  ↓
x64 build/run sonucu
  ↓
parity matrix
```

Bu, “Parser OK yetmez / Semantic OK yetmez / AST OK yetmez / MIR OK yetmez / x64 OK yetmez” kuralının teknik zemini olabilir.

## 11. Ne eksik tamamlanmalı?

### 11.1 Gerçek MIR module JSON exporter

Şu anda MIR pipeline/opcode surface JSON var. Ama dış araçların kullanacağı gerçek MIR şu şekilde dışa verilmeli:

```json
{
  "schema": "uxb-mir-module-v1",
  "functions": [
    {
      "name": "main",
      "blocks": [
        {
          "id": 0,
          "instructions": [
            {"op":"LOAD_CONST","result":"t0","operands":["1"]},
            {"op":"STORE_VAR","result":"A","operands":["t0"]}
          ]
        }
      ]
    }
  ]
}
```

Bu olmadan dış backend/transpiler sağlam kurulamaz.

### 11.2 AST sözleşmesi sadeleştirilmeli

`left/right` ve `firstChild/nextSibling` birlikte kalabilir ama canonical sözleşme yazılmalı:

- Expression için left/right mı?
- Statement/block için child-list mi?
- `role` alanı zorunlu mu?
- Codegen hangi alanı esas alacak?

### 11.3 MIR’i gerçek kanonik IR yapmak

Şu an x64 codegen MIR doğrulaması yapıyor ama gerçek emit AST üzerinden gidiyor. Hedef:

```text
AST → MIR → interpreter
AST → MIR → x64 codegen
AST → MIR → diğer backendler
```

olmalı.

### 11.4 Test çıktıları kaynaklardan ayrılmalı

`tests/` içinde 240 exe, yüzlerce json/log/asm/obj durması, kod-gerçekliği incelemesini zorlaştırır. Test kaynakları ve test çıktıları ayrılmalı:

```text
tests/src/
tests/expected/
test_runs/<stamp>/
artifacts/archive/<stamp>/
```

### 11.5 Overlay hook’ları gerçek instrumentation’a çevrilebilir

Şu an hook’lar no-op. Bunlar ileride katman giriş/çıkış izleme için kullanılabilir:

```text
LEXER_START / LEXER_END
PARSER_START / PARSER_END
SEMANTIC_START / SEMANTIC_END
MIR_LOWER_START / MIR_LOWER_END
CODEGEN_START / CODEGEN_END
```

Bu JSON trace ve VSCode live panel için çok yararlı olur.

## 12. Son hüküm

uXBasiC kaynak kodu iyi bir temel. Bunu “BASIC yazan küçük dil” diye değil, “FreeBASIC ile yazılmış çok katmanlı compiler framework” diye görmek gerekir.

En doğru strateji:

1. `src/` canonical kalsın.
2. `compiler/` overlay aktif switchboard ve instrumentation katmanı olsun.
3. AST JSON gerçek kalmaya devam etsin.
4. HIR inventory JSON daha zenginleştirilsin.
5. Gerçek MIR module JSON exporter yazılsın.
6. MIR canonical IR yapılsın.
7. x64 codegen AST’ten MIR’e taşınsın veya açıkça “AST native backend” diye adlandırılsın.
8. UXM ile doğrudan syntax düzeyinde değil, artifact/diagnostic/runtime/test mimarisi düzeyinde bağ kurulsun.
9. Test çıktıları arşive alınsın, test kaynakları sade kalsın.
10. Her feature için katman matrisinde `Parser/Semantic/AST/MIR/x64/Test` ayrı ayrı PASS/FAIL yazılsın.

