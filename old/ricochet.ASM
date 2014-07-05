SEGMENT _TEXT PUBLIC CLASS=CODE USE16
SEGMENT _DATA PUBLIC CLASS=DATA

; glb waitForKey : (void) void
; glb getVideoMode : (void) unsigned char
; glb setVideoMode : (
; prm     mode : unsigned char
;     ) void
; glb plotPixel : (
; prm     pixelData : unsigned char
; prm     offset_ptr : unsigned
;     ) void
; glb drawSprite : (
; prm     destBuffer_seg : unsigned
; prm     pixelData_ptr : unsigned
; prm     length : unsigned
; prm     height : unsigned
; prm     xPos : unsigned
; prm     yPos : unsigned
;     ) void
; glb initialVideoMode : unsigned char
SEGMENT _DATA
	global	_initialVideoMode
_initialVideoMode:
	times	1 db 0
; SEGMENT _DATA
; glb sprite1 : [0u] unsigned char
SEGMENT _DATA
	global	_sprite1
_sprite1:
; =
; RPN'ized expression: "5 "
; Expanded expression: "5 "
; Expression value: 5
	db	5
; RPN'ized expression: "5 "
; Expanded expression: "5 "
; Expression value: 5
	db	5
; RPN'ized expression: "5 "
; Expanded expression: "5 "
; Expression value: 5
	db	5
; RPN'ized expression: "5 "
; Expanded expression: "5 "
; Expression value: 5
	db	5
; RPN'ized expression: "5 "
; Expanded expression: "5 "
; Expression value: 5
	db	5
; RPN'ized expression: "9 "
; Expanded expression: "9 "
; Expression value: 9
	db	9
; RPN'ized expression: "9 "
; Expanded expression: "9 "
; Expression value: 9
	db	9
; RPN'ized expression: "9 "
; Expanded expression: "9 "
; Expression value: 9
	db	9
; RPN'ized expression: "9 "
; Expanded expression: "9 "
; Expression value: 9
	db	9
; RPN'ized expression: "9 "
; Expanded expression: "9 "
; Expression value: 9
	db	9
; RPN'ized expression: "5 "
; Expanded expression: "5 "
; Expression value: 5
	db	5
; RPN'ized expression: "5 "
; Expanded expression: "5 "
; Expression value: 5
	db	5
; RPN'ized expression: "5 "
; Expanded expression: "5 "
; Expression value: 5
	db	5
; RPN'ized expression: "5 "
; Expanded expression: "5 "
; Expression value: 5
	db	5
; RPN'ized expression: "5 "
; Expanded expression: "5 "
; Expression value: 5
	db	5
; SEGMENT _DATA
; glb main : (void) void
SEGMENT _TEXT
	global	_main
_main:
	push	bp
	mov	bp, sp
	jmp	L2
L1:
; RPN'ized expression: "initialVideoMode ( getVideoMode ) = "
; Expanded expression: "initialVideoMode  getVideoMode ()0 =(1) "
; Fused expression:    "( getVideoMode )0 =(154) *initialVideoMode ax "
	call	_getVideoMode
	mov	[_initialVideoMode], al
	mov	ah, 0
; RPN'ized expression: "( 19 setVideoMode ) "
; Expanded expression: " 19  setVideoMode ()2 "
; Fused expression:    "( 19 , setVideoMode )2 "
	push	19
	call	_setVideoMode
	sub	sp, -2
; loc     i : (@-2): unsigned
; for
; RPN'ized expression: "i 0 = "
; Expanded expression: "(@-2) 0 =(2) "
; Fused expression:    "=(170) *(@-2) 0 "
	mov	ax, 0
	mov	[bp-2], ax
L5:
; RPN'ized expression: "i 65535u < "
; Expanded expression: "(@-2) *(2) 65535u <u "
; Fused expression:    "<u *(@-2) 65535u IF! "
	mov	ax, [bp-2]
	cmp	ax, -1
	jae	L8
	jmp	L7
