bits 64
default rel

extern __uxb_rt_print_f32
extern __uxb_rt_print_newline
extern __uxb_rt_print_i64
extern __uxb_rt_print_f64
extern calloc
extern __uxb_rt_runtime_error_exit
extern memmove
extern CreateFileMappingA
extern MapViewOfFile
extern UnmapViewOfFile
extern CloseHandle
extern __uxb_rt_exc_uncaught

section .data
uxb_g_A: dq 0
uxb_g_F: dq 0
uxb_g_D: dq 0
uxb_g_H: dq 0
__uxb_mir_str_0: db 68,105,122,105,32,98,101,108,108,101,107,32,97,121,105,114,109,97,32,98,97,115,97,114,105,115,105,122,32,47,32,97,114,114,97,121,32,109,101,109,111,114,121,32,97,108,108,111,99,97,116,105,111,110,32,102,97,105,108,101,100,58,32,95,95,117,120,98,95,97,114,114,95,65,0
__uxb_mem_space: times 1048576 db 0
__uxb_memory_seq_buf: times 65536 db 0
__uxb_empty_text: db 0
__uxb_mem_virtual_base: dq 0
__uxb_mem_virtual_map: dq 0
__uxb_mem_virtual_size: dq 1048576
__uxb_mem_error: dq 0
__uxb_memref_count: dq 0
__uxb_memref_width: dq 1
__uxb_mir_str_1: db 97,114,114,97,121,32,105,110,100,101,120,32,111,117,116,32,111,102,32,98,111,117,110,100,115,32,65,0

section .bss
__uxb_arr_A: resq 3
__uxb_memref_tab: resb 6144

section .text
global main
main:
    push rbp
    mov rbp, rsp
    push rbx
    ; uxb register discipline: rax=result r10=rhs r11=temp rcx/rdx/r8/r9=call args rbx=saved
    mov r11, rsp
    sub r11, 280
    test byte [r11], 0
    sub rsp, 280
    mov qword [rbp-208], rsi
    mov qword [rbp-216], rdi
    mov qword [rbp-224], r12
    mov qword [rbp-232], r13
    mov qword [rbp-240], r14
    mov qword [rbp-248], r15
