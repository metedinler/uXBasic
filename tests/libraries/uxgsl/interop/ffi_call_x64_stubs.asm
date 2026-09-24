; uXBasic FFI x64 call stub plan
; ABI=WIN64-MSABI STACK=16 SHADOW=32
bits 64

default rel
extern exit
section .text

global __uxb_ffi_stub_1
global __uxb_ffi_symptr_1
__uxb_ffi_stub_1:
    ; line=37 dll=uxcapi.dll symbol=uxcapi_version conv=CDECL
    ; arg_count=0 stack_args=0 reserve=40
    sub rsp, 40
    mov r11, qword [rel __uxb_ffi_symptr_1]
    test r11, r11
    jnz __uxb_ffi_call_1
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_1:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_1: dq 0
section .text

global __uxb_ffi_stub_2
global __uxb_ffi_symptr_2
__uxb_ffi_stub_2:
    ; line=41 dll=uxcapi.dll symbol=uxcapi_last_error conv=CDECL
    ; arg_count=0 stack_args=0 reserve=40
    sub rsp, 40
    mov r11, qword [rel __uxb_ffi_symptr_2]
    test r11, r11
    jnz __uxb_ffi_call_2
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_2:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_2: dq 0
section .text

global __uxb_ffi_stub_3
global __uxb_ffi_symptr_3
__uxb_ffi_stub_3:
    ; line=45 dll=uxcapi.dll symbol=uxcapi_shutdown conv=CDECL
    ; arg_count=0 stack_args=0 reserve=40
    sub rsp, 40
    mov r11, qword [rel __uxb_ffi_symptr_3]
    test r11, r11
    jnz __uxb_ffi_call_3
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_3:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_3: dq 0
section .text

global __uxb_ffi_stub_4
global __uxb_ffi_symptr_4
global __uxb_ffi_arg_4_1
global __uxb_ffi_arg_4_2
__uxb_ffi_stub_4:
    ; line=49 dll=uxcapi.dll symbol=uxcapi_symbol_address conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_4_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_4_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_4]
    test r11, r11
    jnz __uxb_ffi_call_4
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_4:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_4: dq 0
__uxb_ffi_arg_4_1: dq 0
__uxb_ffi_arg_4_2: dq 0
section .text

global __uxb_ffi_stub_5
global __uxb_ffi_symptr_5
__uxb_ffi_stub_5:
    ; line=53 dll=uxcapi.dll symbol=uxcapi_type_struct_new conv=CDECL
    ; arg_count=0 stack_args=0 reserve=40
    sub rsp, 40
    mov r11, qword [rel __uxb_ffi_symptr_5]
    test r11, r11
    jnz __uxb_ffi_call_5
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_5:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_5: dq 0
section .text

global __uxb_ffi_stub_6
global __uxb_ffi_symptr_6
global __uxb_ffi_arg_6_1
global __uxb_ffi_arg_6_2
__uxb_ffi_stub_6:
    ; line=57 dll=uxcapi.dll symbol=uxcapi_type_union_new conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_6_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_6_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_6]
    test r11, r11
    jnz __uxb_ffi_call_6
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_6:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_6: dq 0
__uxb_ffi_arg_6_1: dq 0
__uxb_ffi_arg_6_2: dq 0
section .text

global __uxb_ffi_stub_7
global __uxb_ffi_symptr_7
global __uxb_ffi_arg_7_1
global __uxb_ffi_arg_7_2
__uxb_ffi_stub_7:
    ; line=61 dll=uxcapi.dll symbol=uxcapi_type_add_field conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_7_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_7_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_7]
    test r11, r11
    jnz __uxb_ffi_call_7
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_7:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_7: dq 0
__uxb_ffi_arg_7_1: dq 0
__uxb_ffi_arg_7_2: dq 0
section .text

global __uxb_ffi_stub_8
global __uxb_ffi_symptr_8
global __uxb_ffi_arg_8_1
global __uxb_ffi_arg_8_2
__uxb_ffi_stub_8:
    ; line=65 dll=uxcapi.dll symbol=uxcapi_type_add_struct_field conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_8_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_8_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_8]
    test r11, r11
    jnz __uxb_ffi_call_8
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_8:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_8: dq 0
__uxb_ffi_arg_8_1: dq 0
__uxb_ffi_arg_8_2: dq 0
section .text

global __uxb_ffi_stub_9
global __uxb_ffi_symptr_9
global __uxb_ffi_arg_9_1
global __uxb_ffi_arg_9_2
global __uxb_ffi_arg_9_3
__uxb_ffi_stub_9:
    ; line=69 dll=uxcapi.dll symbol=uxcapi_type_add_array_field conv=CDECL
    ; arg_count=3 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_9_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_9_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_9_3]
    movq xmm2, r8
    mov r11, qword [rel __uxb_ffi_symptr_9]
    test r11, r11
    jnz __uxb_ffi_call_9
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_9:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_9: dq 0
__uxb_ffi_arg_9_1: dq 0
__uxb_ffi_arg_9_2: dq 0
__uxb_ffi_arg_9_3: dq 0
section .text

global __uxb_ffi_stub_10
global __uxb_ffi_symptr_10
global __uxb_ffi_arg_10_1
global __uxb_ffi_arg_10_2
global __uxb_ffi_arg_10_3
__uxb_ffi_stub_10:
    ; line=73 dll=uxcapi.dll symbol=uxcapi_type_add_struct_array_field conv=CDECL
    ; arg_count=3 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_10_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_10_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_10_3]
    movq xmm2, r8
    mov r11, qword [rel __uxb_ffi_symptr_10]
    test r11, r11
    jnz __uxb_ffi_call_10
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_10:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_10: dq 0
__uxb_ffi_arg_10_1: dq 0
__uxb_ffi_arg_10_2: dq 0
__uxb_ffi_arg_10_3: dq 0
section .text

global __uxb_ffi_stub_11
global __uxb_ffi_symptr_11
global __uxb_ffi_arg_11_1
global __uxb_ffi_arg_11_2
global __uxb_ffi_arg_11_3
__uxb_ffi_stub_11:
    ; line=77 dll=uxcapi.dll symbol=uxcapi_type_set_expected_layout conv=CDECL
    ; arg_count=3 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_11_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_11_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_11_3]
    movq xmm2, r8
    mov r11, qword [rel __uxb_ffi_symptr_11]
    test r11, r11
    jnz __uxb_ffi_call_11
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_11:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_11: dq 0
__uxb_ffi_arg_11_1: dq 0
__uxb_ffi_arg_11_2: dq 0
__uxb_ffi_arg_11_3: dq 0
section .text

global __uxb_ffi_stub_12
global __uxb_ffi_symptr_12
global __uxb_ffi_arg_12_1
__uxb_ffi_stub_12:
    ; line=81 dll=uxcapi.dll symbol=uxcapi_type_finalize conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_12_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_12]
    test r11, r11
    jnz __uxb_ffi_call_12
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_12:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_12: dq 0
__uxb_ffi_arg_12_1: dq 0
section .text

global __uxb_ffi_stub_13
global __uxb_ffi_symptr_13
global __uxb_ffi_arg_13_1
__uxb_ffi_stub_13:
    ; line=85 dll=uxcapi.dll symbol=uxcapi_type_kind conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_13_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_13]
    test r11, r11
    jnz __uxb_ffi_call_13
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_13:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_13: dq 0
__uxb_ffi_arg_13_1: dq 0
section .text

global __uxb_ffi_stub_14
global __uxb_ffi_symptr_14
global __uxb_ffi_arg_14_1
__uxb_ffi_stub_14:
    ; line=89 dll=uxcapi.dll symbol=uxcapi_type_size conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_14_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_14]
    test r11, r11
    jnz __uxb_ffi_call_14
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_14:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_14: dq 0
__uxb_ffi_arg_14_1: dq 0
section .text

global __uxb_ffi_stub_15
global __uxb_ffi_symptr_15
global __uxb_ffi_arg_15_1
__uxb_ffi_stub_15:
    ; line=93 dll=uxcapi.dll symbol=uxcapi_type_alignment conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_15_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_15]
    test r11, r11
    jnz __uxb_ffi_call_15
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_15:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_15: dq 0
__uxb_ffi_arg_15_1: dq 0
section .text

global __uxb_ffi_stub_16
global __uxb_ffi_symptr_16
global __uxb_ffi_arg_16_1
__uxb_ffi_stub_16:
    ; line=97 dll=uxcapi.dll symbol=uxcapi_type_free conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_16_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_16]
    test r11, r11
    jnz __uxb_ffi_call_16
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_16:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_16: dq 0
__uxb_ffi_arg_16_1: dq 0
section .text

global __uxb_ffi_stub_17
global __uxb_ffi_symptr_17
global __uxb_ffi_arg_17_1
global __uxb_ffi_arg_17_2
global __uxb_ffi_arg_17_3
global __uxb_ffi_arg_17_4
global __uxb_ffi_arg_17_5
__uxb_ffi_stub_17:
    ; line=101 dll=uxcapi.dll symbol=uxcapi_call_new conv=CDECL
    ; arg_count=5 stack_args=1 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_17_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_17_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_17_3]
    movq xmm2, r8
    mov r9, qword [rel __uxb_ffi_arg_17_4]
    movq xmm3, r9
    mov rax, qword [rel __uxb_ffi_arg_17_5]
    mov qword [rsp+32], rax
    mov r11, qword [rel __uxb_ffi_symptr_17]
    test r11, r11
    jnz __uxb_ffi_call_17
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_17:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_17: dq 0
__uxb_ffi_arg_17_1: dq 0
__uxb_ffi_arg_17_2: dq 0
__uxb_ffi_arg_17_3: dq 0
__uxb_ffi_arg_17_4: dq 0
__uxb_ffi_arg_17_5: dq 0
section .text

global __uxb_ffi_stub_18
global __uxb_ffi_symptr_18
global __uxb_ffi_arg_18_1
__uxb_ffi_stub_18:
    ; line=105 dll=uxcapi.dll symbol=uxcapi_call_free conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_18_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_18]
    test r11, r11
    jnz __uxb_ffi_call_18
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_18:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_18: dq 0
__uxb_ffi_arg_18_1: dq 0
section .text

global __uxb_ffi_stub_19
global __uxb_ffi_symptr_19
global __uxb_ffi_arg_19_1
__uxb_ffi_stub_19:
    ; line=109 dll=uxcapi.dll symbol=uxcapi_call_clear_arguments conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_19_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_19]
    test r11, r11
    jnz __uxb_ffi_call_19
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_19:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_19: dq 0
__uxb_ffi_arg_19_1: dq 0
section .text

global __uxb_ffi_stub_20
global __uxb_ffi_symptr_20
global __uxb_ffi_arg_20_1
global __uxb_ffi_arg_20_2
__uxb_ffi_stub_20:
    ; line=113 dll=uxcapi.dll symbol=uxcapi_call_set_return_struct conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_20_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_20_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_20]
    test r11, r11
    jnz __uxb_ffi_call_20
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_20:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_20: dq 0
__uxb_ffi_arg_20_1: dq 0
__uxb_ffi_arg_20_2: dq 0
section .text

