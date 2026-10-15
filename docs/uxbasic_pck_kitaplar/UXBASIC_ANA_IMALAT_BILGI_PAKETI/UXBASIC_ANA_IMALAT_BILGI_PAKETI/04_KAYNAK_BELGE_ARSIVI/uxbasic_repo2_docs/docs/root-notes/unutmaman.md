unutmaman gereken bir seyde hem debuh modda hemde normal modda bizim tup raporlarimiz log dosyalarina kaydediliyor. ayrica her katmanin ciktilari json olarak kayit ediliyor. simdi asagidaki plani harfiyen uygula.
gerekirse gelistirmelerini yap.
not src15 su anki src klasorunun ziplenerek sistem olusturmak icin baska bir ai ye gonderdigim dosya yani src<no>.zip ifadesi daima senin calisma alanindaki src klasorun anlamina geliyor.

Mete abi, şimdi saf Türkçe ve net anlatıyorum.

Senin istediğin şey **debug’u kaldırmak değil**. Senin istediğin şey şu:

**Çıktı sistemi düzgün olsun.**

Yani compiler çalışınca bazı bilgiler ekrana da yazılmalı, log dosyasına da yazılmalı. Ama kullanıcı `--quiet` derse ekrana hiçbir şey basmamalı. `--debug` derse ayrıntılı bilgiler ayrı debug log dosyasına gitmeli. Interpreter modunda ise programın kendi `PRINT` çıktısı normal çıkış kanalına gitmeli; compiler loguyla karışmamalı.

Benim önceki analizimde hata şuydu: “Print varsa kaldırılsın” diye fazla basit baktım. Doğru yaklaşım şu: `Print` satırları rastgele kalmasın; merkezi bir çıktı/log sisteminden geçsin.

## Şu an src15 gerçek durumu

`diagnostics.fbs` içinde şu an sadece basit ana log sistemi var:

```text
dist/loglar/uxbasic.log
```

Ama şu ayrımlar yok:

```text
normal ekran çıktısı
sessiz mod
debug log
compiler run log
token dump özel modu
programın kendi interpreter çıktısı
```

`main.bas` içinde hâlâ doğrudan ekrana basan satırlar var:

```bas
Print "[DEBUG] Token sayisi:"
Print tokLine
Print "[DEBUG] ASTWriteJson result="
```

Bunlar tamamen yanlış değil; ama **merkezi sisteme bağlı değil**. Sorun bu.

## Debug token sayısı nedir?

Compiler içindeki “token” başka şeydir. AI tokenı başka şeydir.

Compiler tokenı şudur:

```basic
Dim x As Integer
```

Compiler bunu parçalara böler:

```text
DIM
x
AS
Integer
```

Bunlara lexer tokenı denir. Bu compiler’ın normal işidir.

Ama compiler debug modda bunları ekrana dökerse:

```text
[TOK] idx=1 kind=KEYWORD lexeme='DIM'
[TOK] idx=2 kind=IDENT lexeme='x'
...
```

bu uzun yazılar Copilot/ChatGPT ekranına düşerse, AI bunları da okur. O zaman senin Copilot/ChatGPT hakkından yer.

Kısaca:

```text
Compiler’ın token üretmesi normaldir.
Compiler’ın binlerce tokenı ekrana dökmesi AI kullanımını yer.
```

## Çıkış sistemi için doğru plan

Bence isimler tek merkezden gitmeli. `ParserDiag`, `ParserLog`, `debugMode`, `DiagBilgi`, `DiagHata` gibi isimler çoğalmamalı. Hepsinin üstünde tek sistem olmalı.

Önerilen merkezi ad:

```text
UxbLog
```

Yani parser, lexer, main, semantic, MIR, x64 hepsi aynı sisteme yazacak.

## 8A-2.5 — Merkezi çıktı/log sistemi

Bu 8A-3’e geçmeden önce yapılmalı. Çünkü `__vptr` gibi zor işe geçmeden önce compiler’ın ne yaptığını düzgün raporlaması lazım.

### Dosya 1: `src/runtime/diagnostics.fbs`

Buraya yeni alanlar eklenecek:

```bas
Type DiagState
    initialized As Integer
    logPath As String
    debugLogPath As String
    screenEnabled As Integer
    debugEnabled As Integer
    quietMode As Integer
    sourceBaseName As String
End Type
```

Yeni seviyeler:

```bas
Sub UxbInfo(ByRef msgText As String)
Sub UxbWarn(ByRef msgText As String)
Sub UxbError(ByRef msgText As String)
Sub UxbDebug(ByRef msgText As String)
Sub UxbTrace(ByRef msgText As String)
Sub UxbUserOut(ByRef msgText As String)
```

