extern printConsole

section .data
    screenW: dq 0
    screenH: dq 0
    screenT: dq 0
    ditherset: db " ", 176,177,178,"???????????????????"; db " `.-':_,^=><+rc?sLTv",40,"J7",41,"|Fi",123,125,"CfI31tlu",91,"neoZ5Yxjya",93,"2ESw",176,"qkP6h9d4VpOGbUAKXHm8RD#$Bg0MNWQ%&@",177,178
    screen: db 260000 dup '.' ;max total canvas size.
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

;a canvas that can display brightness values 0->127
;each "pixel" is 8x4 characters wide.

initCanvas: ;rax rbx W and H (quad word)
    mul rax, 8
    mov rdx, screenW
    mov [rdx], rax

    mul rbx, 4
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
    inc rcx
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
