/*
 * _20170610_IR_PWM.c
 *
 * Created: 10-06-2017 11:09:24
 *  Author: Hariharan
 */ 

#define F_CPU 14745600
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <math.h>
#include "lcd.c"
#include "dependency.c"

void turn_on_ir_proximity()
{
	PORTH = PORTH & 0xF7;
} 
void turn_off_ir_proximity()
{
	PORTH = PORTH | 0x08;
}
int main(void)
{
	lcd_set_4bit();		//To initialise lcd ports
	lcd_init();
    while(1)
    {
       turn_off_ir_proximity();
	   _delay_ms(5000);
	   turn_on_ir_proximity();
	   _delay_ms(5000); 
    }
}