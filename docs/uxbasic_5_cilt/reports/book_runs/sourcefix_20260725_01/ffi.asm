bits 64
default rel

extern __uxb_ffi_resolve_all
extern __uxb_ffi_stub_1
extern __uxb_ffi_stub_2
extern __uxb_ffi_arg_2_1
extern __uxb_ffi_stub_3
extern __uxb_rt_print_cstr
extern __uxb_rt_print_newline

section .data
uxb_g_ILK: dq 0
uxb_g_IKINCI: dq 0
__uxb_mir_str_0: db 107,101,114,110,101,108,51,50,0
__uxb_mir_str_1: db 71,101,116,84,105,99,107,67,111,117,110,116,0
__uxb_mir_str_2: db 85,51,50,0
__uxb_mir_str_3: db 83,84,68,67,65,76,76,0
__uxb_mir_str_4: db 107,101,114,110,101,108,51,50,46,100,108,108,0
__uxb_mir_str_5: db 83,108,101,101,112,0
__uxb_mir_str_6: db 87,73,78,65,80,73,95,84,73,67,75,95,79,75,0
__uxb_mir_str_7: db 67,73,76,84,52,95,70,70,73,95,80,65,83,83,0
__uxb_mir_str_8: db 65,83,83,69,82,84,32,102,97,105,108,101,100,32,91,108,105,110,101,32,57,58,53,93,0

section .text
global main
main:
    push rbp
    mov rbp, rsp
    push rbx
    ; uxb register discipline: rax=result r10=rhs r11=temp rcx/rdx/r8/r9=call args rbx=saved
    sub rsp, 280
    mov qword [rbp-240], 0
    sub rsp, 32
    call __uxb_ffi_resolve_all
    add rsp, 32
.Lmir_block_0:
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:2:5 LOAD_CONST lexeme=DIM
    mov rax, 0
    mov eax, eax
    mov qword [rbp-16], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:2:5 STORE_VAR lexeme=DIM
    mov rax, qword [rbp-16]
    mov eax, eax
    mov qword [rel uxb_g_ILK], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:3:5 LOAD_CONST lexeme=DIM
    mov rax, 0
    mov eax, eax
    mov qword [rbp-24], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:3:5 STORE_VAR lexeme=DIM
    mov rax, qword [rbp-24]
    mov eax, eax
    mov qword [rel uxb_g_IKINCI], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:5:25 LOAD_CONST lexeme=kernel32
    lea rax, [rel __uxb_mir_str_0]
    mov qword [rbp-32], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:5:37 LOAD_CONST lexeme=GetTickCount
    lea rax, [rel __uxb_mir_str_1]
    mov qword [rbp-40], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:5:53 LOAD_CONST lexeme=U32
    lea rax, [rel __uxb_mir_str_2]
    mov qword [rbp-48], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:5:58 LOAD_CONST lexeme=STDCALL
    lea rax, [rel __uxb_mir_str_3]
    mov qword [rbp-56], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:5:15 CALL lexeme=CALL
    sub rsp, 32
    call __uxb_ffi_stub_1
    add rsp, 32
    mov eax, eax
    mov qword [rbp-64], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:5:11 CAST lexeme=U32
    mov rax, qword [rbp-64]
    mov eax, eax
    mov qword [rbp-72], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:5:11 STORE_VAR lexeme=U32
    mov rax, qword [rbp-72]
    mov eax, eax
    mov qword [rel uxb_g_ILK], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:6:15 LOAD_CONST lexeme=kernel32.dll
    lea rax, [rel __uxb_mir_str_4]
    mov qword [rbp-80], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:6:31 LOAD_CONST lexeme=Sleep
    lea rax, [rel __uxb_mir_str_5]
    mov qword [rbp-88], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:6:46 LOAD_CONST lexeme=STDCALL
    lea rax, [rel __uxb_mir_str_3]
    mov qword [rbp-96], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:6:55 LOAD_CONST lexeme=5
    mov rax, 5
    mov qword [rbp-104], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:6:5 CALL lexeme=CALL
    mov rax, qword [rbp-104]
    mov qword [rel __uxb_ffi_arg_2_1], rax
    sub rsp, 32
    call __uxb_ffi_stub_2
    add rsp, 32
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:7:28 LOAD_CONST lexeme=kernel32.dll
    lea rax, [rel __uxb_mir_str_4]
    mov qword [rbp-120], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:7:44 LOAD_CONST lexeme=GetTickCount
    lea rax, [rel __uxb_mir_str_1]
    mov qword [rbp-128], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:7:60 LOAD_CONST lexeme=U32
    lea rax, [rel __uxb_mir_str_2]
    mov qword [rbp-136], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:7:65 LOAD_CONST lexeme=STDCALL
    lea rax, [rel __uxb_mir_str_3]
    mov qword [rbp-144], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:7:18 CALL lexeme=CALL
    sub rsp, 32
    call __uxb_ffi_stub_3
    add rsp, 32
    mov eax, eax
    mov qword [rbp-152], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:7:14 CAST lexeme=U32
    mov rax, qword [rbp-152]
    mov eax, eax
    mov qword [rbp-160], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:7:14 STORE_VAR lexeme=U32
    mov rax, qword [rbp-160]
    mov eax, eax
    mov qword [rel uxb_g_IKINCI], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:9:22 GE lexeme=ilk
    ; resolved compare types: U32, U32
    mov rax, qword [rel uxb_g_IKINCI]
    mov r10, qword [rel uxb_g_ILK]
    cmp rax, r10
    setge al
    movzx rax, al
    neg rax
    cmp rax, 0
    setne al
    movzx rax, al
    neg rax
    mov qword [rbp-168], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:9:19 LOAD_CONST lexeme=>=
    mov rax, 0
    mov qword [rbp-176], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:9:19 NE lexeme=>=
    ; resolved compare types: BOOL, I64
    mov rax, qword [rbp-168]
    mov r10, qword [rbp-176]
    cmp rax, r10
    setne al
    movzx rax, al
    neg rax
    cmp rax, 0
    setne al
    movzx rax, al
    neg rax
    mov qword [rbp-184], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:9:19 JZ lexeme=>=
    mov rax, qword [rbp-184]
    cmp rax, 0
    je .Lmir_block_2
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:9:19 JMP lexeme=>=
    jmp .Lmir_block_1
