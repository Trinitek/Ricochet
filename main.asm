
main:
    ;call initializeBall
    ;
    ;call newTrajectory
    ;mov di, buffer
    ;mov cx, 100
    ;@@:
    ;    call checkCollision
    ;    call ricochet
    ;    
    ;    mov ax, word [ball.direction]
    ;    call printBinary
    ;    mov si, separator
    ;    call string.teletype
    ;    
    ;    mov ax, word [ball.x]
    ;    call string.numberToString
    ;    mov si, di
    ;    call string.teletype
    ;    
    ;    mov si, separator
    ;    call string.teletype
    ;    
    ;    mov ax, word [ball.y]
    ;    call string.numberToString
    ;    mov si, di
    ;    call string.teletype
    ;    
    ;    mov si, newline
    ;    call string.teletype
    ;    
    ;    call nextPosition
    ;loop @b
    ;
    ;xor ax, ax
    ;int 0x16
    ;jmp @f
    ;;ret
    ;
    ;newline db 0x0D, 0x0A, 0
    ;separator db ', ', 0
    ;buffer db 10 dup ?
    ;temp dw ?
    ;notSup db "Not ", 0
    ;sup db "supported", 0x0D, 0x0A, 0
    ;
    ;;;;
    ;@@:
    
    mov ax, 0x13
    int 0x10
    call tickWait
    call initializeBall
    call newTrajectory
    push 0xA000
    pop es
    mov cx, 5000
    
    @@:
    call tickWait
    call checkCollision
    call ricochet
    mov ax, word [ball.x]
    mov bx, word [ball.y]
    call coordToPtr
    mov di, ax
    mov al, 0x09
    stosb
    call nextPosition
    loop @b
    
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

; tickWait(void)
; Busy-wait for 55 ms.
tickWait:
    pusha

    mov ah, 0
    int 0x1A
    mov bx, dx

    .spinwait:
        mov ah, 0
        int 0x1A
        
        cmp bx, dx
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
    