
/* Prototypes */
void waitForKey(void);
unsigned char getVideoMode(void);
void setVideoMode(unsigned char mode);
void plotPixel(unsigned char pixelData, unsigned short offset_ptr);
void drawSprite(unsigned short destBuffer_seg, unsigned short pixelData_ptr, unsigned short length, unsigned short height, unsigned short xPos, unsigned short yPos);

/* Memory pointers */
#define videoMemory_ptr 0xA000
//asm ("%define videoMemory_ptr 0xA000");

/* Global variables */
unsigned char initialVideoMode;

unsigned char sprite1[] = {5,5,5,5,5,  9,9,9,9,9, 5,5,5,5,5};

/* Main program */
void main(void)
{
	// set video mode
	initialVideoMode = getVideoMode();
	setVideoMode(0x13);
	
	// fill screen with gray background
	unsigned short i;
	for (i = 0; i < 65535u; i++)
	{
		plotPixel(8, i);
	}
	
	// draw sprite
	drawSprite(0xA000, sprite1, 5u, 3u, 30u, 25u);
	
	// pause
	waitForKey();
	
	// exit to operating system
	setVideoMode(initialVideoMode);
	return;
}

void waitForKey(void)
{
	asm("xor ax, ax");
	asm("int 0x16");
}

/** return the current video mode */
unsigned char getVideoMode(void)
{
	asm("mov ah, 0x0F \n"
		"int 0x10 \n"
		"mov ah, 0 ");
}

/** set the video mode to the passed mode number */
void setVideoMode(unsigned char mode)
{
	asm("push ax \n"
		"mov al, [bp + 4] \n"
		"mov ah, 0 \n"
		"int 0x10 \n"
		"pop ax ");
}

/** plot an array of pictures to video memory */
void plotPixel(unsigned char pixelData, unsigned short offset_ptr)
{
	asm("push ax \n"
		"push es \n"
		"push di \n"
		
		"push 0xA000 \n"
		"pop es \n"
		"mov di, [bp + 6] \n"
		"mov al, [bp + 4] \n"
		"stosb \n"
		
		"pop di \n"
		"pop es \n"
		"pop ax ");
}

void drawSprite(unsigned short destBuffer_seg, unsigned short pixelData_ptr, unsigned short length, unsigned short height, unsigned short xPos, unsigned short yPos)
{
	// calculate the offset from the X Y positions
	unsigned short destBuffer_ptr = 320u * yPos + xPos;
	
	// setup destination pointer
	asm("push ax \n"
	
		"mov ax, [bp + 4] \n"
		"mov es, ax \n"
		
		"pop ax \n"
		
		"mov di, [bp - 2] "); // refers to destBuffer_ptr
	
	unsigned short hPos, lPos;
	
	for (hPos = 0; hPos < height; hPos++)
	{
		for (lPos = 0; lPos < length; lPos++)
		{
			asm("push si \n"
				"push ax \n"
				"push cx \n"
				
				"mov si, [bp + 6] \n"
				"mov al, [si] \n"
				"stosb \n"
				
				"pop cx \n"
				"pop ax \n"
				"pop si ");
			
			pixelData_ptr++; // next pixel
		}
		
		destBuffer_ptr = destBuffer + 320 - length;
	}
}