
    extern GetStdHandle
    extern WriteFile

section .data
    endl: db 10
    buf: db 30 dup 0

section .text

global printConsole
global printNum
global printConsoleTz
global calcAdr
global int2String
global calcTz
global printLnTz
global padInt2String
global printNumFPss

printNumFPss: ;xmm0 in
    ;print the integer bit.
    cvttss2si rcx, xmm0
    push rcx
    mov r10, buf
    call int2String
    mov rdx, buf
    call calcTz
    add rdx, r8

    ;mov rdx, buf
    mov [rdx], '.' ;add decimal point
    inc rdx
    
    pop rcx
    cvtsi2ss xmm1, rcx
    subss xmm0, xmm1
    ;xmm0 has the fractional part.
    mov rax, 100000
    cvtsi2ss xmm1, rax
    mulss xmm0, xmm1
    cvttss2si rcx, xmm0 ;rcx has integer form of fractional part.

  ;  mov rdx, buf
    mov r10, rdx
    mov rbx, 5 ;5 decimal places (10^5)
    call padInt2String ;print the fractional part (padded), num and buffer are already in place
    
    mov rdx, buf
    add rdx, r8
    mov [rdx], 10
    inc r8    

    mov rdx, buf
    add r8, 5 ;length of the whole thing
    call printConsole

ret

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

printNum: ;rcx in
    mov r10, buf
    call int2String
    mov rdx, buf
    call calcTz
    mov rdx, buf
    add rdx, r8
    mov [rdx], 10
    mov rdx, buf
    inc r8
    call printConsole
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
