# UXBc Mimari Notu — Backendler, CLI, JSON, I18N

## Ana mimari değişmedi

```text
Kaynak .bas/.uxb
   ↓
Lexer / Parser
   ↓
AST
   ↓
Semantic / Type / Layout
   ↓
MIR
   ↓
AST Interpreter / MIR Interpreter / Native Backends
```

## Native backendler

```text
Native Backends
   ├─ x64 AST Codegen        eski ve daha dolu hat
   ├─ MIR x64 Codegen        yeni kanonik backend adayı
   └─ x86 Codegen            ikincil/legacy/rewrite hattı; unutulmayacak ama ana hedef x64
```

## CLI hedefi

Compiler CLI tarafı şu seçimi açık yapabilmeli:

```text
--execmem --interpreter-backend AST
--execmem --interpreter-backend MIR

--emit-x64-nasm --codegen-source AST
--emit-x64-nasm --codegen-source MIR --enable-mir-x64-experimental

--build-x64 --codegen-source AST
--build-x64 --codegen-source MIR --enable-mir-x64-experimental

--emit-x86-nasm / --build-x86  ileride x86 için
```

## JSON standardı

Eski JSON çıktıları bozulmayacak. Yeni full JSON çıktılarında ortak alanlar olacak:

```json
{
  "schema_version": "...",
  "producer": "uXBasiC",
  "kind": "...",
  "source_file": "...",
  "status": "ok",
  "diagnostics": []
}
```

## Dil dosyaları

Varsayılan tanı dili Türkçe olacak. İngilizce ikinci dil olacak.
Dil dosyaları dışarıda olacak:

```text
uxb/i18n/tr.json
uxb/i18n/en.json
```

Bu adımda i18n sadece sözleşme olarak yazıldı. Son adımda tüm hata mesajları bu sisteme taşınacak.
