UXB_006_TP02_FIX

- UXB_005 diagnostic changes are fully reverted because that patch did not compile.
- UXB_004 is intentionally retained: tp_02 expects BASIC AND/OR bitwise results.
- Fixes x64 numeric inference: integer-looking NUMBER literals no longer become F64.
  This prevents SHL/SHR expressions from being sent to the float/XMM emitter.

Expected focused test: tp_02 x64 progresses to ASM/build/run and prints:
22, 34, 2, 4, 13, 9, 24, 3
