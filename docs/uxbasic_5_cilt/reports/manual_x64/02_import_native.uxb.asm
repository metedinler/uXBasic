bits 64
default rel

extern __uxb_rt_print_cstr
extern __uxb_rt_print_newline

section .data
__uxb_mir_str_0: db 67,73,76,84,52,95,73,77,80,79,82,84,95,83,85,82,70,65,67,69,95,80,65,83,83,0

section .text
global main
main:
    push rbp
    mov rbp, rsp
    push rbx
    ; uxb register discipline: rax=result r10=rhs r11=temp rcx/rdx/r8/r9=call args rbx=saved
    sub rsp, 56
.Lmir_block_0:
    ; .\docs\uxbasic_5_cilt\examples\cilt4\02_import_native.uxb:9:7 LOAD_CONST lexeme=CILT4_IMPORT_SURFACE_PASS
    lea rax, [rel __uxb_mir_str_0]
    mov qword [rbp-16], rax
    ; .\docs\uxbasic_5_cilt\examples\cilt4\02_import_native.uxb:9:7 CALL lexeme=CILT4_IMPORT_SURFACE_PASS
    mov rax, qword [rbp-16]
    mov rcx, rax
    sub rsp, 32
    call __uxb_rt_print_cstr
    add rsp, 32
    ; .\docs\uxbasic_5_cilt\examples\cilt4\02_import_native.uxb:9:7 CALL lexeme=CILT4_IMPORT_SURFACE_PASS
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; .\docs\uxbasic_5_cilt\examples\cilt4\02_import_native.uxb:9:7 RET lexeme=CILT4_IMPORT_SURFACE_PASS
    xor rax, rax
    jmp .Lmir_epilogue_MAIN_0
.Lmir_epilogue_MAIN_0:
    add rsp, 56
    pop rbx
    pop rbp
    ret
.Lmir_divzero_MAIN_0:
    mov rax, 2
    jmp .Lmir_epilogue_MAIN_0
