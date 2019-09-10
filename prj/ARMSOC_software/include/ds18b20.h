#ifndef _ds18b20_H
#define _ds18b20_H

#include "systick.h"
#include "gpio.h"

void ds18b20init(void);
void ds18b20wr(uint8_t dat);
uint8_t ds18b20rd(void);
double readtemp(void);
#endif
