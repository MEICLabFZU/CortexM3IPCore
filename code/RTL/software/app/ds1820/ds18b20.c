#include "ds18b20.h"

void   ds18b20init()
{
	bit_set(GPIO_DDR, GPIO_PIN_0, 0x01);	 //输出状态
	bit_set(GPIO_DR, GPIO_PIN_0, 0x00);		//主动拉低 至少480us
	delay_us(500);
	bit_set(GPIO_DDR, GPIO_PIN_0, 0x00);	//电阻上拉状态，等80us DS18B20 会发出拉低信号，然后再等至少400us	
	delay_us(500);
}

void ds18b20wr(uint8_t dat)
{
	
	uint8_t i=0;
	bit_set(GPIO_DDR, GPIO_PIN_0, 0x01);	  //输出模式，主动拉低
	for(i=0;i<8;i++)
	{
		bit_set(GPIO_DR, GPIO_PIN_0, 0x00);		//拉低大于1us 数据就可以传输了
		delay_us(10);													//DS18B20会在15us后采集总线数据
		
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
		bit_set(GPIO_DDR, GPIO_PIN_0, 0x01); //输出配置
		bit_set(GPIO_DR, GPIO_PIN_0, 0x00);	//主动拉低
		delay_us(4);												//延时大于1us就行
		bit_set(GPIO_DDR, GPIO_PIN_0, 0x00);	  //输入配置
		delay_us(10);												//大于10us
		if(((*GPIO_EXT) & (0x00000001))== 0x00000001)
		{
			value|=0x80;
		}
		delay_us(45);	//等至少45us
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
