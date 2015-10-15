
videoBufferSeg      dw ?

; word <si> setVideoBufferPtr(void)
; SI = ptr to error string, null if successful.
setVideoBufferSeg:
    push ax
    push bx
    push es
    
    if _target = target.dos
        mov ah, 0x4A                ; resize program's memory space to free unused memory
        mov bx, ds                  ; DOS allocates the largest block available for COM executables.
        push es
        mov es, bx
        mov bx, endOfProgram/16     ; 16 bytes per paragraph
        int 0x21
        pop es
        
        mov ah, 0x48                ; allocate memory for buffer
        mov bx, (320*200)/16        ; 16 bytes per paragraph
        int 0x21
        
        jc @f                       ; no error?
        mov word [videoBufferSeg], ax
        xor si, si                  ; null si, save segment
        jmp .end
        
        @@:
        cmp ax, 0x07                ; error code 0x07?
        jne @f
        mov si, .err_mcb
        jmp .end
        
        .nomem:
        @@:
        mov si, .err_nomem          ; error code 0x08?
        jmp .end
        
        .err_mcb    db "Can't allocate video buffer: memory control block destroyed", 0x0D, 0x0A, 0
        .err_nomem  db "Can't allocate video buffer: insufficient memory", 0x0D, 0x0A, 0
        
    else if _target = target.mikeos
        mov ax, ds
        add ax, 0x100
        mov word [videoBufferSeg], ax
    end if
    
    .end:
        pop es
        pop bx
        pop ax
        ret

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

; void drawBuffer(void)
drawBuffer:
    pusha
    push ds
    push es
    
    mov ax, word [videoBufferSeg]
    mov ds, ax
    xor si, si
    mov ax, 0xA000
    mov es, ax
    mov di, si
    mov cx, (320*200)/2
    rep movsw
    
    pop es
    pop ds
    popa
    ret
    
; void clearBuffer(void)
clearBuffer:
    pusha
    push es
    
    mov ax, word [videoBufferSeg]
    mov es, ax
    xor di, di
    mov cx, (320*200)/2
    xor ax, ax
    rep stosw
    
    pop es
    popa
    ret
    