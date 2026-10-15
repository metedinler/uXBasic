# UXB Full Surface Parity Yaşam Döngüsü

## Kural

Lexer yüzeyindeki her öğe mimaride yaşam döngüsüne sahip olmak zorundadır. Bir öğe bazı hedeflerde çalışmayabilir; fakat bu bile uygulamadır. Çünkü desteklenmeyen hedefte açık diagnostic üretmek de gerçek davranıştır.

## Katman matrisi

| Katman | Her lexer öğesi için gereken karşılık | NO ise anlamı |
|---|---|---|
| Lexer | Keyword/operator/literal token | Öğenin dil yüzeyinde var olmadığı anlamına gelir. |
| Parser | Statement/expr/type/preprocessor parse yolu | Sözcük tanınır ama cümle kurulamaz. Kritik eksiktir. |
| AST | Node kind veya generic op/type alanı | Parser çıktısı standardize edilmez. Kritik eksiktir. |
| AST Interpreter | Doğrudan çalıştırma veya açık unsupported | Eğitim/test yürütmesi eksik kalır. |
| Semantic/Type | Tip, kapsam, lvalue/rvalue, hedef uygunluğu | En kritik katmandır; yoksa MIR/backend güvenilmez. |
| MIR | Opcode/runtime call/fail-close lowering | Hedeflerden bağımsız anlam eksik kalır. |
| MIR Interpreter | Opcode çalıştırma veya açık unsupported | JIT/yorumlayıcı/test hattı eksik kalır. |
| Runtime | Servis, DLL, library, memory, I/O davranışı | Çalışma zamanı kopar. |
| JS Backend | JS emit veya unsupported diagnostic | Web hedefi sessiz bozulur. |
| WASM/WAT Backend | WAT/WASM emit veya unsupported diagnostic | WASM hedefi sessiz bozulur. |
| x64/x86 Backend | native emit veya unsupported diagnostic | Native hedefi sessiz bozulur. |
| CLI/Gate | Raporlama ve test seçeneği | Coverage ölçülemez. |
| Tests | Pozitif/negatif test | Gerçek coverage kanıtlanamaz. |
| Docs/LLM | PCK ve eğitim açıklaması | İnsan/model yanlış öğrenir. |

## Implementation zorunlu mu?

Evet, fakat implementation her zaman “her backend’de gerçek makine kodu üret” demek değildir. Implementation üç şekilde olabilir:

1. Gerçek çalışma: hedef destekliyorsa kod üretilir veya runtime çalışır.
2. Fail-close: hedef desteklemiyorsa açık hata kodu ve açıklama verilir.
3. Reserved/future: dilde ayrılmışsa parser tanır, semantic resmi “reserved but not enabled” tanısı verir.

Sessizce yok saymak, IDENT gibi geçirmek, dummy çıktı üretmek veya testte placeholder yazmak yasaktır.

## İlk kapatılması gereken yüzeyler

1. Operatörler.
2. TRUE/FALSE.
3. Logic16.
4. BASIC `=` karşılaştırması.
5. Veri tipleri ve aliasları.
6. ARRAY/LIST/DICT/SET.
7. Preprocessor yüzeyi.
8. DLL/API/IMPORT/INCLUDE ayrımı.
9. JS/WASM/native hedef fail-close kararları.
