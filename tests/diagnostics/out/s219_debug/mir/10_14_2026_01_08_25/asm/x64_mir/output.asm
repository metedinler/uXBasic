bits 64
default rel

extern __uxb_rt_print_i64
extern __uxb_rt_print_newline
extern __uxb_rt_exc_uncaught

section .data
uxb_g_U8V: dq 0
uxb_g_I8V: dq 0
uxb_g_U16V: dq 0
uxb_g_I16V: dq 0
uxb_g_U32V: dq 0
uxb_g_I32V: dq 0

section .text
global main
main:
    push rbp
    mov rbp, rsp
    push rbx
    ; uxb register discipline: rax=result r10=rhs r11=temp rcx/rdx/r8/r9=call args rbx=saved
    mov r11, rsp
    sub r11, 392
    test byte [r11], 0
    sub rsp, 392
    mov qword [rbp-312], rsi
    mov qword [rbp-320], rdi
    mov qword [rbp-328], r12
    mov qword [rbp-336], r13
    mov qword [rbp-344], r14
    mov qword [rbp-352], r15
.Lmir_block_0:
    ; tests\diagnostics\s219_rotate_width.uxb:1:1 LOAD_CONST lexeme=DIM ;
    mov rax, 0
    movzx rax, al
    mov qword [rbp-16], rax
    ; tests\diagnostics\s219_rotate_width.uxb:1:1 STORE_VAR lexeme=DIM ;
    mov rax, qword [rbp-16]
    movzx rax, al
    movzx rax, al
    mov qword [rel uxb_g_U8V], rax
    ; tests\diagnostics\s219_rotate_width.uxb:1:17 LOAD_CONST lexeme=129 ;
    mov rax, 129
    mov qword [rbp-24], rax
    ; tests\diagnostics\s219_rotate_width.uxb:1:17 STORE_VAR lexeme=129 ;
    mov rax, qword [rbp-24]
    movzx rax, al
    mov qword [rel uxb_g_U8V], rax
    ; tests\diagnostics\s219_rotate_width.uxb:2:1 LOAD_CONST lexeme=DIM ;
    mov rax, 0
    movsx rax, al
    mov qword [rbp-32], rax
    ; tests\diagnostics\s219_rotate_width.uxb:2:1 STORE_VAR lexeme=DIM ;
    mov rax, qword [rbp-32]
    movsx rax, al
    movsx rax, al
    mov qword [rel uxb_g_I8V], rax
    ; tests\diagnostics\s219_rotate_width.uxb:2:17 LOAD_CONST lexeme=- ;
    mov rax, -127
    mov qword [rbp-40], rax
    ; tests\diagnostics\s219_rotate_width.uxb:2:17 STORE_VAR lexeme=- ;
    mov rax, qword [rbp-40]
    movsx rax, al
    mov qword [rel uxb_g_I8V], rax
    ; tests\diagnostics\s219_rotate_width.uxb:3:1 LOAD_CONST lexeme=DIM ;
    mov rax, 0
    movzx rax, ax
    mov qword [rbp-48], rax
    ; tests\diagnostics\s219_rotate_width.uxb:3:1 STORE_VAR lexeme=DIM ;
    mov rax, qword [rbp-48]
    movzx rax, ax
    movzx rax, ax
    mov qword [rel uxb_g_U16V], rax
    ; tests\diagnostics\s219_rotate_width.uxb:3:19 LOAD_CONST lexeme=32769 ;
    mov rax, 32769
    mov qword [rbp-56], rax
    ; tests\diagnostics\s219_rotate_width.uxb:3:19 STORE_VAR lexeme=32769 ;
    mov rax, qword [rbp-56]
    movzx rax, ax
    mov qword [rel uxb_g_U16V], rax
    ; tests\diagnostics\s219_rotate_width.uxb:4:1 LOAD_CONST lexeme=DIM ;
    mov rax, 0
    movsx rax, ax
    mov qword [rbp-64], rax
    ; tests\diagnostics\s219_rotate_width.uxb:4:1 STORE_VAR lexeme=DIM ;
    mov rax, qword [rbp-64]
    movsx rax, ax
    movsx rax, ax
    mov qword [rel uxb_g_I16V], rax
    ; tests\diagnostics\s219_rotate_width.uxb:4:19 LOAD_CONST lexeme=- ;
    mov rax, -32767
    mov qword [rbp-72], rax
    ; tests\diagnostics\s219_rotate_width.uxb:4:19 STORE_VAR lexeme=- ;
    mov rax, qword [rbp-72]
    movsx rax, ax
    mov qword [rel uxb_g_I16V], rax
    ; tests\diagnostics\s219_rotate_width.uxb:5:1 LOAD_CONST lexeme=DIM ;
    mov rax, 0
    mov eax, eax
    mov qword [rbp-80], rax
    ; tests\diagnostics\s219_rotate_width.uxb:5:1 STORE_VAR lexeme=DIM ;
    mov rax, qword [rbp-80]
    mov eax, eax
    mov eax, eax
    mov qword [rel uxb_g_U32V], rax
    ; tests\diagnostics\s219_rotate_width.uxb:5:19 LOAD_CONST lexeme=2147483649 ;
    mov rax, 2147483649
    mov qword [rbp-88], rax
    ; tests\diagnostics\s219_rotate_width.uxb:5:19 STORE_VAR lexeme=2147483649 ;
    mov rax, qword [rbp-88]
    mov eax, eax
    mov qword [rel uxb_g_U32V], rax
    ; tests\diagnostics\s219_rotate_width.uxb:6:1 LOAD_CONST lexeme=DIM ;
    mov rax, 0
    movsxd rax, eax
    mov qword [rbp-96], rax
    ; tests\diagnostics\s219_rotate_width.uxb:6:1 STORE_VAR lexeme=DIM ;
    mov rax, qword [rbp-96]
    movsxd rax, eax
    movsxd rax, eax
    mov qword [rel uxb_g_I32V], rax
    ; tests\diagnostics\s219_rotate_width.uxb:6:19 LOAD_CONST lexeme=- ;
    mov rax, -2147483647
    mov qword [rbp-104], rax
    ; tests\diagnostics\s219_rotate_width.uxb:6:19 STORE_VAR lexeme=- ;
    mov rax, qword [rbp-104]
    movsxd rax, eax
    mov qword [rel uxb_g_I32V], rax
    ; tests\diagnostics\s219_rotate_width.uxb:8:15 LOAD_CONST lexeme=1 ;
    mov rax, 1
    mov qword [rbp-112], rax
    ; tests\diagnostics\s219_rotate_width.uxb:8:15 ROL lexeme=1 ;
    mov rax, qword [rel uxb_g_U8V]
    movzx rax, al
    mov r10, qword [rbp-112]
    mov rcx, r10
    rol rax, cl
    movzx rax, al
    mov qword [rbp-120], rax
    ; tests\diagnostics\s219_rotate_width.uxb:8:11 CALL lexeme=ROL ;
    mov rax, qword [rbp-120]
    movzx rax, al
    mov rcx, rax
    sub rsp, 32
    call __uxb_rt_print_i64
    add rsp, 32
    ; tests\diagnostics\s219_rotate_width.uxb:8:11 CALL lexeme=ROL ;
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; tests\diagnostics\s219_rotate_width.uxb:9:15 LOAD_CONST lexeme=1 ;
    mov rax, 1
    mov qword [rbp-128], rax
    ; tests\diagnostics\s219_rotate_width.uxb:9:15 ROR lexeme=1 ;
    mov rax, qword [rel uxb_g_U8V]
    movzx rax, al
    mov r10, qword [rbp-128]
    mov rcx, r10
    ror rax, cl
    movzx rax, al
    mov qword [rbp-136], rax
    ; tests\diagnostics\s219_rotate_width.uxb:9:11 CALL lexeme=ROR ;
    mov rax, qword [rbp-136]
    movzx rax, al
    mov rcx, rax
    sub rsp, 32
    call __uxb_rt_print_i64
    add rsp, 32
    ; tests\diagnostics\s219_rotate_width.uxb:9:11 CALL lexeme=ROR ;
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; tests\diagnostics\s219_rotate_width.uxb:10:15 LOAD_CONST lexeme=1 ;
    mov rax, 1
    mov qword [rbp-144], rax
    ; tests\diagnostics\s219_rotate_width.uxb:10:15 ROL lexeme=1 ;
    mov rax, qword [rel uxb_g_I8V]
    movsx rax, al
    mov r10, qword [rbp-144]
    mov rcx, r10
    rol rax, cl
    movsx rax, al
    mov qword [rbp-152], rax
    ; tests\diagnostics\s219_rotate_width.uxb:10:11 CALL lexeme=ROL ;
    mov rax, qword [rbp-152]
    movsx rax, al
    mov rcx, rax
    sub rsp, 32
    call __uxb_rt_print_i64
    add rsp, 32
    ; tests\diagnostics\s219_rotate_width.uxb:10:11 CALL lexeme=ROL ;
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; tests\diagnostics\s219_rotate_width.uxb:11:15 LOAD_CONST lexeme=1 ;
    mov rax, 1
    mov qword [rbp-160], rax
    ; tests\diagnostics\s219_rotate_width.uxb:11:15 ROR lexeme=1 ;
    mov rax, qword [rel uxb_g_I8V]
    movsx rax, al
    mov r10, qword [rbp-160]
    mov rcx, r10
    ror rax, cl
    movsx rax, al
    mov qword [rbp-168], rax
    ; tests\diagnostics\s219_rotate_width.uxb:11:11 CALL lexeme=ROR ;
    mov rax, qword [rbp-168]
    movsx rax, al
    mov rcx, rax
    sub rsp, 32
    call __uxb_rt_print_i64
    add rsp, 32
    ; tests\diagnostics\s219_rotate_width.uxb:11:11 CALL lexeme=ROR ;
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; tests\diagnostics\s219_rotate_width.uxb:12:16 LOAD_CONST lexeme=1 ;
    mov rax, 1
    mov qword [rbp-176], rax
    ; tests\diagnostics\s219_rotate_width.uxb:12:16 ROL lexeme=1 ;
    mov rax, qword [rel uxb_g_U16V]
    movzx rax, ax
    mov r10, qword [rbp-176]
    mov rcx, r10
    rol rax, cl
    movzx rax, ax
    mov qword [rbp-184], rax
    ; tests\diagnostics\s219_rotate_width.uxb:12:12 CALL lexeme=ROL ;
    mov rax, qword [rbp-184]
    movzx rax, ax
    mov rcx, rax
    sub rsp, 32
    call __uxb_rt_print_i64
    add rsp, 32
    ; tests\diagnostics\s219_rotate_width.uxb:12:12 CALL lexeme=ROL ;
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; tests\diagnostics\s219_rotate_width.uxb:13:16 LOAD_CONST lexeme=1 ;
    mov rax, 1
    mov qword [rbp-192], rax
    ; tests\diagnostics\s219_rotate_width.uxb:13:16 ROR lexeme=1 ;
    mov rax, qword [rel uxb_g_U16V]
    movzx rax, ax
    mov r10, qword [rbp-192]
    mov rcx, r10
    ror rax, cl
    movzx rax, ax
    mov qword [rbp-200], rax
    ; tests\diagnostics\s219_rotate_width.uxb:13:12 CALL lexeme=ROR ;
    mov rax, qword [rbp-200]
    movzx rax, ax
    mov rcx, rax
    sub rsp, 32
    call __uxb_rt_print_i64
    add rsp, 32
    ; tests\diagnostics\s219_rotate_width.uxb:13:12 CALL lexeme=ROR ;
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; tests\diagnostics\s219_rotate_width.uxb:14:16 LOAD_CONST lexeme=1 ;
    mov rax, 1
    mov qword [rbp-208], rax
    ; tests\diagnostics\s219_rotate_width.uxb:14:16 ROL lexeme=1 ;
    mov rax, qword [rel uxb_g_I16V]
    movsx rax, ax
    mov r10, qword [rbp-208]
    mov rcx, r10
    rol rax, cl
    movsx rax, ax
    mov qword [rbp-216], rax
    ; tests\diagnostics\s219_rotate_width.uxb:14:12 CALL lexeme=ROL ;
    mov rax, qword [rbp-216]
    movsx rax, ax
    mov rcx, rax
    sub rsp, 32
    call __uxb_rt_print_i64
    add rsp, 32
    ; tests\diagnostics\s219_rotate_width.uxb:14:12 CALL lexeme=ROL ;
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; tests\diagnostics\s219_rotate_width.uxb:15:16 LOAD_CONST lexeme=1 ;
    mov rax, 1
    mov qword [rbp-224], rax
    ; tests\diagnostics\s219_rotate_width.uxb:15:16 ROR lexeme=1 ;
    mov rax, qword [rel uxb_g_I16V]
    movsx rax, ax
    mov r10, qword [rbp-224]
    mov rcx, r10
    ror rax, cl
    movsx rax, ax
    mov qword [rbp-232], rax
    ; tests\diagnostics\s219_rotate_width.uxb:15:12 CALL lexeme=ROR ;
    mov rax, qword [rbp-232]
    movsx rax, ax
    mov rcx, rax
    sub rsp, 32
    call __uxb_rt_print_i64
    add rsp, 32
    ; tests\diagnostics\s219_rotate_width.uxb:15:12 CALL lexeme=ROR ;
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; tests\diagnostics\s219_rotate_width.uxb:16:16 LOAD_CONST lexeme=1 ;
    mov rax, 1
    mov qword [rbp-240], rax
    ; tests\diagnostics\s219_rotate_width.uxb:16:16 ROL lexeme=1 ;
    mov rax, qword [rel uxb_g_U32V]
    mov eax, eax
    mov r10, qword [rbp-240]
    mov rcx, r10
    rol rax, cl
    mov eax, eax
    mov qword [rbp-248], rax
    ; tests\diagnostics\s219_rotate_width.uxb:16:12 CALL lexeme=ROL ;
    mov rax, qword [rbp-248]
    mov eax, eax
    mov rcx, rax
    sub rsp, 32
    call __uxb_rt_print_i64
    add rsp, 32
    ; tests\diagnostics\s219_rotate_width.uxb:16:12 CALL lexeme=ROL ;
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; tests\diagnostics\s219_rotate_width.uxb:17:16 LOAD_CONST lexeme=1 ;
    mov rax, 1
    mov qword [rbp-256], rax
    ; tests\diagnostics\s219_rotate_width.uxb:17:16 ROR lexeme=1 ;
    mov rax, qword [rel uxb_g_U32V]
    mov eax, eax
    mov r10, qword [rbp-256]
    mov rcx, r10
    ror rax, cl
    mov eax, eax
    mov qword [rbp-264], rax
    ; tests\diagnostics\s219_rotate_width.uxb:17:12 CALL lexeme=ROR ;
    mov rax, qword [rbp-264]
    mov eax, eax
    mov rcx, rax
    sub rsp, 32
    call __uxb_rt_print_i64
    add rsp, 32
    ; tests\diagnostics\s219_rotate_width.uxb:17:12 CALL lexeme=ROR ;
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; tests\diagnostics\s219_rotate_width.uxb:18:16 LOAD_CONST lexeme=1 ;
    mov rax, 1
    mov qword [rbp-272], rax
    ; tests\diagnostics\s219_rotate_width.uxb:18:16 ROL lexeme=1 ;
    mov rax, qword [rel uxb_g_I32V]
    movsxd rax, eax
    mov r10, qword [rbp-272]
    mov rcx, r10
    rol rax, cl
    movsxd rax, eax
    mov qword [rbp-280], rax
    ; tests\diagnostics\s219_rotate_width.uxb:18:12 CALL lexeme=ROL ;
    mov rax, qword [rbp-280]
    movsxd rax, eax
    mov rcx, rax
    sub rsp, 32
    call __uxb_rt_print_i64
    add rsp, 32
    ; tests\diagnostics\s219_rotate_width.uxb:18:12 CALL lexeme=ROL ;
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; tests\diagnostics\s219_rotate_width.uxb:19:16 LOAD_CONST lexeme=1 ;
    mov rax, 1
    mov qword [rbp-288], rax
    ; tests\diagnostics\s219_rotate_width.uxb:19:16 ROR lexeme=1 ;
    mov rax, qword [rel uxb_g_I32V]
    movsxd rax, eax
    mov r10, qword [rbp-288]
    mov rcx, r10
    ror rax, cl
    movsxd rax, eax
    mov qword [rbp-296], rax
    ; tests\diagnostics\s219_rotate_width.uxb:19:12 CALL lexeme=ROR ;
    mov rax, qword [rbp-296]
    movsxd rax, eax
    mov rcx, rax
    sub rsp, 32
    call __uxb_rt_print_i64
    add rsp, 32
    ; tests\diagnostics\s219_rotate_width.uxb:19:12 CALL lexeme=ROR ;
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; tests\diagnostics\s219_rotate_width.uxb:19:12 RET lexeme=ROR ;
    mov r10, 0
    mov rcx, r10
    sub rsp, 32
    call __uxb_rt_exc_uncaught
    add rsp, 32
    test rax, rax
    jz .Lmir_RET_NO_EXCEPTION_7
    mov rax, 1
    jmp .Lmir_epilogue_MAIN_0
.Lmir_RET_NO_EXCEPTION_7:
    xor rax, rax
    jmp .Lmir_epilogue_MAIN_0
.Lmir_epilogue_MAIN_0:
    mov rsi, qword [rbp-312]
    mov rdi, qword [rbp-320]
    mov r12, qword [rbp-328]
    mov r13, qword [rbp-336]
    mov r14, qword [rbp-344]
    mov r15, qword [rbp-352]
    add rsp, 392
    pop rbx
    pop rbp
    ret
.Lmir_divzero_MAIN_0:
    mov rax, 2
    jmp .Lmir_epilogue_MAIN_0
