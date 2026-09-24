# uXBasic CLI Opsiyon Matrisi (Mevcut + Overlay)

## Mevcut Compiler Opsiyonlari (calisan)

1. Interpreter:
- `--execmem --interpreter-backend AST`
- `--execmem --interpreter-backend MIR`

2. Katman JSON ciktilari:
- `--ast-json-out <path>`
- `--hir-json-out <path>`
- `--mir-pipeline-json-out <path>`
- `--mir-opcodes-json-out <path>`
- `--artifact-report-json-out <path>`
- `<source>.session.json`
- `session.live.json`

3. Native/derleme akisi:
- `--emit-x64-nasm --emit-x64-nasm-out <path>`
- `--codegen [--codegen-source AST|MIR]`
- `--build-x64 [--build-x64-out <dir>] [--codegen-source AST|MIR]`

4. Interop:
- `--interop`

## Overlay Switchboard (tek komut)

Script: `uxb/compiler/scripts/uxb_switchboard.ps1`

- `-Mode matrix-all`
- `-Mode json-all`
- `-Mode interp-ast`
- `-Mode interp-mir`
- `-Mode emit-x64`
- `-Mode build-x64`
- `-Mode interop`
- `-Mode build-compiler-x64`
- `-Mode build-compiler-x86`
- `-Mode native-toolchain-auto`

## Toolchain kapsami

1. FreeBASIC (`fbc`)
2. NASM (`nasm`)
3. GCC (`gcc`)
4. G++ (`g++`)

Switchboard summary JSON dosyasi her kosuda aktif toolchain path/version bilgisini yazar.
Switchboard ayrica `session.live.json` dosyasini uretir.

## Hata metni hedefi

Switchboard ozetinde:
- `error.tr`: Turkce birincil
- `error.en`: Ingilizce ikincil
- `error.code`: tespit edilen kod

Bu model, VSCode extension ve otomasyon scriptleri icin standard hata sozlesmesidir.

## Test Koku Modeli

1. Kanonik test kok: `uxb/tests`
2. Geri uyum yolu: `tests` junction (silmesiz gecis)
