#include "OLEDGUI.h"
void put1(double temp)
{
	uint32_t i,j,k; 
	unsigned char number[6];
	//k = ((int )(temp*10))%10 + 0X30;
	i = ((int )temp)/10 + 0x30;
	j = ((int )temp)%10 + 0x30;
	
	
  number[0] = ':';
	delay_us(1);
  number[1] = i;
	delay_us(1);
  number[2] = j;
	delay_us(1);
  number[3] = '.';
	delay_us(1);
  number[4] = '0';
	delay_us(1);
	number[5] = '\0';
	delay_us(1);
	disp_string_8x16_16x16(0,0,"室内温度");
	delay_ms(1);
	display_string_8x16(0,33,number);
	delay_ms(1);
	disp(0,55);

}

void put2(double temp)
{
	uint32_t i,j,k; 
	unsigned char number[6];
	i = ((int )temp)/10 + 0x30;
	j = ((int )temp)%10 + 0x30;
	//k = ((int )(temp*10))%10 + 0X30;
	
  number[0] = ':';
	delay_us(1);
  number[1] = i;
	delay_us(1);
  number[2] = j;
	delay_us(1);
  number[3] = '.';
	delay_us(1);
  number[4] = '0';
	delay_us(1);
	number[5] = '\0';
	delay_us(1);
	disp_string_8x16_16x16(16,0,"室外温度");
	delay_ms(1);
	display_string_8x16(16,33,number);
	delay_ms(1);
	disp(16,55);
	
}

void put3()
{
	disp_string_8x16_16x16(32,0,"室内外温差较大");
	
}

void put4()
{
	disp_string_8x16_16x16(32,0,"室内外温差适宜");
	
}

void put5()
{
	disp_string_8x16_16x16(48,0,"注意保暖");
	
}

void put6()
{
	disp_string_8x16_16x16(48,0,"注意防暑");
	
}


