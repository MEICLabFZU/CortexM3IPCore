#include "gpio.h"
#include "systick.h"

void IR_init(void)
{
				bit_set(GPIO_DDR, GPIO_PIN_7, 1);
				bit_set(GPIO_DR, GPIO_PIN_7, 1);
}



void send_d0(void)       //???0,????????
{
        bit_set(GPIO_DR, GPIO_PIN_7, 0);
        delay_us(560);
        bit_set(GPIO_DR, GPIO_PIN_7, 1);
        delay_us(560);
}
void send_d1(void) //???1,????????
{
        bit_set(GPIO_DR, GPIO_PIN_7, 0);
        delay_us(560);
        bit_set(GPIO_DR, GPIO_PIN_7, 1);
        delay_us(1680);
}
void send_ir_byte(uint8_t tp)   //send a byte
{
        uint8_t i;
        for(i=0;i<8;i++)
        {
                if(tp&0x80)
                {
                       send_d1();
                }
                else 
                {
                       send_d0();
                }
                tp<<=1;      //????????
        }
}
void ir_start(void)         //NEC???????
{
        bit_set(GPIO_DR, GPIO_PIN_7, 0);
        delay_ms(9);
        bit_set(GPIO_DR, GPIO_PIN_7, 1);
        delay_ms(4.5);
}
void send_ir_info(uint8_t IR_USER_CODE, uint8_t key)    //????????????
{
        IR_init();          //???GPIO
        ir_start();                        //NEC??


        send_ir_byte(IR_USER_CODE);    //???
        send_ir_byte(~IR_USER_CODE);   //?????
        send_ir_byte(key);                      //???
        send_ir_byte(~key);                    //?????


        bit_set(GPIO_DR, GPIO_PIN_7, 0);
        delay_us(560);   //??????????????,?????


        bit_set(GPIO_DR, GPIO_PIN_7, 1); //??????
}

