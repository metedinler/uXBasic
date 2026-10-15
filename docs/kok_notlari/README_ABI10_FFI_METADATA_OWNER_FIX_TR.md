# UXB ABI10 FFI Metadata Owner Fix (05.07.2026)

Bu paket ABI10 smoke zincirinde görülen şu sıradaki hatayı hedefler:

- `semantic-step3: type: unknown symbol: void`

Önceki adımda `DLL` marker'ı FFI metadata olarak atlanmıştı; ancak AST içinde bazı metadata çocuklarının `parent` alanı güvenilir olmadığı için `VOID`, `CDECL` veya tip listesi gibi öğeler runtime ifade/type inference aşamasına kaçabiliyordu.

Bu yama `src/semantic/semantic_step3_gate.fbs` içinde FFI metadata tespitini güçlendirir:

- doğrudan `parent` varsa parent zincirinden FFI çağrısını bulur;
- `parent` eksik/yanlışsa `Step3FindOwnerNode` ile owner çağrıyı bulur;
- çocuk sırasını doğrudan çocuk veya descendant olarak hesaplar;
- `CALL(DLL, lib, sym, VOID, CDECL, "PTR", h)` biçimindeki `DLL`, `VOID`, `CDECL`, tip-listesi stringi metadata olarak atlanır;
- runtime argüman olan `h` yine normal sembol/type kontrolünden geçer.

Paket, ABI10 runner ve build yardımcılarını da önceki çalışan sürümle birlikte taşır; böylece kullanıcı mevcut klasör üstüne doğrudan açınca dosya uyumu korunur.

## Uygulama

```powershell
Set-Location "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb"
Expand-Archive -LiteralPath .\UXB_ABI10_FFI_METADATA_OWNER_FIX_20260705_DIRECT_ROOT.zip -DestinationPath . -Force
```

Ardından x64 compiler yeniden üretilmelidir; aksi halde eski `bin\uxb.exe` aynı semantic hatasını vermeye devam eder.
