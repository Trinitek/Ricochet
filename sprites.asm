
sprites:
    .ball ballSprite\
        c.ALPHA,\
        c.BLUE,\
        c.LIGHTBLUE,\
        c.DARKBLUE
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

; void drawSprite(word x, word y, word height, word width, word <si> spritePtr)
; Assumes DS is set to the data segment and ES to any video buffer
drawSprite:
    pusha
    
    push ax
    call coordToPtr
    mov di, ax
    pop ax
    
    .nextY:
        push cx
        push dx
        mov cx, dx
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
        pop dx
        pop cx
        
        add di, 320
        sub di, dx
        dec bx
        loop .nextY
    
    .end:
    
    popa
    ret
    
; void drawBorder(void)
; Expects ES to point to buffer B
drawBorder:
    pusha
    
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
    