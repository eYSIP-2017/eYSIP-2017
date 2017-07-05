/*
Author : R Hariharan
Description: This is a C Code to simuate the working of the Rendezous Prblem. We consider here
that the robot can sense the surrounding using IR proximity sensor (8 placed 45 degrees apart).
The centroid of the shape formed by all the robots as vertices is calculated. This is the point 
the robot travels to. 
*/
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

#define PI 3.14159265

//Function to generate random sensor Values
int get_sensor_value()
{
	time_t t;
	srand((unsigned) time(&t));
	return rand() % 150;		
}

//Function which is used to get all 8 sensor values
void generate_sensor_values(int * array)
{
	//The below code is used to generate random sensor values
	/*
	int i;
	for(i=0;i<8;i++)
	{
		// array[i] = get_sensor_value();
		// sleep(1);
		scanf("%d",&array[i]);
	}
	*/

	//Below code is to enter the sensor values manually 
	array[0] = 150;
	array[1] = 150;
	array[2] = 40;
	array[3] = 150;
	array[4] = 150;
	array[5] = 150;
	array[6] = 150;
	array[7] = 150;

	return;
}

//Function to print the integer values of the array of size n
void print_sensor_values(char * string,int * array,int n)
{
	int i;
	printf("%s :: ", string);
	for(i=0;i<n;i++)
	{
		printf("%d ",array[i]);
	}
	printf("\n");
	return;
}

//Function to find the centroid of the shape formed by the robots
int find_centroid(int * sensor_values,int * centroid)
{
	float x = 0; //x co-ordinate of centroid
	float y = 0; //y co-ordinate of centroid
	int i;
	int counter = 0; //Count of robots in the shape (Number of vertices)
	//8 sensors - run 8 times
	for(i=0;i<8;i++)
	{
		//Check if the robots is in range (100 mm)
		if(sensor_values[i] < 100)
		{
			printf("%d %f %f\n",sensor_values[i], sensor_values[i] * cos(i * 45 * PI / 180), sensor_values[i] * sin(i * 45 * PI / 180));
			printf("Angle : %f\n", i * 45 * PI / 180);
			//change the polar co-ordinates to cartesian co-ordinates
			x += sensor_values[i] * cos(i * 45 * PI / 180);
			y += sensor_values[i] * sin(i * 45 * PI / 180);
			counter++;
		}
	}
	printf("Counter :: %d\n", counter);
	//Centroid = (sum of all co-ordinates)/(number of vertices)
	x = x/(counter+1);
	y = y/(counter+1); 
	printf("x: %f y: %f\n", x,y);

	int distance = sqrt(pow(x,2)+pow(y,2)); //Distance to move by (relative co-odinate from (0,0) where the robot lies)
	printf("%f\n", y/x);
	int angle = atan(y/x) * 180 / PI; //Angle to rotate by (Robot allways faces in the positive x direction)
	printf("distance: %d angle: %d\n", distance,angle);
	//atan gives value between (90,-90), do need to change it between (0,360)
	if(x < 0 && y > 0)
	{
		angle = 90 - angle;
	}
	else if(x < 0 && y < 0)
	{
		angle = 180 + angle;
	}
	printf("distance: %d angle: %d\n", distance,angle);
	centroid[0] = distance;
	centroid[1] = angle;
	return 0;
}

//Call different functions, and analyse the output
int main()
{
	int bot1_sensor_values[8];
	// int bot2_sensor_values[8];
	generate_sensor_values(bot1_sensor_values);
	// generate_sensor_values(bot2_sensor_values);
	print_sensor_values("Bot 1",bot1_sensor_values,8);
	// print_sensor_values("Bot 2",bot2_sensor_values,8);
	int bot1_centroid[2];
	// int bot2_centroid[2];
	find_centroid(bot1_sensor_values,bot1_centroid);
	// find_centroid(bot2_sensor_values,bot2_centroid);
	print_sensor_values("Centroid Bot 1",bot1_centroid,2);
	// print_sensor_values("Centroid Bot 2",bot2_csentroid,2);
	return 0;
}
