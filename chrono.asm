extern GetTickCount
extern printConsoleTz
extern int2String
extern printNum

section .data
lastTick: dq 0
hello: db "hello",0
pb: db "            "
el: db 10,0

section .text
global main
global sleep
global mswait
global deltaLast


sleep: ;rax in
    mov r8, rax
        waitLoop:
            mov rax, r8
            call deltaLast
            cmp al, 0
        jz waitLoop
ret

mswait:
        mov rax, 100000
        wl:
            nop
        dec rax
        cmp rax, 0
        jg wl

ret

deltaLast: ;rcx in, rax out (1 is true, 0 is false)
    push rax
    call GetTickCount
    pop rcx

    mov rbx, lastTick
    mov rbx, [rbx]

    ;rax currenttime rbx lasttime rcx targettime

    sub rbx, rax ;rbx is negative time elapsed

    add rcx, rbx
    cmp rcx, 0
    ;if positive, time is under target
    ;if negative, time is over target
    jl dlt
        mov rax, 0
    ret
    dlt:
        mov rbx, lastTick
        mov [rbx], rax
        mov rax, 1
ret