global __uxb_ffi_stub_21
global __uxb_ffi_symptr_21
global __uxb_ffi_arg_21_1
global __uxb_ffi_arg_21_2
__uxb_ffi_stub_21:
    ; line=117 dll=uxcapi.dll symbol=uxcapi_call_arg_i8 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_21_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_21_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_21]
    test r11, r11
    jnz __uxb_ffi_call_21
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_21:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_21: dq 0
__uxb_ffi_arg_21_1: dq 0
__uxb_ffi_arg_21_2: dq 0
section .text

global __uxb_ffi_stub_22
global __uxb_ffi_symptr_22
global __uxb_ffi_arg_22_1
global __uxb_ffi_arg_22_2
__uxb_ffi_stub_22:
    ; line=120 dll=uxcapi.dll symbol=uxcapi_call_arg_u8 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_22_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_22_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_22]
    test r11, r11
    jnz __uxb_ffi_call_22
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_22:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_22: dq 0
__uxb_ffi_arg_22_1: dq 0
__uxb_ffi_arg_22_2: dq 0
section .text

global __uxb_ffi_stub_23
global __uxb_ffi_symptr_23
global __uxb_ffi_arg_23_1
global __uxb_ffi_arg_23_2
__uxb_ffi_stub_23:
    ; line=123 dll=uxcapi.dll symbol=uxcapi_call_arg_i16 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_23_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_23_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_23]
    test r11, r11
    jnz __uxb_ffi_call_23
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_23:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_23: dq 0
__uxb_ffi_arg_23_1: dq 0
__uxb_ffi_arg_23_2: dq 0
section .text

global __uxb_ffi_stub_24
global __uxb_ffi_symptr_24
global __uxb_ffi_arg_24_1
global __uxb_ffi_arg_24_2
__uxb_ffi_stub_24:
    ; line=126 dll=uxcapi.dll symbol=uxcapi_call_arg_u16 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_24_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_24_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_24]
    test r11, r11
    jnz __uxb_ffi_call_24
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_24:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_24: dq 0
__uxb_ffi_arg_24_1: dq 0
__uxb_ffi_arg_24_2: dq 0
section .text

global __uxb_ffi_stub_25
global __uxb_ffi_symptr_25
global __uxb_ffi_arg_25_1
global __uxb_ffi_arg_25_2
__uxb_ffi_stub_25:
    ; line=129 dll=uxcapi.dll symbol=uxcapi_call_arg_i32 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_25_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_25_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_25]
    test r11, r11
    jnz __uxb_ffi_call_25
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_25:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_25: dq 0
__uxb_ffi_arg_25_1: dq 0
__uxb_ffi_arg_25_2: dq 0
section .text

global __uxb_ffi_stub_26
global __uxb_ffi_symptr_26
global __uxb_ffi_arg_26_1
global __uxb_ffi_arg_26_2
__uxb_ffi_stub_26:
    ; line=132 dll=uxcapi.dll symbol=uxcapi_call_arg_u32 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_26_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_26_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_26]
    test r11, r11
    jnz __uxb_ffi_call_26
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_26:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_26: dq 0
__uxb_ffi_arg_26_1: dq 0
__uxb_ffi_arg_26_2: dq 0
section .text

global __uxb_ffi_stub_27
global __uxb_ffi_symptr_27
global __uxb_ffi_arg_27_1
global __uxb_ffi_arg_27_2
__uxb_ffi_stub_27:
    ; line=135 dll=uxcapi.dll symbol=uxcapi_call_arg_i64 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_27_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_27_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_27]
    test r11, r11
    jnz __uxb_ffi_call_27
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_27:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_27: dq 0
__uxb_ffi_arg_27_1: dq 0
__uxb_ffi_arg_27_2: dq 0
section .text

global __uxb_ffi_stub_28
global __uxb_ffi_symptr_28
global __uxb_ffi_arg_28_1
global __uxb_ffi_arg_28_2
__uxb_ffi_stub_28:
    ; line=138 dll=uxcapi.dll symbol=uxcapi_call_arg_u64 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_28_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_28_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_28]
    test r11, r11
    jnz __uxb_ffi_call_28
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_28:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_28: dq 0
__uxb_ffi_arg_28_1: dq 0
__uxb_ffi_arg_28_2: dq 0
section .text

global __uxb_ffi_stub_29
global __uxb_ffi_symptr_29
global __uxb_ffi_arg_29_1
global __uxb_ffi_arg_29_2
__uxb_ffi_stub_29:
    ; line=141 dll=uxcapi.dll symbol=uxcapi_call_arg_f32 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_29_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_29_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_29]
    test r11, r11
    jnz __uxb_ffi_call_29
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_29:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_29: dq 0
__uxb_ffi_arg_29_1: dq 0
__uxb_ffi_arg_29_2: dq 0
section .text

global __uxb_ffi_stub_30
global __uxb_ffi_symptr_30
global __uxb_ffi_arg_30_1
global __uxb_ffi_arg_30_2
__uxb_ffi_stub_30:
    ; line=144 dll=uxcapi.dll symbol=uxcapi_call_arg_f64 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_30_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_30_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_30]
    test r11, r11
    jnz __uxb_ffi_call_30
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_30:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_30: dq 0
__uxb_ffi_arg_30_1: dq 0
__uxb_ffi_arg_30_2: dq 0
section .text

global __uxb_ffi_stub_31
global __uxb_ffi_symptr_31
global __uxb_ffi_arg_31_1
global __uxb_ffi_arg_31_2
global __uxb_ffi_arg_31_3
global __uxb_ffi_arg_31_4
__uxb_ffi_stub_31:
    ; line=147 dll=uxcapi.dll symbol=uxcapi_call_arg_struct conv=CDECL
    ; arg_count=4 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_31_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_31_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_31_3]
    movq xmm2, r8
    mov r9, qword [rel __uxb_ffi_arg_31_4]
    movq xmm3, r9
    mov r11, qword [rel __uxb_ffi_symptr_31]
    test r11, r11
    jnz __uxb_ffi_call_31
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_31:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_31: dq 0
__uxb_ffi_arg_31_1: dq 0
__uxb_ffi_arg_31_2: dq 0
__uxb_ffi_arg_31_3: dq 0
__uxb_ffi_arg_31_4: dq 0
section .text

global __uxb_ffi_stub_32
global __uxb_ffi_symptr_32
global __uxb_ffi_arg_32_1
global __uxb_ffi_arg_32_2
__uxb_ffi_stub_32:
    ; line=151 dll=uxcapi.dll symbol=uxcapi_call_arg_ptr conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_32_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_32_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_32]
    test r11, r11
    jnz __uxb_ffi_call_32
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_32:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_32: dq 0
__uxb_ffi_arg_32_1: dq 0
__uxb_ffi_arg_32_2: dq 0
section .text

global __uxb_ffi_stub_33
global __uxb_ffi_symptr_33
global __uxb_ffi_arg_33_1
global __uxb_ffi_arg_33_2
__uxb_ffi_stub_33:
    ; line=154 dll=uxcapi.dll symbol=uxcapi_call_arg_string conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_33_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_33_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_33]
    test r11, r11
    jnz __uxb_ffi_call_33
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_33:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_33: dq 0
__uxb_ffi_arg_33_1: dq 0
__uxb_ffi_arg_33_2: dq 0
section .text

global __uxb_ffi_stub_34
global __uxb_ffi_symptr_34
global __uxb_ffi_arg_34_1
global __uxb_ffi_arg_34_2
__uxb_ffi_stub_34:
    ; line=157 dll=uxcapi.dll symbol=uxcapi_call_arg_wstring_utf8 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_34_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_34_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_34]
    test r11, r11
    jnz __uxb_ffi_call_34
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_34:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_34: dq 0
__uxb_ffi_arg_34_1: dq 0
__uxb_ffi_arg_34_2: dq 0
section .text

global __uxb_ffi_stub_35
global __uxb_ffi_symptr_35
global __uxb_ffi_arg_35_1
global __uxb_ffi_arg_35_2
__uxb_ffi_stub_35:
    ; line=160 dll=uxcapi.dll symbol=uxcapi_call_arg_long_double_from_f64 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_35_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_35_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_35]
    test r11, r11
    jnz __uxb_ffi_call_35
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_35:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_35: dq 0
__uxb_ffi_arg_35_1: dq 0
__uxb_ffi_arg_35_2: dq 0
section .text

global __uxb_ffi_stub_36
global __uxb_ffi_symptr_36
global __uxb_ffi_arg_36_1
global __uxb_ffi_arg_36_2
__uxb_ffi_stub_36:
    ; line=164 dll=uxcapi.dll symbol=uxcapi_call_append_args conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_36_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_36_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_36]
    test r11, r11
    jnz __uxb_ffi_call_36
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_36:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_36: dq 0
__uxb_ffi_arg_36_1: dq 0
__uxb_ffi_arg_36_2: dq 0
section .text

global __uxb_ffi_stub_37
global __uxb_ffi_symptr_37
global __uxb_ffi_arg_37_1
__uxb_ffi_stub_37:
    ; line=168 dll=uxcapi.dll symbol=uxcapi_call_invoke conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_37_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_37]
    test r11, r11
    jnz __uxb_ffi_call_37
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_37:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_37: dq 0
__uxb_ffi_arg_37_1: dq 0
section .text

global __uxb_ffi_stub_38
global __uxb_ffi_symptr_38
global __uxb_ffi_arg_38_1
__uxb_ffi_stub_38:
    ; line=172 dll=uxcapi.dll symbol=uxcapi_result_i32 conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_38_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_38]
    test r11, r11
    jnz __uxb_ffi_call_38
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_38:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_38: dq 0
__uxb_ffi_arg_38_1: dq 0
section .text

global __uxb_ffi_stub_39
global __uxb_ffi_symptr_39
global __uxb_ffi_arg_39_1
__uxb_ffi_stub_39:
    ; line=175 dll=uxcapi.dll symbol=uxcapi_result_u32 conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_39_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_39]
    test r11, r11
    jnz __uxb_ffi_call_39
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_39:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_39: dq 0
__uxb_ffi_arg_39_1: dq 0
section .text

global __uxb_ffi_stub_40
global __uxb_ffi_symptr_40
global __uxb_ffi_arg_40_1
__uxb_ffi_stub_40:
    ; line=178 dll=uxcapi.dll symbol=uxcapi_result_i64 conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_40_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_40]
    test r11, r11
    jnz __uxb_ffi_call_40
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_40:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_40: dq 0
__uxb_ffi_arg_40_1: dq 0
section .text

global __uxb_ffi_stub_41
global __uxb_ffi_symptr_41
global __uxb_ffi_arg_41_1
__uxb_ffi_stub_41:
    ; line=181 dll=uxcapi.dll symbol=uxcapi_result_u64 conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_41_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_41]
    test r11, r11
    jnz __uxb_ffi_call_41
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_41:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_41: dq 0
__uxb_ffi_arg_41_1: dq 0
section .text

global __uxb_ffi_stub_42
global __uxb_ffi_symptr_42
global __uxb_ffi_arg_42_1
__uxb_ffi_stub_42:
    ; line=184 dll=uxcapi.dll symbol=uxcapi_result_f64 conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_42_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_42]
    test r11, r11
    jnz __uxb_ffi_call_42
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_42:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_42: dq 0
__uxb_ffi_arg_42_1: dq 0
section .text