Mantık şu olacak:

```text
UxbInfo  → ekrana basar + ana loga yazar
UxbWarn  → ekrana basar + ana loga yazar
UxbError → ekrana basar + ana loga yazar
UxbDebug → sadece --debug varsa debug loga yazar
UxbTrace → sadece --trace varsa debug loga yazar
UxbUserOut → interpreter program çıktısıdır; log sistemiyle karışmaz
```

Sessiz mod:

```text
--quiet veya --sessiz
```

olursa:

```text
UxbInfo ekrana basmaz, loga yazar.
UxbWarn ekrana basmaz, loga yazar.
UxbError tercihen ekrana basabilir veya sadece stderr’e basabilir.
UxbDebug zaten ekrana basmaz.
```

### Dosya 2: `src/main.bas`

Şu argümanlar eklenmeli:

```text
--quiet / --sessiz
--debug
--trace
--debug-token-dump
--log-out <path>
--debug-log-out <path>
```

Şu mevcut debug printler değiştirilmeli:

```bas
Print "[DEBUG] astJsonOut="
Print "[DEBUG] sourcePath="
Print "[DEBUG] Token sayisi:"
Print tokLine
Print "[DEBUG] ASTWriteJson result="
```

Bunlar şöyle olmalı:

```bas
UxbDebug "astJsonOut=" & astJsonOutPath
UxbDebug "sourcePath=" & sourcePath
UxbDebug "source length=" & Str(Len(sourceText))
UxbDebug "Token sayisi: " & Str(st.tokens.count)
UxbDebug "ASTWriteJson result=" & Str(astWriteOk)
```

Ama `tokLine` tek tek ekrana basılmamalı.

Token dump için ayrı bayrak:

```bas
If debugTokenDumpMode <> 0 Then
    SaveTextFile "dist\token_dump.txt", tokDump
    UxbDebug "Token dump yazildi: dist\token_dump.txt"
End If
```

Yani token dökümü sadece istenirse dosyaya yazılacak.

### Dosya 3: `src/parser/parser/parser_shared.fbs`

Şu an var:

```bas
Declare Sub ParserLog(ByRef msgText As String)

Private Sub ParserDiag(ByRef ps As ParseState, ByRef msgText As String)
    If ps.parseDebug <> 0 Then
        ParserLog msgText
    End If
End Sub
```

Bu kötü değil ama isim parser’a özel kalmış. Tek merkez için şöyle yapılmalı:

```bas
Declare Sub UxbDebug(ByRef msgText As String)

Private Sub ParserDiag(ByRef ps As ParseState, ByRef msgText As String)
    If ps.parseDebug <> 0 Then
        UxbDebug "parser: " & msgText
    End If
End Sub
```

Böylece parser özel `ParserLog` kullanmaz; merkezi `UxbDebug` kullanır.

### Dosya 4: tüm katmanlar

Aynı isimler kullanılmalı:

```text
lexer  → UxbDebug "lexer: ..."
parser → UxbDebug "parser: ..."
semantic → UxbDebug "semantic: ..."
mir → UxbDebug "mir: ..."
runtime → UxbDebug "runtime: ..."
x64 → UxbDebug "x64: ..."
build → UxbInfo / UxbError
```

Bu sayede isimler çoğalmaz.

## Compiler çıktısı ile program çıktısı ayrımı

Bu çok önemli.

Compiler’ın kendi bilgisi:

```text
AST JSON yazıldı
MIR üretildi
x64 NASM üretildi
program.exe oluşturuldu
```

Bunlar `UxbInfo` ile loglanmalı.

Interpreter’da kullanıcının programı şunu yazarsa:

```basic
PRINT "Merhaba"
```

bu compiler loguna değil, program çıkışına gitmeli.

Yani:

```text
Compiler logu: derleme bilgileri
Program stdout: kullanıcının program çıktısı
```

Bunlar karışmamalı.

## Derlenen dosyaya özel log

Senin dediğin doğru. Her compile edilen dosya için ayrı log da olmalı.

Örnek:

```text
dist/loglar/uxbasic.log
dist/loglar/uxbasic_debug.log
dist/loglar/program_adi.compile.log
dist/loglar/program_adi.debug.log
dist/reports/program_adi.pipeline.json
dist/reports/program_adi.ast.json
dist/reports/program_adi.mir.json
dist/reports/program_adi.build.json
```

Bu sistemde kullanıcı kendi programı için ne olduğunu görür.