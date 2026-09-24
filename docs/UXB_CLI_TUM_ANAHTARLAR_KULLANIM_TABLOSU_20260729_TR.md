# uXBasic CLI Anahtarları: Tam Kullanım ve Anlam Tablosu

Bu belge compiler kaynaklarından üretilen kanonik CLI registry’sini temel alır.
Varsayılan bildirim dili İngilizcedir; Türkçe için `--message-lang tr` kullanılır.

Temel kalıp:

```powershell
.\bin\uxb.exe <verb> .\program.uxb [anahtarlar]
```

Toplam etkin anahtar: **168**.

| Uzun anahtar | Kısa | Değer ister | Dosya üretir | Katman | Beklenen çıktı | Görevi / doğrulama sözleşmesi |
|---|---|---:|---:|---|---|---|
| `--format-check` | `fmt` | Hayır | Hayır | CLI / Genel | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--help` | `hlp` | Hayır | Hayır | CLI / Genel | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--version` | `ver` | Hayır | Hayır | CLI / Genel | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--target` | `tgt` | Evet | Hayır | CLI / Genel | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--stop-after` | `stp` | Evet | Hayır | CLI / Genel | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--json-out` | `jsn` | Evet | Evet | Web / JS / WASM | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--diag-format` | `dgf` | Evet | Hayır | CLI / Genel | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--error-limit` | `erl` | Evet | Hayır | CLI / Genel | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--emit-nasm` | `ens` | Hayır | Hayır | Native backend | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--emit-js` | `ejs` | Hayır | Hayır | Web / JS / WASM | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--emit-wat` | `ewt` | Hayır | Hayır | Web / JS / WASM | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--emit-wasm` | `ewm` | Hayır | Hayır | Web / JS / WASM | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--dump-ast` | `das` | Hayır | Hayır | AST | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--dump-mir` | `dmi` | Hayır | Hayır | MIR | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--strict` | `str` | Hayır | Hayır | CLI / Genel | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--time-passes` | `tim` | Hayır | Hayır | CLI / Genel | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--debug-token-dump` | `tdp` | Hayır | Hayır | Lexer / Preprocessor | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--token-json-out` | `tkj` | Evet | Evet | Lexer / Preprocessor | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--parse-only` | `par` | Hayır | Hayır | CLI / Genel | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--parser-json-out` | `pjo` | Evet | Evet | Parser | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--ast-contract-check` | `acc` | Hayır | Hayır | AST | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--ast-json-out` | `ajo` | Evet | Evet | AST | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--semantic` | `sem` | Hayır | Hayır | Semantic / HIR / Type | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--semantic-json-out` | `sjo` | Evet | Evet | Semantic / HIR / Type | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--hir-json-out` | `hjo` | Evet | Evet | Semantic / HIR / Type | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--mir-verify` | `mvf` | Hayır | Hayır | MIR | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--codegen-source` | `cgs` | Evet | Hayır | CLI / Genel | .c/.cpp/.asm/.js/.wat | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--mir-full-json-out` | `mfj` | Evet | Evet | MIR | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--execmem` | `exm` | Hayır | Hayır | Runtime / Interpreter | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--interpreter-backend` | `ibk` | Evet | Hayır | Runtime / Interpreter | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--run-report-json-out` | `rrj` | Evet | Evet | Web / JS / WASM | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--emit-x64-nasm` | `x6e` | Hayır | Hayır | Native backend | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--emit-x64-nasm-out` | `x6o` | Evet | Evet | Native backend | .asm/.nasm | ASM/NASM oluşacak; hedef ve symbol raporuyla eşleşecek. |
| `--x64-codegen-policy-json-out` | `x6p` | Evet | Evet | Native backend | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--emit-x86` | `x86` | Hayır | Hayır | Native backend | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--backend-report-json-out` | `brj` | Evet | Evet | Web / JS / WASM | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--js-out` | `jso` | Evet | Evet | Web / JS / WASM | .js | .js artifact oluşacak; boş/placeholder olmayacak; path manifest ile uyumlu olacak. |
| `--wasm-wat-out` | `wto` | Evet | Evet | Web / JS / WASM | .wat | .wat artifact oluşacak; boş/placeholder olmayacak; path manifest ile uyumlu olacak. |
| `--build-x64` | `bx6` | Hayır | Hayır | Native backend | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--build-x64-out` | `bxo` | Evet | Evet | Native backend | .exe | Exe path üretilecek; build report exit code ile bağlanacak. |
| `--validate-all` | `val` | Hayır | Hayır | Tooling / VSCode / Gate | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--validate-all-report-json-out` | `vaj` | Evet | Evet | Web / JS / WASM | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--source-map` | `smp` | Hayır | Hayır | Tooling / VSCode / Gate | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--source-map-json-out` | `smj` | Evet | Evet | Web / JS / WASM | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--doc` | `doc` | Hayır | Hayır | Tooling / VSCode / Gate | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--doc-json-out` | `djo` | Evet | Evet | Web / JS / WASM | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--release-gate` | `rel` | Hayır | Hayır | Tooling / VSCode / Gate | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--release-json-out` | `rjo` | Evet | Evet | Web / JS / WASM | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--tokens-json-out` | `tjs` | Evet | Evet | Lexer / Preprocessor | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--lexer-diagnostics-json-out` | `ldj` | Evet | Evet | Lexer / Preprocessor | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--preprocessed-out` | `pre` | Evet | Evet | Lexer / Preprocessor | .bas/.uxb | Preprocessed source oluşacak; %% meta komut sızmayacak. |
| `--parser-diagnostics-json-out` | `pdj` | Evet | Evet | Parser | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--symbol-table-json-out` | `syj` | Evet | Evet | Semantic / HIR / Type | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--type-table-json-out` | `tyj` | Evet | Evet | Semantic / HIR / Type | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--layout-report-json-out` | `lrj` | Evet | Evet | Semantic / HIR / Type | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--hir-inventory-json-out` | `hij` | Evet | Evet | Semantic / HIR / Type | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--semantic-diagnostics-json-out` | `sdj` | Evet | Evet | Semantic / HIR / Type | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--mir-opt-report-json-out` | `mor` | Evet | Evet | MIR | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--stdout-out` | `sto` | Evet | Evet | Runtime / Interpreter | .txt | Dosya oluşacak, UTF-8 metin, boş değil; hata varsa exit code tutarlı. |
| `--stderr-out` | `ste` | Evet | Evet | Runtime / Interpreter | .txt | Dosya oluşacak, UTF-8 metin, boş değil; hata varsa exit code tutarlı. |
| `--runtime-trace-json-out` | `rtj` | Evet | Evet | Web / JS / WASM | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--wat-out` | `wat` | Evet | Evet | Web / JS / WASM | .wat | .wat artifact oluşacak; boş/placeholder olmayacak; path manifest ile uyumlu olacak. |
| `--wasm-out` | `wsm` | Evet | Evet | Web / JS / WASM | .wasm | .wasm artifact oluşacak; boş/placeholder olmayacak; path manifest ile uyumlu olacak. |
| `--html-out` | `htm` | Evet | Evet | Web / JS / WASM | .html | .html artifact oluşacak; boş/placeholder olmayacak; path manifest ile uyumlu olacak. |
| `--manifest-out` | `man` | Evet | Evet | Web / JS / WASM | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--debug` | `dbg` | Hayır | Hayır | CLI / Genel | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--quiet` | `qui` | Hayır | Hayır | CLI / Genel | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--trace` | `trc` | Hayır | Hayır | Tooling / VSCode / Gate | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--log-out` | `log` | Evet | Evet | Tooling / VSCode / Gate | .log | Dosya oluşacak, UTF-8 metin, boş değil; hata varsa exit code tutarlı. |
| `--debug-log-out` | `dlo` | Evet | Evet | Tooling / VSCode / Gate | .log | Dosya oluşacak, UTF-8 metin, boş değil; hata varsa exit code tutarlı. |
| `--message-lang` | `mlg` | Evet | Hayır | CLI / Genel | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--language` | `lng` | Evet | Hayır | CLI / Genel | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--session-live-json-out` | `slj` | Evet | Evet | Web / JS / WASM | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--layer-timing-json-out` | `ltj` | Evet | Evet | Web / JS / WASM | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--hook-trace` | `htr` | Hayır | Hayır | Tooling / VSCode / Gate | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--trace-json` | `tjx` | Hayır | Evet | Web / JS / WASM | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--interop` | `ino` | Hayır | Hayır | CLI / Genel | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--x64gen` | `x6g` | Hayır | Hayır | Native backend | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--target-x86` | `tx6` | Hayır | Hayır | Native backend | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--codegen` | `cod` | Hayır | Hayır | CLI / Genel | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--x64` | `x64` | Hayır | Hayır | Native backend | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--target-js` | `tgj` | Hayır | Hayır | Web / JS / WASM | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--target-browser` | `tbr` | Hayır | Hayır | Web / JS / WASM | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--x64gen-out` | `xgo` | Evet | Evet | Native backend | .asm/.nasm | ASM/NASM oluşacak; hedef ve symbol raporuyla eşleşecek. |
| `--ir-json-out` | `irj` | Evet | Evet | Web / JS / WASM | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--inventory-json-out` | `inv` | Evet | Evet | Web / JS / WASM | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--pipeline-json-out` | `pij` | Evet | Evet | Web / JS / WASM | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--mir-pipeline-json-out` | `mpj` | Evet | Evet | MIR | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--mir-opcodes-json-out` | `opj` | Evet | Evet | MIR | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--mir-surface-json-out` | `msj` | Evet | Evet | MIR | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--mir-module-json-out` | `mmj` | Evet | Evet | MIR | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--mir-json-out` | `mij` | Evet | Evet | MIR | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--ast-contract-json-out` | `acj` | Evet | Evet | AST | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--ast-contract-report-json-out` | `arj` | Evet | Evet | AST | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--ast-contract-matrix-out` | `acm` | Evet | Evet | AST | .csv/.json | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--artifact-report-json-out` | `afj` | Evet | Evet | Web / JS / WASM | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--mir-verify-json-out` | `mvj` | Evet | Evet | MIR | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--enable-mir-x64` | `mx6` | Hayır | Hayır | MIR | yok / parametre | Deprecated alias: --x64-mode=MIR tercih edilir; geriye uyum icin MIR x64 yolunu acar. |
| `--enable-extfp-runtime` | `xfp` | Hayır | Hayır | Runtime / Interpreter | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--extfp-strict` | `xfs` | Hayır | Hayır | CLI / Genel | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--extfp-diagnostics` | `xfd` | Hayır | Hayır | CLI / Genel | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--extfp-runtime-dir` | `xfr` | Evet | Hayır | Runtime / Interpreter | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--extfp-policy-json-out` | `xfj` | Evet | Evet | Web / JS / WASM | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--console-mode` | `con` | Evet | Hayır | Runtime / Interpreter | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--program-output-out` | `poo` | Evet | Evet | Runtime / Interpreter | .txt | Dosya oluşacak, UTF-8 metin, boş değil; hata varsa exit code tutarlı. |
| `--program-output-json-out` | `poj` | Evet | Evet | Web / JS / WASM | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--final-screen-json-out` | `fsj` | Evet | Evet | Web / JS / WASM | .json | Dosya oluşacak, JSON parse edilecek, schema/status alanı olacak, placeholder yasak. |
| `--target-wat` | `twg` | Hayır | Hayır | Web / JS / WASM | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--target-wasm` | `twm` | Hayır | Hayır | Web / JS / WASM | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--emit-browser` | `ebr` | Hayır | Hayır | Web / JS / WASM | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--validate-all-fail-fast` | `vff` | Hayır | Hayır | AST | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--extract-src` | `esr` | Hayır | Hayır | CLI / Genel | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--adim25-27-close-gate` | `a25` | Hayır | Hayır | CLI / Genel | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--adim25-26-27-close-gate` | `a27` | Hayır | Hayır | CLI / Genel | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--wat2wasm` | `w2w` | Hayır | Hayır | Web / JS / WASM | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--source` | `src` | Evet | Hayır | CLI / Genel | yok / parametre | Exit code, stdout/stderr ve ilgili rapor dosyası doğrulanacak. |
| `--artifact-root` | `art` | Evet | Hayır | Build output root | klasor | Genel build kok dizini verilir; JSON bu kok altindaki json/<run_id>/ klasorune, ASM/OBJ/EXE/WEB ayri alt klasorlere yazilir. |
| `--active-bind-plan-json-out` | `b00` | Evet | Evet | Web / JS / WASM | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--active-bind-plan-txt-out` | `b01` | Evet | Evet | Artifact / JSON | .txt | CLI registry ile ana akis kullanimi dogrulanacak. |
| `--all-diagnostics-json-out` | `b02` | Evet | Evet | Web / JS / WASM | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--ast-exec-result-json-out` | `b03` | Evet | Evet | AST | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--ast-live-json-out` | `b04` | Evet | Evet | AST | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--ast-program-output-out` | `b05` | Evet | Evet | AST | .txt | CLI registry ile ana akis kullanimi dogrulanacak. |
| `--ast-stderr-out` | `b06` | Evet | Evet | AST | .txt | CLI registry ile ana akis kullanimi dogrulanacak. |
| `--ast-stdout-out` | `b07` | Evet | Evet | AST | .txt | CLI registry ile ana akis kullanimi dogrulanacak. |
| `--backend-matrix-json-out` | `b08` | Evet | Evet | Web / JS / WASM | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--browser-index-out` | `b09` | Evet | Evet | Web / JS / WASM | yok / parametre | CLI registry ile ana akis kullanimi dogrulanacak. |
| `--canonical-mir-json-out` | `b10` | Evet | Evet | MIR | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--error-language-file` | `b11` | Evet | Hayır | Diagnostics | yok / parametre | CLI registry ile ana akis kullanimi dogrulanacak. |
| `--error-log-out` | `b12` | Evet | Evet | Diagnostics | yok / parametre | CLI registry ile ana akis kullanimi dogrulanacak. |
| `--error-summary-json-out` | `b13` | Evet | Evet | Web / JS / WASM | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--error-to-terminal` | `b14` | Hayır | Hayır | Diagnostics | yok / parametre | CLI registry ile ana akis kullanimi dogrulanacak. |
| `--interpreter-compare-json-out` | `b15` | Evet | Evet | Runtime / Interpreter | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--js-report-json-out` | `b16` | Evet | Evet | Web / JS / WASM | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--mir-exec-result-json-out` | `b17` | Evet | Evet | MIR | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--mir-live-json-out` | `b18` | Evet | Evet | MIR | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--mir-program-output-out` | `b19` | Evet | Evet | MIR | .txt | CLI registry ile ana akis kullanimi dogrulanacak. |
| `--mir-stderr-out` | `b20` | Evet | Evet | MIR | .txt | CLI registry ile ana akis kullanimi dogrulanacak. |
| `--mir-stdout-out` | `b21` | Evet | Evet | MIR | .txt | CLI registry ile ana akis kullanimi dogrulanacak. |
| `--mir-verify-canonical-json-out` | `b22` | Evet | Evet | MIR | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--mir-verify-semantic-json-out` | `b23` | Evet | Evet | MIR | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--mir-x64-required-opcode-gate-json-out` | `b24` | Evet | Evet | MIR | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--original-source-out` | `b25` | Evet | Evet | CLI / Genel | yok / parametre | CLI registry ile ana akis kullanimi dogrulanacak. |
| `--parser-ast-json-out` | `b26` | Evet | Evet | AST | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--parser-surface-contract-json-out` | `b27` | Evet | Evet | Web / JS / WASM | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--pp` | `b28` | Evet | Hayır | Lexer / Preprocessor | yok / parametre | CLI registry ile ana akis kullanimi dogrulanacak. |
| `--preprocess-result-json-out` | `b29` | Evet | Evet | Web / JS / WASM | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--preprocessor` | `b30` | Evet | Hayır | Lexer / Preprocessor | yok / parametre | CLI registry ile ana akis kullanimi dogrulanacak. |
| `--run-id` | `b31` | Evet | Hayır | Artifact / JSON | yok / parametre | CLI registry ile ana akis kullanimi dogrulanacak. |
| `--run-manifest-json-out` | `b32` | Evet | Evet | Web / JS / WASM | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--runtime-route-matrix-json-out` | `b33` | Evet | Evet | Runtime / Interpreter | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--semantic-enums-json-out` | `b34` | Evet | Evet | Semantic / Type | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--semantic-layouts-json-out` | `b35` | Evet | Evet | Semantic / Type | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--semantic-mir-json-out` | `b36` | Evet | Evet | MIR | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--semantic-types-json-out` | `b37` | Evet | Evet | Semantic / Type | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--type-cast-report-json-out` | `b38` | Evet | Evet | AST | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--vscode-diagnostics-json-out` | `b39` | Evet | Evet | Web / JS / WASM | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--wasm-report-json-out` | `b40` | Evet | Evet | Web / JS / WASM | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--x64-ast-report-json-out` | `b41` | Evet | Evet | AST | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--x64-mir-report-json-out` | `b42` | Evet | Evet | MIR | .json | Dosya olusacak, JSON parse edilecek ve schema/status alanlari kontrol edilecek. |
| `--x64-mode` | `b43` | Evet | Hayır | Native backend | yok / parametre | CLI registry ile ana akis kullanimi dogrulanacak. |
| `-elf` | `b44` | Evet | Hayır | CLI / Genel | yok / parametre | CLI registry ile ana akis kullanimi dogrulanacak. |
| `-elo` | `b45` | Evet | Hayır | CLI / Genel | yok / parametre | CLI registry ile ana akis kullanimi dogrulanacak. |
| `-ett` | `b46` | Hayır | Hayır | CLI / Genel | yok / parametre | CLI registry ile ana akis kullanimi dogrulanacak. |
| `-s` | `b47` | Evet | Hayır | CLI / Genel | yok / parametre | CLI registry ile ana akis kullanimi dogrulanacak. |
| `--type-infer-report-csv-out` | `tir` | Evet | Evet | Type Binding | .csv | Builtin type inference registry CSV raporu yazilir. |
| `--js-runtime-out` | `jrt` | Evet | Evet | Web / JS / WASM | .js | Browser hedefinde JS runtime dosyasi olusacak; HTML bu dosyaya once baglanacak. |
| `--out-root` | `ort` | Evet | Hayır | Build output root | klasor | Genel build kok dizini verilir; uretimler <out-root>/<run-id>/ altinda toplanir. --artifact-root eski alias olarak kalir. |

## Sık kullanılan örnekler

```powershell
.\bin\uxb.exe lex .\program.uxb --tokens-json-out .\reports\tokens.json
.\bin\uxb.exe ast .\program.uxb --ast-json-out .\reports\ast.json
.\bin\uxb.exe sem .\program.uxb --all-diagnostics-json-out .\reports\diagnostics.json
.\bin\uxb.exe int .\program.uxb --interpreter-backend AST
.\bin\uxb.exe int .\program.uxb --interpreter-backend MIR
.\bin\uxb.exe bld .\program.uxb --x64-mode MIR --build-x64-out .\build\program_x64
.\bin\uxb.exe ast .\program.uxb --message-lang tr
```

Makine doğrulama raporu `reports/cli/all_cli_options_verify.json` konumunda üretilir.
