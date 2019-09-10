#include "vga.h"

void vgawr(uint32_t font)
{
	*VGAD = font;
}

void vgaprintfHZ(char *s , uint32_t l)
{
	int i;
	for(i=0;i<l;i=i+2)
	{
		int b;
		b = ((int)s[i]<<8) + (int)s[i+1];
		*VGAD = b;
	}
	 
}
	
void vgaprintfSZ(double temp)
	{
		int h,t,u;
		h = (int)(temp*100);
		t = h/100;
		u = h%100;
		*VGAD = t/10 + 48;
		*VGAD = t%10 + 48;
		*VGAD = 0X2E;
		*VGAD = u/10 + 48;
		*VGAD = u%10 + 48;
	}
