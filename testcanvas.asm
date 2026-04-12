extern initCanvas
extern printCanvas
extern calcAdrScreen
extern ditherFill

section .data

section .text
global main

main:
    push rbp
    mov rbp, rsp
    sub rsp, 64*16

    mov rax, 40
    mov rbx, 20
    call initCanvas

    mov rax, 10
    mov rbx, 10
    call calcAdrScreen
    mov [rdx], 176

    call printCanvas    
    

    mov rax, 0
    mov rsp, rbp
    pop rbp
ret