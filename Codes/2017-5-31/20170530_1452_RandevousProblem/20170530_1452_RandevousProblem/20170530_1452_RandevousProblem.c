/*
 * _20170530_1452_RandevousProblem.c
 *
 * Created: 30-05-2017 14:53:02
 * Author: R Hariharan
 * Description:
	 The robot can sense the surrounding using IR proximity sensor (8 placed 45 degrees apart). 
	 The centroid of the shape formed by all the robots as vertices is calculated. This is the point the robot travels to.
 */ 

#define F_CPU 14745600
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <math.h>
#include "lcd.c"
#include "dependency.c"

#define PI 3.14159265

//Function to get the sensor values
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
//Small tweak to atan() function
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
//Function computes the centroid of the shape formed by the robots as vertices.
int find_centroid(int * sensor_values,int * centroid)
{
	int x = 0; //x co-ordinate of centroid
	int y = 0; //y co-ordinate of centroid
	int i;
	int counter = 0; //number of robots in the shape (number of vertices)
	//8 Sensor - run loop 8 times
	for(i=0;i<8;i++)
	{
		//Check if robot is in the range 100mm
		if(sensor_values[i] < 100)
		{
			//Convert polar co-ordinates to cartesian co-ordinates
			x += sensor_values[i] * cos(i * 45 * PI / 180);
			y += sensor_values[i] * sin(i * 45 * PI / 180);
			counter++;
		}
	}
	//centroid = (sum of all cordinates)/(number of vetices)
	x = x/(counter+1);
	y = y/(counter+1);
	
	int distance = sqrt(pow(x,2)+pow(y,2)); //Distance of the centroid with robot at (0,0) 
	int angle = attan(x,y); //Angle to rotate by with the robot facing positive x-axis
	//aatan function gives angle of range (90,-90), we need convert it (0,360)
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

//Print the sensor values on LCD
void print_sensor_values(int * array)
{
	lcd_print(1,5,array[0],3);
	lcd_print(1,9,array[1],3);
	lcd_print(1,13,array[2],3);
	lcd_print(2,5,array[6],3);
	lcd_print(2,9,array[7],3);
	return;
}

//Call the function, and analyse the output
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
	left_degrees(bot_centroid[1]); //Rotate left by the mentioned degrees
	forward_mm(bot_centroid[0]*10); //Move forward by mentioned distance in mm
	
	return 0;
}