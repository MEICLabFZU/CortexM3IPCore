#ifndef __GPIO_H
#define __GPIO_H

#include "DE2_115.h"

#define GPIO_PIN_0	((uint8_t)0x01)	/*!< Pin 0 selected */
#define GPIO_PIN_1	((uint8_t)0x02)	/*!< Pin 1 selected */
#define GPIO_PIN_2	((uint8_t)0x04)	/*!< Pin 2 selected */
#define GPIO_PIN_3	((uint8_t)0x08)	/*!< Pin 3 selected */
#define GPIO_PIN_4	((uint8_t)0x10)	/*!< Pin 4 selected */
#define GPIO_PIN_5	((uint8_t)0x20)	/*!< Pin 5 selected */
#define GPIO_PIN_6	((uint8_t)0x40)	/*!< Pin 6 selected */
#define GPIO_PIN_7	((uint8_t)0x80)	/*!< Pin 7 selected */
#define GPIO_PIN_All    ((uint8_t)0xFF) /*!< All pins selected */

void bit_set(unsigned int* GPIO_X, uint8_t GPIO_PIN, uint8_t flag);
uint8_t bit_read(unsigned int* GPIO_X,uint8_t GPIO_PIN);
#endif
