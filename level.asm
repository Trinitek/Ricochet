
; void unpackLevel(byte <al> levelNumber)
;
; Loads the read-only level information into working memory.
unpackLevel:
    pusha
    
    mov si, leveldata               ; find the level data for the number
    dec al
    mov dx, level.width * level.height
    mov ah, 0
    mul dx
    add si, ax
    mov di, uninitialized.currentLevel
    mov cx, level.width * level.height
    rep movsb
    
    popa
    ret

; void drawLevel(void)
; Expects ES to point to buffer A
;
; Reads the brick objects from the array and displays them to the screen.
drawLevel:
    pusha
    
    mov dx, field.xMin
    mov bx, field.yMax
    mov si, uninitialized.currentLevel
    mov cx, level.width * level.height
    .readBrick:
        lodsb
        cmp al, btype.NULL          ; skip entry if block type is null
        je .nextPosition
        
        push cx
        mov cl, al
        mov ax, dx
        call drawBrick
        pop cx
        
        .nextPosition:
            add dx, brick.width
            cmp dx, field.xMax
            jb @f
            mov dx, field.xMin
            sub bx, brick.height
        
            @@:
        loop .readBrick
    
    .end:
    popa
    ret
