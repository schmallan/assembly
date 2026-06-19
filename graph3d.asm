extern initCanvas
extern printCanvas
extern calcAdrScreen
extern printNumFPss
extern drawLine
extern printNumFPss
extern mysin
extern mycos
extern cls
extern deltaLast
extern fpMOD

section .data
screenW: equ 400
screenH: equ 160

camOffX: dd 0
camOffY: dd 0
camOffZ: dd 50.0

twoPI: dd 6.283

zoom: dd 30.0
focal: dd 2.0
theta: dd 0.5
theta2: dd 0.5
thickness: equ 15

myVal: dd 0.0
myFloat: dd 0.02

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

rotpoint: ;turns the vector in xmm5 and xmm6 registers by angle in xmm7
    
    movss xmm0, xmm7 ; x = x*cos(a)-y*sin(a);
    call mycos ;xmm0 = cos(a)
    
    mulss xmm0, xmm5 ;xmm8 = x*cos(a)
    movss xmm8, xmm0 

    movss xmm0, xmm7
    call mysin ;xmm0 = sin(a)
    
    mulss xmm0, xmm6 ;xmm0 = y*cos(a)
    subss xmm8, xmm0 ;xmm8 = x*cos(a)-y*sin(a)

    movss xmm0, xmm7 ; y = x*sin(a)+y*cos(a);
    call mysin ;xmm0 = cos(a)

    mulss xmm0, xmm5
    movss xmm9, xmm0
    
    movss xmm0, xmm7
    call mycos
    
    mulss xmm0, xmm6
    addss xmm9, xmm0 

    movss xmm5, xmm8
    movss xmm6, xmm9

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

            movss xmm13, xmm1
            mov rax, theta ;rotate x-z axis
            movss xmm7, [rax]
            movss xmm5, xmm0
            movss xmm6, xmm2
            call rotpoint
            movss xmm0, xmm5
            movss xmm2, xmm6
            movss xmm1, xmm13
            
            movss xmm13, xmm0
            mov rax, theta2 ;rotate y-z axis
            movss xmm7, [rax]
            movss xmm5, xmm1
            movss xmm6, xmm2
            call rotpoint
            movss xmm1, xmm5
            movss xmm2, xmm6
            movss xmm0, xmm13

            mov rax, focal
            movss xmm10, [rax]

            mov rax, camOffX
            movss xmm11, [rax]
            mov rax, camOffY
            movss xmm12, [rax]
            mov rax, camOffZ
            movss xmm13, [rax]
            
            addss xmm0, xmm11
            addss xmm1, xmm12
            addss xmm2, xmm13


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
ret ;convert world point to display

retpointWorld:
    mul rax, 12
    mov rdx, worldPoints
    call retpoint
    add rdx, 4
    movss xmm2, [rdx]
ret ;get world point at index into xmm012
retpointDisplay:
    mul rax, 8
    mov rdx, displayPoints
    call retpoint
ret ;get world point at index into xmm01
retpoint: ;rax index, xmm012 xyz
   
    add rdx, rax
    movss xmm0, [rdx]
    add rdx, 4
    movss xmm1, [rdx]
ret

