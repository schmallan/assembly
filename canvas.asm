extern printConsole
extern mswait
extern printNum
extern deltaLast
extern mysin
extern mycos

section .data
    screenW: dq 0
    screenH: dq 0
    screenT: dq 0
    ditherset: db " ", 176,177,178,"???????????????????"; db " `.-':_,^=><+rc?sLTv",40,"J7",41,"|Fi",123,125,"CfI31tlu",91,"neoZ5Yxjya",93,"2ESw",176,"qkP6h9d4VpOGbUAKXHm8RD#$Bg0MNWQ%&@",177,178
    screen: db 400*400*32 dup "." ;max total canvas size.
    ;ditherset: db ' ', 176, 177, 178, '?'
    ditherPattern: db 1,1,13,13,4,4,16,16,9,9,5,5,12,12,8,8,3,3,15,15,2,2,14,14,11,11,7,7,10,10,6,6
    ditherHeight: equ 4
    ditherWidth: equ 8
    ditherLength: equ 16;ditherHeight*ditherWidth

; ditherPattern: db 1,25,7,31,2,26,8,32,17,9,23,15,18,10,24,16,5,29,3,27,6,30,4,28,21,13,19,11,22,14,20,12

section .text
global initCanvas
global printCanvas
global ditherFill
global calcAdrScreen
global drawLine
global cls
;global main

drawLine: ;rabcd x1 y1 x2 y2; r12 color

    push rbp
    mov rbp, rsp
    sub rsp, 32*16
    
    ;test which difference is larger. (draw along x axis or y axis?)
    mov r8, rcx
    sub r8, rax
    cmp rax, rcx
    jl dlsx
        mov r8, rax
        sub r8, rcx
    dlsx: 

    mov r10, rdx
    sub r10, rbx
    cmp rbx, rdx
    jl dlsy
        mov r10, rbx
        sub r10, rdx ;(beware the curse of register 9)
    dlsy: 
    ;r10 is abs(dy), r8 is abs(dx)
    mov r11, 0
    cmp r10, r8
    jl dlss ;if dy>dx, swap dy and dx. (swap back at the end.)
        xor rax, rbx 
        xor rbx, rax 
        xor rax, rbx

        xor rcx, rdx
        xor rdx, rcx
        xor rcx, rdx        

        ;swap back flag
        mov r11, 1
    dlss:


    cmp rax, rcx ;make sure than the ab registers contain the leftmost point.
    jl dls

        xor rax, rcx ;swap the points
        xor rcx, rax ;xor swap!!!
        xor rax, rcx

        xor rbx, rdx
        xor rdx, rbx
        xor rbx, rdx        
    dls:


    push rcx

    ;calculate the slope in xmm0 (rise/run)
    ;"ConVert Signed Integer to Scalar Single precision (64 bit fp)"
    sub rcx, rax

    cvtsi2ss xmm1, rcx ;dX
    mov rcx, rdx
    sub rcx, rbx
    cvtsi2ss xmm0, rcx ;dY
    divss xmm0,xmm1

    ;mov rcx, 1
    ;cvtsi2ss xmm0, rcx

    ;convert y1 to fp in xmm1
    cvtsi2ss xmm1, rbx

    pop rcx
    mov r8, rax
    
    dll:
        push rcx
        addss xmm1, xmm0
        inc r8
        cvttss2si r10, xmm1

        mov rax, r8
        mov rbx, r10

        cmp r11, 0
        jz dlflip
            mov rax, r10
            mov rbx, r8
        dlflip:
        
        call calcAdrScreen
        mov [rdx], r12b
        pop rcx
    cmp r8, rcx
    jl dll

    mov rsp, rbp
    pop rbp
ret

rect: ;rabx x,y rcdx w,h r8 color
    mov r11, r8
    mov r8, rcx
    mov r10, rdx
    call calcAdrScreen

    recto:
        push rdx
        mov rcx, r8
        recti:
            mov [rdx], r11b
            inc rdx
        dec rcx
        cmp rcx, 0
        jg recti
        pop rdx
        mov rax, screenW
        add rdx, [rax]
        inc rdx
    dec r10
    cmp r10, 0
    jg recto
ret

cls: ;r8 color
    mov rax, 0
    mov rbx, 0
    mov rcx, screenW
    mov rcx, [rcx]
    mov rdx, screenH
    mov rdx, [rdx]
    mov r11, r8
    call rect
ret 

;a canvas that can display brightness values 0->127 using dithering
;each "pixel" is 8x4 characters wide.
initCanvas: ;rax rbx W and H (quad word)
    mov rdx, screenW
    mov [rdx], rax

    mov rdx, screenH
    mov [rdx], rbx

    mov rcx, rax
    inc rcx ;to make room for the endline.
    mul rcx, rbx
    mov rdx, screenT
    mov [rdx], rcx

    ;set all the endlines.
    mov rcx, screen
    add rcx, rax
    inc rax
    initloop:
        mov [rcx], 10
        add rcx, rax
    dec rbx
    cmp rbx, 0
    jg initloop
ret

printCanvas:
    mov rdx, screen
    mov rcx, screenT
    mov r8, [rcx]
    call printConsole
ret

calcAdrScreen: ;rab X,Y rdx out (adr)
    mov rcx, screenW
    mov rcx, [rcx]
    inc rcx ;add one for the endline
    mul rbx, rcx
    add rbx, rax
    mov rdx, screen
    add rdx, rbx
ret

ditherFill: ;rabx x y, rcx color (0-128)

    push rcx
    call calcAdrScreen
    pop rcx

    mov r9, ditherPattern
    mov r10, ditherset

    dec r10
    dfm:
        inc r10
        sub rcx, ditherLength
    cmp rcx, 0
    jnl dfm
    add rcx, ditherLength

    mov rax, 0
    dfo:
    inc rax
        push rdx

        mov rbx, 0
        dfi:

            mov r8, [r9]
            dec r8
            cmp cl, r8b
            push r10
            jng dfs
                inc r10
            dfs:
            mov r8, [r10]
            mov [rdx], r8b
            pop r10

            inc r9
            inc rdx
        inc rbx
        cmp rbx, ditherWidth
        jl dfi
        
        pop rdx
        
        mov r8, screenW
        add rdx, [r8]
        inc rdx
    cmp rax, ditherHeight
    jl dfo
    
ret

