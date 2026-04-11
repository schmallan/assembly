extern initCanvas
extern printCanvas
extern ditherFill

section .data
tsW: equ 400
tsH: equ 250
ditherHeight: equ 4
ditherWidth: equ 8

section .text
global main

main:
    push rbp
    mov rbp, rsp
    sub rsp, 64*16
    
    
    mov rax, 0
    mov rsp, rbp
    pop rbp
ret