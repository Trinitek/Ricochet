
paddle:
    .x              dw ?
    .y              dw ?
    
; word <enum pside> checkPaddleCollision(void)
;
; Test for the paddle's hitbox touching any other hitbox, and return a corresponding
; enum value. Null if no collision.
checkPaddleCollision:
    push bx
    
    mov bx, word [paddle.x]         ; Test left field border
    cmp bx, field.xMin
    jne @f
    mov ax, pside.LEFT
    jmp .end
    
    @@:
    add bx, paddle.width            ; Test right field border
    cmp bx, field.xMax
    jne @f
    mov ax, pside.RIGHT
    jmp .end
    
    @@:
    mov ax, pside.NULL              ; No collision
    
    .end:
    pop bx
    ret
