
main:
    call tickWait
    call newTrajectory
    ret

; tickWait(void)
; Busy-wait for 55 ms.
tickWait:
    pusha

    mov ah, 0
    int 0x1A
    mov bx, dx

    .spinwait:
        mov ah, 0
        int 0x1A
        
        cmp bx, dx
        je .spinwait
    
    popa
    ret
    