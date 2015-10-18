
sprites:
    .ball ballSprite c.ALPHA, c.BLUE, c.LIGHTBLUE, c.DARKBLUE

; void drawBallSprite(word x, word y)
; Assumes DS is set to the data segment and ES to the secondary video buffer
drawBallSprite:
    pusha
    
    mov si, sprites.ball
    
    push ax
    call coordToPtr
    mov di, ax
    pop ax
    
    mov cx, ballSprite.width
    .next_Y:
        cmp bx, 200
        jae .next_Y_end
        
        push cx
        mov cx, ballSprite.height
        .next_X:
            cmp ax, 320
            jae .next_X_end
            
            mov dl, byte [ds:si]
            mov byte [es:di], dl
            
            .next_X_end:
            inc ax
            inc si
            inc di
            loop .next_X
            pop cx
        
        .next_Y_end:
        add di, 320
        sub di, ballSprite.width
        sub ax, ballSprite.width
        loop .next_Y
    
    .end:
    
    popa
    ret
    