
    extern GetStdHandle
    extern WriteFile

section .data
    endl: db 10

section .text

global printConsole
global printConsoleTz
global calcAdr
global int2String
global calcTz
global printLnTz
global padInt2String


printConsole:  ;rdx message pointer; r8 message length
    push rbp
    mov rbp, rsp
    sub rsp, 10*16

    mov rcx, -11
    call GetStdHandle
    mov rcx, rax
    call WriteFile

    mov rax, 0
    mov rsp, rbp
    pop rbp
ret

printConsoleTz:  ;rdx message pointer;
    push rbp
    mov rbp, rsp
    sub rsp, 10*16

    push rdx
    call calcTz
    pop rdx

    call printConsole

    mov rax, 0
    mov rsp, rbp
    pop rbp
ret
calcAdr: ;rabc X,Y,W rdx base; rdx out (adr)
    mul rbx, rcx
    add rbx, rax
    add rdx, rbx
ret

printLnTz:
    call printConsoleTz
    mov rdx, endl
    mov r8, 1
    call printConsole
ret

int2String: ;rcx in ;r10 in printbuffer
    mov rbx, 0
    mov rax, rcx
    ;method without using the stack
    pil: ;first find how many digits 
    inc rbx
    mov rdx, 0
    mov r8, 10
    div r8
    cmp rax, 0
    jg pil

    mov rax, rcx
    mov rcx, r10
    add rcx, rbx
    mov [rcx], 0
    dec rcx
    pil2: ;then move to printBuffer
    mov rdx, 0
    mov r8, 10
    div r8
    mov [rcx], '0'
    add [rcx], rdx
    dec rcx
    cmp rax, 0
    jg pil2

ret

padInt2String: ;rcx in ;r10 in printbuffer; rbx in padded size
    ;set the padded length to zeros
    mov r11,0
    ploop:
        mov rax, r10
        add rax, r11
        mov [rax], 250

        inc r11
    cmp r11, rbx    
    jl ploop
    inc rax
    mov [rax], 0

    mov rax, rcx
    mov rcx, r10
    add rcx, rbx
    mov [rcx], 0
    dec rcx
    ppil2: ;then move to printBuffer
    mov rdx, 0
    mov r8, 10
    div r8
    mov [rcx], '0'
    add [rcx], rdx
    dec rcx
    cmp rax, 0
    jg ppil2
ret

calcTz: ;in rdx, out r8

    mov r8, 0
    ptzl:
        mov cl, [rdx]
        inc rdx
        inc r8
    cmp cl, 0
    jnz ptzl
    dec r8

ret
