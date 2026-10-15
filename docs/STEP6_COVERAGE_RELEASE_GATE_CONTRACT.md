# UXBc Adım 6 Contract — Coverage Gate + Full Test Runner

## Amaç

Adım 6'nın amacı yeni dil özelliği eklemek değildir. Amaç, mevcut compiler katmanlarının durumunu ölçmek, testleri matrix statülerine bağlamak ve kırılan katmanı açıkça raporlamaktır.

## Ana kavramlar

### Release gate

Tüm alt gate sonuçlarını birleştirir:

```text
workspace clean
toolchain doctor
language surface matrix
prior step gap audit
expected runner
layer gate
step3/step4/step5 auditleri
```

### Layer gate

Her testin hangi katmanda kırıldığını sınıflandırır:

```text
SOURCE_LOAD
LEXER
PARSER
AST_CONTRACT
SEMANTIC
HIR
MIR_BUILD
MIR_VERIFY
AST_INTERPRETER
MIR_INTERPRETER
X64_AST_CODEGEN
MIR_X64_CODEGEN
X64_BUILD
EXTFP_RUNTIME
FFI_BACKEND
TYPE_CLASS_BACKEND
UNKNOWN
```

### Expected runner

Testlerden beklenen durumu bilir:

```text
PASS_ALL
PASS_INTERPRETERS_ONLY
EXPECTED_DIAGNOSTIC
TOOLCHAIN_OR_FILE_MISSING
NATIVE_MISMATCH
MIR_MISMATCH
BUILD_OR_RUNTIME_FAIL
FAIL
```

### Test matrix link

Her test dosyasını matrix öğesine bağlar:

```text
test_path
feature_family
surface_items
required_layers
expected_status
strictness
```

## Zorunlu kurallar

1. Sahte PASS yasak.
2. Toolchain eksikse FAIL değil `TOOLCHAIN_OR_FILE_MISSING`.
3. Unsupported ama açık diagnostic varsa `EXPECTED_DIAGNOSTIC`.
4. AST interpreter / MIR interpreter doğruluk referansı olarak kullanılacak.
5. Native x64 çıktısı interpreter çıktısıyla karşılaştırılacak.
6. Her katmanın JSON/MD/CSV çıktısı olacak.
7. Kaynak klasörüne çıktı yazılmayacak.
8. Test sonucu hangi katmanda kırıldı açık yazılacak.
9. Önceki adımların kalan açıkları saklanmayacak.