addPointsArr:



    mov rax, -26
    mov rbx, -22
    mov rcx, -1
    call addpointInt
    mov rax, -26
    mov rbx, -18
    mov rcx, -1
    call addpointInt
    mov rax, -19
    mov rbx, -16
    mov rcx, -1
    call addpointInt
    mov rax, -19
    mov rbx, 13
    mov rcx, -1
    call addpointInt
    mov rax, -25
    mov rbx, 15
    mov rcx, -1
    call addpointInt
    mov rax, -25
    mov rbx, 20
    mov rcx, -1
    call addpointInt
    mov rax, 4
    mov rbx, 20
    mov rcx, -1
    call addpointInt
    mov rax, 5
    mov rbx, 15
    mov rcx, -1
    call addpointInt
    mov rax, -3
    mov rbx, 13
    mov rcx, -1
    call addpointInt
    mov rax, -3
    mov rbx, 3
    mov rcx, -1
    call addpointInt
    mov rax, 13
    mov rbx, 3
    mov rcx, -1
    call addpointInt
    mov rax, 26
    mov rbx, -3
    mov rcx, -1
    call addpointInt
    mov rax, 27
    mov rbx, -16
    mov rcx, -1
    call addpointInt
    mov rax, 12
    mov rbx, -23
    mov rcx, -1
    call addpointInt

    mov rax, -3
    mov rbx, -17
    mov rcx, -1
    call addpointInt
    mov rax, -3
    mov rbx, -5
    mov rcx, -1
    call addpointInt
    mov rax, 9
    mov rbx, -3
    mov rcx, -1
    call addpointInt
    mov rax, 13
    mov rbx, -9
    mov rcx, -1
    call addpointInt
    mov rax, 10
    mov rbx, -15
    mov rcx, -1
    call addpointInt
    ;s

    mov rax, -26
    mov rbx, -22
    mov rcx, thickness
    call addpointInt
    mov rax, -26
    mov rbx, -18
    mov rcx, thickness
    call addpointInt
    mov rax, -19
    mov rbx, -16
    mov rcx, thickness
    call addpointInt
    mov rax, -19
    mov rbx, 13
    mov rcx, thickness
    call addpointInt
    mov rax, -25
    mov rbx, 15
    mov rcx, thickness
    call addpointInt
    mov rax, -25
    mov rbx, 20
    mov rcx, thickness
    call addpointInt
    mov rax, 4
    mov rbx, 20
    mov rcx, thickness
    call addpointInt
    mov rax, 5
    mov rbx, 15
    mov rcx, thickness
    call addpointInt
    mov rax, -3
    mov rbx, 13
    mov rcx, thickness
    call addpointInt
    mov rax, -3
    mov rbx, 3
    mov rcx, thickness
    call addpointInt
    mov rax, 13
    mov rbx, 3
    mov rcx, thickness
    call addpointInt
    mov rax, 26
    mov rbx, -3
    mov rcx, thickness
    call addpointInt
    mov rax, 27
    mov rbx, -16
    mov rcx, thickness
    call addpointInt
    mov rax, 12
    mov rbx, -23
    mov rcx, thickness
    call addpointInt

    mov rax, -3
    mov rbx, -17
    mov rcx, thickness
    call addpointInt
    mov rax, -3
    mov rbx, -5
    mov rcx, thickness
    call addpointInt
    mov rax, 9
    mov rbx, -3
    mov rcx, thickness
    call addpointInt
    mov rax, 13
    mov rbx, -9
    mov rcx, thickness
    call addpointInt
    mov rax, 10
    mov rbx, -15
    mov rcx, thickness
    call addpointInt

