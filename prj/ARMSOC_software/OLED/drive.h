#ifndef __DRIVE_H
#define __DRIVE_H			 
#include "stdlib.h"
#include "core_cm3.h"
#include "gpio.h"

void OLED_WriteReg(uint8_t data);
void OLED_WriteData(uint8_t Data);
void OLED_InitReg(void); //有可能存在问题
void OLED_SetCursor(uint16_t Xpoint, uint16_t Ypoint );
void OLED_SetContrast(uint16_t arr);//对比度
void transfer_col_data(unsigned char data1,unsigned char data2);//纯黑白 两列 八行
void transfer_col_data2(unsigned char data1,unsigned char data2,unsigned char gray_value);//自定义灰度 两列 八行
void display_string_8x16(uint8_t row,uint8_t column,uint8_t *text);//8X16 字符
void display_string_16x16(uint8_t row,uint8_t column,uint8_t *text);//16X16 汉字
void disp(uint8_t row,uint8_t column);
void disp_string_8x16_16x16(uint8_t row,uint8_t column,uint8_t *text);
void clear_screen(void);
void put1(double temp);
void put2(double temp);
void put3(void);
void put4(void);
void put5(void);
void put6(void);



#endif 