global __uxb_ffi_stub_43
global __uxb_ffi_symptr_43
global __uxb_ffi_arg_43_1
__uxb_ffi_stub_43:
    ; line=187 dll=uxcapi.dll symbol=uxcapi_result_ptr conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_43_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_43]
    test r11, r11
    jnz __uxb_ffi_call_43
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_43:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_43: dq 0
__uxb_ffi_arg_43_1: dq 0
section .text

global __uxb_ffi_stub_44
global __uxb_ffi_symptr_44
global __uxb_ffi_arg_44_1
__uxb_ffi_stub_44:
    ; line=190 dll=uxcapi.dll symbol=uxcapi_result_string conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_44_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_44]
    test r11, r11
    jnz __uxb_ffi_call_44
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_44:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_44: dq 0
__uxb_ffi_arg_44_1: dq 0
section .text

global __uxb_ffi_stub_45
global __uxb_ffi_symptr_45
global __uxb_ffi_arg_45_1
__uxb_ffi_stub_45:
    ; line=193 dll=uxcapi.dll symbol=uxcapi_result_struct_size conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_45_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_45]
    test r11, r11
    jnz __uxb_ffi_call_45
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_45:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_45: dq 0
__uxb_ffi_arg_45_1: dq 0
section .text

global __uxb_ffi_stub_46
global __uxb_ffi_symptr_46
global __uxb_ffi_arg_46_1
global __uxb_ffi_arg_46_2
global __uxb_ffi_arg_46_3
__uxb_ffi_stub_46:
    ; line=197 dll=uxcapi.dll symbol=uxcapi_result_struct_copy conv=CDECL
    ; arg_count=3 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_46_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_46_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_46_3]
    movq xmm2, r8
    mov r11, qword [rel __uxb_ffi_symptr_46]
    test r11, r11
    jnz __uxb_ffi_call_46
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_46:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_46: dq 0
__uxb_ffi_arg_46_1: dq 0
__uxb_ffi_arg_46_2: dq 0
__uxb_ffi_arg_46_3: dq 0
section .text

global __uxb_ffi_stub_47
global __uxb_ffi_symptr_47
global __uxb_ffi_arg_47_1
__uxb_ffi_stub_47:
    ; line=201 dll=uxcapi.dll symbol=uxcapi_call_error conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_47_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_47]
    test r11, r11
    jnz __uxb_ffi_call_47
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_47:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_47: dq 0
__uxb_ffi_arg_47_1: dq 0
section .text

global __uxb_ffi_stub_48
global __uxb_ffi_symptr_48
__uxb_ffi_stub_48:
    ; line=205 dll=uxcapi.dll symbol=uxcapi_args_new conv=CDECL
    ; arg_count=0 stack_args=0 reserve=40
    sub rsp, 40
    mov r11, qword [rel __uxb_ffi_symptr_48]
    test r11, r11
    jnz __uxb_ffi_call_48
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_48:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_48: dq 0
section .text

global __uxb_ffi_stub_49
global __uxb_ffi_symptr_49
global __uxb_ffi_arg_49_1
__uxb_ffi_stub_49:
    ; line=208 dll=uxcapi.dll symbol=uxcapi_args_free conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_49_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_49]
    test r11, r11
    jnz __uxb_ffi_call_49
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_49:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_49: dq 0
__uxb_ffi_arg_49_1: dq 0
section .text

global __uxb_ffi_stub_50
global __uxb_ffi_symptr_50
global __uxb_ffi_arg_50_1
__uxb_ffi_stub_50:
    ; line=211 dll=uxcapi.dll symbol=uxcapi_args_clear conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_50_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_50]
    test r11, r11
    jnz __uxb_ffi_call_50
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_50:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_50: dq 0
__uxb_ffi_arg_50_1: dq 0
section .text

global __uxb_ffi_stub_51
global __uxb_ffi_symptr_51
global __uxb_ffi_arg_51_1
global __uxb_ffi_arg_51_2
__uxb_ffi_stub_51:
    ; line=214 dll=uxcapi.dll symbol=uxcapi_args_add_i8 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_51_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_51_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_51]
    test r11, r11
    jnz __uxb_ffi_call_51
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_51:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_51: dq 0
__uxb_ffi_arg_51_1: dq 0
__uxb_ffi_arg_51_2: dq 0
section .text

global __uxb_ffi_stub_52
global __uxb_ffi_symptr_52
global __uxb_ffi_arg_52_1
global __uxb_ffi_arg_52_2
__uxb_ffi_stub_52:
    ; line=217 dll=uxcapi.dll symbol=uxcapi_args_add_u8 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_52_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_52_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_52]
    test r11, r11
    jnz __uxb_ffi_call_52
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_52:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_52: dq 0
__uxb_ffi_arg_52_1: dq 0
__uxb_ffi_arg_52_2: dq 0
section .text

global __uxb_ffi_stub_53
global __uxb_ffi_symptr_53
global __uxb_ffi_arg_53_1
global __uxb_ffi_arg_53_2
__uxb_ffi_stub_53:
    ; line=220 dll=uxcapi.dll symbol=uxcapi_args_add_i16 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_53_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_53_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_53]
    test r11, r11
    jnz __uxb_ffi_call_53
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_53:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_53: dq 0
__uxb_ffi_arg_53_1: dq 0
__uxb_ffi_arg_53_2: dq 0
section .text

global __uxb_ffi_stub_54
global __uxb_ffi_symptr_54
global __uxb_ffi_arg_54_1
global __uxb_ffi_arg_54_2
__uxb_ffi_stub_54:
    ; line=223 dll=uxcapi.dll symbol=uxcapi_args_add_u16 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_54_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_54_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_54]
    test r11, r11
    jnz __uxb_ffi_call_54
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_54:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_54: dq 0
__uxb_ffi_arg_54_1: dq 0
__uxb_ffi_arg_54_2: dq 0
section .text

global __uxb_ffi_stub_55
global __uxb_ffi_symptr_55
global __uxb_ffi_arg_55_1
global __uxb_ffi_arg_55_2
__uxb_ffi_stub_55:
    ; line=226 dll=uxcapi.dll symbol=uxcapi_args_add_i32 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_55_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_55_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_55]
    test r11, r11
    jnz __uxb_ffi_call_55
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_55:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_55: dq 0
__uxb_ffi_arg_55_1: dq 0
__uxb_ffi_arg_55_2: dq 0
section .text

global __uxb_ffi_stub_56
global __uxb_ffi_symptr_56
global __uxb_ffi_arg_56_1
global __uxb_ffi_arg_56_2
__uxb_ffi_stub_56:
    ; line=229 dll=uxcapi.dll symbol=uxcapi_args_add_u32 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_56_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_56_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_56]
    test r11, r11
    jnz __uxb_ffi_call_56
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_56:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_56: dq 0
__uxb_ffi_arg_56_1: dq 0
__uxb_ffi_arg_56_2: dq 0
section .text

global __uxb_ffi_stub_57
global __uxb_ffi_symptr_57
global __uxb_ffi_arg_57_1
global __uxb_ffi_arg_57_2
__uxb_ffi_stub_57:
    ; line=232 dll=uxcapi.dll symbol=uxcapi_args_add_i64 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_57_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_57_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_57]
    test r11, r11
    jnz __uxb_ffi_call_57
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_57:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_57: dq 0
__uxb_ffi_arg_57_1: dq 0
__uxb_ffi_arg_57_2: dq 0
section .text

global __uxb_ffi_stub_58
global __uxb_ffi_symptr_58
global __uxb_ffi_arg_58_1
global __uxb_ffi_arg_58_2
__uxb_ffi_stub_58:
    ; line=235 dll=uxcapi.dll symbol=uxcapi_args_add_u64 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_58_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_58_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_58]
    test r11, r11
    jnz __uxb_ffi_call_58
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_58:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_58: dq 0
__uxb_ffi_arg_58_1: dq 0
__uxb_ffi_arg_58_2: dq 0
section .text

global __uxb_ffi_stub_59
global __uxb_ffi_symptr_59
global __uxb_ffi_arg_59_1
global __uxb_ffi_arg_59_2
__uxb_ffi_stub_59:
    ; line=238 dll=uxcapi.dll symbol=uxcapi_args_add_f32 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_59_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_59_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_59]
    test r11, r11
    jnz __uxb_ffi_call_59
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_59:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_59: dq 0
__uxb_ffi_arg_59_1: dq 0
__uxb_ffi_arg_59_2: dq 0
section .text

global __uxb_ffi_stub_60
global __uxb_ffi_symptr_60
global __uxb_ffi_arg_60_1
global __uxb_ffi_arg_60_2
__uxb_ffi_stub_60:
    ; line=241 dll=uxcapi.dll symbol=uxcapi_args_add_f64 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_60_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_60_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_60]
    test r11, r11
    jnz __uxb_ffi_call_60
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_60:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_60: dq 0
__uxb_ffi_arg_60_1: dq 0
__uxb_ffi_arg_60_2: dq 0
section .text

global __uxb_ffi_stub_61
global __uxb_ffi_symptr_61
global __uxb_ffi_arg_61_1
global __uxb_ffi_arg_61_2
__uxb_ffi_stub_61:
    ; line=244 dll=uxcapi.dll symbol=uxcapi_args_add_ptr conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_61_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_61_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_61]
    test r11, r11
    jnz __uxb_ffi_call_61
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_61:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_61: dq 0
__uxb_ffi_arg_61_1: dq 0
__uxb_ffi_arg_61_2: dq 0
section .text

global __uxb_ffi_stub_62
global __uxb_ffi_symptr_62
global __uxb_ffi_arg_62_1
global __uxb_ffi_arg_62_2
__uxb_ffi_stub_62:
    ; line=247 dll=uxcapi.dll symbol=uxcapi_args_add_string conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_62_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_62_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_62]
    test r11, r11
    jnz __uxb_ffi_call_62
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_62:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_62: dq 0
__uxb_ffi_arg_62_1: dq 0
__uxb_ffi_arg_62_2: dq 0
section .text

global __uxb_ffi_stub_63
global __uxb_ffi_symptr_63
global __uxb_ffi_arg_63_1
global __uxb_ffi_arg_63_2
__uxb_ffi_stub_63:
    ; line=250 dll=uxcapi.dll symbol=uxcapi_args_add_wstring_utf8 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_63_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_63_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_63]
    test r11, r11
    jnz __uxb_ffi_call_63
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_63:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_63: dq 0
__uxb_ffi_arg_63_1: dq 0
__uxb_ffi_arg_63_2: dq 0
section .text

global __uxb_ffi_stub_64
global __uxb_ffi_symptr_64
global __uxb_ffi_arg_64_1
global __uxb_ffi_arg_64_2
__uxb_ffi_stub_64:
    ; line=253 dll=uxcapi.dll symbol=uxcapi_args_add_long_double_from_f64 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_64_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_64_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_64]
    test r11, r11
    jnz __uxb_ffi_call_64
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_64:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_64: dq 0
__uxb_ffi_arg_64_1: dq 0
__uxb_ffi_arg_64_2: dq 0
section .text

