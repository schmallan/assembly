DEFAULT REL

extern printConsole
extern hexDump
extern printLnTz
extern GetSystemTime
extern printConsoleTz
extern int2String
extern GlobalMemoryStatusEx
extern regDump


section .data

pad: db 256 dup 0
struct: dw 8 dup 1
poop: db 0

section .bss

section .text
global main

main:
    push rbp
    mov rbp, rsp
    sub rsp, 32*16

    ;[] use as memory address, just like array 

   ; mov rax, 18446744073709551615 
   ; mov rbx, -18446744073709551615 
    mov rcx, struct
    call GetSystemTime

    ;mov rax, struct
    ;mov rbx, 1
    ;call hexDump

    mov rbx, struct
    lea rax, [rbx]
    mov rsp, rbp
    pop rbp
ret

time:

    mov rdx, 0
    mov rdx, struct
    lea rcx, [rdx]
    call GetSystemTime

    mov rax, struct
    mov rbx, 1
    call hexDump

ret