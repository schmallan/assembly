    extern GetAsyncKeyState
    extern printConsole
    extern printConsoleTz
    extern int2String
    extern printLnTz
    extern padInt2String

section .data
printBuffer: db "xxxxxxxxxxxxxxx";
asdasdd: db "hello guys itz zelensky"
space: db " ",0
sep: db " | ",0
endl: db 10
mem: db 0

section .text
global main

main:
    push rbp
    mov rbp, rsp
    sub rsp, 10*16

    mov rax, printBuffer
    call hexDump

    mov rax, 0
    mov rsp, rbp
    pop rbp
ret

hexDump:  ;rax in
    push rbp
    mov rbp, rsp
    sub rsp, 30*16
    
    mov r15, rax

    mov rax, 0
    outerLoop:
    push rax

        mov rcx, rax
        mul rcx, 16
        push rcx

            mov r10, printBuffer
            mov rbx, 3
            call padInt2String
            mov rdx, printBuffer
            call printConsoleTz
            mov rdx, sep
            call printConsoleTz

        pop rcx

        mov r8, rcx
        add r8, 16
        push r8

        myLoop:
        push rcx
            

            mov rdx, space
            call printConsoleTz

            pop rcx
            push rcx

            mov rdx, r15
            add rdx, rcx
            mov rcx, 0
            mov cl, [rdx]
            call int2Hex
            mov rdx, printBuffer
            call printConsoleTz


        pop rcx
        inc rcx

        pop r8
        push r8

        cmp rcx, r8
        jl myLoop

        push r8
        mov rdx, sep
        call printConsoleTz
        pop r8

        mov rdx, r15
        add rdx, r8
        sub rdx, 16
        mov r8, 16
        call printConsole

        
        pop r8

            
        mov rdx, endl
        call printConsoleTz

    pop rax
    inc rax
    cmp rax, 16
    jl outerLoop
    

    mov rax, 0
    mov rsp, rbp
    pop rbp
ret

int2Hex: ;rcx in

    cmp rcx,0
    jnz nonz
        mov rdx, printBuffer
        mov [rdx], 250
        inc rdx
        mov [rdx], 250
        inc rdx
        mov [rdx], 0
        jmp end
    nonz:

    mov rdx, 0
    mov rax, rcx
    mov rbx, 16
    div rbx
    ; rdx : rax

    mov r9, 2
    mov r8, printBuffer

    hexLoop:
    dec r9
    push r9
    push rdx
    push r8

    cmp rax, 10
    jl isnum
        sub rax, 10
        add rax, 'A'
        mov [r8], rax
    
    jmp con
    isnum:
        add rax, '0'
        mov [r8], rax
    con:

    pop r8
    inc r8
    pop rdx
    mov rax, rdx
    pop r9
    cmp r9, 0
    jg hexLoop

    mov rdx, printBuffer
    add rdx, 2
    mov [rdx], 0
    
    end:
ret