proc_drawSprite:
		pusha
	.unpack:
		define	destSeg		[bp + 10]
		define	sourceOfs	[bp + 8]
		define	width		[bp + 6]
		define	height		[bp + 4]
		define	xPos		[bp + 2]
		define	yPos		[bp]
		
		mov		si, sourceOfs
		mov		ax, destSeg
		mov		es, ax
	
	.calcOffset:
		xor		dx, dx						; reset DX for multiplication
		mov		ax, word yPos
		mov		bx, 320
		mul		bx							; ax = yPos * 320
		mov		bx, word xPos
		add		ax, bx						; ax += xPos
		mov		di, ax						; destOfs = ax
	
	; FOR (current_yPos = height; current_yPos > 0; current_yPos--)
		mov		cx, word height
	.nextY:
		push	cx
		
		; FOR (current_xPos = width; current_xPos > 0; current_xPos--)
		.nextX:
			mov		cx, word width
			rep		movsb
		
		add		di, 320
		mov		ax, word width
		sub		di, ax
		
		pop		cx
		loop	.nextY
	
	.return:
		popa
		ret



;proc_unpackPcx:
;		pusha
;	.unpack:
;		define destSeg		[bp + 4]
;		define destOfs		[bp + 2]
;		define sourceOfs	[bp]
;		
;		mov		si, sourceOfs
;		mov		ax, destSeg
;		mov		es, ax
;		mov		di, destOfs
;		mov		dx, di
;	
;	.calcResolution:
;		define width		[si + .h.xMax - .header]
;		define height		[si + .h.yMax - .header]
;		define bytesPerLine	[si + .h.bytesPerPlaneLine - .header]
;		define imageOffset	[si + .image - .header]
;		
;		; bx = width * height
;		mov		ax, width
;		mul		word height
;		mov		bx, ax
;		
;		mov		si, imageOffset
;		mov		ch, 0		; use CL exclusively for REP ??? instructions
;	
;	.nextByte:
;		mov		cl, [si]
;		cmp		cl, 0x0C
;		jb		.plotPixel	; if byte is not a valid length byte, copy it
;		
;		and		cl, 0x3F	; strip two upper bits
;		inc		si			; next byte in sourceOfs, color byte
;		lodsb
;		rep		stosb		; plot pixels
;		
;		jmp		.test
;	
;	.plotPixel:
;		movsb
;	
;	.test:
;		cmp		di, bx + dx	; test for end of image (currentDestOfs <?> resolution + baseDestOfs)
;		jb		.nextByte
;	
;	.return:
;		popa
;		ret
;	
;	.header:
;	.h.manufacturer			rb 1
;	.h.version				rb 1
;	.h.encoding				rb 1
;	.h.bitsPerPlane			rb 1
;	.h.xMin					rw 1
;	.h.yMin					rw 1
;	.h.xMax					rw 1
;	.h.yMax					rw 1
;	.h.vertDpi				rw 1
;	.h.horizDpi				rw 1
;	.h.palette				rb 48
;	.h.reserved				rb 1
;	.h.colorPlanes			rb 1
;	.h.bytesPerPlaneLine	rw 1
;	.h.paletteType			rw 1
;	.h.hScrSize				rw 1
;	.h.vScrSize				rw 1
;	.h.padding				rb 54
;	.image: