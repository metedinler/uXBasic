INCLUDE "lib1.bas"
INCLUDE "lib2.bas"

INLINE("x64", "nasm", "proc", "ABI=WIN64;PRESERVE=RBX;STACK=16;CC=clang;CXX=clang++;ASM=nasm;LINK=clang")
mov rax, rax
END INLINE

IMPORT(C, "native/helper.c")
IMPORT(CPP, "native/feature.cpp")
IMPORT(ASM, "native/entry.asm")
PRINT 1