.Lmir_block_0:
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:1:1 LOAD_CONST lexeme=DIM ;
    mov rax, 0
    cvtsi2sd xmm0, rax
    cvtsd2ss xmm4, xmm0
    movss dword [rbp-16], xmm4
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:1:1 STORE_VAR lexeme=DIM ;
    cvtss2sd xmm0, dword [rbp-16]
    cvtsd2ss xmm4, xmm0
    movss dword [rel uxb_g_F], xmm4
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:1:16 LOAD_CONST lexeme=16777217 ;
    mov rax, 16777217
    mov qword [rbp-24], rax
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:1:16 STORE_VAR lexeme=16777217 ;
    mov rax, qword [rbp-24]
    cvtsi2sd xmm0, rax
    cvtsd2ss xmm4, xmm0
    movss dword [rel uxb_g_F], xmm4
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:2:1 LOAD_CONST lexeme=DIM ;
    mov rax, 0
    cvtsi2sd xmm0, rax
    movsd qword [rbp-32], xmm0
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:2:1 STORE_VAR lexeme=DIM ;
    movsd xmm0, qword [rbp-32]
    movsd qword [rel uxb_g_D], xmm0
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:2:16 LOAD_CONST lexeme=16777217 ;
    mov rax, 16777217
    mov qword [rbp-40], rax
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:2:16 STORE_VAR lexeme=16777217 ;
    mov rax, qword [rbp-40]
    cvtsi2sd xmm0, rax
    movsd qword [rel uxb_g_D], xmm0
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:3:1 LOAD_CONST lexeme=DIM ;
    mov rax, 0
    cvtsi2sd xmm0, rax
    cvtsd2ss xmm4, xmm0
    movss dword [rbp-48], xmm4
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:3:1 STORE_VAR lexeme=DIM ;
    cvtss2sd xmm0, dword [rbp-48]
    cvtsd2ss xmm4, xmm0
    movss dword [rel uxb_g_H], xmm4
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:3:16 STORE_VAR lexeme=d ;
    movsd xmm0, qword [rel uxb_g_D]
    cvtsd2ss xmm4, xmm0
    movss dword [rel uxb_g_H], xmm4
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:4:11 LOAD_CONST lexeme=16777216 ;
    mov rax, 16777216
    mov qword [rbp-56], rax
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:4:11 FSUB lexeme=16777216 ;
    cvtss2sd xmm0, dword [rel uxb_g_F]
    mov rax, qword [rbp-56]
    cvtsi2sd xmm1, rax
    subsd xmm0, xmm1
    cvtsd2ss xmm4, xmm0
    movss dword [rbp-64], xmm4
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:4:9 CALL lexeme=- ;
    cvtss2sd xmm0, dword [rbp-64]
    sub rsp, 32
    call __uxb_rt_print_f32
    add rsp, 32
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:4:9 CALL lexeme=- ;
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:5:11 LOAD_CONST lexeme=16777216 ;
    mov rax, 16777216
    mov qword [rbp-72], rax
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:5:11 FSUB lexeme=16777216 ;
    cvtss2sd xmm0, dword [rel uxb_g_H]
    mov rax, qword [rbp-72]
    cvtsi2sd xmm1, rax
    subsd xmm0, xmm1
    cvtsd2ss xmm4, xmm0
    movss dword [rbp-80], xmm4
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:5:9 CALL lexeme=- ;
    cvtss2sd xmm0, dword [rbp-80]
    sub rsp, 32
    call __uxb_rt_print_f32
    add rsp, 32
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:5:9 CALL lexeme=- ;
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:6:7 CAST lexeme=F32 ;
    movsd xmm0, qword [rel uxb_g_D]
    cvtsd2ss xmm4, xmm0
    movss dword [rbp-88], xmm4
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:6:16 LOAD_CONST lexeme=16777216 ;
    mov rax, 16777216
    mov qword [rbp-96], rax
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:6:16 SUB lexeme=16777216 ;
    mov rax, qword [rbp-88]
    mov r10, qword [rbp-96]
    sub rax, r10
    mov qword [rbp-104], rax
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:6:14 CALL lexeme=- ;
    cvtss2sd xmm0, dword [rbp-104]
    sub rsp, 32
    call __uxb_rt_print_f32
    add rsp, 32
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:6:14 CALL lexeme=- ;
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:7:7 CAST lexeme=F64 ;
    cvtss2sd xmm0, dword [rel uxb_g_F]
    movsd qword [rbp-112], xmm0
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:7:16 EQ lexeme=d ;
    ; resolved compare types: F64, F64
    movsd xmm0, qword [rbp-112]
    movsd xmm1, qword [rel uxb_g_D]
    ucomisd xmm0, xmm1
    sete al
    setnp dl
    and al, dl
    movzx rax, al
    neg rax
    cmp rax, 0
    setne al
    movzx rax, al
    neg rax
    mov qword [rbp-120], rax
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:7:14 CALL lexeme== ;
    mov rax, qword [rbp-120]
    mov rcx, rax
    sub rsp, 32
    call __uxb_rt_print_i64
    add rsp, 32
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:7:14 CALL lexeme== ;
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:8:7 CAST lexeme=F64 ;
    cvtss2sd xmm0, dword [rel uxb_g_H]
    movsd qword [rbp-128], xmm0
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:8:16 FSUB lexeme=d ;
    movsd xmm0, qword [rbp-128]
    movsd xmm1, qword [rel uxb_g_D]
    subsd xmm0, xmm1
    movsd qword [rbp-136], xmm0
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:8:14 CALL lexeme=- ;
    movsd xmm0, qword [rbp-136]
    sub rsp, 32
    call __uxb_rt_print_f64
    add rsp, 32
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:8:14 CALL lexeme=- ;
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:9:1 DIM lexeme=DIM ;
    mov rcx, 1
    mov rdx, 4
    sub rsp, 32
    call calloc
    add rsp, 32
    test rax, rax
    jnz .Lmir_ARR_ALLOC_OK_7
    lea rcx, [rel __uxb_mir_str_0]
    sub rsp, 32
    call __uxb_rt_runtime_error_exit
    add rsp, 32
