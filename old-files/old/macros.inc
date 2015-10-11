macro getPalette index
	{
		if index > 15
			display index
			display "[MACRO] Warning: palette index out of range!"
		end if
		define colorPtr data_image.palette + (3 * index)
	}
	
macro pcxImage
	{
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
}