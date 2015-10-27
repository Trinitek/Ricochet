
ball:
    .angle          dd ?
    .slope          dd ?
    .x              dw ?
    .y              dw ?
    .xOrigin        dw ?
    .yOrigin        dw ?
    .direction      dw ?
  
; word <bitfield r> checkBallCollision(void)
;
; Test for the ball's hitbox touching any other hitbox, and return a corresponding
; bitfield.
checkBallCollision:
    push bx
    push cx
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
        
        ; Check for paddle collisions
        @@:
        mov bx, word [ball.x]       ; Test left side of the paddle
        cmp bx, word [paddle.x]
        jne @f
        mov cx, word [paddle.y]
        mov bx, word [ball.y]
        cmp bx, cx
        ja @f
        sub cx, paddle.height
        cmp bx, cx
        jb @f
        or ax, r.VPADDLELEFT
        jmp .horizontalSurfaces
        
        @@:
        add bx, paddle.width        ; Test right side of the paddle
        mov cx, word [paddle.x]
        add cx, paddle.width
        cmp bx, cx
        jne @f
        mov cx, word [paddle.y]
        mov bx, word [ball.y]
        cmp bx, cx
        ja @f
        sub cx, paddle.height
        cmp bx, cx
        jb @f
        or ax, r.VPADDLERIGHT
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
        
        ; Check for paddle collisions
        @@:
        mov bx, word [ball.y]       ; Test top of paddle
        cmp bx, word [paddle.y]
        jne @f
        mov cx, word [paddle.x]
        mov bx, word [ball.x]
        cmp bx, cx
        jb @f
        add cx, paddle.width
        cmp bx, cx
        ja @f
        or ax, r.HPADDLE
        jmp .end
        
        @@:
    
    .end:
        pop cx
        pop bx
        ret
        
; void ricochet(word <bitfield r> reflection)
;
; Adjust the ball's slope and direction value in accordance to the surface it's
; bouncing off of.
ricochet:
    push bx
    
    .verticalSurfaces:
        test ax, r.VMIN or r.VMAX   ; are at least one of the vertical bits set?
        jz .horizontalSurfaces
        
        fld dword [ball.slope]      ; slope *= -1
        fchs
        fstp dword [ball.slope]
        
        btc word [ball.direction], d.bit.X
                                    ; invert direction flag for X
    .horizontalSurfaces:
        test ax, r.HMIN or r.HMAX
        jz .horizontalPaddle        ; are at least one of the horizontal bits set?
        
        fld dword [ball.slope]      ; slope *= -1
        fchs                        ; this will be overwritten if it's a paddle collision
        fstp dword [ball.slope]
        
        btc word [ball.direction], d.bit.Y
                                    ; invert direction flag for Y
    .horizontalPaddle:
        bt ax, r.bit.HPADDLE        ; is the horizontal paddle collision bit set?
        jnc .verticalPaddle
        
        ; The full range of the possible angles is 2pi/3 radians, or pi/6 to 5pi/6.
        ; This range is divided into however many pixels make up the paddle's width.
        ; angle = (2pi/3 / paddle.width) * (paddle.x + paddle.width - ball.x) + pi/6
        mov bx, word [paddle.x]
        add bx, paddle.width
        sub bx, word [ball.x]       ; bx = distance of ball from right side of paddle
        mov word [ball.angle], bx   ; using [ball.angle] as a temporary variable
        fild word [ball.angle]      ; load bx
        mov dword [ball.angle], ball.angleRange
        fmul dword [ball.angle]     ; st0 = bx * 2pi/3
        mov word [ball.angle], paddle.width
        fidiv word [ball.angle]     ; st0 /= paddle.width
        mov dword [ball.angle], ball.angleMin
        fadd dword [ball.angle]     ; st0 += pi/6
        fst dword [ball.angle]      ; [ball.angle] = st0
        call newTrajectory          ; Calculate new ball slope from angle
    
    .verticalPaddle:
        bt ax, r.bit.VPADDLELEFT    ; left vertical side of paddle?
        jnc @f
        mov dword [ball.angle], ball.angleMax
        call newTrajectory
        
        @@:
        bt ax, r.bit.VPADDLERIGHT   ; right vertical side of paddle?
        jnc @f
        mov dword [ball.angle], ball.angleMin
        call newTrajectory
        
        @@:
        
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
        jmp .set
        
        @@:
        bt ax, r.bit.VPADDLELEFT
        jnc @f
        mov bx, word [paddle.x]
        mov word [ball.x], bx
        mov bx, word [paddle.y]
        inc bx
        mov word [ball.y], bx
        jmp .set
        
        @@:
        bt ax, r.bit.VPADDLERIGHT
        jnc @f
        mov bx, word [paddle.x]
        add bx, paddle.width
        mov word [ball.x], bx
        mov bx, word [paddle.y]
        inc bx
        mov word [ball.y], bx
        jmp .set
        
        @@:
        bt ax, r.bit.HPADDLE
        jnc @f
        inc word [ball.y]
        jmp .set
        
        @@:
        .set:
            mov ax, word [ball.x]   ; set origin point to current location
            mov word [ball.xOrigin], ax
            mov ax, word [ball.y]
            mov word [ball.yOrigin], ax
        
    .end:
        pop bx
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
    fld dword [ball.angle]          ; st0 = angle
    fsincos                         ; st1 = sin(angle), st0 = cos(angle)
    ftst                            ; compare st0 to 0.0
    push ax                         ; ...can't divide by zero!
    fstsw ax
    sahf
    pop ax
    jz .alternativeSlope            ; ZF set if st0 == 0.0
    
    fdivp                           ; st0 = tan(angle)
    jmp .saveSlope
    
    .alternativeSlope:
        fldlg2                      ; st0 = log(10)2
    
    .saveSlope:
        fstp dword [ball.slope]     ; save slope, keep in st0
    
    .setDirection:
        fld dword [ball.angle]      ; load angle
        fldpi                       ; load pi
        fcompp                      ; compare pi and angle ; pop twice
        push ax
        fstsw ax
        sahf
        pop ax
        jc @f                       ; carry set if pi < angle (positive slope)
        
        bts word [ball.direction], d.bit.Y
        jmp .end
        
        @@:
        btr word [ball.direction], d.bit.Y
        
    .end:
        ret
 
; void nextPosition(void)
;
; Update the ball's X and Y values with respect to its slope and direction.
nextPosition:
    push ax
    
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
