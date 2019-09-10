#ifndef __SYN6288_H
#define __SYN6288_H
#include "UART.h"
#include "DE2_115.h"

void SYN_FrameInfo(uint8_t Music,char *HZdata);
void YS_SYN_Set(char *Info_data);
void PrintCom(uint8_t *DAT,uint8_t len);

#endif
