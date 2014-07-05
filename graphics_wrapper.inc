macro drawSprite destSeg, sourceOfs, width, height, xPos, yPos
; ARGS:
; destSeg = segment to write to
; width, height = dimensions of sprite
; xPos, yPos = position to place on screen
{
	push	bp					; save original value of BP
	
	push	destSeg				; pack arguments
	push	sourceOfs
	push	width
	push	height
	push	xPos
	push	yPos
	
	mov		bp, sp				; BP = current stack position
	
	call	proc_drawSprite
	
	add		sp, 12				; restore SP's position
	pop		bp					; restore original value of BP
}

;macro unpackPcx destSeg, destOfs, sourceOfs
;; ARGS:
;; destSeg = segment to write to
;; destOfs = offset to write to
;; sourceOfs = offset where PCX image resides
;{
;	push	bp
;	
;	push	destSeg
;	push	destOfs
;	push	sourceOfs
;	
;	mov		bp, sp
;	
;	call	proc_unpackPcx
;	
;	add		sp, 6
;	pop		bp
;}