global __uxb_ffi_stub_65
global __uxb_ffi_symptr_65
global __uxb_ffi_arg_65_1
global __uxb_ffi_arg_65_2
global __uxb_ffi_arg_65_3
global __uxb_ffi_arg_65_4
__uxb_ffi_stub_65:
    ; line=257 dll=uxcapi.dll symbol=uxcapi_args_add_struct conv=CDECL
    ; arg_count=4 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_65_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_65_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_65_3]
    movq xmm2, r8
    mov r9, qword [rel __uxb_ffi_arg_65_4]
    movq xmm3, r9
    mov r11, qword [rel __uxb_ffi_symptr_65]
    test r11, r11
    jnz __uxb_ffi_call_65
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_65:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_65: dq 0
__uxb_ffi_arg_65_1: dq 0
__uxb_ffi_arg_65_2: dq 0
__uxb_ffi_arg_65_3: dq 0
__uxb_ffi_arg_65_4: dq 0
section .text

global __uxb_ffi_stub_66
global __uxb_ffi_symptr_66
global __uxb_ffi_arg_66_1
__uxb_ffi_stub_66:
    ; line=261 dll=uxcapi.dll symbol=uxcapi_memory_alloc conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_66_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_66]
    test r11, r11
    jnz __uxb_ffi_call_66
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_66:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_66: dq 0
__uxb_ffi_arg_66_1: dq 0
section .text

global __uxb_ffi_stub_67
global __uxb_ffi_symptr_67
global __uxb_ffi_arg_67_1
global __uxb_ffi_arg_67_2
__uxb_ffi_stub_67:
    ; line=264 dll=uxcapi.dll symbol=uxcapi_memory_calloc conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_67_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_67_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_67]
    test r11, r11
    jnz __uxb_ffi_call_67
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_67:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_67: dq 0
__uxb_ffi_arg_67_1: dq 0
__uxb_ffi_arg_67_2: dq 0
section .text

global __uxb_ffi_stub_68
global __uxb_ffi_symptr_68
global __uxb_ffi_arg_68_1
global __uxb_ffi_arg_68_2
__uxb_ffi_stub_68:
    ; line=267 dll=uxcapi.dll symbol=uxcapi_memory_realloc conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_68_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_68_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_68]
    test r11, r11
    jnz __uxb_ffi_call_68
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_68:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_68: dq 0
__uxb_ffi_arg_68_1: dq 0
__uxb_ffi_arg_68_2: dq 0
section .text

global __uxb_ffi_stub_69
global __uxb_ffi_symptr_69
global __uxb_ffi_arg_69_1
__uxb_ffi_stub_69:
    ; line=270 dll=uxcapi.dll symbol=uxcapi_memory_free conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_69_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_69]
    test r11, r11
    jnz __uxb_ffi_call_69
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_69:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_69: dq 0
__uxb_ffi_arg_69_1: dq 0
section .text

global __uxb_ffi_stub_70
global __uxb_ffi_symptr_70
global __uxb_ffi_arg_70_1
global __uxb_ffi_arg_70_2
__uxb_ffi_stub_70:
    ; line=273 dll=uxcapi.dll symbol=uxcapi_memory_zero conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_70_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_70_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_70]
    test r11, r11
    jnz __uxb_ffi_call_70
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_70:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_70: dq 0
__uxb_ffi_arg_70_1: dq 0
__uxb_ffi_arg_70_2: dq 0
section .text

global __uxb_ffi_stub_71
global __uxb_ffi_symptr_71
global __uxb_ffi_arg_71_1
global __uxb_ffi_arg_71_2
global __uxb_ffi_arg_71_3
__uxb_ffi_stub_71:
    ; line=276 dll=uxcapi.dll symbol=uxcapi_memory_copy conv=CDECL
    ; arg_count=3 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_71_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_71_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_71_3]
    movq xmm2, r8
    mov r11, qword [rel __uxb_ffi_symptr_71]
    test r11, r11
    jnz __uxb_ffi_call_71
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_71:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_71: dq 0
__uxb_ffi_arg_71_1: dq 0
__uxb_ffi_arg_71_2: dq 0
__uxb_ffi_arg_71_3: dq 0
section .text

global __uxb_ffi_stub_72
global __uxb_ffi_symptr_72
global __uxb_ffi_arg_72_1
global __uxb_ffi_arg_72_2
global __uxb_ffi_arg_72_3
__uxb_ffi_stub_72:
    ; line=280 dll=uxcapi.dll symbol=uxcapi_memory_write_i8 conv=CDECL
    ; arg_count=3 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_72_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_72_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_72_3]
    movq xmm2, r8
    mov r11, qword [rel __uxb_ffi_symptr_72]
    test r11, r11
    jnz __uxb_ffi_call_72
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_72:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_72: dq 0
__uxb_ffi_arg_72_1: dq 0
__uxb_ffi_arg_72_2: dq 0
__uxb_ffi_arg_72_3: dq 0
section .text

global __uxb_ffi_stub_73
global __uxb_ffi_symptr_73
global __uxb_ffi_arg_73_1
global __uxb_ffi_arg_73_2
global __uxb_ffi_arg_73_3
__uxb_ffi_stub_73:
    ; line=283 dll=uxcapi.dll symbol=uxcapi_memory_write_u8 conv=CDECL
    ; arg_count=3 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_73_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_73_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_73_3]
    movq xmm2, r8
    mov r11, qword [rel __uxb_ffi_symptr_73]
    test r11, r11
    jnz __uxb_ffi_call_73
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_73:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_73: dq 0
__uxb_ffi_arg_73_1: dq 0
__uxb_ffi_arg_73_2: dq 0
__uxb_ffi_arg_73_3: dq 0
section .text

global __uxb_ffi_stub_74
global __uxb_ffi_symptr_74
global __uxb_ffi_arg_74_1
global __uxb_ffi_arg_74_2
global __uxb_ffi_arg_74_3
__uxb_ffi_stub_74:
    ; line=286 dll=uxcapi.dll symbol=uxcapi_memory_write_i16 conv=CDECL
    ; arg_count=3 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_74_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_74_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_74_3]
    movq xmm2, r8
    mov r11, qword [rel __uxb_ffi_symptr_74]
    test r11, r11
    jnz __uxb_ffi_call_74
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_74:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_74: dq 0
__uxb_ffi_arg_74_1: dq 0
__uxb_ffi_arg_74_2: dq 0
__uxb_ffi_arg_74_3: dq 0
section .text

global __uxb_ffi_stub_75
global __uxb_ffi_symptr_75
global __uxb_ffi_arg_75_1
global __uxb_ffi_arg_75_2
global __uxb_ffi_arg_75_3
__uxb_ffi_stub_75:
    ; line=289 dll=uxcapi.dll symbol=uxcapi_memory_write_u16 conv=CDECL
    ; arg_count=3 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_75_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_75_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_75_3]
    movq xmm2, r8
    mov r11, qword [rel __uxb_ffi_symptr_75]
    test r11, r11
    jnz __uxb_ffi_call_75
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_75:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_75: dq 0
__uxb_ffi_arg_75_1: dq 0
__uxb_ffi_arg_75_2: dq 0
__uxb_ffi_arg_75_3: dq 0
section .text

global __uxb_ffi_stub_76
global __uxb_ffi_symptr_76
global __uxb_ffi_arg_76_1
global __uxb_ffi_arg_76_2
global __uxb_ffi_arg_76_3
__uxb_ffi_stub_76:
    ; line=292 dll=uxcapi.dll symbol=uxcapi_memory_write_i32 conv=CDECL
    ; arg_count=3 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_76_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_76_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_76_3]
    movq xmm2, r8
    mov r11, qword [rel __uxb_ffi_symptr_76]
    test r11, r11
    jnz __uxb_ffi_call_76
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_76:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_76: dq 0
__uxb_ffi_arg_76_1: dq 0
__uxb_ffi_arg_76_2: dq 0
__uxb_ffi_arg_76_3: dq 0
section .text

global __uxb_ffi_stub_77
global __uxb_ffi_symptr_77
global __uxb_ffi_arg_77_1
global __uxb_ffi_arg_77_2
global __uxb_ffi_arg_77_3
__uxb_ffi_stub_77:
    ; line=295 dll=uxcapi.dll symbol=uxcapi_memory_write_u32 conv=CDECL
    ; arg_count=3 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_77_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_77_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_77_3]
    movq xmm2, r8
    mov r11, qword [rel __uxb_ffi_symptr_77]
    test r11, r11
    jnz __uxb_ffi_call_77
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_77:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_77: dq 0
__uxb_ffi_arg_77_1: dq 0
__uxb_ffi_arg_77_2: dq 0
__uxb_ffi_arg_77_3: dq 0
section .text

global __uxb_ffi_stub_78
global __uxb_ffi_symptr_78
global __uxb_ffi_arg_78_1
global __uxb_ffi_arg_78_2
global __uxb_ffi_arg_78_3
__uxb_ffi_stub_78:
    ; line=298 dll=uxcapi.dll symbol=uxcapi_memory_write_i64 conv=CDECL
    ; arg_count=3 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_78_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_78_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_78_3]
    movq xmm2, r8
    mov r11, qword [rel __uxb_ffi_symptr_78]
    test r11, r11
    jnz __uxb_ffi_call_78
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_78:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_78: dq 0
__uxb_ffi_arg_78_1: dq 0
__uxb_ffi_arg_78_2: dq 0
__uxb_ffi_arg_78_3: dq 0
section .text

global __uxb_ffi_stub_79
global __uxb_ffi_symptr_79
global __uxb_ffi_arg_79_1
global __uxb_ffi_arg_79_2
global __uxb_ffi_arg_79_3
__uxb_ffi_stub_79:
    ; line=301 dll=uxcapi.dll symbol=uxcapi_memory_write_u64 conv=CDECL
    ; arg_count=3 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_79_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_79_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_79_3]
    movq xmm2, r8
    mov r11, qword [rel __uxb_ffi_symptr_79]
    test r11, r11
    jnz __uxb_ffi_call_79
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_79:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_79: dq 0
__uxb_ffi_arg_79_1: dq 0
__uxb_ffi_arg_79_2: dq 0
__uxb_ffi_arg_79_3: dq 0
section .text

global __uxb_ffi_stub_80
global __uxb_ffi_symptr_80
global __uxb_ffi_arg_80_1
global __uxb_ffi_arg_80_2
global __uxb_ffi_arg_80_3
__uxb_ffi_stub_80:
    ; line=304 dll=uxcapi.dll symbol=uxcapi_memory_write_f32 conv=CDECL
    ; arg_count=3 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_80_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_80_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_80_3]
    movq xmm2, r8
    mov r11, qword [rel __uxb_ffi_symptr_80]
    test r11, r11
    jnz __uxb_ffi_call_80
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_80:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_80: dq 0
__uxb_ffi_arg_80_1: dq 0
__uxb_ffi_arg_80_2: dq 0
__uxb_ffi_arg_80_3: dq 0
section .text

