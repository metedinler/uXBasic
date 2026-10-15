bits 64
default rel

extern __uxb_rt_print_cstr
extern __uxb_rt_print_newline

section .data
uxb_g_DOGRULAMA: dq 0
__uxb_mir_str_0: db 73,78,76,73,78,69,95,80,79,76,73,67,89,95,79,75,0
__uxb_mir_str_1: db 67,73,76,84,52,95,73,78,76,73,78,69,95,80,65,83,83,0
__uxb_mir_str_2: db 65,83,83,69,82,84,32,102,97,105,108,101,100,32,91,108,105,110,101,32,56,58,53,93,0

section .text
global main
main:
    push rbp
    mov rbp, rsp
    push rbx
    ; uxb register discipline: rax=result r10=rhs r11=temp rcx/rdx/r8/r9=call args rbx=saved
    sub rsp, 152
    mov qword [rbp-112], 0
.Lmir_block_0:
    ; .\docs\uxbasic_5_cilt\examples\cilt4\01_inline_x64.uxb:6:5 LOAD_CONST lexeme=DIM
    mov rax, 0
    movsxd rax, eax
    mov qword [rbp-16], rax
    ; .\docs\uxbasic_5_cilt\examples\cilt4\01_inline_x64.uxb:6:5 STORE_VAR lexeme=DIM
    mov rax, qword [rbp-16]
    movsxd rax, eax
    mov qword [rel uxb_g_DOGRULAMA], rax
    ; .\docs\uxbasic_5_cilt\examples\cilt4\01_inline_x64.uxb:7:17 LOAD_CONST lexeme=7
    mov rax, 7
    mov qword [rbp-24], rax
    ; .\docs\uxbasic_5_cilt\examples\cilt4\01_inline_x64.uxb:7:17 STORE_VAR lexeme=7
    mov rax, qword [rbp-24]
    movsxd rax, eax
    mov qword [rel uxb_g_DOGRULAMA], rax
    ; .\docs\uxbasic_5_cilt\examples\cilt4\01_inline_x64.uxb:8:24 LOAD_CONST lexeme=7
    mov rax, 7
    mov qword [rbp-32], rax
    ; .\docs\uxbasic_5_cilt\examples\cilt4\01_inline_x64.uxb:8:24 EQ lexeme=7
    ; resolved compare types: I32, I64
    mov rax, qword [rel uxb_g_DOGRULAMA]
    mov r10, qword [rbp-32]
    cmp rax, r10
    sete al
    movzx rax, al
    neg rax
    cmp rax, 0
    setne al
    movzx rax, al
    neg rax
    mov qword [rbp-40], rax
    ; .\docs\uxbasic_5_cilt\examples\cilt4\01_inline_x64.uxb:8:22 LOAD_CONST lexeme==
    mov rax, 0
    mov qword [rbp-48], rax
    ; .\docs\uxbasic_5_cilt\examples\cilt4\01_inline_x64.uxb:8:22 NE lexeme==
    ; resolved compare types: BOOL, I64
    mov rax, qword [rbp-40]
    mov r10, qword [rbp-48]
    cmp rax, r10
    setne al
    movzx rax, al
    neg rax
    cmp rax, 0
    setne al
    movzx rax, al
    neg rax
    mov qword [rbp-56], rax
    ; .\docs\uxbasic_5_cilt\examples\cilt4\01_inline_x64.uxb:8:22 JZ lexeme==
    mov rax, qword [rbp-56]
    cmp rax, 0
    je .Lmir_block_2
    ; .\docs\uxbasic_5_cilt\examples\cilt4\01_inline_x64.uxb:8:22 JMP lexeme==
    jmp .Lmir_block_1
.Lmir_block_1:
    ; .\docs\uxbasic_5_cilt\examples\cilt4\01_inline_x64.uxb:9:11 LOAD_CONST lexeme=INLINE_POLICY_OK
    lea rax, [rel __uxb_mir_str_0]
    mov qword [rbp-64], rax
    ; .\docs\uxbasic_5_cilt\examples\cilt4\01_inline_x64.uxb:9:11 CALL lexeme=INLINE_POLICY_OK
    mov rax, qword [rbp-64]
    mov rcx, rax
    sub rsp, 32
    call __uxb_rt_print_cstr
    add rsp, 32
    ; .\docs\uxbasic_5_cilt\examples\cilt4\01_inline_x64.uxb:9:11 CALL lexeme=INLINE_POLICY_OK
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; .\docs\uxbasic_5_cilt\examples\cilt4\01_inline_x64.uxb:10:11 LOAD_CONST lexeme=CILT4_INLINE_PASS
    lea rax, [rel __uxb_mir_str_1]
    mov qword [rbp-72], rax
    ; .\docs\uxbasic_5_cilt\examples\cilt4\01_inline_x64.uxb:10:11 CALL lexeme=CILT4_INLINE_PASS
    mov rax, qword [rbp-72]
    mov rcx, rax
    sub rsp, 32
    call __uxb_rt_print_cstr
    add rsp, 32
    ; .\docs\uxbasic_5_cilt\examples\cilt4\01_inline_x64.uxb:10:11 CALL lexeme=CILT4_INLINE_PASS
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; .\docs\uxbasic_5_cilt\examples\cilt4\01_inline_x64.uxb:10:11 RET lexeme=CILT4_INLINE_PASS
    mov rax, qword [rbp-112]
    cmp rax, 0
    je .Lmir_RET_NO_EXCEPTION_1
    mov rax, qword [rbp-96]
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
    ; .\docs\uxbasic_5_cilt\examples\cilt4\01_inline_x64.uxb:8:22 LOAD_CONST lexeme==
    lea rax, [rel __uxb_mir_str_2]
    mov qword [rbp-88], rax
    ; .\docs\uxbasic_5_cilt\examples\cilt4\01_inline_x64.uxb:8:22 STORE_VAR lexeme==
    mov rax, qword [rbp-88]
    mov qword [rbp-96], rax
    ; .\docs\uxbasic_5_cilt\examples\cilt4\01_inline_x64.uxb:8:22 LOAD_CONST lexeme==
    mov rax, 1
    mov qword [rbp-104], rax
    ; .\docs\uxbasic_5_cilt\examples\cilt4\01_inline_x64.uxb:8:22 STORE_VAR lexeme==
    mov rax, qword [rbp-104]
    mov qword [rbp-112], rax
    ; .\docs\uxbasic_5_cilt\examples\cilt4\01_inline_x64.uxb:8:22 RET lexeme==
    mov rax, qword [rbp-112]
    cmp rax, 0
    je .Lmir_RET_NO_EXCEPTION_2
    mov rax, qword [rbp-96]
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
    add rsp, 152
    pop rbx
    pop rbp
    ret
.Lmir_divzero_MAIN_0:
    mov rax, 2
    jmp .Lmir_epilogue_MAIN_0