L6:
; RPN'ized expression: "i ++p "
; Expanded expression: "(@-2) ++p(2) "
; Fused expression:    "++p(2) *(@-2) "
	mov	ax, [bp-2]
	inc	word [bp-2]
	jmp	L5
L7:
; {
; RPN'ized expression: "( i , 8 plotPixel ) "
; Expanded expression: " (@-2) *(2)  8  plotPixel ()4 "
; Fused expression:    "( *(2) (@-2) , 8 , plotPixel )4 "
	push	word [bp-2]
	push	8
	call	_plotPixel
	sub	sp, -4
; }
	jmp	L6
L8:
; RPN'ized expression: "( 25u , 30u , 3u , 5u , sprite1 , 40960u drawSprite ) "
; Expanded expression: " 25u  30u  3u  5u  sprite1  40960u  drawSprite ()12 "
; Fused expression:    "( 25u , 30u , 3u , 5u , sprite1 , 40960u , drawSprite )12 "
	push	25
	push	30
	push	3
	push	5
	push	_sprite1
	push	-24576
	call	_drawSprite
	sub	sp, -12
; RPN'ized expression: "( waitForKey ) "
; Expanded expression: " waitForKey ()0 "
; Fused expression:    "( waitForKey )0 "
	call	_waitForKey
; RPN'ized expression: "( initialVideoMode setVideoMode ) "
; Expanded expression: " initialVideoMode *(1)  setVideoMode ()2 "
; Fused expression:    "( *(1) initialVideoMode , setVideoMode )2 "
	mov	al, [_initialVideoMode]
	mov	ah, 0
	push	ax
	call	_setVideoMode
	sub	sp, -2
; return
	jmp	L3
; Fused expression:    "0 "
	mov	ax, 0
L3:
	leave
	ret
L2:
	sub	sp, 2
	jmp	L1
; SEGMENT _TEXT
; glb waitForKey : (void) void
SEGMENT _TEXT
	global	_waitForKey
_waitForKey:
	push	bp
	mov	bp, sp
	jmp	L10
L9:
xor ax, ax
int 0x16
L11:
	leave
	ret
L10:
	jmp	L9
; SEGMENT _TEXT
; glb getVideoMode : (void) unsigned char
SEGMENT _TEXT
	global	_getVideoMode
_getVideoMode:
	push	bp
	mov	bp, sp
	jmp	L14
L13:
mov ah, 0x0F 
int 0x10 
mov ah, 0 
L15:
	leave
	ret
L14:
	jmp	L13
; SEGMENT _TEXT
; glb setVideoMode : (
; prm     mode : unsigned char
;     ) void
SEGMENT _TEXT
	global	_setVideoMode
_setVideoMode:
	push	bp
	mov	bp, sp
	jmp	L18
L17:
; loc     mode : (@4): unsigned char
push ax 
mov al, [bp + 4] 
mov ah, 0 
int 0x10 
pop ax 
L19:
	leave
	ret
L18:
	jmp	L17
; SEGMENT _TEXT
; glb plotPixel : (
; prm     pixelData : unsigned char
; prm     offset_ptr : unsigned
;     ) void
SEGMENT _TEXT
	global	_plotPixel
_plotPixel:
	push	bp
	mov	bp, sp
	jmp	L22
L21:
; loc     pixelData : (@4): unsigned char
; loc     offset_ptr : (@6): unsigned
push ax 
push es 
push di 
push 0xA000 
pop es 
mov di, [bp + 6] 
mov al, [bp + 4] 
stosb 
pop di 
pop es 
pop ax 
L23:
	leave
	ret
L22:
	jmp	L21
; SEGMENT _TEXT
; glb drawSprite : (
; prm     destBuffer_seg : unsigned
; prm     pixelData_ptr : unsigned
; prm     length : unsigned
; prm     height : unsigned
; prm     xPos : unsigned
; prm     yPos : unsigned
;     ) void
SEGMENT _TEXT
	global	_drawSprite
_drawSprite:
	push	bp
	mov	bp, sp
	jmp	L26