.Lmir_ARR_ALLOC_OK_7:
    mov qword [rel __uxb_arr_A], rax
    mov rcx, rax
    mov rdx, 4
    call __uxb_memref_register
    mov rax, qword [rel __uxb_arr_A]
    mov qword [rel __uxb_arr_A + 8], 0
    mov qword [rel __uxb_arr_A + 16], 0
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:10:8 LOAD_CONST lexeme=16777217 ;
    mov rax, 16777217
    mov qword [rbp-152], rax
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:10:3 LOAD_CONST lexeme=0 ;
    mov rax, 0
    mov qword [rbp-160], rax
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:10:3 STORE_INDEXED lexeme=0 ;
    mov rcx, qword [rbp-160]
    cmp rcx, 0
    jl .Lmir_ARR_OOB_8
    cmp rcx, 0
    jle .Lmir_ARR_OK_9
.Lmir_ARR_OOB_8:
    lea rcx, [rel __uxb_mir_str_1]
    sub rsp, 32
    call __uxb_rt_runtime_error_exit
    add rsp, 32
.Lmir_ARR_OK_9:
    imul rcx, 4
    mov rdx, qword [rel __uxb_arr_A]
    add rcx, rdx
    mov rax, qword [rbp-152]
    cvtsi2sd xmm0, rax
    cvtsd2ss xmm0, xmm0
    movss dword [rcx], xmm0
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:11:9 LOAD_CONST lexeme=0 ;
    mov rax, 0
    mov qword [rbp-168], rax
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:11:9 LOAD_INDEXED lexeme=0 ;
    mov rcx, qword [rbp-168]
    cmp rcx, 0
    jl .Lmir_ARR_OOB_10
    cmp rcx, 0
    jle .Lmir_ARR_OK_11
.Lmir_ARR_OOB_10:
    lea rcx, [rel __uxb_mir_str_1]
    sub rsp, 32
    call __uxb_rt_runtime_error_exit
    add rsp, 32
.Lmir_ARR_OK_11:
    imul rcx, 4
    mov rdx, qword [rel __uxb_arr_A]
    add rcx, rdx
    movss xmm0, dword [rcx]
    cvtss2sd xmm0, xmm0
    movsd qword [rbp-176], xmm0
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:11:14 LOAD_CONST lexeme=16777216 ;
    mov rax, 16777216
    mov qword [rbp-184], rax
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:11:14 FSUB lexeme=16777216 ;
    movsd xmm0, qword [rbp-176]
    mov rax, qword [rbp-184]
    cvtsi2sd xmm1, rax
    subsd xmm0, xmm1
    cvtsd2ss xmm4, xmm0
    movss dword [rbp-192], xmm4
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:11:12 CALL lexeme=- ;
    cvtss2sd xmm0, dword [rbp-192]
    sub rsp, 32
    call __uxb_rt_print_f32
    add rsp, 32
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:11:12 CALL lexeme=- ;
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; tests\diagnostics\s510_mir_f32_rounding.uxb:11:12 RET lexeme=- ;
    mov r10, 0
    mov rcx, r10
    sub rsp, 32
    call __uxb_rt_exc_uncaught
    add rsp, 32
    test rax, rax
    jz .Lmir_RET_NO_EXCEPTION_12
    mov rax, 1
    jmp .Lmir_epilogue_MAIN_0
.Lmir_RET_NO_EXCEPTION_12:
    xor rax, rax
    jmp .Lmir_epilogue_MAIN_0
.Lmir_epilogue_MAIN_0:
    cmp qword [rel __uxb_mem_error], 0
    je .mir_memory_status_ok_0
    mov eax, 1
.mir_memory_status_ok_0:
    mov rsi, qword [rbp-208]
    mov rdi, qword [rbp-216]
    mov r12, qword [rbp-224]
    mov r13, qword [rbp-232]
    mov r14, qword [rbp-240]
    mov r15, qword [rbp-248]
    add rsp, 280
    pop rbx
    pop rbp
    ret
