; ===
; === RICOCHET - A Breakout-like clone
; === Blake Burgess
; === March - April 2014
; ===

	org		0x100				; MS-DOS program
	
	jmp		start

; ==============================
; === INCLUDES AND SYMBOLS =====
; ==============================

	; Only need to import the procedures necessary. Macros within the includes can be used without
	; importing them first.
	
	macro import function {function}
	
	include	"screen.asm"
	include "string.asm"
		import	string.numberToString
		import	string.teletype
		import	string.reverse
	
	;include "keyboard.asm"
	;	import	keyboard.inputString
	;	import	keyboard.waitForKey
	
	;cursor.xPos	equ dl
	;cursor.yPos	equ dh
	;start.xPos	equ 20
	;start.yPos	equ 12
	;promptColor	equ 0x1F		; white on blue text
	;fieldColor	equ 0x2F		; white on green text
	;paintColor	equ 0x4F		; white on red text
	;turtleFace	equ 0x02		; filled smiley face
	
	;define paletteColor 0
	
	include "macros.inc"
	
; ==============================
; === ENTRY POINT ==============
; ==============================

start:
	.getScreenInfo:
		screen.getMode
		mov		di, data_state.screenMode
		mov		[di], al			; preserve screen mode
	
	.setScreenMode:
		mov		al, screen.mode.text.4025
		screen.setMode				; set screen to 40x25 text, 16 colors

; ==============================
; === MAIN PROGRAM LOOP ========
; ==============================

main:
	getPalette 5
	mov		ax, colorPtr
	mov		di, data_string.buffer
	call	string.numberToString
	mov		si, di
	call	string.teletype
	mov		si, data_string.newLine
	call	string.teletype
	
	getPalette 6
	mov		ax, colorPtr
	mov		di, data_string.buffer
	call	string.numberToString
	mov		si, di
	call	string.teletype
	mov		si, data_string.newLine
	call	string.teletype
	
	getPalette 14
	mov		ax, colorPtr
	mov		di, data_string.buffer
	call	string.numberToString
	mov		si, di
	call	string.teletype
	mov		si, data_string.newLine
	call	string.teletype

	jmp		exit.return

; ==============================
; === PROGRAM FUNCTION SECTION =
; ==============================

; ==========
exit:
	.restoreScreen:
		mov		di, data_state.screenMode
		mov		al, byte [di]
		screen.setMode
	
	.return:
		mov		ax, 0x4C00
		int		0x21

; ==============================
; === PROCEDURE SECTION ========
; ==============================

; ==============================
; === DATA SECTION =============
; ==============================

data_string:
	.buffer:
		db		50 dup 0
	.newLine:
		db		0x0D, 0x0A, 0

data_state:
	.screenMode:
		db		0xFF

data_image:
	.manufacturer:	rb	0
	.version:		rb	0
	.encoding:		rb	0
	.bitsPerPlane:	rb	0
	
	.xMin:			rw	0
	.yMin:			rw	0
	.xMax:			rw	0
	.yMax:			rw	0
	
	.vertDPI:		rw	0
	.horizDPI:		rw	0
	
	.palette:
		repeat 48
			rb	0
		end repeat
		
	.reserved:		rb	0
	
	.colorPlanes:	rb	0
	.bytesPerLine:	rw	0
	.paletteType:	rw	0
	
	.horizScrSize:	rw	0
	.vertScrSize:	rw	0
	
		repeat	54
			rw	0
		end repeat
	
	.image:
		file	"ricochet_pcx.pcx"

	guardian:
		pcxImage
		file "Guardian_1.png"