.Lmir_block_1:
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:10:11 LOAD_CONST lexeme=WINAPI_TICK_OK
    lea rax, [rel __uxb_mir_str_6]
    mov qword [rbp-192], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:10:11 CALL lexeme=WINAPI_TICK_OK
    mov rax, qword [rbp-192]
    mov rcx, rax
    sub rsp, 32
    call __uxb_rt_print_cstr
    add rsp, 32
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:10:11 CALL lexeme=WINAPI_TICK_OK
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:11:11 LOAD_CONST lexeme=CILT4_FFI_PASS
    lea rax, [rel __uxb_mir_str_7]
    mov qword [rbp-200], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:11:11 CALL lexeme=CILT4_FFI_PASS
    mov rax, qword [rbp-200]
    mov rcx, rax
    sub rsp, 32
    call __uxb_rt_print_cstr
    add rsp, 32
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:11:11 CALL lexeme=CILT4_FFI_PASS
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:11:11 RET lexeme=CILT4_FFI_PASS
    mov rax, qword [rbp-240]
    cmp rax, 0
    je .Lmir_RET_NO_EXCEPTION_1
    mov rax, qword [rbp-224]
    mov rcx, rax
    sub rsp, 32
    call __uxb_rt_print_cstr
    add rsp, 32
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    mov rax, 1
    jmp .Lmir_epilogue_MAIN_0
.Lmir_RET_NO_EXCEPTION_1:
    xor rax, rax
    jmp .Lmir_epilogue_MAIN_0
.Lmir_block_2:
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:9:19 LOAD_CONST lexeme=>=
    lea rax, [rel __uxb_mir_str_8]
    mov qword [rbp-216], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:9:19 STORE_VAR lexeme=>=
    mov rax, qword [rbp-216]
    mov qword [rbp-224], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:9:19 LOAD_CONST lexeme=>=
    mov rax, 1
    mov qword [rbp-232], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:9:19 STORE_VAR lexeme=>=
    mov rax, qword [rbp-232]
    mov qword [rbp-240], rax
    ; docs/uxbasic_5_cilt/examples/cilt4/03_ffi_winapi.uxb:9:19 RET lexeme=>=
    mov rax, qword [rbp-240]
    cmp rax, 0
    je .Lmir_RET_NO_EXCEPTION_2
    mov rax, qword [rbp-224]
    mov rcx, rax
    sub rsp, 32
    call __uxb_rt_print_cstr
    add rsp, 32
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    mov rax, 1
    jmp .Lmir_epilogue_MAIN_0
.Lmir_RET_NO_EXCEPTION_2:
    xor rax, rax
    jmp .Lmir_epilogue_MAIN_0
.Lmir_epilogue_MAIN_0:
    add rsp, 280
    pop rbx
    pop rbp
    ret
.Lmir_divzero_MAIN_0:
    mov rax, 2
    jmp .Lmir_epilogue_MAIN_0
