bits 64
default rel

extern __uxb_rt_task_spawn
extern __uxb_rt_task_wait
extern __uxb_rt_task_status
extern __uxb_rt_print_cstr
extern __uxb_rt_print_newline
extern __uxb_rt_task_result
extern __uxb_rt_print_i64
extern __uxb_rt_task_join
extern __uxb_rt_task_error
extern __uxb_rt_str_concat
extern __uxb_rt_exc_uncaught
extern __uxb_rt_task_shutdown

section .data
uxb_g_T: dq 0
__uxb_mir_str_0: db 119,111,114,107,101,114,0
__uxb_mir_str_1: db 84,72,82,69,65,68,0
__uxb_mir_str_2: db 95,95,83,76,79,84,76,65,78,69,95,84,72,82,69,65,68,95,87,79,82,75,69,82,0
__uxb_mir_str_3: db 87,79,82,75,69,82,0
__uxb_mir_str_4: db 91,0
__uxb_mir_str_5: db 93,0

section .text
global main
main:
    push rbp
    mov rbp, rsp
    push rbx
    ; uxb register discipline: rax=result r10=rhs r11=temp rcx/rdx/r8/r9=call args rbx=saved
    sub rsp, 184
.Lmir_block_0:
    ; .\tests\task_model\spawn_join_basic.uxb:3:14 LOAD_CONST lexeme=+ ;
    lea rax, [rel __uxb_mir_str_0]
    mov qword [rbp-16], rax
    ; .\tests\task_model\spawn_join_basic.uxb:3:14 LOAD_CONST lexeme=+ ;
    lea rax, [rel __uxb_mir_str_1]
    mov qword [rbp-24], rax
    ; .\tests\task_model\spawn_join_basic.uxb:3:14 LOAD_CONST lexeme=+ ;
    mov rax, -1
    mov qword [rbp-32], rax
    ; .\tests\task_model\spawn_join_basic.uxb:3:14 LOAD_CONST lexeme=+ ;
    lea rax, [rel __uxb_mir_str_2]
    mov qword [rbp-40], rax
    ; .\tests\task_model\spawn_join_basic.uxb:3:14 CALL lexeme=+ ;
    ; .\tests\task_model\spawn_join_basic.uxb:6:1 LOAD_CONST lexeme=DIM ;
    mov rax, 0
    mov qword [rbp-48], rax
    ; .\tests\task_model\spawn_join_basic.uxb:6:1 STORE_VAR lexeme=DIM ;
    mov rax, qword [rbp-48]
    mov qword [rel uxb_g_T], rax
    ; .\tests\task_model\spawn_join_basic.uxb:6:30 LOAD_CONST lexeme=41 ;
    mov rax, 41
    mov qword [rbp-56], rax
    ; .\tests\task_model\spawn_join_basic.uxb:6:17 CALL lexeme=SPAWN ;
    ; S-030 SPAWN WORKER -> __SLOTLANE_THREAD_WORKER
    sub rsp, 16
    mov qword [rsp], 0
    mov rax, qword [rbp-56]
    mov qword [rsp+8], rax
    mov rdx, rsp
    sub rsp, 48
    lea rcx, [rel __uxb_task_thunk___SLOTLANE_THREAD_WORKER]
    mov r8, 16
    lea r9, [rel __uxb_mir_str_3]
    mov qword [rsp+32], 1
    mov rax, 0
    mov qword [rsp+40], rax
    call __uxb_rt_task_spawn
    add rsp, 64
    mov qword [rbp-64], rax
    ; .\tests\task_model\spawn_join_basic.uxb:6:17 STORE_VAR lexeme=SPAWN ;
    mov rax, qword [rbp-64]
    mov qword [rel uxb_g_T], rax
    ; .\tests\task_model\spawn_join_basic.uxb:8:1 CALL lexeme=t ;
    mov r10, qword [rel uxb_g_T]
    mov rcx, r10
    sub rsp, 32
    call __uxb_rt_task_wait
    add rsp, 32
    mov qword [rbp-72], rax
    ; .\tests\task_model\spawn_join_basic.uxb:8:1 STORE_VAR lexeme=t ;
    mov rax, qword [rbp-72]
    mov qword [rbp-80], rax
    ; .\tests\task_model\spawn_join_basic.uxb:9:7 CALL lexeme=t ;
    mov r10, qword [rel uxb_g_T]
    mov rcx, r10
    sub rsp, 32
    call __uxb_rt_task_status
    add rsp, 32
    mov qword [rbp-88], rax
    ; .\tests\task_model\spawn_join_basic.uxb:9:7 CALL lexeme=t ;
    mov rax, qword [rbp-88]
    mov rcx, rax
    sub rsp, 32
    call __uxb_rt_print_cstr
    add rsp, 32
    ; .\tests\task_model\spawn_join_basic.uxb:9:7 CALL lexeme=t ;
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; .\tests\task_model\spawn_join_basic.uxb:10:7 CALL lexeme=t ;
    mov r10, qword [rel uxb_g_T]
    mov rcx, r10
    sub rsp, 32
    call __uxb_rt_task_result
    add rsp, 32
    mov qword [rbp-96], rax
    ; .\tests\task_model\spawn_join_basic.uxb:10:7 CALL lexeme=t ;
    mov rax, qword [rbp-96]
    mov rcx, rax
    sub rsp, 32
    call __uxb_rt_print_i64
    add rsp, 32
    ; .\tests\task_model\spawn_join_basic.uxb:10:7 CALL lexeme=t ;
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; .\tests\task_model\spawn_join_basic.uxb:11:7 CALL lexeme=t ;
    mov r10, qword [rel uxb_g_T]
    mov rcx, r10
    sub rsp, 32
    call __uxb_rt_task_join
    add rsp, 32
    mov qword [rbp-104], rax
    ; .\tests\task_model\spawn_join_basic.uxb:11:7 CALL lexeme=t ;
    mov rax, qword [rbp-104]
    mov rcx, rax
    sub rsp, 32
    call __uxb_rt_print_i64
    add rsp, 32
    ; .\tests\task_model\spawn_join_basic.uxb:11:7 CALL lexeme=t ;
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; .\tests\task_model\spawn_join_basic.uxb:12:7 LOAD_CONST lexeme=[ ;
    lea rax, [rel __uxb_mir_str_4]
    mov qword [rbp-112], rax
    ; .\tests\task_model\spawn_join_basic.uxb:12:13 CALL lexeme=t ;
    mov r10, qword [rel uxb_g_T]
    mov rcx, r10
    sub rsp, 32
    call __uxb_rt_task_error
    add rsp, 32
    mov qword [rbp-120], rax
    ; .\tests\task_model\spawn_join_basic.uxb:12:13 ADD lexeme=t ;
    mov rax, qword [rbp-112]
    mov r10, qword [rbp-120]
    mov rcx, rax
    mov rdx, r10
    sub rsp, 32
    call __uxb_rt_str_concat
    add rsp, 32
    mov qword [rbp-128], rax
    ; .\tests\task_model\spawn_join_basic.uxb:12:27 LOAD_CONST lexeme=] ;
    lea rax, [rel __uxb_mir_str_5]
    mov qword [rbp-136], rax
    ; .\tests\task_model\spawn_join_basic.uxb:12:27 ADD lexeme=] ;
    mov rax, qword [rbp-128]
    mov r10, qword [rbp-136]
    mov rcx, rax
    mov rdx, r10
    sub rsp, 32
    call __uxb_rt_str_concat
    add rsp, 32
    mov qword [rbp-144], rax
    ; .\tests\task_model\spawn_join_basic.uxb:12:25 CALL lexeme=+ ;
    mov rax, qword [rbp-144]
    mov rcx, rax
    sub rsp, 32
    call __uxb_rt_print_cstr
    add rsp, 32
    ; .\tests\task_model\spawn_join_basic.uxb:12:25 CALL lexeme=+ ;
    sub rsp, 32
    call __uxb_rt_print_newline
    add rsp, 32
    ; .\tests\task_model\spawn_join_basic.uxb:12:25 RET lexeme=+ ;
    mov r10, 0
    mov rcx, r10
    sub rsp, 32
    call __uxb_rt_exc_uncaught
    add rsp, 32
    test rax, rax
    jz .Lmir_RET_NO_EXCEPTION_1
    mov rax, 1
    jmp .Lmir_epilogue_MAIN_0