ret
drawLinesArr:


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
    mov rbx, 4
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
    mov rbx, 8
    call drawLinePoints
    mov rax, 9
    mov rbx, 8
    call drawLinePoints
    mov rax, 9
    mov rbx, 10
    call drawLinePoints
    mov rax, 10
    mov rbx, 11
    call drawLinePoints
    mov rax, 11
    mov rbx, 12
    call drawLinePoints
    mov rax, 13
    mov rbx, 12
    call drawLinePoints
    mov rax, 13
    mov rbx, 0
    call drawLinePoints

    mov rax, 14
    mov rbx, 15
    call drawLinePoints
    mov rax, 15
    mov rbx, 16
    call drawLinePoints
    mov rax, 16
    mov rbx, 17
    call drawLinePoints
    mov rax, 17
    mov rbx, 18
    call drawLinePoints
    mov rax, 18
    mov rbx, 14
    call drawLinePoints

    ;s
    
    mov rax, 0+19
    mov rbx, 1+19
    call drawLinePoints
    mov rax, 2+19
    mov rbx, 1+19
    call drawLinePoints
    mov rax, 3+19
    mov rbx, 2+19
    call drawLinePoints
    mov rax, 3+19
    mov rbx, 4+19
    call drawLinePoints
    
    mov rax, 4+19
    mov rbx, 5+19
    call drawLinePoints
    mov rax, 5+19
    mov rbx, 6+19
    call drawLinePoints
    mov rax, 6+19
    mov rbx, 7+19
    call drawLinePoints
    mov rax, 7+19
    mov rbx, 8+19
    call drawLinePoints
    mov rax, 9+19
    mov rbx, 8+19
    call drawLinePoints
    mov rax, 9+19
    mov rbx, 10+19
    call drawLinePoints
    mov rax, 10+19
    mov rbx, 11+19
    call drawLinePoints
    mov rax, 11+19
    mov rbx, 12+19
    call drawLinePoints
    mov rax, 13+19
    mov rbx, 12+19
    call drawLinePoints
    mov rax, 13+19
    mov rbx, 0+19
    call drawLinePoints

    mov rax, 14+19
    mov rbx, 15+19
    call drawLinePoints
    mov rax, 15+19
    mov rbx, 16+19
    call drawLinePoints
    mov rax, 16+19
    mov rbx, 17+19
    call drawLinePoints
    mov rax, 17+19
    mov rbx, 18+19
    call drawLinePoints
    mov rax, 18+19
    mov rbx, 14+19
    call drawLinePoints

    ;l
    
    mov rax, 0
    mov rbx, 19
    call drawLinePoints
    mov rax, 20
    mov rbx, 1
    call drawLinePoints
    mov rax, 21
    mov rbx, 2
    call drawLinePoints
    mov rax, 3
    mov rbx, 22
    call drawLinePoints
    mov rax, 4
    mov rbx, 23
    call drawLinePoints
    mov rax, 5
    mov rbx, 24
    call drawLinePoints
    mov rax, 6
    mov rbx, 25
    call drawLinePoints
    mov rax, 7
    mov rbx, 26
    call drawLinePoints
    mov rax, 27
    mov rbx, 8
    call drawLinePoints
    mov rax, 9
    mov rbx, 28
    call drawLinePoints
    mov rax, 10
    mov rbx, 29
    call drawLinePoints
    mov rax, 11
    mov rbx, 30
    call drawLinePoints
    mov rax, 31
    mov rbx, 12
    call drawLinePoints
    mov rax, 13
    mov rbx, 32
    call drawLinePoints

    mov rax, 14
    mov rbx, 33
    call drawLinePoints
    mov rax, 15
    mov rbx, 34
    call drawLinePoints
    mov rax, 16
    mov rbx, 35
    call drawLinePoints
    mov rax, 17
    mov rbx, 36
    call drawLinePoints
    mov rax, 18
    mov rbx, 37
    call drawLinePoints
    
    

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

    mul rbx, -1
    mul rdx, -1

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


    call addPointsArr

    ml:
        mov rcx, 5
        call deltaLast
        cmp al, 0
        jz ml

        
    mov rax, screenW
    mov rbx, screenH
    call initCanvas

        mov r8, ' '
        call cls
    
        mov rax, myFloat
        movss xmm1, [rax]
        mov rax, myVal
        movss xmm0, [rax]
        addss xmm0, xmm1

        ;mod 2pi
        mov rbx, twoPI
        movss xmm1, [rbx]
        call fpMOD

        movss [rax], xmm0

        mov rax, myVal
        movss xmm0, [rax]
       ; call mysin
       ; mov rax, twoPI
       ; movss xmm1, [rax]
       ; addss xmm0, xmm1
        mov rax, theta
        movss [rax], xmm0

        mov rax, myVal
        movss xmm0, [rax]
        addss xmm0, xmm0
        call mycos
        mov rax, twoPI
        movss xmm1, [rax]
        addss xmm0, xmm1

        mov rax, 2
        cvtsi2ss xmm1, rax
        divss xmm0, xmm1

        mov rax, theta2
        movss [rax], xmm0
        

        call cvtWorld2Display
        call drawLinesArr
        call printCanvas

    jmp ml


    mov rax, 0
    mov rsp, rbp
    pop rbp
ret