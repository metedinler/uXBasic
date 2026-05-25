# Adim2 CLI Pipeline Gate

| case | status | exit | artifact_json | policy_json | program_json | actual_emitter | fallback_used |
|---|---|---:|---|---|---|---|---|
| ast_interpreter | PASS | 0 | True | False | True |  |  |
| mir_interpreter | PASS | 0 | True | False | True |  |  |
| x64_ast_asm | PASS | 0 | True | True | True | AST_X64 | False |
| x64_mir_asm | PASS | 0 | True | True | True | MIR_X64 | False |
| x64_ast_exe | PASS | 0 | True | True | True | AST_X64 | False |
| x64_mir_exe | TOOLCHAIN_OR_FILE_MISSING | 14 | False | True | False | MIR_X64 | False |
| json_full | PASS | 0 | True | True | True | MIR_X64 | False |

## Lock and Verify Audit

- lock_file_detected: `True`
- hardcoded_timeout_120s_detected: `True`
- lock_timeout_sec_option_present: `False`
- mir_verified_for_policy_cache_present: `True`
- mir_verify_call_count: `2`