.Lmir_divzero_MAIN_0:
    mov rax, 2
    jmp .Lmir_epilogue_MAIN_0
__uxb_mem_fail:
    mov qword [rel __uxb_mem_error], 1
    xor eax, eax
    ret

__uxb_mem_virtual_init:
    push r12
    push r13
    sub rsp, 8
    mov r12, rcx
    add r12, rdx
    jc .mem_virtual_init_fail
    test r12, r12
    jz .mem_virtual_init_fail
    mov r13, [rel __uxb_mem_virtual_map]
    test r13, r13
    jz .mem_virtual_init_no_old
    mov rcx, [rel __uxb_mem_virtual_base]
    test rcx, rcx
    jz .mem_virtual_init_skip_unmap
    sub rsp, 32
    call UnmapViewOfFile
    add rsp, 32
.mem_virtual_init_skip_unmap:
    mov rcx, r13
    sub rsp, 32
    call CloseHandle
    add rsp, 32
.mem_virtual_init_no_old:
    mov qword [rel __uxb_mem_virtual_base], 0
    mov qword [rel __uxb_mem_virtual_map], 0
    mov rax, -1
    mov rcx, rax
    xor rdx, rdx
    mov r8d, 4
    mov r9, r12
    shr r9, 32
    sub rsp, 48
    mov qword [rsp+32], r12
    mov qword [rsp+40], 0
    call CreateFileMappingA
    add rsp, 48
    test rax, rax
    jz .mem_virtual_init_fail
    mov r13, rax
    mov rcx, r13
    mov edx, 983071
    xor r8d, r8d
    xor r9d, r9d
    sub rsp, 48
    mov qword [rsp+32], r12
    call MapViewOfFile
    add rsp, 48
    test rax, rax
    jz .mem_virtual_init_map_fail
    mov [rel __uxb_mem_virtual_base], rax
    mov [rel __uxb_mem_virtual_map], r13
    mov [rel __uxb_mem_virtual_size], r12
    mov eax, 1
    add rsp, 8
    pop r13
    pop r12
    ret
.mem_virtual_init_map_fail:
    mov rcx, r13
    sub rsp, 32
    call CloseHandle
    add rsp, 32
.mem_virtual_init_fail:
    add rsp, 8
    pop r13
    pop r12
    jmp __uxb_mem_fail

__uxb_memref_register:
    lea r8, [rel __uxb_memref_tab]
    mov r9, [rel __uxb_memref_count]
    xor r10, r10
    mov r11, -1
.memref_reg_scan:
    cmp r10, r9
    jae .memref_reg_place
    mov rax, r10
    imul rax, 24
    cmp qword [r8+rax+16], 2
    jne .memref_reg_free_check
    push rsi
    mov rsi, [r8+rax]
    add rsi, [r8+rax+8]
    cmp rcx, rsi
    jae .memref_reg_no_overlap
    mov rsi, rcx
    add rsi, rdx
    cmp rsi, [r8+rax]
    jbe .memref_reg_no_overlap
    mov qword [r8+rax+16], 0
.memref_reg_no_overlap:
    pop rsi
.memref_reg_free_check:
    cmp r11, -1
    jne .memref_reg_next
    cmp qword [r8+rax+16], 0
    jne .memref_reg_next
    mov r11, r10
.memref_reg_next:
    inc r10
    jmp .memref_reg_scan
.memref_reg_place:
    cmp r11, -1
    jne .memref_reg_store
    cmp r9, 256
    jae .memref_reg_done
    mov r11, r9
    inc r9
    mov [rel __uxb_memref_count], r9
.memref_reg_store:
    mov rax, r11
    imul rax, 24
    mov [r8+rax], rcx
    mov [r8+rax+8], rdx
    mov qword [r8+rax+16], 1
.memref_reg_done:
    ret

__uxb_memref_release:
    lea r8, [rel __uxb_memref_tab]
    mov r9, [rel __uxb_memref_count]
    xor r10, r10