global __uxb_ffi_stub_81
global __uxb_ffi_symptr_81
global __uxb_ffi_arg_81_1
global __uxb_ffi_arg_81_2
global __uxb_ffi_arg_81_3
__uxb_ffi_stub_81:
    ; line=307 dll=uxcapi.dll symbol=uxcapi_memory_write_f64 conv=CDECL
    ; arg_count=3 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_81_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_81_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_81_3]
    movq xmm2, r8
    mov r11, qword [rel __uxb_ffi_symptr_81]
    test r11, r11
    jnz __uxb_ffi_call_81
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_81:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_81: dq 0
__uxb_ffi_arg_81_1: dq 0
__uxb_ffi_arg_81_2: dq 0
__uxb_ffi_arg_81_3: dq 0
section .text

global __uxb_ffi_stub_82
global __uxb_ffi_symptr_82
global __uxb_ffi_arg_82_1
global __uxb_ffi_arg_82_2
global __uxb_ffi_arg_82_3
__uxb_ffi_stub_82:
    ; line=310 dll=uxcapi.dll symbol=uxcapi_memory_write_ptr conv=CDECL
    ; arg_count=3 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_82_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_82_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_82_3]
    movq xmm2, r8
    mov r11, qword [rel __uxb_ffi_symptr_82]
    test r11, r11
    jnz __uxb_ffi_call_82
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_82:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_82: dq 0
__uxb_ffi_arg_82_1: dq 0
__uxb_ffi_arg_82_2: dq 0
__uxb_ffi_arg_82_3: dq 0
section .text

global __uxb_ffi_stub_83
global __uxb_ffi_symptr_83
global __uxb_ffi_arg_83_1
global __uxb_ffi_arg_83_2
global __uxb_ffi_arg_83_3
global __uxb_ffi_arg_83_4
__uxb_ffi_stub_83:
    ; line=313 dll=uxcapi.dll symbol=uxcapi_memory_write_string conv=CDECL
    ; arg_count=4 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_83_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_83_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_83_3]
    movq xmm2, r8
    mov r9, qword [rel __uxb_ffi_arg_83_4]
    movq xmm3, r9
    mov r11, qword [rel __uxb_ffi_symptr_83]
    test r11, r11
    jnz __uxb_ffi_call_83
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_83:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_83: dq 0
__uxb_ffi_arg_83_1: dq 0
__uxb_ffi_arg_83_2: dq 0
__uxb_ffi_arg_83_3: dq 0
__uxb_ffi_arg_83_4: dq 0
section .text

global __uxb_ffi_stub_84
global __uxb_ffi_symptr_84
global __uxb_ffi_arg_84_1
global __uxb_ffi_arg_84_2
__uxb_ffi_stub_84:
    ; line=317 dll=uxcapi.dll symbol=uxcapi_memory_read_i8 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_84_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_84_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_84]
    test r11, r11
    jnz __uxb_ffi_call_84
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_84:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_84: dq 0
__uxb_ffi_arg_84_1: dq 0
__uxb_ffi_arg_84_2: dq 0
section .text

global __uxb_ffi_stub_85
global __uxb_ffi_symptr_85
global __uxb_ffi_arg_85_1
global __uxb_ffi_arg_85_2
__uxb_ffi_stub_85:
    ; line=320 dll=uxcapi.dll symbol=uxcapi_memory_read_u8 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_85_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_85_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_85]
    test r11, r11
    jnz __uxb_ffi_call_85
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_85:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_85: dq 0
__uxb_ffi_arg_85_1: dq 0
__uxb_ffi_arg_85_2: dq 0
section .text

global __uxb_ffi_stub_86
global __uxb_ffi_symptr_86
global __uxb_ffi_arg_86_1
global __uxb_ffi_arg_86_2
__uxb_ffi_stub_86:
    ; line=323 dll=uxcapi.dll symbol=uxcapi_memory_read_i16 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_86_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_86_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_86]
    test r11, r11
    jnz __uxb_ffi_call_86
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_86:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_86: dq 0
__uxb_ffi_arg_86_1: dq 0
__uxb_ffi_arg_86_2: dq 0
section .text

global __uxb_ffi_stub_87
global __uxb_ffi_symptr_87
global __uxb_ffi_arg_87_1
global __uxb_ffi_arg_87_2
__uxb_ffi_stub_87:
    ; line=326 dll=uxcapi.dll symbol=uxcapi_memory_read_u16 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_87_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_87_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_87]
    test r11, r11
    jnz __uxb_ffi_call_87
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_87:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_87: dq 0
__uxb_ffi_arg_87_1: dq 0
__uxb_ffi_arg_87_2: dq 0
section .text

global __uxb_ffi_stub_88
global __uxb_ffi_symptr_88
global __uxb_ffi_arg_88_1
global __uxb_ffi_arg_88_2
__uxb_ffi_stub_88:
    ; line=329 dll=uxcapi.dll symbol=uxcapi_memory_read_i32 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_88_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_88_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_88]
    test r11, r11
    jnz __uxb_ffi_call_88
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_88:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_88: dq 0
__uxb_ffi_arg_88_1: dq 0
__uxb_ffi_arg_88_2: dq 0
section .text

global __uxb_ffi_stub_89
global __uxb_ffi_symptr_89
global __uxb_ffi_arg_89_1
global __uxb_ffi_arg_89_2
__uxb_ffi_stub_89:
    ; line=332 dll=uxcapi.dll symbol=uxcapi_memory_read_u32 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_89_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_89_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_89]
    test r11, r11
    jnz __uxb_ffi_call_89
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_89:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_89: dq 0
__uxb_ffi_arg_89_1: dq 0
__uxb_ffi_arg_89_2: dq 0
section .text

global __uxb_ffi_stub_90
global __uxb_ffi_symptr_90
global __uxb_ffi_arg_90_1
global __uxb_ffi_arg_90_2
__uxb_ffi_stub_90:
    ; line=335 dll=uxcapi.dll symbol=uxcapi_memory_read_i64 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_90_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_90_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_90]
    test r11, r11
    jnz __uxb_ffi_call_90
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_90:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_90: dq 0
__uxb_ffi_arg_90_1: dq 0
__uxb_ffi_arg_90_2: dq 0
section .text

global __uxb_ffi_stub_91
global __uxb_ffi_symptr_91
global __uxb_ffi_arg_91_1
global __uxb_ffi_arg_91_2
__uxb_ffi_stub_91:
    ; line=338 dll=uxcapi.dll symbol=uxcapi_memory_read_u64 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_91_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_91_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_91]
    test r11, r11
    jnz __uxb_ffi_call_91
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_91:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_91: dq 0
__uxb_ffi_arg_91_1: dq 0
__uxb_ffi_arg_91_2: dq 0
section .text

global __uxb_ffi_stub_92
global __uxb_ffi_symptr_92
global __uxb_ffi_arg_92_1
global __uxb_ffi_arg_92_2
__uxb_ffi_stub_92:
    ; line=341 dll=uxcapi.dll symbol=uxcapi_memory_read_f32 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_92_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_92_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_92]
    test r11, r11
    jnz __uxb_ffi_call_92
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_92:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_92: dq 0
__uxb_ffi_arg_92_1: dq 0
__uxb_ffi_arg_92_2: dq 0
section .text

global __uxb_ffi_stub_93
global __uxb_ffi_symptr_93
global __uxb_ffi_arg_93_1
global __uxb_ffi_arg_93_2
__uxb_ffi_stub_93:
    ; line=344 dll=uxcapi.dll symbol=uxcapi_memory_read_f64 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_93_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_93_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_93]
    test r11, r11
    jnz __uxb_ffi_call_93
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_93:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_93: dq 0
__uxb_ffi_arg_93_1: dq 0
__uxb_ffi_arg_93_2: dq 0
section .text

global __uxb_ffi_stub_94
global __uxb_ffi_symptr_94
global __uxb_ffi_arg_94_1
global __uxb_ffi_arg_94_2
__uxb_ffi_stub_94:
    ; line=347 dll=uxcapi.dll symbol=uxcapi_memory_read_ptr conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_94_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_94_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_94]
    test r11, r11
    jnz __uxb_ffi_call_94
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_94:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_94: dq 0
__uxb_ffi_arg_94_1: dq 0
__uxb_ffi_arg_94_2: dq 0
section .text

global __uxb_ffi_stub_95
global __uxb_ffi_symptr_95
global __uxb_ffi_arg_95_1
global __uxb_ffi_arg_95_2
__uxb_ffi_stub_95:
    ; line=350 dll=uxcapi.dll symbol=uxcapi_memory_read_string conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_95_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_95_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_95]
    test r11, r11
    jnz __uxb_ffi_call_95
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_95:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_95: dq 0
__uxb_ffi_arg_95_1: dq 0
__uxb_ffi_arg_95_2: dq 0
section .text

global __uxb_ffi_stub_96
global __uxb_ffi_symptr_96
global __uxb_ffi_arg_96_1
global __uxb_ffi_arg_96_2
global __uxb_ffi_arg_96_3
__uxb_ffi_stub_96:
    ; line=354 dll=uxcapi.dll symbol=uxcapi_callback_new conv=CDECL
    ; arg_count=3 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_96_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_96_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_96_3]
    movq xmm2, r8
    mov r11, qword [rel __uxb_ffi_symptr_96]
    test r11, r11
    jnz __uxb_ffi_call_96
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_96:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_96: dq 0
__uxb_ffi_arg_96_1: dq 0
__uxb_ffi_arg_96_2: dq 0
__uxb_ffi_arg_96_3: dq 0
section .text

global __uxb_ffi_stub_97
global __uxb_ffi_symptr_97
global __uxb_ffi_arg_97_1
global __uxb_ffi_arg_97_2
__uxb_ffi_stub_97:
    ; line=357 dll=uxcapi.dll symbol=uxcapi_callback_add_arg conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_97_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_97_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_97]
    test r11, r11
    jnz __uxb_ffi_call_97
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_97:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_97: dq 0
__uxb_ffi_arg_97_1: dq 0
__uxb_ffi_arg_97_2: dq 0
section .text

global __uxb_ffi_stub_98
global __uxb_ffi_symptr_98
global __uxb_ffi_arg_98_1
__uxb_ffi_stub_98:
    ; line=360 dll=uxcapi.dll symbol=uxcapi_callback_build conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_98_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_98]
    test r11, r11
    jnz __uxb_ffi_call_98
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_98:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_98: dq 0
__uxb_ffi_arg_98_1: dq 0
section .text

global __uxb_ffi_stub_99
global __uxb_ffi_symptr_99
global __uxb_ffi_arg_99_1
__uxb_ffi_stub_99:
    ; line=363 dll=uxcapi.dll symbol=uxcapi_callback_pointer conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_99_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_99]
    test r11, r11
    jnz __uxb_ffi_call_99
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_99:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_99: dq 0
__uxb_ffi_arg_99_1: dq 0
section .text

global __uxb_ffi_stub_100
global __uxb_ffi_symptr_100
global __uxb_ffi_arg_100_1
__uxb_ffi_stub_100:
    ; line=366 dll=uxcapi.dll symbol=uxcapi_callback_free conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_100_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_100]
    test r11, r11
    jnz __uxb_ffi_call_100
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_100:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_100: dq 0
__uxb_ffi_arg_100_1: dq 0
section .text

