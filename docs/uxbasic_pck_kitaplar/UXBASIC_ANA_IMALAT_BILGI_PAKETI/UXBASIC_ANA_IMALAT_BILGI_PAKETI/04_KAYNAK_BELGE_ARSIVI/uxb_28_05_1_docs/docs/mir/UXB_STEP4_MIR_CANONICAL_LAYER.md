# uXBasic Step4 MIR Canonical Layer

Bu katman `src/semantic/mir*.fbs` içinde yaşayan mevcut çalışan MIR yolunu silmez. `src/mir/` altında opcode, type, instruction, registry, lowering decision, verify contract ve JSON writer sözleşmesini tanımlar.

Akış:

```text
AST + semantic/type/layout
→ existing semantic MIR lowering
→ canonical opcode/verify registry
→ MIR verifier
→ MIR JSON
```

Kritik kural: `TYPE_UNKNOWN`, `TYPE_ERROR`, `LAYOUT_MISSING` ve fail-closed opcode yürütülebilir path içinde kabul edilmez.