.memref_rel_scan:
    cmp r10, r9
    jae .memref_rel_done
    mov rax, r10
    imul rax, 24
    cmp qword [r8+rax+16], 1
    jne .memref_rel_next
    cmp [r8+rax], rcx
    jne .memref_rel_next
    mov qword [r8+rax+16], 2
    jmp .memref_rel_done
.memref_rel_next:
    inc r10
    jmp .memref_rel_scan
.memref_rel_done:
    ret

__uxb_memref_check:
    push rsi
    push rdi
    push r8
    push r10
    push r11
    lea r8, [rel __uxb_memref_tab]
    mov r10, [rel __uxb_memref_count]
    xor r11, r11
    xor edi, edi
.memref_chk_scan:
    cmp r11, r10
    jae .memref_chk_end
    mov rax, r11
    imul rax, 24
    mov rsi, [r8+rax+16]
    cmp rsi, 1
    je .memref_chk_live
    cmp rsi, 2
    jne .memref_chk_next
    mov rsi, [r8+rax]
    cmp rcx, rsi
    jb .memref_chk_next
    add rsi, [r8+rax+8]
    cmp rcx, rsi
    jae .memref_chk_next
    mov edi, 1
    jmp .memref_chk_next
.memref_chk_live:
    mov rsi, [r8+rax]
    cmp rcx, rsi
    jb .memref_chk_next
    add rsi, [r8+rax+8]
    cmp rcx, rsi
    ja .memref_chk_next
    mov rax, rcx
    add rax, [rel __uxb_memref_width]
    cmp rax, rsi
    ja .memref_chk_fail
    jmp .memref_chk_ok
.memref_chk_next:
    inc r11
    jmp .memref_chk_scan
.memref_chk_end:
    test edi, edi
    jnz .memref_chk_fail
.memref_chk_ok:
    mov eax, 1
    jmp .memref_chk_ret
.memref_chk_fail:
    xor eax, eax
.memref_chk_ret:
    pop r11
    pop r10
    pop r8
    pop rdi
    pop rsi
    ret

__uxb_mem_resolve_mode:
    cmp rdx, 1
    je .mem_resolve_virtual
    cmp rdx, 2
    je .mem_resolve_native
.mem_resolve_virtual:
    cmp rcx, [rel __uxb_mem_virtual_size]
    jae .mem_resolve_fail
    mov rax, [rel __uxb_mem_virtual_base]
    test rax, rax
    jnz .mem_resolve_virtual_base
    lea rax, [rel __uxb_mem_space]
.mem_resolve_virtual_base:
    add rax, rcx
    ret
.mem_resolve_native:
    call __uxb_memref_check
    test eax, eax
    jz .mem_resolve_fail
    mov rax, rcx
    ret
.mem_resolve_fail:
    jmp __uxb_mem_fail

__uxb_mem_loadb_mode:
    mov qword [rel __uxb_memref_width], 1
    call __uxb_mem_resolve_mode
    test rax, rax
    jz .mem_loadb_fail
    movzx eax, byte [rax]
    ret
.mem_loadb_fail:
    jmp __uxb_mem_fail

__uxb_mem_loadw_mode:
    cmp rdx, 2
    je .mem_loadw_resolve
    mov rax, [rel __uxb_mem_virtual_size]
    sub rax, 2
    cmp rcx, rax
    ja .mem_loadw_fail
.mem_loadw_resolve:
    mov qword [rel __uxb_memref_width], 2
    call __uxb_mem_resolve_mode
    test rax, rax
    jz .mem_loadw_fail
    movzx eax, word [rax]
    ret
.mem_loadw_fail:
    jmp __uxb_mem_fail

__uxb_mem_loadd_mode:
    cmp rdx, 2
    je .mem_loadd_resolve
    mov rax, [rel __uxb_mem_virtual_size]
    sub rax, 4
    cmp rcx, rax
    ja .mem_loadd_fail
.mem_loadd_resolve:
    mov qword [rel __uxb_memref_width], 4
    call __uxb_mem_resolve_mode
    test rax, rax
    jz .mem_loadd_fail
    mov eax, dword [rax]
    ret
