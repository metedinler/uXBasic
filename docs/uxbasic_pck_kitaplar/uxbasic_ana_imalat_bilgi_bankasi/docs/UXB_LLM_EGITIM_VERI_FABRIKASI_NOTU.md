# UXB LLM Eğitim Veri Fabrikası Notu

uXBasic’i LLM’ye öğretmenin en değerli yolu kitap değil, derleyici çıktılı gerçek veri üretmektir.

## Ana kayıt paketi

Her örnek için:

- `program.uxb`
- `stdout.txt`
- `stderr.txt`
- `tokens.json`
- `ast.json`
- `semantic.json`
- `mir.json` veya `mir_full.json`
- `run_report.json`
- gerekiyorsa `program.js`, `program.wat`, `index.html`, `manifest.json`

## Veri türleri

1. Türkçe istek → uXBasic kodu.
2. uXBasic kodu → açıklama.
3. uXBasic kodu → beklenen stdout.
4. uXBasic kodu → tokens/AST/MIR.
5. Hatalı uXBasic → hata ve düzeltme.
6. FreeBASIC/QBasic/Python/C/JS → uXBasic çeviri çiftleri.
7. Kütüphane fonksiyonu → kullanım ve örnek.

## Model ayrımı

- SmolLM2 benzeri küçük model: tamamlama, küçük örnek, hızlı deneme.
- Qwen/Qwen-Coder: gerçek uXBasic programlama asistanı.

## Kural

Operatörler, TRUE/FALSE, BASIC eşitliği ve full surface parity düzelmeden büyük eğitim verisi üretilmemelidir. Aksi hâlde model yanlış dil gerçekliğini öğrenir.
