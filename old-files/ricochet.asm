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

	; spriteSheetPos = sourceOfs + xPos + (sheetWidth * yPos)
	define	sheet.ptr _dataSpriteSheet.image
	define	sheet.palette _dataSpriteSheet.palette
	define	sheet.width 117
	define	sheet.height 44
	
	define	splash.ptr 0
	define	splash.width 85
	define	splash.height 44
	
	define	transparent.ptr 85
	define	transparent.width 1
	define	transparent.height 1
	
	define	blockGreen.ptr 86
	define	blockGreen.width 20
	define	blockGreen.height 10

	include "bios_wrapper.inc"
	
	include "graphics.asm"
	
; ==============================
; === ENTRY POINT ==============
; ==============================

start:
		; preserve screen mode
		getScreenMode
		mov		di, _dataState.screenMode
		mov		[di], al
		
		; set screen mode to 0x13
		mov		al, 0x13
		setScreenMode

; ==============================
; === MAIN PROGRAM LOOP ========
; ==============================

main:
	
	;drawSprite 0xA000, _dataSprite.sprite, 5, 3, 30, 50
	;drawSprite 0xA000, _dataSprite.sprite2, 6, 9, 100, 100
	;drawSprite 0xA000, _dataSprite.sprite2, 6, 9, 200, 50
	;waitForKeystroke
	
	unpackPcx 0xA000, 0, _dataImageRes, 320, 200
	waitForKeystroke
	
	setPalette _dataImagePalette
	waitForKeystroke
	
	;drawSprite 0xA000, _dataSprite.sprite, 5, 3, 30, 50
	;drawSprite 0xA000, _dataSprite.sprite2, 6, 9, 100, 100
	;drawSprite 0xA000, _dataSprite.sprite2, 6, 9, 200, 50
	;waitForKeystroke
	
	unpackPcx ds, _dataBuffer, _dataSpriteSheet.image, 117, 44
	setPalette sheet.palette
	waitForKeystroke
	
	drawSprite 0xA000, splash.ptr, sheet.width, splash.width, splash.height, 100, 100
	waitForKeystroke

	jmp		exit

; ==============================
; === PROGRAM FUNCTION SECTION =
; ==============================

; ==========
exit:
	.restoreScreen:
		mov		di, _dataState.screenMode
		mov		al, byte [di]
		setScreenMode
	
	.return:
		;mov		ax, 0x4C00
		;int		0x21
		ret

; ==============================
; === PROCEDURE SECTION ========
; ==============================

; ==============================
; === DATA SECTION =============
; ==============================

_dataString:
	.buffer:
		db		50 dup 0
	.newLine:
		db		0x0D, 0x0A, 0

_dataState:
	.screenMode:
		db		?

_dataSpriteSheet:
	.image:
		file	"res\sprites.rle"
	.palette:
		file	"res\sprites.pal"

_dataImageRes:
		file	"res\fs1.rle"

_dataImagePalette:
		file	"res\fs1.pal"

_dataBuffer: