    extern GetAsyncKeyState
    extern printConsole
    extern printConsoleTz
    extern int2String
    extern printLnTz
    extern padInt2String
    extern calcTz

section .data
;i had an error here cuz i was using dup wrong and instead of duplicating a string 5 times i duplicated a 5 string times which is why it wouldn't compile.

padding: equ 5
regNames: db "rax:rbx:rcx:rdx:rsi:rdi:rsp:rbp: r8: r9:r10:r11:r12:r13:r14:r15:"
regStore: db 32*8 dup "x"
dumpBuffer: db (73+padding) dup " "
regBuffer: db 100 dup " "
printBuffer: db "abcdefghixxxxj";
title: db "offset ",padding-3 dup " ",179," hex          +4           +8           +12         ",179," text",0
bar: db (76+padding) dup 196, 0
endl: db 10

section .text
;global main
global regDump
global hexDump

main:
    push rbp
    mov rbp, rsp
    sub rsp, 10*16

    call regDump

    mov rax, 0
    mov rsp, rbp
    pop rbp
ret

regDump:
    call saveReg


    mov r11, regStore
    mov rax, 0
    dumpLoop:
    push rax

        mov rcx, regBuffer
        mov rdx, ' '
        mov rbx, 70
        call strFill

        call regLine
        mov r12, regBuffer
        add r12, 35

        mov rax, 0
        hexP:
            push rax

            mov rax, 0
            mov al, [r11]
            mov rcx, r12
            call byte2Hex
            inc r11
            sub r12, 2

            pop rax
            inc rax
        cmp rax, 8
        jnz hexP


        add r12, 20
        mov [r12], 0
        

        push r11
        mov rdx, regBuffer
        mov r8, 30
        call printLnTz
        pop r11


    pop rax
    inc rax   
    cmp rax, 16
    jl dumpLoop
    

ret


strFill:  ;rcx <- rdx for rbx length
    add rcx, rbx
    fillL:
        mov [rcx], dl
        dec rcx
    dec rbx
    cmp rbx, 0
    jnl fillL

ret


regLine:
    mov r12, regBuffer

    mov rdx, r11
    mov rcx, r12
    mov rbx, 3
    call strCopy

    add r11, 8
    add r12, 5

    mov r10, printBuffer
    mov rdx, r11
    mov rcx, [rdx]
    call int2String

    mov rdx, printBuffer
    call calcTz
    mov rbx, r8
    dec rbx

    mov rdx, printBuffer
    mov rcx, r12
    call strCopy
ret

saveReg:
    push r15
    push r14
    push r13
    push r12
    push r11
    push r10
    push r9
    push r8 
    push rbp
    push rsp
    push rdi
    push rsi
    push rdx
    push rcx
    push rbx
    push rax
    
    mov rcx, regNames
    mov rax, regStore
    mov rbx, 16
    regLoop:
        add rax, 0

        mov r8d, [rcx]
        mov [rax], r8d

        add rax, 8

        pop rdx
        mov [rax], rdx

        add rax, 8

        add rcx, 4

        dec rbx
        cmp rbx, 0
    jg regLoop

ret

hexDump: ;rax mem address, rbx words
    push rbp
    mov rbp, rsp
    sub rsp, 30*16

    push rax
    push rbx
    
    mov rdx, title
    call printLnTz

    mov rdx, bar
    mov rax, rdx
    add rax, 4
    add rax, padding
    mov [rax], 197
    mov rdx, bar
    mov rax, rdx
    add rax, 57
    add rax, padding
    mov [rax], 197
    call printLnTz

    pop r12
    pop r10

    mov r11, 0
    lineLoop:
        push r11
        push r12
        push r10


        call writeStart

        
        pop r10
        mov r8,0
        mL:

            mov rax, 0
            mov al, [r10]
            call byte2Hex
            add rcx, 2
            mov [rcx], ' '
            inc rcx
            inc r10

            cmp r8, 7
            jz split
            cmp r8, 3
            jz split
            cmp r8, 11
            jz split
            

            jmp nsplit
                split:
                mov [rcx], ' '
                inc rcx
            nsplit:


        inc r8
        cmp r8, 16
        jl mL
        mov [rcx], 179

        add rcx, 2

        push r10

        sub r10, 16
        mov rdx, r10
        mov rbx, 15
        call censCopy

        add rcx, 16

        inc rcx
        mov [rcx], 0

        

        mov rdx, dumpBuffer
        mov r8, 100
        call printLnTz


        mov rcx, dumpBuffer
        add rcx, 9

        pop r10
        pop r12
        pop r11
    inc r11
    cmp r11, r12
    jl lineLoop


    mov rax, 0
    mov rsp, rbp
    pop rbp
ret

writeStart:


    mov rcx, r11
    mul rcx, 16
    mov r10, printBuffer
    mov rbx, padding
    call padInt2String

    mov rcx, dumpBuffer
    mov rdx, printBuffer
    add rcx, 2
    mov rbx, padding
    dec rbx
    call strCopy

    mov rcx, dumpBuffer
    add rcx, 4
    add rcx, padding
    mov [rcx], 179
    add rcx, 2

ret

strCopy:  ;rcx <- rdx for rbx length
    add rcx, rbx
    add rdx, rbx
    copyLoop:
        mov rax, [rdx]
        mov [rcx], al
        dec rcx
        dec rdx
    dec rbx
    cmp rbx, 0
    jnl copyLoop

ret


censCopy:  ;rcx <- rdx for rbx length
    add rcx, rbx
    add rdx, rbx
    censl:
        mov al, [rdx]

        cmp al, 31
        jg cens
            mov rax, 250
        cens:

        mov [rcx], al
        dec rcx
        dec rdx
    dec rbx
    cmp rbx, 0
    jnl censl

ret

byte2Hex: ;rax in ;rcx pointer ;uses abcd
    cmp rax, 0
    jnz nz
        mov [rcx], 250
        inc rcx
        mov [rcx], 250
        dec rcx
        ret
    nz:

    mov rdx, 0
    mov rbx, 16
    div rbx
    ; 2nd digit rdx, 1st rax
    call letter2Hex
    mov rax, rdx
    inc rcx
    call letter2Hex
    dec rcx
ret

letter2Hex: ;rdx in ;rcx pointer
    cmp rax, 10
    jl num
        sub rax, 10
        add rax, 'A'
    jmp skip
    num:
        add rax, '0'
    skip:
    mov [rcx], al
ret