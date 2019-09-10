#include <stdint.h>
#include <stdio.h>
#include	<string.h>
#include  <stdlib.h>
#include "systick.h"
#include "ds18b20.h"
#include "gpio.h"



void CM3DS_MPS2_uart_SendChar(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART, char txchar)
 {
       while(CM3DS_MPS2_UART->STATE & 0X01);
       CM3DS_MPS2_UART->DATA = (uint32_t)txchar;
 }
 
 uint32_t CM3DS_MPS2_uart_GetBaudDivider(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART)
 {
       return CM3DS_MPS2_UART->BAUDDIV;
 }
 
void CM3DS_MPS2_uart_SetBaudDivider(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART , uint32_t divider)
 {
      CM3DS_MPS2_UART->BAUDDIV = divider;
 }
void CM3DS_MPS2_uart_SetCtrl(CM3DS_MPS2_UART_TypeDef *CM3DS_MPS2_UART , uint32_t ctrl)
 {
      CM3DS_MPS2_UART->CTRL = ctrl;
 }
int main(void)
{
	uint32_t divider;
	uint32_t ctrl;
	ctrl = 0x01;
	divider = 0x000C3;
	char txchar;
	txchar = 'a';
	CM3DS_MPS2_uart_SetCtrl(UART0 , ctrl);
	CM3DS_MPS2_uart_SetBaudDivider(UART0, divider);
	CM3DS_MPS2_uart_SendChar(UART0, txchar);
	txchar = 'b';
	CM3DS_MPS2_uart_SetCtrl(UART1 , ctrl);
	CM3DS_MPS2_uart_SetBaudDivider(UART1, divider);
	CM3DS_MPS2_uart_SendChar(UART1, txchar);
	txchar = 'c';
	CM3DS_MPS2_uart_SetCtrl(UART2 , ctrl);
	CM3DS_MPS2_uart_SetBaudDivider(UART2, divider);
	CM3DS_MPS2_uart_SendChar(UART2, txchar);
	//ds18b20wr(0xcc);
	//ds18b20wr(0x44);
	while(1);
}