.mem_loadd_fail:
    jmp __uxb_mem_fail

__uxb_mem_loadq_mode:
    cmp rdx, 2
    je .mem_loadq_resolve
    mov rax, [rel __uxb_mem_virtual_size]
    sub rax, 8
    cmp rcx, rax
    ja .mem_loadq_fail
.mem_loadq_resolve:
    mov qword [rel __uxb_memref_width], 8
    call __uxb_mem_resolve_mode
    test rax, rax
    jz .mem_loadq_fail
    mov rax, qword [rax]
    ret
.mem_loadq_fail:
    jmp __uxb_mem_fail

__uxb_mem_storeb_mode:
    mov r10, rdx
    mov rdx, r8
    cmp rdx, 2
    je .mem_storeb_resolve
    mov rax, [rel __uxb_mem_virtual_size]
    sub rax, 1
    cmp rcx, rax
    ja .mem_storeb_fail
.mem_storeb_resolve:
    mov qword [rel __uxb_memref_width], 1
    call __uxb_mem_resolve_mode
    test rax, rax
    jz .mem_storeb_fail
    mov byte [rax], r10b
    mov eax, 1
    ret
.mem_storeb_fail:
    jmp __uxb_mem_fail

__uxb_mem_storew_mode:
    mov r10, rdx
    mov rdx, r8
    cmp rdx, 2
    je .mem_storew_resolve
    mov rax, [rel __uxb_mem_virtual_size]
    sub rax, 2
    cmp rcx, rax
    ja .mem_storew_fail
.mem_storew_resolve:
    mov qword [rel __uxb_memref_width], 2
    call __uxb_mem_resolve_mode
    test rax, rax
    jz .mem_storew_fail
    mov word [rax], r10w
    mov eax, 1
    ret
.mem_storew_fail:
    jmp __uxb_mem_fail

__uxb_mem_stored_mode:
    mov r10, rdx
    mov rdx, r8
    cmp rdx, 2
    je .mem_stored_resolve
    mov rax, [rel __uxb_mem_virtual_size]
    sub rax, 4
    cmp rcx, rax
    ja .mem_stored_fail
.mem_stored_resolve:
    mov qword [rel __uxb_memref_width], 4
    call __uxb_mem_resolve_mode
    test rax, rax
    jz .mem_stored_fail
    mov dword [rax], r10d
    mov eax, 1
    ret
.mem_stored_fail:
    jmp __uxb_mem_fail

__uxb_mem_storeq_mode:
    mov r10, rdx
    mov rdx, r8
    cmp rdx, 2
    je .mem_storeq_resolve
    mov rax, [rel __uxb_mem_virtual_size]
    sub rax, 8
    cmp rcx, rax
    ja .mem_storeq_fail
.mem_storeq_resolve:
    mov qword [rel __uxb_memref_width], 8
    call __uxb_mem_resolve_mode
    test rax, rax
    jz .mem_storeq_fail
    mov qword [rax], r10
    mov eax, 1
    ret
.mem_storeq_fail:
    jmp __uxb_mem_fail

__uxb_mem_copy_mode:
    test r8, r8
    jz .mem_copy_mode_done
    mov r10, rcx
    mov r11, rdx
    cmp r9, 2
    je .mem_copy_mode_native_or_auto
    mov rax, [rel __uxb_mem_virtual_size]
    sub rax, r8
    cmp r10, rax
    ja .mem_copy_mode_fail
    cmp r11, rax
    ja .mem_copy_mode_fail
.mem_copy_mode_native_or_auto:
    mov qword [rel __uxb_memref_width], r8
    mov rcx, r10
    mov rdx, r9
    call __uxb_mem_resolve_mode
    test rax, rax
    jz .mem_copy_mode_fail
    mov r10, rax
    mov rcx, r11
    mov rdx, r9
    call __uxb_mem_resolve_mode
    test rax, rax
    jz .mem_copy_mode_fail
    mov rcx, rax
    mov rdx, r10
    sub rsp, 32
    call memmove
    add rsp, 32
.mem_copy_mode_done:
    mov eax, 1
    ret
