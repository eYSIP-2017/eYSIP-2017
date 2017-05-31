/*
 * _20170530_1452_RandevousProblem.c
 *
 * Created: 30-05-2017 14:53:02
 *  Author: Hariharan
 */ 

#define F_CPU 14745600
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <math.h>
#include "lcd.c"
#include "dependency.c"

#define PI 3.14159265

void get_sensor_values(int * array)
{
	array[0] = ADC_Conversion(6);
	array[1] = ADC_Conversion(5);
	array[2] = ADC_Conversion(4);
	array[3] = 150;
	array[4] = 150;
	array[5] = 150;
	array[6] = ADC_Conversion(8);
	array[7] = ADC_Conversion(7);
	
	/* array[0] = 150;
	array[1] = 150;
	array[2] = 40;
	array[3] = 150;
	array[4] = 150;
	array[5] = 150;
	array[6] = 150;
	array[7] = 150; */
	return;
}
int attan(int x, int y)
{
	if(x == 0 && y > 0)
	{
		return 90;
	}
	else if(x == 0 && y < 0)
	{
		return 270;
	}
	else
	{
		return atan(y/x) * 180 / PI;
	}
}
int find_centroid(int * sensor_values,int * centroid)
{
	int x = 0;
	int y = 0;
	int i;
	int counter = 0;
	for(i=0;i<8;i++)
	{
		if(sensor_values[i] < 100)
		{
			// printf("%f %f\n", sensor_values[i] * cos(i * 45 * PI / 180), sensor_values[i] * sin(i * 45 * PI / 180));
			x += sensor_values[i] * cos(i * 45 * PI / 180);
			y += sensor_values[i] * sin(i * 45 * PI / 180);
			counter++;
		}
	}
	x = x/(counter+1);
	y = y/(counter+1);
	int distance = sqrt(pow(x,2)+pow(y,2));
	int angle = attan(x,y);
	if(x < 0 && y > 0)
	{
		angle = 90 - angle;
	}
	else if(x < 0 && y < 0)
	{
		angle = 180 + angle;
	}
	centroid[0] = distance;
	centroid[1] = angle;
	return 0;
}

void print_sensor_values(int * array)
{
	lcd_print(1,5,array[0],3);
	lcd_print(1,9,array[1],3);
	lcd_print(1,13,array[2],3);
	lcd_print(2,5,array[6],3);
	lcd_print(2,9,array[7],3);
	return;
}

int main(void)
{
	init_devices1();	//To initiate the ports in the device
	init_devices0();	//To initiate the ports in the device
	init_devices2();	//To initiate the ports in the device
	init_devices3();
	lcd_set_4bit();		//To initialise lcd ports
	lcd_init();
    //_delay_ms(5000);
	int bot_sensor_values[8];
	get_sensor_values(bot_sensor_values);
	print_sensor_values(bot_sensor_values);
	int bot_centroid[2];
	find_centroid(bot_sensor_values,bot_centroid);
	lcd_print(2,1,bot_centroid[1],3);
	_delay_ms(2000);
	if(bot_centroid[1] < 0)
	{
		lcd_print(2,5,100,3);
		bot_centroid[1] = 360 + bot_centroid[1];
	}
	lcd_print(1,1,bot_centroid[0],3);
	lcd_print(2,1,bot_centroid[1],3);
	left_degrees(bot_centroid[1]);
	forward_mm(bot_centroid[0]*10);
}