#ifndef _VGA_H
#define _VGA_H
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "core_cm3.h"
#define VGAD (int*)0x80000000
void vgawr(uint32_t font);
void vgaprintfHZ(char *s , uint32_t l);
void vgaprintfSZ(double temp);

#endif

