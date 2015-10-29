
sprites:
    .ball ballSprite\
        c.ALPHA,\
        c.LIGHTBLUE,\
        c.AQUA,\
        c.BLUE
    .wall hvWallSprite\
        c.WHITE20,\
        c.WHITE40,\
        c.WHITE60,\
        c.WHITE80,\
        c.WHITE,\
        c.WHITE80,\
        c.WHITE60,\
        c.WHITE40,\
        c.WHITE20
    .lCorner leftCornerSprite\
        c.WHITE20,\
        c.WHITE40,\
        c.WHITE60,\
        c.WHITE80,\
        c.WHITE,\
        c.WHITE80,\
        c.WHITE60,\
        c.WHITE40,\
        c.WHITE20
    .rCorner rightCornerSprite\
        c.WHITE20,\
        c.WHITE40,\
        c.WHITE60,\
        c.WHITE80,\
        c.WHITE,\
        c.WHITE80,\
        c.WHITE60,\
        c.WHITE40,\
        c.WHITE20
    .lPaddle leftPaddleCapSprite\
        c.ALPHA,\
        c.AQUA,\
        c.LIGHTBLUE,\
        c.BLUE,\
        c.DARKBLUE
    .rPaddle rightPaddleCapSprite\
        c.ALPHA,\
        c.AQUA,\
        c.LIGHTBLUE,\
        c.BLUE,\
        c.DARKBLUE
    .paddle paddleBodySprite\
        c.AQUA,\
        c.DARKBLUE,\
        c.BLUE
    .brickmap brickSprite 0, 1, 2

; void drawSprite(word x, word y, word height, word width, word <si> spritePtr, word <di> colorMapPtr)
; Assumes DS is set to the data segment and ES to any video buffer
; If DI is null, no color map is used to draw the sprite.
drawSprite:
    pusha
    
    mov word [.colormap], di
    
    push ax
    call coordToPtr
    mov di, ax
    pop ax
    
    .nextY:
        push ax
        push cx
        push dx
        mov cx, dx
        .nextX:
            cmp ax, 320
            ja @f
            cmp bx, 200
            ja @f
        
            mov dl, byte [ds:si]
            cmp word [.colormap], 0
            jz .putPixel
            
            .loadFromMap:
                push bx
                mov bx, word [.colormap]
                mov dh, 0
                add bx, dx
                mov dl, byte [ds:bx]
                pop bx
        
            .putPixel:
                cmp dl, c.ALPHA
                je @f
                mov byte [es:di], dl
        
            @@:
            inc si
            inc di
            inc ax
            loop .nextX
        pop dx
        pop cx
        pop ax
        
        add di, 320
        sub di, dx
        dec bx
        loop .nextY
    
    .end:
    
    popa
    ret
    
    .colormap dw ?
    
; void drawBorder(void)
; Expects ES to point to buffer B
drawBorder:
    pusha
    
    xor di, di
    mov ax, field.xMin - 9
    mov bx, field.yMin
    mov dx, vertWallSprite.width
    mov si, sprites.wall
    mov cx, field.yMax - field.yMin
    .vert1:
        push cx
        mov cx, vertWallSprite.height
        call drawSprite
        pop cx
        inc bx
        loop .vert1
    
    mov ax, field.xMax
    mov bx, field.yMin
    mov cx, field.yMax - field.yMin
    .vert2:
        push cx
        mov cx, vertWallSprite.height
        call drawSprite
        pop cx
        inc bx
        loop .vert2
    
    mov ax, field.xMin
    mov bx, field.yMax + horizWallSprite.height - 1
    mov dx, horizWallSprite.width
    mov cx, field.xMax - field.xMin
    .horiz:
        push cx
        mov cx, horizWallSprite.height
        call drawSprite
        pop cx
        inc ax
        loop .horiz
    
    mov ax, field.xMin - 9
    mov bx, field.yMax + leftCornerSprite.height - 1
    mov cx, leftCornerSprite.height
    mov dx, leftCornerSprite.width
    mov si, sprites.lCorner
    call drawSprite
    
    mov ax, field.xMax
    mov cx, rightCornerSprite.height
    mov dx, rightCornerSprite.width
    mov si, sprites.rCorner
    call drawSprite
    
    popa
    ret
    
; void drawPaddle(word x, word y)
; Expects ES to point to buffer A
drawPaddle:
    pusha
    
    xor di, di
    mov cx, leftPaddleCapSprite.height
    mov dx, leftPaddleCapSprite.width
    mov si, sprites.lPaddle
    call drawSprite
    
    add ax, leftPaddleCapSprite.width
    mov dx, paddleBodySprite.width
    mov si, sprites.paddle
    mov cx, paddle.width - leftPaddleCapSprite.width - rightPaddleCapSprite.width
    .drawBody:
        push cx
        mov cx, paddleBodySprite.height
        call drawSprite
        inc ax
        pop cx
        loop .drawBody
    
    mov cx, rightPaddleCapSprite.height
    mov dx, rightPaddleCapSprite.width
    mov si, sprites.rPaddle
    call drawSprite
    
    popa
    ret
    
; void drawBall(word x, word y)
; Expects ES to point to buffer A
drawBall:
    pusha
    
    sub ax, ballSprite.hotspot_xy
    add bx, ballSprite.hotspot_xy
    mov cx, ballSprite.height
    mov dx, ballSprite.width
    mov si, sprites.ball
    xor di, di
    call drawSprite
    
    popa
    ret
    
; void drawBrick(word x, word y, byte <cl enum btype> type)
; Expects ES to point to buffer A
drawBrick:
    pusha
    
    cmp cl, btype.RED
    jne @f
    mov di, cm.REDBRICK
    jmp .draw
    @@:
    cmp cl, btype.GREEN
    jne @f
    mov di, cm.GREENBRICK
    jmp .draw
    @@:
    cmp cl, btype.BLUE
    jne @f
    mov di, cm.BLUEBRICK
    jmp .draw
    @@:
    xor di, di
    
    .draw:
    mov cx, brickSprite.height
    mov dx, brickSprite.width
    mov si, sprites.brickmap
    call drawSprite
    
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
    