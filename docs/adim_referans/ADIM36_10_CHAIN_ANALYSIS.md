# ADIM36 — 10 Zincir Analizi Yenileme

Bu çalışma, daha önce ADIM30 ile yaptığımız “10 halkalı yaşam zinciri” testini genişletir.

| No | Halka | Kanıt çıktısı | Kırılırsa anlamı |
|---:|---|---|---|
| 1 | Lexer / Preprocessor | tokens, diagnostics, preprocessed source | Yüzey tanınmıyor veya `%%` komut sızıyor |
| 2 | Parser | AST JSON | Syntax yüzeyi parser’da yok |
| 3 | AST Contract | contract JSON | Node türü registry’de yaşamıyor |
| 4 | Semantic / Type / Layout | symbol/type/layout/HIR | Sembol, tip, class/field/layout çözülmüyor |
| 5 | MIR Lowering | MIR JSON | AST/HIR’den MIR’e gerçek karşılık yok |
| 6 | MIR Verify | verify JSON | Backend öncesi IR geçersiz |
| 7 | Interpreter | stdout/report | AST/MIR runtime gerçek çalıştırmıyor |
| 8 | x64 | NASM/policy | Native backend route yok veya native-only eksik |
| 9 | JS/WAT/WASM/Browser | JS/WAT/HTML/manifest/report | Web/backend route yok veya host bridge eksik |
| 10 | Expected/Actual | CSV/gate | Gerçek çıktı beklenenle uyuşmuyor |

ADIM36 özellikle negatif testleri güçlendirir. Amaç sadece “pozitif smoke geçti” demek değil; yanlış kullanımın doğru yerde kırıldığını da kanıtlamaktır.
