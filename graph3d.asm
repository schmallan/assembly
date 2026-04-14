extern initCanvas
extern printCanvas
extern calcAdrScreen
extern printNumFPss

section .data
myFloat: dd 0x3F2B851F

;current number of points in the array.
pointNum: dq 0

;let one point be a triplet of single precision FP numbers, X Y and Z
points: dd 10 dup 3 dup 0

section .text
global main

addpoint: ;xyz xmm0, xmm1, xmm2

ret

main:
    push rbp
    mov rbp, rsp
    sub rsp, 64*16

    mov rax, myFloat
    movss xmm0, [rax]
    call printNumFPss

    mov rax, 0
    mov rsp, rbp
    pop rbp
ret