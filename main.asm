
main:
    mov ax, 0x13
    int 0x10
    
    call initializeBall
    call newTrajectory
    
;    push 0xA000
    mov ax, ds
    add ax, 0x100
    mov es, ax
;    pop es
    mov cx, 5000
    
    .drawLines:
    
    push cx
    mov cx, 500
    .pause:
;        call tickWait
        loop .pause
    pop cx
    
    call checkCollision
    call ricochet
    mov ax, word [ball.x]
    mov bx, word [ball.y]
    call coordToPtr
    mov di, ax
    mov al, 0x09
    stosb
    call nextPosition
    loop .drawLines
    
    push es
    pop ds
    mov ax, 0xA000
    mov es, ax
    xor di, di
    mov si, di
    mov cx, 320*200
    rep movsb
    
    xor ax, ax
    int 0x16
    mov ax, 0x03
    int 0x10
    ret
    
initializeBall:
    mov dword [ball.angle], 1.37    ; (pi)7/16
    mov dword [ball.slope], 3.0
    mov word [ball.x], 160
    mov word [ball.y], 15
    mov word [ball.xOrigin], 160
    mov word [ball.yOrigin], 15
    mov word [ball.direction], 11b
    ret

; void initializeTimer(void)
; Set speaker timer to divide 1.19 MHz by 16384, giving a ~14 ms period.
initializeTimer:
    push ax
    cli
    
    mov al, 0xB6
    out 0x43, al
    mov ax, 16384
    out 0x42, al
    mov al, ah
    out 0x42, al
    
    sti
    pop ax
    ret
    
; void tickWait(void)
; Busy-wait for 55 ms.
tickWait:
    pusha
    
    ;mov ah, 0
    ;int 0x1A
    ;mov bx, dx
    ;
    ;.spinwait1:
    ;    mov ah, 0
    ;    int 0x1A
    ;    
    ;    cmp bx, dx
    ;    je .spinwait1
    ;    
    ;popa
    ;ret
    
    macro readCount {
        cli                         ; disable interrupts
        mov al, 10000000b           ; read back count from speaker timer
        out 0x43, al
        in al, 0x40                 ; load low byte of count
        mov ah, al
        in al, 0x40                 ; load high byte of count
        rol ax, 8
        sti                         ; enable interrupts
    }
    
    readCount
    mov bx, ax
    
    .spinwait:
        readCount
        cmp ax, bx
        je .spinwait
    
    popa
    ret
    
; void printBinary(byte n)
; al = n
printBinary:
    pusha
    
    mov bl, al
    mov ah, 0x0E
    mov cx, 8
    
    .nextBit:
        shl bl, 1
        jc .one
        
        .zero:
            mov al, '0'
            jmp .common
        
        .one:
            mov al, '1'
        
        .common:
        int 0x10
        loop .nextBit
        
    popa
    ret
    