#ifndef __Seven_Segment_Digit_H
#define __Seven_Segment_Digit_H

#include "DE2_115.h"
#include "gpio.h"

extern unsigned char table[];
extern unsigned char table1[];
extern unsigned char ssdi,ssdt,ssds;
extern unsigned char ssdil,ssdtl,ssdih,ssdth;


#define K_SHIFT GPIO_PIN_1
#define K_UP GPIO_PIN_2
#define K_DOWN GPIO_PIN_3

#define k_shift  bit_read( GPIO_EXT,K_SHIFT)
#define k_up   bit_read( GPIO_EXT,K_UP)
#define k_down bit_read( GPIO_EXT,K_DOWN)
void ssdsint(void);
void ssd(void);
void ssd1(void);
void ssdshift(void);
void ssduints(void);
void ssdtens(void);
uint8_t ssdiup(void);
uint8_t ssdidown(void);
uint8_t ssdtup(void);
uint8_t ssdtdown(void);

#endif
