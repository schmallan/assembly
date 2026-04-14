extern initCanvas
extern printCanvas
extern calcAdrScreen
extern printNumFPss
extern drawLine
extern printNumFPss

section .data
screenW: equ 200
screenH: equ 100

camOffX: dd 1.0
camOffY: dd 1.0
camOffZ: dd 1.0


zoom: dd 25.0
focal: dd 2.0

myFloat: dd 0x3F2B851F

;current number of points in the array.
pointNum: dq -1

;let one point be a triplet of single precision FP numbers, X Y and Z
worldPoints: dd 100 dup 3 dup 0
displayPoints: dd 100 dup 2 dup 0

section .text
global main

addpointInt: ;rabcx xyz
    cvtsi2ss xmm0, rax
    cvtsi2ss xmm1, rbx
    cvtsi2ss xmm2, rcx
    call addpointWorld
ret

addpointDisplay: ;rbx index in.
    
    mov rdx, displayPoints
    
    mul rbx, 8
    call addpoint

ret

addpointWorld:
    
    mov rdx, worldPoints

    mov rax, pointNum
    mov rbx, [rax]
    inc rbx
    mov [rax], rbx

    mul rbx, 12
    call addpoint
    add rdx, 4
    movss [rdx], xmm2
    

ret

addpoint: ;xyz xmm0, xmm1, xmm2

    add rdx, rbx

    movss [rdx], xmm0
    add rdx, 4
    movss [rdx], xmm1
    
ret

cvtWorld2Display:
    mov rax, pointNum
    mov rax, [rax]
    cvl:
        push rax
            call retpointWorld

            mov rax, focal
            movss xmm10, [rax]

            mov rax, camOffX
            movss xmm11, [rax]
            mov rax, camOffY
            movss xmm12, [rax]
            
            addss xmm0, xmm11
            addss xmm1, xmm12

            mulss xmm0, xmm10
            divss xmm0, xmm2
            mulss xmm1, xmm10
            divss xmm1, xmm2
            
            

        pop rbx
        push rbx
            call addpointDisplay
        pop rax

        dec rax
    cmp rax, 0
    jnl cvl
ret


printoutpt:
    mov rax, pointNum
    mov rax, [rax]
    pvl:
        push rax
            call retpointWorld
            call printNumFPss
        pop rax
    dec rax
    cmp rax, 0
    jnl pvl
ret

retpointWorld:
    mul rax, 12
    mov rdx, worldPoints
    call retpoint
    add rdx, 4
    movss xmm2, [rdx]
ret
retpointDisplay:
    mul rax, 8
    mov rdx, displayPoints
    call retpoint
ret
retpoint: ;rax index, xmm012 xyz
   
    add rdx, rax
    movss xmm0, [rdx]
    add rdx, 4
    movss xmm1, [rdx]
ret

addPointsArr:

    mov rax, 1
    mov rbx, 1
    mov rcx, 5
    call addpointInt
    mov rax, 1
    mov rbx, -1
    mov rcx, 5
    call addpointInt
    mov rax, -1
    mov rbx, -1
    mov rcx, 5
    call addpointInt
    mov rax, -1
    mov rbx, 1
    mov rcx, 5
    call addpointInt
    
    mov rax, 1
    mov rbx, 1
    mov rcx, 7
    call addpointInt
    mov rax, 1
    mov rbx, -1
    mov rcx, 7
    call addpointInt
    mov rax, -1
    mov rbx, -1
    mov rcx, 7
    call addpointInt
    mov rax, -1
    mov rbx, 1
    mov rcx, 7
    call addpointInt
    

ret

drawLinePoints: ;rax rbx points.
    call retpointDisplay

    mov rax, zoom
    movss xmm10, [rax]
    mulss xmm0, xmm10
    mulss xmm1, xmm10
    
    cvttss2si rcx, xmm0
    push rcx
    cvttss2si rdx, xmm1
    push rdx

    mov rax, rbx
    call retpointDisplay

    mulss xmm0, xmm10
    mulss xmm1, xmm10

    cvttss2si rax, xmm0
    cvttss2si rbx, xmm1
    pop rdx
    pop rcx

    mul rax, 2 ;square display.
    mul rcx, 2

    add rax, screenW/2
    add rbx, screenH/2
    add rcx, screenW/2
    add rdx, screenH/2
    call drawLine
    


ret

main:
    push rbp
    mov rbp, rsp
    sub rsp, 64*16

    mov rax, screenW
    mov rbx, screenH
    call initCanvas

    call addPointsArr

    ;call printoutpt
    call cvtWorld2Display

    mov r12, 177

    mov rax, 0
    mov rbx, 1
    call drawLinePoints
    mov rax, 2
    mov rbx, 1
    call drawLinePoints
    mov rax, 3
    mov rbx, 2
    call drawLinePoints
    mov rax, 3
    mov rbx, 0
    call drawLinePoints
    
    mov rax, 4
    mov rbx, 5
    call drawLinePoints
    mov rax, 5
    mov rbx, 6
    call drawLinePoints
    mov rax, 6
    mov rbx, 7
    call drawLinePoints
    mov rax, 7
    mov rbx, 4
    call drawLinePoints

    mov rax, 0
    mov rbx, 4
    call drawLinePoints
    mov rax, 1
    mov rbx, 5
    call drawLinePoints
    mov rax, 2
    mov rbx, 6
    call drawLinePoints
    mov rax, 3
    mov rbx, 7
    call drawLinePoints
    


    call printCanvas

    mov rax, 0
    mov rsp, rbp
    pop rbp
ret