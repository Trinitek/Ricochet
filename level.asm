
; void unpackLevel(byte <al> levelNumber)
unpackLevel:
    pusha
    
    mov si, leveldata               ; find the level data for the number
    dec al
    mov dx, level.width * level.height
    mov ah, 0
    mul dx
    add si, ax
    
    mov di, uninitialized.brickobj.data
    mov word [.x], 0
    mov word [.y], 0
    
    mov cx, level.width * level.height
    .unpack:
        movsb
        mov ax, word [.x]
        stosw
        mov ax, word [.y]
        stosw
        add di, brickobj.size
        
        .next:
            inc word [.x]
            cmp word [.x], level.width
            jb @f
            mov word [.x], 0
            inc word [.y]
        loop .unpack
        jmp .end
            @@:
            inc word [.x]
        loop .unpack
    
    .end:
    popa
    ret
    
    .x dw ?
    .y dw ?

; void drawLevel(void)
; Expects ES to point to buffer A
;
; Reads the brick objects from the array and displays them to the screen.
drawLevel:
    pusha
    
    mov si, uninitialized.brickobj.data
    
    mov cx, level.width * level.height
    .readBrick:
        lodsb
        cmp al, btype.NULL          ; skip entry if block type is null
        jne @f
        add si, brickobj.size - 1
        loop .readBrick
        jmp .end
        
        @@:
        mov cl, al
        lodsw                       ; load x and y coordinates
        mov bx, ax
        lodsw
        xchg ax, bx
        call drawBrick
        
        loop .readBrick
    
    .end:
    popa
    ret
