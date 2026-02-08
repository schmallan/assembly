extern myFunction

section .data


section .text
global main

main:
    push rbp
    mov rbp, rsp
    sub rsp, 10*16

    mov rax, 0
    mov rsp, rbp
    pop rbp
ret