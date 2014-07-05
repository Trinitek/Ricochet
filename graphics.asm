	
	
	; ==============================
	; ==============================
	macro unpackPcx destSeg, destOfs, sourceOfs, width, height
	; ARGS:
	; destSeg = segment to write to
	; destOfs = offset to write to
	; sourceOfs = offset where PCX image resides
	{
		local	proc_unpackPcx
		proc_unpackPcx:
		
		pusha
		
		mov		ax, destSeg			; setup destination pointer
		mov		es, ax
		mov		di, destOfs
		mov		si, sourceOfs		; setup source pointer
		mov		bx, (width * height) + destOfs
									; bx = pointer to last byte in destination
		mov		ch, 0				; use cl exclusively for REP instructions
		
		.nextByte:
			mov		cl, [si]
			cmp		cl, 0xC0
			jb		.plotPixel		; if byte is not a length byte, it's pixel data
			
			and		cl, 0x3F		; strip upper two bits
			
			inc		si				; next byte in source: pixel data
			lodsb
			rep		stosb
			
			jmp		.testEof
		
		.plotPixel:
			movsb
		
		.testEof:
			cmp		di, bx			; current destination offset == end of destination?
			jb		.nextByte
		
		popa
	}
	
	
	; ==============================
	; ==============================
	macro setPalette sourceOfs
	; ARGS:
	; sourceOfs = offset to RGB encoded palette data, expects 256 entries
	{
		local	proc_setPalette
		proc_setPalette:
		
		pusha
		
		mov		si, sourceOfs		; setup source pointer
		mov		dx, 0x3C8			; prepare VGA to accept new palette entries
		mov		al, 0
		out		dx, al
		inc		dx					; pipe data through port 0x3C9
		mov		cx, 256*3
		
		.palette:
			lodsb
			shr		al, 2			; 6 most significant bits only
			out		dx, al			; set RGB entry
			dec		cx
			jnz		.palette		; and loop until cx=0
		
		popa
	}
	
	
	; ==============================
	; ==============================
	macro drawSprite destSeg, sourceOfs, sheetWidth, width, height, xPos, yPos
	; ARGS:
	; destSeg = segment to write to
	; sourceOfs = offset to sprite in sprite sheet
	; sheetWidth = width of sprite sheet
	; width, height = dimensions of sprite
	; xPos, yPos = position to place on screen
	{
		pusha
		
		mov		ax, destSeg
		mov		es, ax
		mov		si, sourceOfs
		mov		dx, sheetWidth
		mov		bx, width
		mov		cx, height
		mov		di, xPos + (yPos * 200)
		
		call	proc_drawSprite
		
		popa
	}
	
	proc_drawSprite:
		
		; for (cx=height; cx>0; cx--)
		.nextLine:
			; bx = height
			; cx = width
			xchg	cx, bx
			
			; for (cx=width; cx>0; cx--)
			.nextPixel:
				rep		movsb	; current sprite line -> current video memory line
				loop	.nextPixel
				; cx = height
				; bx = width
				xchg	cx, bx
			
			add		si, dx		; si = sourceOfs + sheetWidth - width
			sub		si, bx
			
			add		di, 320		; di = destOfs + 320 - width
			sub		di, bx
			loop	.nextLine
		
		ret
	
	
	; ==============================
	; ==============================