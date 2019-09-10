
#define _MAIN_C_
////////////////////////////////////////////////////////////////////////////////
#include "ucos_ii.h"
#include "os_cpu.h"


#include "main.h"
#include <stdlib.h>
#include <stdio.h>
#include "gpio.h"
#include "UART.h"

//#include "IR.h"
#include "systick.h"
#include "DE2_115.h"
//#include "OLEDGUI.h"


char *cnt_d;
char *str;
char a[5];
unsigned int buff_size = 15;   //??????
unsigned int dat_count;    //????????
unsigned int buff_lenght;  //???????
unsigned char buff_useful;  //????????

unsigned char Read_buff[16];   //?????????
unsigned char *control = "";


INT32U  BSP_CPU_ClkFreq (void)
{
    return (25000000);
}

INT32U  OS_CPU_SysTickClkFreq (void)
{
    INT32U  freq;

//	RCC_ClocksTypeDef rcc_clocks;
//	RCC_GetClocksFreq(&rcc_clocks);

//	freq = (INT32U)rcc_clocks.HCLK_Frequency;
    freq = BSP_CPU_ClkFreq();
    return (freq);
}


static void startup_task(void *p_arg)
{

	OS_CPU_SR cpu_sr = 0;

	OS_CPU_SysTickInit();

#if (OS_TASK_STAT_EN > 0)
	OSStatInit();
#endif

	OS_ENTER_CRITICAL();				//???(????)

	OSTaskCreate(led1_task, (void *)0,
					   (OS_STK*)&LED1_TASK_STK[LED1_STK_SIZE - 1], LED1_TASK_PRIO);
	OSTaskCreate(led2_task, (void *)0,
					   (OS_STK*)&LED2_TASK_STK[LED2_STK_SIZE - 1], LED2_TASK_PRIO);
	OSTaskCreate(led3_task, (void *)0,
					   (OS_STK*)&LED3_TASK_STK[LED3_STK_SIZE - 1], LED3_TASK_PRIO);
	OSTaskSuspend(STARTUP_TASK_PRIO);  	//??
	OS_EXIT_CRITICAL();					//??

}


int main(void)
{
	bit_set(GPIO_DDR, GPIO_PIN_All, 0XFF);
	uart0init();
	OSInit();
	OSTaskCreate(startup_task, (void *)0,
				 (OS_STK*)&startup_task_stk[STARTUP_TASK_STK_SIZE - 1], STARTUP_TASK_PRIO);
	OSStart();
	return 0;

}


void led1_task(void *p_arg)
{
	while(1){

//	while((UART0->STATE & 2)==2)
//	{
//			for(int i =0 ;i<5;i++)
//		{
//			if(Uart0Getc() != '\n')
//				a[i] = Uart0Getc();
//			else 
//				a[i] = '\0';
//		}
//	}

//		
		
//			cnt_d =  Uart0GetLine(str);
//			while(cnt_d != 0)
//			{
//			Uart0Putc(str[cnt_d]);
//				cnt_d +=1;
//			}
			
//			a[0] = Uart0Getc();
//			a[1] = Uart0Getc();
//			a[2] = Uart0Getc();
//			a[3] = Uart0Getc();
//			a[4] = Uart0Getc();
//int i = 0;
//while(Uart0Getc()!= '\n') 
//{
//	a[i++]=Uart0Getc();
//	if(a[i] == '\n') break;
//}
//						for(int i = 0;i<5;i++)
//			{
//				a[i]=Uart0Getc();
//			}
//			while(Uart0Getc() != '\n');
//			for(int i = 0;i<5;i++)
//			{
//				Uart0Putc(a[i]);
//			}
			
		  while(Uart0Getc() != '0');
			OSTimeDly(500);
		  Uart0Putc('1');		
			OSTimeDly(500);
		
			while(Uart0Getc() != '2');
			OSTimeDly(500);
			Uart0Putc('3');
			OSTimeDly(500);
		
			while(Uart0Getc() != '4');
			OSTimeDly(500);
			Uart0Putc('1');
		
			while(Uart0Getc() != '2');
			OSTimeDly(500);
			Uart0Putc('1');
			OSTimeDly(500);
			
			while(Uart0Getc() != '2');
			OSTimeDly(500);
			Uart0Putc('5');
			OSTimeDly(500);
			
			for(int i = 0;i<5;i++)
			{
				a[i]=Uart0Getc();
			}
			while(Uart0Getc() != '\n');
			for(int i = 0;i<5;i++)
			{
				Uart0Putc(a[i]);
			}
			
	/*		
			while(Uart0Getc() != '\n')
			{
				
				str[cnt_d] = Uart0Getc();
				cnt_d += 1;
			}
			OSTimeDly(500);
			Uart0Putc(&str);
			OSTimeDly(500);
	*/		
			while(Uart0Getc() != '6');
			OSTimeDly(500);
			Uart0Putc('7');
			OSTimeDly(500);

			while(Uart0Getc() != '8');
			OSTimeDly(500);

			while(1);
	}
}
	
void led2_task(void *p_arg)
{
	while(1){

	  bit_set(GPIO_DR, GPIO_PIN_6, 0X00);
		OSTimeDly(500);
		bit_set(GPIO_DR, GPIO_PIN_6, 0X01);
		OSTimeDly(500);
		
		bit_read(GPIO_EXT,GPIO_PIN_0);
		bit_read(GPIO_EXT,GPIO_PIN_1);
		bit_read(GPIO_EXT,GPIO_PIN_2);
		bit_read(GPIO_EXT,GPIO_PIN_3);
		bit_read(GPIO_EXT,GPIO_PIN_5);
		bit_read(GPIO_EXT,GPIO_PIN_7);
		
			
	}
}


	void led3_task(void *p_arg)
{
	while(1){

	//	bit_set(GPIO_DR, GPIO_PIN_6, 0X00);
		
		  while(Uart1Getc() != 'a');
			OSTimeDly(500);
		  Uart1Putc('b');
				
			OSTimeDly(500);
			
		while(1);
			
	}
}
	
	//unsigned char inst, ch_get;

//	send_ir_info(55,88);
	
	 

