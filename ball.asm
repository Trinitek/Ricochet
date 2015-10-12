
enum d, FWD, REV

ball:
    .angle          dd 3.322        ; ~ sin(pi/2) / log10(2)
    .slope          dd 3.0 ;0.2 ;3.0
    .x              dw 160
    .y              dw 5
    .xOrigin        dw 160
    .yOrigin        dw 5
    .direction      db d.FWD
    
checkCollision:
    ret
    
; void newTrajectory(void)
;
; Recalculate the slope of the ball's trajectory for a new angle value.
;
; if (cos(trajectory) - x) != 0.0
;   ball.slope = (sin(trajectory) - y) / (cos(trajectory) - x)
; else
;   ball.slope = (sin(trajectory) - y) / log10(2)
newTrajectory:
    finit
    
    fld dword [ball.angle]          ; st0 = angle
    fsincos                         ; st1 = sin(angle), st0 = cos(angle)
    fild word [ball.y]
    fsubr st0, st2                  ; st0 = sin - y
    ffree st2                       ; destroy sin
    fild word [ball.x]
    fsubr st0, st2                  ; st0 = cos - x
    ffree st2                       ; destroy cos
    fldz                            ; push 0.0
    fcomip st, st1                  ; st1 must not be zero
    jnz @f                          ; set st0 to something non-zero
    
    .newDivisor:
        fldlg2                      ; push log10(2) (~0.30)
        faddp                       ; st0 = ~0.30, st1 = sin - y
    @@:
    
    fdivp st1, st0                  ; st0 = st1 / st0 = slope
    fstp dword [ball.slope]         ; store slope
    
    ret
 
; void nextPosition(void)
;
; Update the ball's X and Y values with respect to its slope and direction.
nextPosition:
    finit
    
    fld dword [ball.slope]          ; st0 = slope
    fld st0                         ; push another copy of slope
    fabs                            ; st0 = abs(slope)
    fld1                            ; push 1.0
    fcomipp                         ; compare 1.0 and abs(slope) ; pop twice
    jc .use_Y_axis                  ; carry set if 1.0 < abs(slope)
    
    macro nextOnAxis axis* {
        local goingFwd, goingRev, exit
        
        cmp [ball.direction], d.FWD
        jne .#goingRev
        
        .#goingFwd:
            inc axis
            jmp .#exit
        .#goingRev:
            dec axis
        .#exit:
    }
    
    .use_X_axis:                    ; X +- 1 ; Y = m(X - xOrigin) + yOrigin
        nextOnAxis word [ball.x]
        fild word [ball.x]          ; push X
        fisub word [ball.xOrigin]   ; st0 = X - xOrigin
        fmulp                       ; st0 *= m
        fiadd word [ball.yOrigin]   ; st0 += yOrigin
        fistp word [ball.y]         ; [ball.y] = st0
        jmp .end
        
    .use_Y_axis:                    ; Y +- 1 ; X = (Y - yOrigin)/m + xOrigin
        nextOnAxis word [ball.y]
        fild word [ball.y]          ; push Y
        fisub word [ball.yOrigin]   ; st0 = Y - yOrigin
        fdivrp                      ; st0 /= m
        fiadd word [ball.xOrigin]   ; st0 += xOrigin
        fistp word [ball.x]         ; [ball.x] = st0

    .end:
        ret
