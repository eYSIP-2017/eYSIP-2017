/*
 * _20170610_IR_PWM_Reciever.c
 *
 * Created: 10-06-2017 11:26:52
 *  Author: Hariharan
 */ 

#define F_CPU 14745600
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <math.h>
#include "lcd.c"
#include "dependency.c"
#include <string.h>

int main(void)
{
	init_devices1();	//To initiate the ports in the device
	init_devices0();	//To initiate the ports in the device
	init_devices2();	//To initiate the ports in the device
	init_devices3();
	lcd_set_4bit();		//To initialise lcd ports
	lcd_init();
	PORTH = PORTH | 0x08;
	int value = 0 ;
	char * str = "\0";
    int i;
	for(i=0;i<16;i++)
    {
		value = ADC_Conversion(6);
		lcd_print(2,1,value,3);
		if(value < 100)
			strcat(str,"0");
		else
			strcat(str,"1"); 	
    }
	lcd_cursor(1,1);
	lcd_string(str);	
}