#include "Seven_Segment_Digit.h"

/*unsigned char table[]={0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90};
unsigned char table1[]={0xc7,0x89};
unsigned char ssdi,ssdt,ssds;
unsigned char ssdil,ssdtl,ssdih,ssdth;*/

void ssdsint()
{
	ssds = 0;
	ssdil = 5;
	ssdtl = 1;
	ssdih = 5;
	ssdth = 3;
	ssdi = 5;
	ssdt = 1;
}

void ssd()
{
	if(ssds == 0)
	{
		ssdi = ssdil;
		ssdt = ssdtl;
	}
	if(ssds == 1)
	{
		ssdi = ssdih;
		ssdt = ssdth;
	}
}
void ssd1()
{
	if(ssds == 0)
	{
		ssdil = ssdi;
		ssdth = ssdt;
	}
	if(ssds == 1)
	{
		ssdih = ssdi;
		ssdth = ssdt;
	}
}



void ssdshift()
{
	uint8_t shift;
	shift = k_shift;
	if(shift == 0)
	{
		if(ssds == 1)
		{
			ssds = 0;
		}
		if(ssds == 0)
		{
			ssds = 1;
		}
	}
	bit_set(GPIO1_DDR, GPIO_PIN_All, 0xff);
	bit_set(GPIO1_DR, GPIO_PIN_All, table1[ssds]);
		
}

void ssduints()
{
	bit_set(GPIO2_DDR, GPIO_PIN_All, 0xff);
	bit_set(GPIO2_DR, GPIO_PIN_All, table[ssdi]);
	
}

void ssdtens()
{
	bit_set(GPIO3_DDR, GPIO_PIN_All, 0xff);
	bit_set(GPIO3_DR, GPIO_PIN_All, table[ssdt]);

}

uint8_t ssdiup()
{
	uint8_t up=0;
	up = k_up;
	if(up == 0)
	{
		if(ssdi == 9)
		{
			ssdi = 0;
		}
		else
		{
			ssdi++;
		}
	}
	return ssdi;

}

uint8_t ssdidown()
{
	uint8_t down=0;
	down = k_down;
	if(down == 0)
	{
		if(ssdi == 0)
		{
			ssdi = 9;
		}
		else
		{
			ssdi--;
		}
	}
	return ssdi;

}

uint8_t ssdtup()
{
	uint8_t tup=0;
	tup = k_up;
	if(ssdi == 9)
	{
		if(tup == 0)
		{
			if(ssdt == 9)
			{
				ssdt = 0;
			}
			else
			{
				ssdt++;
			}
		}
			
	}
	return ssdt;


}

uint8_t ssdtdown()
{
	uint8_t tdown=0;
	tdown = k_down;
	if(ssdi == 0)
	{
		if(tdown == 0)
		{
			if(ssdt == 0)
			{
				ssdt = 9;
			}
			else
			{
				ssdt--;
			}
		}
			
	}
	return ssdt;


}