global __uxb_ffi_stub_101
global __uxb_ffi_symptr_101
global __uxb_ffi_arg_101_1
__uxb_ffi_stub_101:
    ; line=369 dll=uxcapi.dll symbol=uxcapi_callback_pending conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_101_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_101]
    test r11, r11
    jnz __uxb_ffi_call_101
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_101:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_101: dq 0
__uxb_ffi_arg_101_1: dq 0
section .text

global __uxb_ffi_stub_102
global __uxb_ffi_symptr_102
global __uxb_ffi_arg_102_1
__uxb_ffi_stub_102:
    ; line=372 dll=uxcapi.dll symbol=uxcapi_callback_next conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_102_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_102]
    test r11, r11
    jnz __uxb_ffi_call_102
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_102:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_102: dq 0
__uxb_ffi_arg_102_1: dq 0
section .text

global __uxb_ffi_stub_103
global __uxb_ffi_symptr_103
global __uxb_ffi_arg_103_1
__uxb_ffi_stub_103:
    ; line=376 dll=uxcapi.dll symbol=uxcapi_event_free conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_103_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_103]
    test r11, r11
    jnz __uxb_ffi_call_103
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_103:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_103: dq 0
__uxb_ffi_arg_103_1: dq 0
section .text

global __uxb_ffi_stub_104
global __uxb_ffi_symptr_104
global __uxb_ffi_arg_104_1
__uxb_ffi_stub_104:
    ; line=379 dll=uxcapi.dll symbol=uxcapi_event_arg_count conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_104_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_104]
    test r11, r11
    jnz __uxb_ffi_call_104
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_104:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_104: dq 0
__uxb_ffi_arg_104_1: dq 0
section .text

global __uxb_ffi_stub_105
global __uxb_ffi_symptr_105
global __uxb_ffi_arg_105_1
global __uxb_ffi_arg_105_2
__uxb_ffi_stub_105:
    ; line=382 dll=uxcapi.dll symbol=uxcapi_event_arg_kind conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_105_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_105_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_105]
    test r11, r11
    jnz __uxb_ffi_call_105
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_105:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_105: dq 0
__uxb_ffi_arg_105_1: dq 0
__uxb_ffi_arg_105_2: dq 0
section .text

global __uxb_ffi_stub_106
global __uxb_ffi_symptr_106
global __uxb_ffi_arg_106_1
global __uxb_ffi_arg_106_2
__uxb_ffi_stub_106:
    ; line=385 dll=uxcapi.dll symbol=uxcapi_event_arg_u64 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_106_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_106_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_106]
    test r11, r11
    jnz __uxb_ffi_call_106
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_106:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_106: dq 0
__uxb_ffi_arg_106_1: dq 0
__uxb_ffi_arg_106_2: dq 0
section .text

global __uxb_ffi_stub_107
global __uxb_ffi_symptr_107
global __uxb_ffi_arg_107_1
global __uxb_ffi_arg_107_2
__uxb_ffi_stub_107:
    ; line=388 dll=uxcapi.dll symbol=uxcapi_event_arg_f64 conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_107_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_107_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_107]
    test r11, r11
    jnz __uxb_ffi_call_107
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_107:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_107: dq 0
__uxb_ffi_arg_107_1: dq 0
__uxb_ffi_arg_107_2: dq 0
section .text

global __uxb_ffi_stub_108
global __uxb_ffi_symptr_108
global __uxb_ffi_arg_108_1
global __uxb_ffi_arg_108_2
__uxb_ffi_stub_108:
    ; line=391 dll=uxcapi.dll symbol=uxcapi_event_arg_string conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_108_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_108_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_108]
    test r11, r11
    jnz __uxb_ffi_call_108
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_108:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_108: dq 0
__uxb_ffi_arg_108_1: dq 0
__uxb_ffi_arg_108_2: dq 0
section .text

global __uxb_ffi_stub_109
global __uxb_ffi_symptr_109
__uxb_ffi_stub_109:
    ; line=402 dll=uxgsl.dll symbol=uxgsl_api_version conv=CDECL
    ; arg_count=0 stack_args=0 reserve=40
    sub rsp, 40
    mov r11, qword [rel __uxb_ffi_symptr_109]
    test r11, r11
    jnz __uxb_ffi_call_109
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_109:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_109: dq 0
section .text

global __uxb_ffi_stub_110
global __uxb_ffi_symptr_110
__uxb_ffi_stub_110:
    ; line=406 dll=uxgsl.dll symbol=uxgsl_available conv=CDECL
    ; arg_count=0 stack_args=0 reserve=40
    sub rsp, 40
    mov r11, qword [rel __uxb_ffi_symptr_110]
    test r11, r11
    jnz __uxb_ffi_call_110
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_110:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_110: dq 0
section .text

global __uxb_ffi_stub_111
global __uxb_ffi_symptr_111
__uxb_ffi_stub_111:
    ; line=410 dll=uxgsl.dll symbol=uxgsl_gsl_version conv=CDECL
    ; arg_count=0 stack_args=0 reserve=40
    sub rsp, 40
    mov r11, qword [rel __uxb_ffi_symptr_111]
    test r11, r11
    jnz __uxb_ffi_call_111
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_111:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_111: dq 0
section .text

global __uxb_ffi_stub_112
global __uxb_ffi_symptr_112
__uxb_ffi_stub_112:
    ; line=414 dll=uxgsl.dll symbol=uxgsl_self_test conv=CDECL
    ; arg_count=0 stack_args=0 reserve=40
    sub rsp, 40
    mov r11, qword [rel __uxb_ffi_symptr_112]
    test r11, r11
    jnz __uxb_ffi_call_112
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_112:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_112: dq 0
section .text

global __uxb_ffi_stub_113
global __uxb_ffi_symptr_113
__uxb_ffi_stub_113:
    ; line=418 dll=uxgsl.dll symbol=uxgsl_last_status conv=CDECL
    ; arg_count=0 stack_args=0 reserve=40
    sub rsp, 40
    mov r11, qword [rel __uxb_ffi_symptr_113]
    test r11, r11
    jnz __uxb_ffi_call_113
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_113:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_113: dq 0
section .text

global __uxb_ffi_stub_114
global __uxb_ffi_symptr_114
__uxb_ffi_stub_114:
    ; line=422 dll=uxgsl.dll symbol=uxgsl_last_gsl_status conv=CDECL
    ; arg_count=0 stack_args=0 reserve=40
    sub rsp, 40
    mov r11, qword [rel __uxb_ffi_symptr_114]
    test r11, r11
    jnz __uxb_ffi_call_114
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_114:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_114: dq 0
section .text

global __uxb_ffi_stub_115
global __uxb_ffi_symptr_115
__uxb_ffi_stub_115:
    ; line=426 dll=uxgsl.dll symbol=uxgsl_last_error conv=CDECL
    ; arg_count=0 stack_args=0 reserve=40
    sub rsp, 40
    mov r11, qword [rel __uxb_ffi_symptr_115]
    test r11, r11
    jnz __uxb_ffi_call_115
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_115:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_115: dq 0
section .text

global __uxb_ffi_stub_116
global __uxb_ffi_symptr_116
global __uxb_ffi_arg_116_1
__uxb_ffi_stub_116:
    ; line=430 dll=uxgsl.dll symbol=uxgsl_status_text conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_116_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_116]
    test r11, r11
    jnz __uxb_ffi_call_116
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_116:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_116: dq 0
__uxb_ffi_arg_116_1: dq 0
section .text

global __uxb_ffi_stub_117
global __uxb_ffi_symptr_117
global __uxb_ffi_arg_117_1
__uxb_ffi_stub_117:
    ; line=434 dll=uxgsl.dll symbol=uxgsl_bessel_j0 conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_117_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_117]
    test r11, r11
    jnz __uxb_ffi_call_117
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_117:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_117: dq 0
__uxb_ffi_arg_117_1: dq 0
section .text

global __uxb_ffi_stub_118
global __uxb_ffi_symptr_118
global __uxb_ffi_arg_118_1
__uxb_ffi_stub_118:
    ; line=438 dll=uxgsl.dll symbol=uxgsl_bessel_j1 conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_118_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_118]
    test r11, r11
    jnz __uxb_ffi_call_118
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_118:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_118: dq 0
__uxb_ffi_arg_118_1: dq 0
section .text

global __uxb_ffi_stub_119
global __uxb_ffi_symptr_119
global __uxb_ffi_arg_119_1
__uxb_ffi_stub_119:
    ; line=442 dll=uxgsl.dll symbol=uxgsl_bessel_y0 conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_119_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_119]
    test r11, r11
    jnz __uxb_ffi_call_119
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_119:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_119: dq 0
__uxb_ffi_arg_119_1: dq 0
section .text

global __uxb_ffi_stub_120
global __uxb_ffi_symptr_120
global __uxb_ffi_arg_120_1
__uxb_ffi_stub_120:
    ; line=446 dll=uxgsl.dll symbol=uxgsl_gamma conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_120_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_120]
    test r11, r11
    jnz __uxb_ffi_call_120
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_120:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_120: dq 0
__uxb_ffi_arg_120_1: dq 0
section .text

global __uxb_ffi_stub_121
global __uxb_ffi_symptr_121
global __uxb_ffi_arg_121_1
__uxb_ffi_stub_121:
    ; line=450 dll=uxgsl.dll symbol=uxgsl_lngamma conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_121_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_121]
    test r11, r11
    jnz __uxb_ffi_call_121
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_121:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_121: dq 0
__uxb_ffi_arg_121_1: dq 0
section .text

global __uxb_ffi_stub_122
global __uxb_ffi_symptr_122
global __uxb_ffi_arg_122_1
__uxb_ffi_stub_122:
    ; line=454 dll=uxgsl.dll symbol=uxgsl_erf conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_122_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_122]
    test r11, r11
    jnz __uxb_ffi_call_122
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_122:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_122: dq 0
__uxb_ffi_arg_122_1: dq 0
section .text

global __uxb_ffi_stub_123
global __uxb_ffi_symptr_123
global __uxb_ffi_arg_123_1
global __uxb_ffi_arg_123_2
__uxb_ffi_stub_123:
    ; line=458 dll=uxgsl.dll symbol=uxgsl_gaussian_pdf conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_123_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_123_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_123]
    test r11, r11
    jnz __uxb_ffi_call_123
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_123:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_123: dq 0
__uxb_ffi_arg_123_1: dq 0
__uxb_ffi_arg_123_2: dq 0
section .text

global __uxb_ffi_stub_124
global __uxb_ffi_symptr_124
global __uxb_ffi_arg_124_1
__uxb_ffi_stub_124:
    ; line=462 dll=uxgsl.dll symbol=uxgsl_rng_create conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_124_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_124]
    test r11, r11
    jnz __uxb_ffi_call_124
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_124:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_124: dq 0
__uxb_ffi_arg_124_1: dq 0
section .text

global __uxb_ffi_stub_125
global __uxb_ffi_symptr_125
global __uxb_ffi_arg_125_1
__uxb_ffi_stub_125:
    ; line=466 dll=uxgsl.dll symbol=uxgsl_rng_free conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_125_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_125]
    test r11, r11
    jnz __uxb_ffi_call_125
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_125:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_125: dq 0
__uxb_ffi_arg_125_1: dq 0
section .text

