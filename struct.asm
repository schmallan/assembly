
extern printConsole
extern hexDump
extern printLnTz
extern GetLocalTime
extern GetSystemTime
extern printConsoleTz
extern int2String
extern GlobalMemoryStatusEx
extern regDump
extern WriteFile
extern GetTickCount
extern GetPhysicallyInstalledSystemMemory


    extern GetStdHandle
    extern WriteFile

DEFAULT REL

section .data
hello: db "hellooooooo",0
struct: dw 8 dup 1

section .bss
lastStep: resb 8

section .text
global main

main:
    push rbp
    mov rbp, rsp
    sub rsp, 64*16
    
    mov rcx, hello
    call regDump

    mov rax, 8
    mov rsp, rbp
    pop rbp
ret
