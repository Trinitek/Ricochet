
main:

    call setVideoBufferSeg
    cmp si, 0
    jz @f
    call print
    ret
    @@:
    
    finit
    
    mov ax, 0x13
    int 0x10
    
    call loadPalette
    call initializeTimer
    call initializeBall
    call newTrajectory
    
    mov ax, word [bufferB]          ; clear buffer B
    mov es, ax
    call clearBuffer
    call drawBorder                 ; draw background elements
    
    mov cx, 5000
    
    ;jmp @f
    
    .drawLines:
        mov ax, cs                  ; DS = CS
        mov ds, ax
    
        push cx
        push cx
        mov cx, 1000
        .pause:
            ;call tickWait
            loop .pause
        pop cx
        
        call checkCollision
        call ricochet
        
        mov ax, word [bufferA]      ; draw buffer B to buffer A
        mov es, ax
        mov ax, word [bufferB]
        mov ds, ax
        call drawBuffer
        
        mov ax, cs                  ; DS = CS
        mov ds, ax
        
        mov ax, 65
        mov bx, 20
        call drawPaddle
        
        mov ax, word [ball.x]
        mov bx, word [ball.y]
        sub ax, ballSprite.hotspot_xy
        add bx, ballSprite.hotspot_xy
        mov cx, ballSprite.height
        mov dx, ballSprite.width
        mov si, sprites.ball
        call drawSprite
        
        call nextPosition
        
        mov ax, 0xA000              ; draw buffer A to screen
        mov es, ax
        mov ax, word [bufferA]
        mov ds, ax
        call drawBuffer
    
        pop cx
        loop .drawLines
    
    @@:
    
    xor ax, ax
    int 0x16
    mov ax, 0x03
    int 0x10
    
    jmp cleanup
    
cleanup:
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
; Busy-wait for 14 ms.
tickWait:
    pusha
    
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
    
; void print(char* <si> str)
print:
    push ax
    push si
    
    mov ah, 0x0E
    .nextChar:
        lodsb
        cmp al, 0
        jz .end
        int 0x10
        jmp .nextChar
        
    .end:
    
    pop si
    pop ax
    ret
    