.Lmir_RET_NO_EXCEPTION_1:
    xor rax, rax
    jmp .Lmir_epilogue_MAIN_0
.Lmir_epilogue_MAIN_0:
    mov rbx, rax
    mov rcx, 1
    sub rsp, 32
    call __uxb_rt_task_shutdown
    add rsp, 32
    test rbx, rbx
    cmovnz rax, rbx
    add rsp, 184
    pop rbx
    pop rbp
    ret
.Lmir_divzero_MAIN_0:
    mov rax, 2
    jmp .Lmir_epilogue_MAIN_0
uxb_fn___SLOTLANE_THREAD_WORKER:
    push rbp
    mov rbp, rsp
    push rbx
    ; uxb register discipline: rax=result r10=rhs r11=temp rcx/rdx/r8/r9=call args rbx=saved
    sub rsp, 88
    mov rax, rcx
    movsxd rax, eax
    mov qword [rbp-32], rax
.Lmir_block_0:
    ; .\tests\task_model\spawn_join_basic.uxb:2:1 STORE_VAR lexeme=THREAD ;
    mov rax, qword [rbp-32]
    movsxd rax, eax
    movsxd rax, eax
    mov qword [rbp-16], rax
    ; .\tests\task_model\spawn_join_basic.uxb:3:16 LOAD_CONST lexeme=1 ;
    mov rax, 1
    mov qword [rbp-40], rax
    ; .\tests\task_model\spawn_join_basic.uxb:3:16 ADD lexeme=1 ;
    mov rax, qword [rbp-32]
    movsxd rax, eax
    mov r10, qword [rbp-40]
    add rax, r10
    movsxd rax, eax
    mov qword [rbp-48], rax
    ; .\tests\task_model\spawn_join_basic.uxb:3:14 RET lexeme=+ ;
    mov rax, qword [rbp-48]
    movsxd rax, eax
    jmp .Lmir_epilogue___SLOTLANE_THREAD_WORKER_1
    ; .\tests\task_model\spawn_join_basic.uxb:3:14 RET lexeme=+ ;
    mov r10, 1
    mov rcx, r10
    sub rsp, 32
    call __uxb_rt_exc_uncaught
    add rsp, 32
    test rax, rax
    jz .Lmir_RET_NO_EXCEPTION_2
    mov rax, 1
    jmp .Lmir_epilogue___SLOTLANE_THREAD_WORKER_1
.Lmir_RET_NO_EXCEPTION_2:
    xor rax, rax
    jmp .Lmir_epilogue___SLOTLANE_THREAD_WORKER_1
.Lmir_epilogue___SLOTLANE_THREAD_WORKER_1:
    add rsp, 88
    pop rbx
    pop rbp
    ret
.Lmir_divzero___SLOTLANE_THREAD_WORKER_1:
    mov rax, 2
    jmp .Lmir_epilogue___SLOTLANE_THREAD_WORKER_1
__uxb_task_thunk___SLOTLANE_THREAD_WORKER:
    push rbp
    mov rbp, rsp
    push rbx
    sub rsp, 40
    mov rbx, rcx
    mov rcx, qword [rbx+8]
    call uxb_fn___SLOTLANE_THREAD_WORKER
    mov qword [rbx], rax
    xor eax, eax
    add rsp, 40
    pop rbx
    pop rbp
    ret
