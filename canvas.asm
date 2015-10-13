
; word coordToPtr(word x, word y)
coordToPtr:
    push bx
    push dx
    
    ; Move (0,0) origin from top left to bottom left of canvas
    mov dx, 200
    sub dx, bx
    
    mov bx, ax                      ; bx = x
    mov ax, dx                      ; ax = newY
    
    mov dx, 320                     ; ax = (newY * 320) + x
    mul dx
    add ax, bx
    
    pop dx
    pop bx
    ret
