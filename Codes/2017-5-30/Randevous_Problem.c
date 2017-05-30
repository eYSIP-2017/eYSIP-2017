#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

#define PI 3.14159265

int get_sensor_value()
{
	time_t t;
	srand((unsigned) time(&t));
	return rand() % 150;		
}

void generate_sensor_values(int * array)
{
	int i;
	for(i=0;i<8;i++)
	{
		array[i] = get_sensor_value();
		sleep(1);
		// scanf("%d",&array[i]);
	}
	return;
}

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

int find_centroid(int * sensor_values,int * centroid)
{
	float x = 0;
	float y = 0;
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
	printf("Counter :: %d\n", counter);
	x = x/(counter+1);
	y = y/(counter+1);
	printf("x: %f y: %f\n", x,y);
	int distance = sqrt(pow(x,2)+pow(y,2));
	int angle = atan(y/x) * 180 / PI;
	printf("distance: %d angle: %d\n", distance,angle);
	if(x< 0 && y > 0)
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

int main()
{
	int bot1_sensor_values[8];
	int bot2_sensor_values[8];
	generate_sensor_values(bot1_sensor_values);
	generate_sensor_values(bot2_sensor_values);
	print_sensor_values("Bot 1",bot1_sensor_values,8);
	print_sensor_values("Bot 2",bot2_sensor_values,8);
	int bot1_centroid[2];
	int bot2_centroid[2];
	find_centroid(bot1_sensor_values,bot1_centroid);
	find_centroid(bot2_sensor_values,bot2_centroid);
	print_sensor_values("Centroid Bot 1",bot1_centroid,2);
	print_sensor_values("Centroid Bot 2",bot2_centroid,2);
	return 0;
}
