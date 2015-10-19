
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
    
    mov cx, ballSprite.height
    .nextY:
        push cx
        mov cx, ballSprite.width
        .nextX:
            cmp ax, 320
            ja @f
            cmp bx, 200
            ja @f
        
            mov dl, byte [ds:si]
            cmp dl, c.ALPHA
            je @f
            mov byte [es:di], dl
        
            @@:
            inc si
            inc di
            inc ax
            loop .nextX
        pop cx
        
        add di, 320 - ballSprite.width
        dec bx
        loop .nextY
    
    .end:
    
    popa
    ret
    
; void drawBorder(void)
drawBorder:
    pusha
    
    mov ax, field.xMin - 9
    mov bx, field.yMax
    mov cx, field.yMax - field.yMin + 1
    mov dl, c.WHITE20
    call vertLine
    inc ax
    mov dl, c.WHITE40
    call vertLine
    inc ax
    mov dl, c.WHITE60
    call vertLine
    inc ax
    mov dl, c.WHITE80
    call vertLine
    inc ax
    mov dl, c.WHITE
    call vertLine
    inc ax
    mov dl, c.WHITE80
    call vertLine
    inc ax
    mov dl, c.WHITE60
    call vertLine
    inc ax
    mov dl, c.WHITE40
    call vertLine
    inc ax
    mov dl, c.WHITE20
    call vertLine
    
    popa
    ret
    
; void vertLine(word x, word y, word length, byte <dl> color)
vertLine:
    pusha
    
    call coordToPtr
    mov di, ax
    
    .nextY:
        mov byte [es:di], dl
        add di, 320
        loop .nextY
    
    popa
    ret

; void horizLine(word x, word y, word length, byte <dl> color)
horizLine:
    pusha
    
    call coordToPtr
    mov di, ax
    mov al, dl
    rep stosb
    
    popa
    ret
    