UXB_008_LAST3_FIX
=================

Purpose
-------
1. Fix x64 interop resolver parsing of valid preprocessor/meta sources.
2. Replace the comment-only pack-13 ASM fixture with a real Win64 NASM object unit.

No bypasses
-----------
- Raw parse is attempted first.
- Preprocessing is used only as a fallback after a real parse failure.
- Preprocess failure remains fatal.
- Parsing the expanded source failure remains fatal.
- IMPORT ASM still must assemble and link successfully.
- No ADIM25, AST, MIR, x64 or web gate is forced to PASS.

Changed files
-------------
src/build/interop_manifest.fbs
xtestx/project_packs/pack_13_import_c_cpp_asm/native/a.asm
