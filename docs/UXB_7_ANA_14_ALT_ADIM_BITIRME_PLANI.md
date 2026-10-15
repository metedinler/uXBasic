# uXBasiC 7 Ana / 14 Alt Adım Bitirme Planı

Bu planın amacı: Copilot'un dağılmasını engellemek ve her adımı ölçülebilir yapmak.

## Temel kural
- Tek sayılı alt adımlar ChatGPT modül paketi üretir.
- Çift sayılı alt adımlar Copilot bu modülleri okuyarak eksik kodu tamamlar.
- Her adım sonunda build + smoke + matrix raporu zorunludur.
- Sahte başarı yasak. Destek yoksa diagnostic.

## 1. Ana Adım — Dil yüzeyi ve matrix kilidi
### Alt Adım 1 — ChatGPT
`uxb_language_surface_full_matrix.py` eklendi. Tüm keyword, operator, type, data structure, FFI, MIR opcode ve builtin yüzeyi çıkarılır.

### Alt Adım 2 — Copilot
Matrixte `mir=missing/diagnostic_only` olan öncelikli öğeler için MIR lowering kodu yazacak. x64_mir eksikse emitter yazacak.

## 2. Ana Adım — MIR lowering tamamlama
### Alt Adım 3 — ChatGPT
MIR lowering helper modülleri ve opcode contract dosyaları üretilecek.
### Alt Adım 4 — Copilot
Parser/AST/Semantic'te var olan tüm statement/expression öğelerini MIR'e indirecek.

## 3. Ana Adım — MIR x64 runtime-backed backend
### Alt Adım 5 — ChatGPT
Console/file/string/memory runtime helper modülleri üretilecek.
### Alt Adım 6 — Copilot
MIR x64 emitter bunlara call üretecek; native olmayan sistemlerde diagnostic verecek.

## 4. Ana Adım — TYPE/CLASS/OOP/FFI
### Alt Adım 7 — ChatGPT
TYPE/CLASS/FFI backend contract ve runtime helper iskeletleri üretilecek.
### Alt Adım 8 — Copilot
TYPE field, method call, CALL DLL, INLINE, IMPORT hatlarını gerçek backend'e bağlayacak.

## 5. Ana Adım — Floating point ve high precision completion
### Alt Adım 9 — ChatGPT
F80/F128/BIGF/BIGD/BALL test ve lowering doğrulama modülleri üretilecek.
### Alt Adım 10 — Copilot
Her FP expression yolunu runtime call'a indirecek; register arithmetic yok.

## 6. Ana Adım — Coverage gate ve full test runner
### Alt Adım 11 — ChatGPT
Release gate, layer gate ve expected runner üretilecek.
### Alt Adım 12 — Copilot
Tüm testleri matrix statüleriyle bağlayacak; kırılan katmanı gösterecek.

## 7. Ana Adım — Final merge ve VSCode debugger öncesi IDE
### Alt Adım 13 — ChatGPT
UXBc final merge scripti ve IDE command contract üretilecek.
### Alt Adım 14 — Copilot
VSCode eklentisini build/run/test/dashboard açısından tamamlayacak. Gerçek debugger bundan sonra ayrı iş.
