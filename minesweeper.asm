extern initCanvas
extern printCanvas
extern calcAdrScreen
extern printConsole
extern cls
extern printMem
extern calcAdrScreen

section .data
playX: equ 3
playY: equ 3
msg: db "MINESWEEPER"
fieldX: equ 3
fieldY: equ 3
minefield: db 100*100 dup 0

section .text
global main

pgrid: ;rax rbx
    push rax
    push rbx
    call calcAdrScreen
    pop rbx
    pop rax
    mov [rdx], 197
    inc rdx
    mov [rdx], 196
    inc rdx
    mov [rdx], 196
    inc rdx
    mov [rdx], 196
    
    inc rbx
    call calcAdrScreen
    mov [rdx], 179
ret

main:
    push rbp
    mov rbp, rsp
    sub rsp, 10*16

    mov rax, 30
    mov rbx, 15
    call initCanvas

    mov r8, ' '
    call cls
    
    mov rax, 1
    mov rbx, 1
    call calcAdrScreen
    mov r8, msg
    mov r10, 11
    call printMem
    
    mov r10, playX
    ol:
    mov r8, playY
    il:
        mov rax, r8
        mov rbx, r10
        call calcAdrScreen
        mov [rdx], 250
    add r8, 4
    cmp r8, playX+fieldX*4+1
    jl il
    add r10, 2
    cmp r10, playY+fieldY*2+1
    jl ol

    call printCanvas

    mov rax, 8
    mov rsp, rbp
    pop rbp
ret