global __uxb_ffi_stub_126
global __uxb_ffi_symptr_126
global __uxb_ffi_arg_126_1
__uxb_ffi_stub_126:
    ; line=470 dll=uxgsl.dll symbol=uxgsl_rng_uniform conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_126_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_126]
    test r11, r11
    jnz __uxb_ffi_call_126
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_126:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_126: dq 0
__uxb_ffi_arg_126_1: dq 0
section .text

global __uxb_ffi_stub_127
global __uxb_ffi_symptr_127
global __uxb_ffi_arg_127_1
global __uxb_ffi_arg_127_2
__uxb_ffi_stub_127:
    ; line=474 dll=uxgsl.dll symbol=uxgsl_rng_gaussian conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_127_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_127_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_127]
    test r11, r11
    jnz __uxb_ffi_call_127
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_127:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_127: dq 0
__uxb_ffi_arg_127_1: dq 0
__uxb_ffi_arg_127_2: dq 0
section .text

global __uxb_ffi_stub_128
global __uxb_ffi_symptr_128
global __uxb_ffi_arg_128_1
__uxb_ffi_stub_128:
    ; line=478 dll=uxgsl.dll symbol=uxgsl_vector_create conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_128_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_128]
    test r11, r11
    jnz __uxb_ffi_call_128
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_128:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_128: dq 0
__uxb_ffi_arg_128_1: dq 0
section .text

global __uxb_ffi_stub_129
global __uxb_ffi_symptr_129
global __uxb_ffi_arg_129_1
__uxb_ffi_stub_129:
    ; line=482 dll=uxgsl.dll symbol=uxgsl_vector_free conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_129_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_129]
    test r11, r11
    jnz __uxb_ffi_call_129
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_129:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_129: dq 0
__uxb_ffi_arg_129_1: dq 0
section .text

global __uxb_ffi_stub_130
global __uxb_ffi_symptr_130
global __uxb_ffi_arg_130_1
__uxb_ffi_stub_130:
    ; line=486 dll=uxgsl.dll symbol=uxgsl_vector_size conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_130_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_130]
    test r11, r11
    jnz __uxb_ffi_call_130
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_130:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_130: dq 0
__uxb_ffi_arg_130_1: dq 0
section .text

global __uxb_ffi_stub_131
global __uxb_ffi_symptr_131
global __uxb_ffi_arg_131_1
global __uxb_ffi_arg_131_2
global __uxb_ffi_arg_131_3
__uxb_ffi_stub_131:
    ; line=490 dll=uxgsl.dll symbol=uxgsl_vector_set conv=CDECL
    ; arg_count=3 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_131_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_131_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_131_3]
    movq xmm2, r8
    mov r11, qword [rel __uxb_ffi_symptr_131]
    test r11, r11
    jnz __uxb_ffi_call_131
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_131:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_131: dq 0
__uxb_ffi_arg_131_1: dq 0
__uxb_ffi_arg_131_2: dq 0
__uxb_ffi_arg_131_3: dq 0
section .text

global __uxb_ffi_stub_132
global __uxb_ffi_symptr_132
global __uxb_ffi_arg_132_1
global __uxb_ffi_arg_132_2
__uxb_ffi_stub_132:
    ; line=494 dll=uxgsl.dll symbol=uxgsl_vector_get conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_132_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_132_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_132]
    test r11, r11
    jnz __uxb_ffi_call_132
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_132:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_132: dq 0
__uxb_ffi_arg_132_1: dq 0
__uxb_ffi_arg_132_2: dq 0
section .text

global __uxb_ffi_stub_133
global __uxb_ffi_symptr_133
global __uxb_ffi_arg_133_1
__uxb_ffi_stub_133:
    ; line=498 dll=uxgsl.dll symbol=uxgsl_vector_mean conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_133_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_133]
    test r11, r11
    jnz __uxb_ffi_call_133
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_133:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_133: dq 0
__uxb_ffi_arg_133_1: dq 0
section .text

global __uxb_ffi_stub_134
global __uxb_ffi_symptr_134
global __uxb_ffi_arg_134_1
__uxb_ffi_stub_134:
    ; line=502 dll=uxgsl.dll symbol=uxgsl_vector_sd conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_134_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_134]
    test r11, r11
    jnz __uxb_ffi_call_134
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_134:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_134: dq 0
__uxb_ffi_arg_134_1: dq 0
section .text

global __uxb_ffi_stub_135
global __uxb_ffi_symptr_135
global __uxb_ffi_arg_135_1
__uxb_ffi_stub_135:
    ; line=506 dll=uxgsl.dll symbol=uxgsl_vector_variance conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_135_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_135]
    test r11, r11
    jnz __uxb_ffi_call_135
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_135:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_135: dq 0
__uxb_ffi_arg_135_1: dq 0
section .text

global __uxb_ffi_stub_136
global __uxb_ffi_symptr_136
global __uxb_ffi_arg_136_1
global __uxb_ffi_arg_136_2
__uxb_ffi_stub_136:
    ; line=512 dll=uxgsl.dll symbol=uxgsl_matrix_create conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_136_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_136_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_136]
    test r11, r11
    jnz __uxb_ffi_call_136
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_136:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_136: dq 0
__uxb_ffi_arg_136_1: dq 0
__uxb_ffi_arg_136_2: dq 0
section .text

global __uxb_ffi_stub_137
global __uxb_ffi_symptr_137
global __uxb_ffi_arg_137_1
__uxb_ffi_stub_137:
    ; line=516 dll=uxgsl.dll symbol=uxgsl_matrix_free conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_137_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_137]
    test r11, r11
    jnz __uxb_ffi_call_137
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_137:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_137: dq 0
__uxb_ffi_arg_137_1: dq 0
section .text

global __uxb_ffi_stub_138
global __uxb_ffi_symptr_138
global __uxb_ffi_arg_138_1
__uxb_ffi_stub_138:
    ; line=520 dll=uxgsl.dll symbol=uxgsl_matrix_rows conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_138_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_138]
    test r11, r11
    jnz __uxb_ffi_call_138
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_138:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_138: dq 0
__uxb_ffi_arg_138_1: dq 0
section .text

global __uxb_ffi_stub_139
global __uxb_ffi_symptr_139
global __uxb_ffi_arg_139_1
__uxb_ffi_stub_139:
    ; line=524 dll=uxgsl.dll symbol=uxgsl_matrix_columns conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_139_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_139]
    test r11, r11
    jnz __uxb_ffi_call_139
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_139:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_139: dq 0
__uxb_ffi_arg_139_1: dq 0
section .text

global __uxb_ffi_stub_140
global __uxb_ffi_symptr_140
global __uxb_ffi_arg_140_1
global __uxb_ffi_arg_140_2
global __uxb_ffi_arg_140_3
global __uxb_ffi_arg_140_4
__uxb_ffi_stub_140:
    ; line=528 dll=uxgsl.dll symbol=uxgsl_matrix_set conv=CDECL
    ; arg_count=4 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_140_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_140_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_140_3]
    movq xmm2, r8
    mov r9, qword [rel __uxb_ffi_arg_140_4]
    movq xmm3, r9
    mov r11, qword [rel __uxb_ffi_symptr_140]
    test r11, r11
    jnz __uxb_ffi_call_140
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_140:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_140: dq 0
__uxb_ffi_arg_140_1: dq 0
__uxb_ffi_arg_140_2: dq 0
__uxb_ffi_arg_140_3: dq 0
__uxb_ffi_arg_140_4: dq 0
section .text

global __uxb_ffi_stub_141
global __uxb_ffi_symptr_141
global __uxb_ffi_arg_141_1
global __uxb_ffi_arg_141_2
global __uxb_ffi_arg_141_3
__uxb_ffi_stub_141:
    ; line=532 dll=uxgsl.dll symbol=uxgsl_matrix_get conv=CDECL
    ; arg_count=3 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_141_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_141_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_141_3]
    movq xmm2, r8
    mov r11, qword [rel __uxb_ffi_symptr_141]
    test r11, r11
    jnz __uxb_ffi_call_141
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_141:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_141: dq 0
__uxb_ffi_arg_141_1: dq 0
__uxb_ffi_arg_141_2: dq 0
__uxb_ffi_arg_141_3: dq 0
section .text

global __uxb_ffi_stub_142
global __uxb_ffi_symptr_142
global __uxb_ffi_arg_142_1
__uxb_ffi_stub_142:
    ; line=536 dll=uxgsl.dll symbol=uxgsl_matrix_set_zero conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_142_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_142]
    test r11, r11
    jnz __uxb_ffi_call_142
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_142:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_142: dq 0
__uxb_ffi_arg_142_1: dq 0
section .text

global __uxb_ffi_stub_143
global __uxb_ffi_symptr_143
global __uxb_ffi_arg_143_1
__uxb_ffi_stub_143:
    ; line=540 dll=uxgsl.dll symbol=uxgsl_matrix_set_identity conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_143_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_143]
    test r11, r11
    jnz __uxb_ffi_call_143
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_143:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_143: dq 0
__uxb_ffi_arg_143_1: dq 0
section .text

global __uxb_ffi_stub_144
global __uxb_ffi_symptr_144
global __uxb_ffi_arg_144_1
global __uxb_ffi_arg_144_2
global __uxb_ffi_arg_144_3
__uxb_ffi_stub_144:
    ; line=544 dll=uxgsl.dll symbol=uxgsl_matrix_multiply conv=CDECL
    ; arg_count=3 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_144_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_144_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_144_3]
    movq xmm2, r8
    mov r11, qword [rel __uxb_ffi_symptr_144]
    test r11, r11
    jnz __uxb_ffi_call_144
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_144:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_144: dq 0
__uxb_ffi_arg_144_1: dq 0
__uxb_ffi_arg_144_2: dq 0
__uxb_ffi_arg_144_3: dq 0
section .text

global __uxb_ffi_stub_145
global __uxb_ffi_symptr_145
global __uxb_ffi_arg_145_1
__uxb_ffi_stub_145:
    ; line=551 dll=uxgsl.dll symbol=uxgsl_integration_workspace_create conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_145_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_145]
    test r11, r11
    jnz __uxb_ffi_call_145
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_145:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_145: dq 0
__uxb_ffi_arg_145_1: dq 0
section .text

global __uxb_ffi_stub_146
global __uxb_ffi_symptr_146
global __uxb_ffi_arg_146_1
__uxb_ffi_stub_146:
    ; line=555 dll=uxgsl.dll symbol=uxgsl_integration_workspace_free conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_146_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_146]
    test r11, r11
    jnz __uxb_ffi_call_146
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_146:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_146: dq 0
__uxb_ffi_arg_146_1: dq 0
section .text

