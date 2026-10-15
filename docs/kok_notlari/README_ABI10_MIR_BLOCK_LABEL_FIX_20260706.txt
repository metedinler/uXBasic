UXB_ABI10_MIR_BLOCK_LABEL_FIX_20260706

Problem:
- ABI10 AST stage is already past the old ASSERT/SUB expression errors.
- MIR now fails with: MIR label not found: 1.
- Semantic MIR lowerers emit numeric local basic-block ids in JMP/JZ/JNZ operands.
- The canonical MIR interpreter executes one flat instruction stream and jumps only by label table.
- semantic_to_canonical_mir_bridge.fbs was copying numeric targets (for example operand "1") without emitting a matching canonical label.

Fix:
1) src/semantic/semantic_to_canonical_mir_bridge.fbs
   - Adds function-scoped block labels: __UXB_BLK_F<functionIndex>_B<blockId>.
   - Emits a block label before every canonicalized semantic basic block.
   - Rewrites MIR_JMP / MIR_JMP_IF_FALSE / MIR_JMP_IF_TRUE numeric block targets to these scoped labels.
   - Keeps user GOTO/GOSUB labels untouched.
   - Makes function labels carry operand(0)=functionName and operand(1..)=parameter names.
   - Updates structural verification to use canonical opcode names and accept label targets.

2) src/interpreter/mir/mir_interp.fbs
   - Invoked routines no longer stop at internal block labels; they stop only at the next MIR_FUNCTION_LABEL.
   - MIR CALL can now target a user FUNCTION/SUB label, bind arguments to parameter names from the function label, execute it, and write the return value to resultName.

FFI audit:
- src/interpreter/mir/mir_interp_ffi.fbs already has UXB_MIRFFI_MAX_ARGS=10 and routes through uxffi_invoke10.
- ABI10 CALL(DLL, ..., type-list, args...) layout is compatible after the previous CALL16 fix.
- No uxffi.dll change is included here.

Expected result:
- The current "MIR label not found: 1" should be removed.
- If a later failure appears, it should be in the next layer: uxffi.dll deployment, actual FFI value conversion, or x64 AST build/runtime.
