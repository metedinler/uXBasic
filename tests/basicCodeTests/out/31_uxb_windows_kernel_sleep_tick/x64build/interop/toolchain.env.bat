@echo off
set UXB_CC=gcc
set UXB_CXX=g++
set UXB_ASM=nasm
set UXB_LINK=gcc
set UXB_CC_PATH=C:\Program Files\CodeBlocks\MinGW\bin
set UXB_CXX_PATH=C:\Program Files\CodeBlocks\MinGW\bin
set UXB_ASM_PATH=C:\Program Files\CodeBlocks\MinGW\bin
set UXB_LINK_PATH=C:\Program Files\CodeBlocks\MinGW\bin
set UXB_CC_CMD=%UXB_CC%
set UXB_CXX_CMD=%UXB_CXX%
set UXB_ASM_CMD=%UXB_ASM%
set UXB_LINK_CMD=%UXB_LINK%
if not "%UXB_CC_PATH%"=="" set UXB_CC_CMD=%UXB_CC_PATH%\%UXB_CC%
if not "%UXB_CXX_PATH%"=="" set UXB_CXX_CMD=%UXB_CXX_PATH%\%UXB_CXX%
if not "%UXB_ASM_PATH%"=="" set UXB_ASM_CMD=%UXB_ASM_PATH%\%UXB_ASM%
if not "%UXB_LINK_PATH%"=="" set UXB_LINK_CMD=%UXB_LINK_PATH%\%UXB_LINK%
if /I "%UXB_CC%"=="gcc" if exist "C:\Program Files\CodeBlocks\MinGW\bin\gcc.exe" set UXB_CC_CMD=C:\Program Files\CodeBlocks\MinGW\bin\gcc.exe
if /I "%UXB_CXX%"=="g++" if exist "C:\Program Files\CodeBlocks\MinGW\bin\g++.exe" set UXB_CXX_CMD=C:\Program Files\CodeBlocks\MinGW\bin\g++.exe
if /I "%UXB_ASM%"=="nasm" if exist "C:\Program Files\CodeBlocks\MinGW\bin\nasm.exe" set UXB_ASM_CMD=C:\Program Files\CodeBlocks\MinGW\bin\nasm.exe
if /I "%UXB_LINK%"=="gcc" if exist "C:\Program Files\CodeBlocks\MinGW\bin\gcc.exe" set UXB_LINK_CMD=C:\Program Files\CodeBlocks\MinGW\bin\gcc.exe
exit /b 0
