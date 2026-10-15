UXB_004_TP02_OPS_FIX_20260712

Kapsam:
- Sadece src/codegen/x64/helpers/x64_codegen_runtime_emit_helpers.fbs dosyasini degistirir.
- ADIM25 gate/route dosyalarina dokunmaz.

Hedef:
- release_pipeline tp_02_pack_02_operators_logic_bit x64 operator hattini duzeltmek.

Degisiklik:
- BASIC AND/OR x64 AST codegen icinde bitwise integer operator olarak emit edilir.
- C tarzi &&/|| logical short-circuit olarak kalir.
- SHR logical shift (shr) olarak emit edilir.
