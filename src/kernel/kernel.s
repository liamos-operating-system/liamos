bits 16
org 0x100

call checkmod
jmp _start

checkmod:
    mov al, byte [ksig]
    mov bl, byte [ksig+1]
    mov cl, byte [ksig+2]
    mov dl, byte [ksig+3]
    mov byte [0x300], 0
    cmp al, 122
    jne imgbad
    cmp bl, 70
    jne imgbad
    cmp cl, 74
    jne imgbad
    cmp dl, 41
    jne imgbad
    inc byte [0x300]
    ret

print:
    pusha
    mov ah, 0x0E
.lp:
    lodsb
    or cx, cx
    jz .end
    int 10h
    dec cx
    jmp .lp
.end:
    popa
    ret

_start:
    cli
    push es
    push 0x0000
    pop es
    mov word [0x04], keyboardint
    mov word [0x06], 0x0000
    pop es
    sti

keyboardint:
    push es
    push word 0x0001
    pop es
    mov byte [es:0x0000], al
    pop es
    iret

imgbad:
    mov al, byte [0x0300]
    mov si, imgbad_msg0
    mov cx, 46
    call print
.hlt:
    jmp $


imgbad_msg0: db `FATAL: Image might be bad. (Invalid signature)`
ksig: db 112, 70, 74, 41
