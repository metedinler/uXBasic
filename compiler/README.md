# uxb Compiler Overlay

Bu klasor, var olan compiler kaynaklarini degistirmeden katman bazli sarmalayici/hook duzeni sunar.

Dizinler:
- hooks: no-op ve etkisiz izleme hook dosyalari
- wrappers: AST/HIR/MIR/runtime/codegen sarmalayicilari
- scripts: `uxb` odakli build ve JSON export komutlari

Not: Asil kaynak kod `src/` altindadir. Burasi gecis ve izleme overlay katmanidir.

