
; void loadPalette(void)
loadPalette:
    pusha
    push es
    
    mov ax, 0x1012
    mov bx, 0
    mov cx, paletteIndex_
    push ds
    pop es
    mov dx, c_palette_
    int 0x10
    
    pop es
    popa
    ret
