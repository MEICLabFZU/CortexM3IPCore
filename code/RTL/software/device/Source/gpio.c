#include "gpio.h"

void bit_set(unsigned int* GPIO_X, uint8_t GPIO_PIN, uint8_t flag)
{

	if(GPIO_PIN == 0Xff)
	{
		*GPIO_X = flag; 
	}
	else
	{
		if(flag==0x01)
		{
			*GPIO_X=*GPIO_X|GPIO_PIN;

		}
		if(flag==0x00)
		{
			GPIO_PIN=~GPIO_PIN;
			*GPIO_X=*GPIO_X&GPIO_PIN;
		}
  }
	
}

uint8_t bit_read(unsigned int* GPIO_X,uint8_t GPIO_PIN)
{
	uint8_t bitmask;
	uint8_t bitdata = 0xff;
	bitmask = *GPIO_X & GPIO_PIN;
	if(!bitmask)
	{
		bitdata = 0;
	}
	else
	{
		bitdata = 1;
	}
	return bitdata;
	
}
