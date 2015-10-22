
bufferA             dw ?
bufferB             dw ?

; word <si> setVideoBufferSeg(void)
; SI = ptr to error string, null if successful.
setVideoBufferSeg:
    push ax
    push bx
    push es
    
    if _target = target.dos
        mov ah, 0x4A                ; resize program's memory space to free unused memory
        mov bx, ds                  ; DOS allocates the largest block available for COM executables
        push es
        mov es, bx
        mov bx, endOfProgram/16     ; 16 bytes per paragraph
        int 0x21
        pop es
        
        macro errorHandle_malloc _bufferPtr* {
            local allOk
        
            jc @f                   ; no error?
            mov word [_bufferPtr], ax
            xor si, si              ; null si, save segment
            jmp .#allOk
            
            @@:
            cmp ax, 0x07            ; error code 0x07?
            jne @f
            mov si, err_mcb
            jmp .end
            
            @@:
            mov si, err_nomem       ; error code 0x08?
            jmp .end
            
            .#allOk:
        }
        
        mov ah, 0x48                ; allocate memory for bufferA
        mov bx, (320*200)/16        ; 16 bytes per paragraph
        int 0x21
        errorHandle_malloc bufferA  ; handle any errors
        
        mov ah, 0x48                ; allocate memory for bufferB
        mov bx, (320*200)/16        ; 16 bytes per paragraph
        int 0x21
        errorHandle_malloc bufferB  ; handle any errors
        
        postpone {
            err_mcb:
                    db "Can't allocate video buffer: memory control block destroyed", 0x0D, 0x0A, 0
            err_nomem:
                    db "Can't allocate video buffer: insufficient memory", 0x0D, 0x0A, 0
        }
        
    else if _target = target.mikeos
        mov ax, ds
        add ax, 0x1000
        mov word [bufferA], ax
        add ax, 0x1000
        mov word [bufferB], ax
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
    mov dx, 199
    sub dx, bx
    
    mov bx, ax                      ; bx = x
    mov ax, dx                      ; ax = newY
    
    mov dx, 320                     ; ax = (newY * 320) + x
    mul dx
    add ax, bx
    
    pop dx
    pop bx
    ret

; void drawBuffer(word <ds> seg_srcBuffer, word <es> seg_destBuffer)
drawBuffer:
    pusha
    
    xor si, si
    mov di, si
    mov cx, (320*200)/4
    rep movsd
    
    popa
    ret
    
; void clearBuffer(word <es> seg_destBuffer)
clearBuffer:
    pusha
    
    xor di, di
    mov cx, (320*200)/4
    xor eax, eax
    rep stosd
    
    popa
    ret
    