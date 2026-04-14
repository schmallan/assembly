extern initCanvas
extern printCanvas
extern mysin
extern mycos
extern calcAdrScreen
extern drawLine
extern cls
extern fpMOD
extern deltaLast

section .data

    twoPI: dd 6.28318530718
    myFloat: dd 2.09539510239
    myFloat2: dd 0.02
    numSides: equ 3

section .text
global main


main:
    push rbp
    mov rbp, rsp
    sub rsp, 128*16

    mov rax, 400
    mov rbx, 200
    call initCanvas

    mov rax, 0
    cvtsi2ss xmm9, rax
    cvtsi2ss xmm11, rax
    

    mov r13, 300
    mov r14, 100
        mov rax, myFloat
        movss xmm10, [rax]
    mm:

    mov rcx, 5
    call deltaLast
    cmp al, 0
    jz mm

    movss xmm9, xmm11
    
    
    mov rax, myFloat2
    movss xmm12, [rax]
    addss xmm11, xmm12

    mov r8, 0
    ml: 
        push r8


        addss xmm9, xmm10

        mov rax, 50
        cvtsi2ss xmm6, rax

        movss xmm0, xmm9
        call mysin
        mulss xmm0, xmm6
        cvttss2si rbx, xmm0
        movss xmm0, xmm9
        call mycos
        mulss xmm0, xmm6
        cvttss2si rax, xmm0
        

        add rax, 100
        mul rax, 2
        add rbx, 100

        mov rcx, r13
        mov rdx, r14

        mov r13, rax
        mov r14, rbx

        mov r12, '@'
         call drawLine
            
        
        pop r8
    inc r8
    cmp r8,numSides
    jl ml

    
    call printCanvas

    mov r8, ' '
    call cls

    jmp mm

    mov rax, 0
    mov rsp, rbp
    pop rbp
ret