#ifndef __DE2_115_H
#define __DE2_115_H

#include <stdint.h>
#include <stdio.h>
#include "core_cm3.h"

typedef struct
{
  __IO   uint32_t  DATA;          /*!< Offset: 0x000 Data Register    (R/W) */
  __IO   uint32_t  STATE;         /*!< Offset: 0x004 Status Register  (R/W) */
  __IO   uint32_t  CTRL;          /*!< Offset: 0x008 Control Register (R/W) */
  
  __I    uint32_t  INTSTATUS;   /*!< Offset: 0x00C Interrupt Status Register (R/ ) */

  __IO   uint32_t  BAUDDIV;       /*!< Offset: 0x010 Baudrate Divider Register (R/W) */

} CM3DS_MPS2_UART_TypeDef;

#define APBPERIPH_BASE	((unsigned int)0x40000000)

#define GPIO_BASE	(APBPERIPH_BASE+0x0000)
#define UART0_BASE	(APBPERIPH_BASE+0x4000)
#define UART1_BASE	(APBPERIPH_BASE+0x5000)
#define UART2_BASE	(APBPERIPH_BASE+0x6000)

#define UART0             ((CM3DS_MPS2_UART_TypeDef   *) UART0_BASE   )
#define UART1             ((CM3DS_MPS2_UART_TypeDef   *) UART1_BASE   )
#define UART2             ((CM3DS_MPS2_UART_TypeDef   *) UART2_BASE   )
#define GPIO_DR		(unsigned int*)(GPIO_BASE+0x00) //out data register
#define GPIO_DDR	(unsigned int*)(GPIO_BASE+0x04) //direction data register
#define GPIO_CTL	(unsigned int*)(GPIO_BASE+0x08)
#define GPIO_INTEN	(unsigned int*)(GPIO_BASE+0x30)
#define GPIO_INTMASK	(unsigned int*)(GPIO_BASE+0x34)
#define GPIO_INTTYPE	(unsigned int*)(GPIO_BASE+0x38)
#define GPIO_INTPOL	(unsigned int*)(GPIO_BASE+0x3C)
#define GPIO_INTSTA	(unsigned int*)(GPIO_BASE+0x40)
#define GPIO_INTRAW	(unsigned int*)(GPIO_BASE+0x44)
#define GPIO_EOI	(unsigned int*)(GPIO_BASE+0x4C) //interrupt clear
#define GPIO_EXT	(unsigned int*)(GPIO_BASE+0x50) //pod data register
#define GPIO_SYNC	(unsigned int*)(GPIO_BASE+0x60) //level sensitive interrupt synchronization register

#endif
