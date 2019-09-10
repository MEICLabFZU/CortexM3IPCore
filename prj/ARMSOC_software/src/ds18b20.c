#include "ds18b20.h"

void   ds18b20init()
{
	bit_set(GPIO_DDR, GPIO_PIN_0, 0x01);	  
	bit_set(GPIO_DR, GPIO_PIN_0, 0x00);
	delay_us(500);
	bit_set(GPIO_DDR, GPIO_PIN_0, 0x00);	
	delay_us(500);
}

void ds18b20wr(uint8_t dat)
{
	
	uint8_t i=0;
	bit_set(GPIO_DDR, GPIO_PIN_0, 0x01);	  
	for(i=0;i<8;i++)
	{
		bit_set(GPIO_DR, GPIO_PIN_0, 0x00);
		delay_us(10);					
		
		if((dat&0x01)==1)
		{
		   	bit_set(GPIO_DR, GPIO_PIN_0, 0x01);
		}
		else
		{
			bit_set(GPIO_DR, GPIO_PIN_0, 0x00);	
		}
		delay_us(60);
		bit_set(GPIO_DR, GPIO_PIN_0, 0x01);
		dat>>=1;
	}
}

uint8_t ds18b20rd()
{
	uint8_t i=0,value=0;
	for(i=0;i<8;i++)
	{
		value>>=1;
		bit_set(GPIO_DDR, GPIO_PIN_0, 0x01); // ‰≥ˆ≈‰÷√
		bit_set(GPIO_DR, GPIO_PIN_0, 0x00);
		delay_us(4);
		bit_set(GPIO_DDR, GPIO_PIN_0, 0x00);	  // ‰»Î≈‰÷√
		delay_us(10);	
		if(((*GPIO_EXT) & (0x01))== 0x01)
		{
			value|=0x80;
		}
		delay_us(60);	
	}
	return value;
}

double readtemp()
{
	uint8_t a,b;
	uint16_t temp;
	double value;
	ds18b20init();
	ds18b20wr(0xcc);
	ds18b20wr(0x44);
	delay_ms(400);
	delay_ms(400);
	
	ds18b20init();
	ds18b20wr(0xcc);
	ds18b20wr(0xbe);
	a=ds18b20rd();
	b=ds18b20rd();
	temp=b;
	temp=(temp<<8)+a;
	if((temp&0xf800)==0xf800)
	{
		temp=(~temp)+1;
		value=temp*(-0.0625);
	}
	else
	{
		value=temp*(0.0625);	
	}
	return value;				
}