L25:
; loc     destBuffer_seg : (@4): unsigned
; loc     pixelData_ptr : (@6): unsigned
; loc     length : (@8): unsigned
; loc     height : (@10): unsigned
; loc     xPos : (@12): unsigned
; loc     yPos : (@14): unsigned
; loc     destBuffer_ptr : (@-2): unsigned
; RPN'ized expression: "destBuffer_ptr 320u yPos * xPos + = "
; Expanded expression: "(@-2) 320u (@14) *(2) * (@12) *(2) + =(2) "
; Fused expression:    "* 320u *(@14) + ax *(@12) =(170) *(@-2) ax "
	mov	ax, 320
	mul	word [bp+14]
	add	ax, [bp+12]
	mov	[bp-2], ax
push ax 
mov ax, [bp + 4] 
mov es, ax 
pop ax 
mov di, [bp - 2] 
; loc     hPos : (@-4): unsigned
; loc     lPos : (@-6): unsigned
; for
; RPN'ized expression: "hPos 0 = "
; Expanded expression: "(@-4) 0 =(2) "
; Fused expression:    "=(170) *(@-4) 0 "
	mov	ax, 0
	mov	[bp-4], ax
L29:
; RPN'ized expression: "hPos height < "
; Expanded expression: "(@-4) *(2) (@10) *(2) <u "
; Fused expression:    "<u *(@-4) *(@10) IF! "
	mov	ax, [bp-4]
	cmp	ax, [bp+10]
	jae	L32
	jmp	L31
L30:
; RPN'ized expression: "hPos ++p "
; Expanded expression: "(@-4) ++p(2) "
; Fused expression:    "++p(2) *(@-4) "
	mov	ax, [bp-4]
	inc	word [bp-4]
	jmp	L29
L31:
; {
; for
; RPN'ized expression: "lPos 0 = "
; Expanded expression: "(@-6) 0 =(2) "
; Fused expression:    "=(170) *(@-6) 0 "
	mov	ax, 0
	mov	[bp-6], ax
L33:
; RPN'ized expression: "lPos length < "
; Expanded expression: "(@-6) *(2) (@8) *(2) <u "
; Fused expression:    "<u *(@-6) *(@8) IF! "
	mov	ax, [bp-6]
	cmp	ax, [bp+8]
	jae	L36
	jmp	L35
L34:
; RPN'ized expression: "lPos ++p "
; Expanded expression: "(@-6) ++p(2) "
; Fused expression:    "++p(2) *(@-6) "
	mov	ax, [bp-6]
	inc	word [bp-6]
	jmp	L33
L35:
; {
push si 
push ax 
push cx 
mov si, [bp + 6] 
mov al, [si] 
stosb 
pop cx 
pop ax 
pop si 
; RPN'ized expression: "pixelData_ptr ++p "
; Expanded expression: "(@6) ++p(2) "
; Fused expression:    "++p(2) *(@6) "
	mov	ax, [bp+6]
	inc	word [bp+6]
; }
	jmp	L34
L36:
add di, 320 
sub di, [bp - 8]
; }
	jmp	L30
L32:
L27:
	leave
	ret
L26:
	sub	sp, 6
	jmp	L25
; SEGMENT _TEXT


; Syntax/declaration table/stack:
; Bytes used: 848/20736


; Macro table:
; Macro __SMALLER_C__ = `0x0100`
; Macro __SMALLER_C_16__ = ``
; Macro __SMALLER_C_SCHAR__ = ``
; Macro videoMemory_ptr = `0xA000`
; Bytes used: 87/4096


; Identifier table:
; Ident waitForKey
; Ident <something>
; Ident getVideoMode
; Ident setVideoMode
; Ident mode
; Ident plotPixel
; Ident pixelData
; Ident offset_ptr
; Ident drawSprite
; Ident destBuffer_seg
; Ident pixelData_ptr
; Ident length
; Ident height
; Ident xPos
; Ident yPos
; Ident initialVideoMode
; Ident sprite1
; Ident main
; Bytes used: 197/4752

; Next label number: 37
; Compilation succeeded.
