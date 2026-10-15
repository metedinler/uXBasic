# MIR x64 Prompt-3 Expansion Notes

Bu yama, temiz UXBc paketinin üzerine önce F80/F128 external FP codegen yamasını korur, sonra MIR x64 emitter kapsamını büyütür.

## Artık desteklenen MIR x64 çekirdeği

- `DIM`
- `CONST`
- `DEF_TYPE` compile-time no-op
- `SETSTRINGSIZE` compile-time no-op
- `LOAD_CONST`
- `LOAD_VAR`
- `STORE_VAR`
- `ADD/SUB/MUL/DIV/MOD/NEG`
- `EQ/NE/LT/LE/GT/GE`
- `AND/OR/XOR/NOT/SHL/SHR/ROL/ROR`
- `JMP/JZ/JNZ/LABEL`
- `CALL PRINT/PRINTLN/CLS/LOCATE/COLOR/RANDOMIZE/INPUT`
- `RET`

## Bilerek diagnostic kalanlar

- `LOAD_INDEXED`
- `STORE_INDEXED`
- `REDIM`
- `NEW`
- `FADD/FSUB/FMUL/FDIV/FNEG`

Bunlar silent skip edilmez. MIR experimental mode bunları görürse açık diagnostic ile durur.

## Neden 192 keyword tamamlandı denmedi?

192 keyword parser/lexer yüzeyidir. Native MIR x64 emitter için gerçekçi ilk halka, MIR lowering'in ürettiği çekirdek opcodes'u sağlamlaştırmaktır. Bu yama o halkayı büyütür ama "tüm dil native MIR x64 oldu" iddiası taşımaz.
