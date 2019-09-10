#include "systick.h"
void delay_us(uint32_t i)
{
	int temp;
	SysTick->LOAD=25*i;		 //������װ��ֵ, 25MHZʱ
	SysTick->CTRL=0X05;		 //ʹ�ܣ����������޶���������25Mʱ��Դ
	SysTick->VAL=0;		   	 //���������
	do
	{
		temp=SysTick->CTRL;		   //��ȡ��ǰ������ֵ
	}
	while((temp&0x01)&&(!(temp&(1<<16))));	 //�ȴ�ʱ�䵽��
	SysTick->CTRL=0;	//�رռ�����
	SysTick->VAL=0;		//��ռ�����
}
void delay_ms(uint32_t i)
{
	int temp;
	SysTick->LOAD=25000*i;	  //������װ��ֵ, 25MHZʱ  ���671ms
	SysTick->CTRL=0X05;		//ʹ�ܣ����������޶����������ⲿʱ��Դ
	SysTick->VAL=0;			//���������
	do
	{
		temp=SysTick->CTRL;	   //��ȡ��ǰ������ֵ
	}
	while((temp&0x01)&&(!(temp&(1<<16))));	//�ȴ�ʱ�䵽��
	SysTick->CTRL=0;	//�رռ�����
	SysTick->VAL=0;		//��ռ�����
}
