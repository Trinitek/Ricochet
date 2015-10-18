
ball:
    .angle          dd ?
    .slope          dd ?
    .x              dw ?
    .y              dw ?
    .xOrigin        dw ?
    .yOrigin        dw ?
    .direction      dw ?
  
; word <bitfield r> checkCollision(void)
;
; Test for the ball's hitbox touching any other hitbox, and return a corresponding
; bitfield.
checkCollision:
    push bx
    xor ax, ax
    
    .verticalSurfaces:
        ; Check for field border collisions
        mov bx, word [ball.x]       ; Test left field border
        cmp bx, field.xMin
        jne @f
        or ax, r.VMIN
        jmp .horizontalSurfaces
        
        @@:
        add bx, ball.width          ; Test right field border
        cmp bx, field.xMax
        jne @f
        or ax, r.VMAX
        jmp .horizontalSurfaces
        
        @@:
    
    .horizontalSurfaces:
        ; Check for field border collisions
        mov bx, word [ball.y]       ; Test bottom field border
        cmp bx, field.yMin
        jne @f
        or ax, r.HMIN
        jmp .end
        
        @@:
        add bx, ball.height         ; Test top field border
        cmp bx, field.yMax
        jne @f
        or ax, r.HMAX
        jmp .end
        
        @@:
    
    .end:
        pop bx
        ret
        
; void ricochet(word <bitfield r> reflection)
;
; Adjust the ball's slope and direction value in accordance to the surface it's
; bouncing off of.
ricochet:
    
    .verticalSurfaces:
        test ax, r.VMIN + r.VMAX    ; are at least one of the vertical bits set?
        jz .horizontalSurfaces
        
        ;finit                       ; slope *= -1
        fld dword [ball.slope]
        fchs
        fstp dword [ball.slope]
        
        btc word [ball.direction], d.bit.X
                                    ; invert direction flag for X
    
    .horizontalSurfaces:
        test ax, r.HMIN + r.HMAX    ; are at least one onf the horizontal bits set?
        jz .newOrigin
        
        ;finit                       ; slope *= -1
        fld dword [ball.slope]
        fchs
        fstp dword [ball.slope]
        
        btc word [ball.direction], d.bit.Y
                                    ; invert direction flag for Y
        
    .newOrigin:
        cmp ax, 0                   ; were any of the bits set?
        jz .end
        
        bt ax, r.bit.VMIN           ; adjust coordinates in the event of a collision
        jnc @f
        inc word [ball.x]
        jmp .set
        @@:
        bt ax, r.bit.VMAX
        jnc @f
        dec word [ball.x]
        jmp .set
        @@:
        bt ax, r.bit.HMIN
        jnc @f
        inc word [ball.y]
        jmp .set
        @@:
        bt ax, r.bit.HMAX
        jnc @f
        dec word [ball.y]
        
        @@:
        .set:
        mov ax, word [ball.x]       ; set origin point to current location
        mov word [ball.xOrigin], ax
        mov ax, word [ball.y]
        mov word [ball.yOrigin], ax
        
    .end:
        ret
    
; void newTrajectory(void)
;
; Recalculate the slope of the ball's trajectory for a new angle value.
;
; if cos(slope) != 0.0
;   ball.slope = sin(slope) / cos(slope)
; else
;   ball.slope = log(10)2
newTrajectory:
    ;finit
    
    fld dword [ball.angle]          ; st0 = angle
    fsincos                         ; st1 = sin(angle), st0 = cos(angle)
    ftst                            ; compare st0 to 0.0
    push ax                         ; ...can't divide by zero!
    fstsw ax
    sahf
    pop ax
    jz .alternativeSlope            ; ZF set if st0 == 0.0
    
    fdivp                           ; st0 = tan(angle)
    jmp .end
    
    .alternativeSlope:
        fldlg2                      ; st0 = log(10)2
    
    .end:
        fstp dword [ball.slope]
        ret
 
; void nextPosition(void)
;
; Update the ball's X and Y values with respect to its slope and direction.
nextPosition:
    push ax
    ;finit
    
    fld dword [ball.slope]          ; st0 = slope
    fld st0                         ; push another copy of slope
    fabs                            ; st0 = abs(slope)
    fld1                            ; push 1.0
    fcompp                          ; compare 1.0 and abs(slope) ; pop twice
    fstsw ax
    sahf
    jc .use_Y_axis                  ; carry set if 1.0 < abs(slope)
    
    .use_X_axis:                    ; X +- 1 ; Y = m(X - xOrigin) + yOrigin
        bt word [ball.direction], d.bit.X
        jnc .x_dec
        inc word [ball.x]
        jmp @f
        .x_dec:
        dec word [ball.x]
        @@:
        
        fild word [ball.x]          ; push X
        fisub word [ball.xOrigin]   ; st0 = X - xOrigin
        fmulp                       ; st0 *= m
        fiadd word [ball.yOrigin]   ; st0 += yOrigin
        fistp word [ball.y]         ; [ball.y] = st0
        jmp .end
        
    .use_Y_axis:                    ; Y +- 1 ; X = (Y - yOrigin)/m + xOrigin
        bt word [ball.direction], d.bit.Y
        jnc .y_dec
        inc word [ball.y]
        jmp @f
        .y_dec:
        dec word [ball.y]
        @@:
        
        fild word [ball.y]          ; push Y
        fisub word [ball.yOrigin]   ; st0 = Y - yOrigin
        fdivrp                      ; st0 /= m
        fiadd word [ball.xOrigin]   ; st0 += xOrigin
        fistp word [ball.x]         ; [ball.x] = st0

    .end:
        pop ax
        ret