.mem_copy_mode_fail:
    jmp __uxb_mem_fail

__uxb_mem_fill_mode:
    test r8, r8
    jz .mem_fill_mode_done
    mov r11, r10
    imul r11, r8
    jo .mem_fill_mode_fail
    cmp r9, 2
    je .mem_fill_mode_resolve
    mov rax, [rel __uxb_mem_virtual_size]
    sub rax, r11
    cmp rcx, rax
    ja .mem_fill_mode_fail
.mem_fill_mode_resolve:
    mov qword [rel __uxb_memref_width], r11
    push r12
    mov r12, r10
    mov r11, rdx
    mov rdx, r9
    call __uxb_mem_resolve_mode
    test rax, rax
    jz .mem_fill_mode_fail_pop
    mov r10, rax
    xor rax, rax
.mem_fill_mode_loop:
    cmp rax, r8
    jae .mem_fill_mode_done_pop
    cmp r12, 1
    je .mem_fill_mode_b
    cmp r12, 2
    je .mem_fill_mode_w
    cmp r12, 8
    je .mem_fill_mode_q
    mov dword [r10 + rax * 4], r11d
    jmp .mem_fill_mode_next
.mem_fill_mode_b:
    mov byte [r10 + rax], r11b
    jmp .mem_fill_mode_next
.mem_fill_mode_w:
    mov word [r10 + rax * 2], r11w
    jmp .mem_fill_mode_next
.mem_fill_mode_q:
    mov qword [r10 + rax * 8], r11
.mem_fill_mode_next:
    inc rax
    jmp .mem_fill_mode_loop
.mem_fill_mode_done_pop:
    pop r12
.mem_fill_mode_done:
    mov eax, 1
    ret
.mem_fill_mode_fail_pop:
    pop r12
.mem_fill_mode_fail:
    jmp __uxb_mem_fail

__uxb_mem_peeks_mode:
    cmp rdx, 65535
    ja .mem_peeks_fail
    test rdx, rdx
    jz .mem_peeks_empty
    cmp r8, 2
    je .mem_peeks_resolve
    mov rax, [rel __uxb_mem_virtual_size]
    sub rax, rdx
    cmp rcx, rax
    ja .mem_peeks_fail
.mem_peeks_resolve:
    mov qword [rel __uxb_memref_width], rdx
    mov r10, rcx
    mov r11, rdx
    mov rdx, r8
    mov rcx, r10
    call __uxb_mem_resolve_mode
    test rax, rax
    jz .mem_peeks_fail
    mov r10, rax
    lea rax, [rel __uxb_memory_seq_buf]
    xor r8, r8
.mem_peeks_loop:
    cmp r8, r11
    jae .mem_peeks_done
    mov dl, [r10 + r8]
    mov [rax + r8], dl
    inc r8
    jmp .mem_peeks_loop
.mem_peeks_done:
    mov byte [rax + r11], 0
    ret
.mem_peeks_empty:
    lea rax, [rel __uxb_empty_text]
    ret
.mem_peeks_fail:
    jmp __uxb_mem_fail

__uxb_mem_pokes_mode:
    test r8, r8
    jz .mem_pokes_mode_done
    cmp r9, 2
    je .mem_pokes_mode_resolve
    mov rax, [rel __uxb_mem_virtual_size]
    sub rax, r8
    cmp rcx, rax
    ja .mem_pokes_mode_fail
.mem_pokes_mode_resolve:
    mov qword [rel __uxb_memref_width], r8
    mov r10, rcx
    mov r11, rdx
    mov rdx, r9
    mov rcx, r10
    call __uxb_mem_resolve_mode
    test rax, rax
    jz .mem_pokes_mode_fail
    mov r10, rax
    xor rax, rax
.mem_pokes_mode_loop:
    cmp rax, r8
    jae .mem_pokes_mode_done
    mov dl, [r11 + rax]
    mov [r10 + rax], dl
    inc rax
    jmp .mem_pokes_mode_loop
.mem_pokes_mode_done:
    mov eax, 1
    ret
.mem_pokes_mode_fail:
    jmp __uxb_mem_fail

