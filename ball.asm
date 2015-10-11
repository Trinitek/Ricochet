
ball:
    .trajectory     dd ?
    .slope          dd ?
    .x              dw ?
    .y              dw ?
    
checkCollision:
    ret
    
; void newTrajectory(void)
;
; if (cos(trajectory) - x) != 0.0
;   ball.slope = (sin(trajectory) - y) / (cos(trajectory) - x)
; else
;   ball.slope = (sin(trajectory) - y) / log10(2)
newTrajectory:
    finit
    
    fld dword [ball.trajectory]
    fsincos                         ; st1 = sin, st0 = cos
    fild word [ball.y]
    fsubr st0, st2                  ; st0 = sin - y
    ffree st2                       ; destroy sin
    fild word [ball.x]
    fsubr st0, st2                  ; st0 = cos - x
    ffree st2                       ; destroy cos
    fldz                            ; st0 = 0.0
    fcomip st, st1                  ; st1 must not be zero
    jnz @f                          ; set st0 to something non-zero
    
    .newDivisor:
        fldlg2                      ; st0 = log10(2) = ~0.30, st1 = 0.0
        faddp                       ; st0 = ~0.30, st1 = sin - y
    @@:
    
    fdivp st1, st0                  ; st0 = st1 / st0 = slope
    fstp dword [ball.slope]         ; store slope
    
    ret
    
nextPosition:
    ret
