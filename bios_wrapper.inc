macro getScreenMode
; RETURN:
; ah = number of character columns
; al = video mode
{
	push	bx
	mov		ah, 0x0F
	int		0x10
	pop		bx
}

macro setScreenMode
; ARGS:
; al = video mode
{
	push	ax
	mov		ah, 0
	int		0x10
	pop		ax
}

macro getKeystroke
; RETURN:
; ah = BIOS scan code
; al = ASCII code
{
	mov		ah, 0x10
	int		0x16
}

macro waitForKeystroke
; RETURN:
; ah = BIOS scan code
; al = ASCII code
{
	local	getKey
	getKey:
		getKeystroke
		cmp		ax, 0
		jz		getKey
}