global __uxb_ffi_stub_147
global __uxb_ffi_symptr_147
global __uxb_ffi_arg_147_1
global __uxb_ffi_arg_147_2
global __uxb_ffi_arg_147_3
global __uxb_ffi_arg_147_4
global __uxb_ffi_arg_147_5
global __uxb_ffi_arg_147_6
global __uxb_ffi_arg_147_7
global __uxb_ffi_arg_147_8
global __uxb_ffi_arg_147_9
__uxb_ffi_stub_147:
    ; line=559 dll=uxgsl.dll symbol=uxgsl_integrate_qag conv=CDECL
    ; arg_count=9 stack_args=5 reserve=72
    sub rsp, 72
    mov rcx, qword [rel __uxb_ffi_arg_147_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_147_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_147_3]
    movq xmm2, r8
    mov r9, qword [rel __uxb_ffi_arg_147_4]
    movq xmm3, r9
    mov rax, qword [rel __uxb_ffi_arg_147_5]
    mov qword [rsp+32], rax
    mov rax, qword [rel __uxb_ffi_arg_147_6]
    mov qword [rsp+40], rax
    mov rax, qword [rel __uxb_ffi_arg_147_7]
    mov qword [rsp+48], rax
    mov rax, qword [rel __uxb_ffi_arg_147_8]
    mov qword [rsp+56], rax
    mov rax, qword [rel __uxb_ffi_arg_147_9]
    mov qword [rsp+64], rax
    mov r11, qword [rel __uxb_ffi_symptr_147]
    test r11, r11
    jnz __uxb_ffi_call_147
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_147:
    call r11
    add rsp, 72
    ret
section .data
__uxb_ffi_symptr_147: dq 0
__uxb_ffi_arg_147_1: dq 0
__uxb_ffi_arg_147_2: dq 0
__uxb_ffi_arg_147_3: dq 0
__uxb_ffi_arg_147_4: dq 0
__uxb_ffi_arg_147_5: dq 0
__uxb_ffi_arg_147_6: dq 0
__uxb_ffi_arg_147_7: dq 0
__uxb_ffi_arg_147_8: dq 0
__uxb_ffi_arg_147_9: dq 0
section .text

global __uxb_ffi_stub_148
global __uxb_ffi_symptr_148
__uxb_ffi_stub_148:
    ; line=563 dll=uxgsl.dll symbol=uxgsl_last_estimated_error conv=CDECL
    ; arg_count=0 stack_args=0 reserve=40
    sub rsp, 40
    mov r11, qword [rel __uxb_ffi_symptr_148]
    test r11, r11
    jnz __uxb_ffi_call_148
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_148:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_148: dq 0
section .text

global __uxb_ffi_stub_149
global __uxb_ffi_symptr_149
__uxb_ffi_stub_149:
    ; line=569 dll=uxgsl.dll symbol=uxgsl_root_bisection_create conv=CDECL
    ; arg_count=0 stack_args=0 reserve=40
    sub rsp, 40
    mov r11, qword [rel __uxb_ffi_symptr_149]
    test r11, r11
    jnz __uxb_ffi_call_149
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_149:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_149: dq 0
section .text

global __uxb_ffi_stub_150
global __uxb_ffi_symptr_150
global __uxb_ffi_arg_150_1
__uxb_ffi_stub_150:
    ; line=573 dll=uxgsl.dll symbol=uxgsl_root_bisection_free conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_150_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_150]
    test r11, r11
    jnz __uxb_ffi_call_150
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_150:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_150: dq 0
__uxb_ffi_arg_150_1: dq 0
section .text

global __uxb_ffi_stub_151
global __uxb_ffi_symptr_151
global __uxb_ffi_arg_151_1
global __uxb_ffi_arg_151_2
global __uxb_ffi_arg_151_3
global __uxb_ffi_arg_151_4
global __uxb_ffi_arg_151_5
__uxb_ffi_stub_151:
    ; line=577 dll=uxgsl.dll symbol=uxgsl_root_bisection_set conv=CDECL
    ; arg_count=5 stack_args=1 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_151_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_151_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_151_3]
    movq xmm2, r8
    mov r9, qword [rel __uxb_ffi_arg_151_4]
    movq xmm3, r9
    mov rax, qword [rel __uxb_ffi_arg_151_5]
    mov qword [rsp+32], rax
    mov r11, qword [rel __uxb_ffi_symptr_151]
    test r11, r11
    jnz __uxb_ffi_call_151
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_151:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_151: dq 0
__uxb_ffi_arg_151_1: dq 0
__uxb_ffi_arg_151_2: dq 0
__uxb_ffi_arg_151_3: dq 0
__uxb_ffi_arg_151_4: dq 0
__uxb_ffi_arg_151_5: dq 0
section .text

global __uxb_ffi_stub_152
global __uxb_ffi_symptr_152
global __uxb_ffi_arg_152_1
__uxb_ffi_stub_152:
    ; line=581 dll=uxgsl.dll symbol=uxgsl_root_bisection_iterate conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_152_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_152]
    test r11, r11
    jnz __uxb_ffi_call_152
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_152:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_152: dq 0
__uxb_ffi_arg_152_1: dq 0
section .text

global __uxb_ffi_stub_153
global __uxb_ffi_symptr_153
global __uxb_ffi_arg_153_1
__uxb_ffi_stub_153:
    ; line=585 dll=uxgsl.dll symbol=uxgsl_root_bisection_root conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_153_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_153]
    test r11, r11
    jnz __uxb_ffi_call_153
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_153:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_153: dq 0
__uxb_ffi_arg_153_1: dq 0
section .text

global __uxb_ffi_stub_154
global __uxb_ffi_symptr_154
global __uxb_ffi_arg_154_1
__uxb_ffi_stub_154:
    ; line=589 dll=uxgsl.dll symbol=uxgsl_root_bisection_lower conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_154_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_154]
    test r11, r11
    jnz __uxb_ffi_call_154
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_154:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_154: dq 0
__uxb_ffi_arg_154_1: dq 0
section .text

global __uxb_ffi_stub_155
global __uxb_ffi_symptr_155
global __uxb_ffi_arg_155_1
__uxb_ffi_stub_155:
    ; line=593 dll=uxgsl.dll symbol=uxgsl_root_bisection_upper conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_155_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_155]
    test r11, r11
    jnz __uxb_ffi_call_155
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_155:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_155: dq 0
__uxb_ffi_arg_155_1: dq 0
section .text

global __uxb_ffi_stub_156
global __uxb_ffi_symptr_156
global __uxb_ffi_arg_156_1
global __uxb_ffi_arg_156_2
global __uxb_ffi_arg_156_3
__uxb_ffi_stub_156:
    ; line=597 dll=uxgsl.dll symbol=uxgsl_root_bisection_interval_converged conv=CDECL
    ; arg_count=3 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_156_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_156_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_156_3]
    movq xmm2, r8
    mov r11, qword [rel __uxb_ffi_symptr_156]
    test r11, r11
    jnz __uxb_ffi_call_156
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_156:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_156: dq 0
__uxb_ffi_arg_156_1: dq 0
__uxb_ffi_arg_156_2: dq 0
__uxb_ffi_arg_156_3: dq 0
section .text

global __uxb_ffi_stub_157
global __uxb_ffi_symptr_157
global __uxb_ffi_arg_157_1
global __uxb_ffi_arg_157_2
__uxb_ffi_stub_157:
    ; line=603 dll=uxgsl.dll symbol=uxgsl_complex_create conv=CDECL
    ; arg_count=2 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_157_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_157_2]
    movq xmm1, rdx
    mov r11, qword [rel __uxb_ffi_symptr_157]
    test r11, r11
    jnz __uxb_ffi_call_157
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_157:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_157: dq 0
__uxb_ffi_arg_157_1: dq 0
__uxb_ffi_arg_157_2: dq 0
section .text

global __uxb_ffi_stub_158
global __uxb_ffi_symptr_158
global __uxb_ffi_arg_158_1
__uxb_ffi_stub_158:
    ; line=607 dll=uxgsl.dll symbol=uxgsl_complex_free conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_158_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_158]
    test r11, r11
    jnz __uxb_ffi_call_158
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_158:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_158: dq 0
__uxb_ffi_arg_158_1: dq 0
section .text

global __uxb_ffi_stub_159
global __uxb_ffi_symptr_159
global __uxb_ffi_arg_159_1
__uxb_ffi_stub_159:
    ; line=611 dll=uxgsl.dll symbol=uxgsl_complex_real conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_159_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_159]
    test r11, r11
    jnz __uxb_ffi_call_159
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_159:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_159: dq 0
__uxb_ffi_arg_159_1: dq 0
section .text

global __uxb_ffi_stub_160
global __uxb_ffi_symptr_160
global __uxb_ffi_arg_160_1
__uxb_ffi_stub_160:
    ; line=615 dll=uxgsl.dll symbol=uxgsl_complex_imaginary conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_160_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_160]
    test r11, r11
    jnz __uxb_ffi_call_160
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_160:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_160: dq 0
__uxb_ffi_arg_160_1: dq 0
section .text

global __uxb_ffi_stub_161
global __uxb_ffi_symptr_161
global __uxb_ffi_arg_161_1
__uxb_ffi_stub_161:
    ; line=619 dll=uxgsl.dll symbol=uxgsl_complex_abs conv=CDECL
    ; arg_count=1 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_161_1]
    movq xmm0, rcx
    mov r11, qword [rel __uxb_ffi_symptr_161]
    test r11, r11
    jnz __uxb_ffi_call_161
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_161:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_161: dq 0
__uxb_ffi_arg_161_1: dq 0
section .text

global __uxb_ffi_stub_162
global __uxb_ffi_symptr_162
global __uxb_ffi_arg_162_1
global __uxb_ffi_arg_162_2
global __uxb_ffi_arg_162_3
__uxb_ffi_stub_162:
    ; line=623 dll=uxgsl.dll symbol=uxgsl_complex_add conv=CDECL
    ; arg_count=3 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_162_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_162_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_162_3]
    movq xmm2, r8
    mov r11, qword [rel __uxb_ffi_symptr_162]
    test r11, r11
    jnz __uxb_ffi_call_162
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_162:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_162: dq 0
__uxb_ffi_arg_162_1: dq 0
__uxb_ffi_arg_162_2: dq 0
__uxb_ffi_arg_162_3: dq 0
section .text

global __uxb_ffi_stub_163
global __uxb_ffi_symptr_163
global __uxb_ffi_arg_163_1
global __uxb_ffi_arg_163_2
global __uxb_ffi_arg_163_3
__uxb_ffi_stub_163:
    ; line=627 dll=uxgsl.dll symbol=uxgsl_complex_multiply conv=CDECL
    ; arg_count=3 stack_args=0 reserve=40
    sub rsp, 40
    mov rcx, qword [rel __uxb_ffi_arg_163_1]
    movq xmm0, rcx
    mov rdx, qword [rel __uxb_ffi_arg_163_2]
    movq xmm1, rdx
    mov r8, qword [rel __uxb_ffi_arg_163_3]
    movq xmm2, r8
    mov r11, qword [rel __uxb_ffi_symptr_163]
    test r11, r11
    jnz __uxb_ffi_call_163
    mov ecx, 127
    call exit
    ud2
__uxb_ffi_call_163:
    call r11
    add rsp, 40
    ret
section .data
__uxb_ffi_symptr_163: dq 0
__uxb_ffi_arg_163_1: dq 0
__uxb_ffi_arg_163_2: dq 0
__uxb_ffi_arg_163_3: dq 0
section .text
