/*
Author: R Hariharan

Description:
This is a C simulation code. Given a set of robots the robots comuputes a best fit line with the robots
as points on a graph. We use mean-squared method of line fit. Each robot has 8 IR proximity sensors 
which are 45 degrees apart placed in a circle, to sense the surrounding. Each robot computes its own
line of best fit by sensing its surrounding.

Drawback: The line of best computed by two robots of the same shape is not always same.
*/
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>

#define PI 3.14159265

//Function to get random sensor values
int get_sensor_value()
{
	time_t t;
	srand((unsigned) time(&t));
	return rand() % 150;		
}

//Function to generate the sensor values (8 sensor values)
void generate_sensor_values(int * array)
{
	//Below code generates the random sensor value
	/*
	int i;
	for(i=0;i<8;i++)
	{
		// array[i] = get_sensor_value();
		// sleep(1);
		scanf("%d",&array[i]);
	}
	*/
	//Below code puts sensor values manually
	array[0] = 28;
	array[1] = 20;
	array[2] = 150;
	array[3] = 150;
	array[4] = 150;
	array[5] = 150;
	array[6] = 150;
	array[7] = 20;
	return;
}
//Generate function for robot 2
void generate_sensor_values2(int * array)
{
	// int i;
	// for(i=0;i<8;i++)
	// {
	// 	// array[i] = get_sensor_value();
	// 	// sleep(1);
	// 	scanf("%d",&array[i]);
	// }
	array[0] = 150;
	array[1] = 150;
	array[2] = 20;
	array[3] = 20;
	array[4] = 150;
	array[5] = 150;
	array[6] = 150;
	array[7] = 150;
	return;
}
//Generate function for robot 3
void generate_sensor_values3(int * array)
{
	// int i;
	// for(i=0;i<8;i++)
	// {
	// 	// array[i] = get_sensor_value();
	// 	// sleep(1);
	// 	scanf("%d",&array[i]);
	// }
	array[0] = 28;
	array[1] = 20;
	array[2] = 150;
	array[3] = 150;
	array[4] = 150;
	array[5] = 150;
	array[6] = 150;
	array[7] = 150;
	return;
}
//Generate function for robot 4
void generate_sensor_values4(int * array)
{
	// int i;
	// for(i=0;i<8;i++)
	// {
	// 	// array[i] = get_sensor_value();
	// 	// sleep(1);
	// 	scanf("%d",&array[i]);
	// }
	array[0] = 150;
	array[1] = 20;
	array[2] = 40;
	array[3] = 150;
	array[4] = 150;
	array[5] = 60;
	array[6] = 150;
	array[7] = 150;
	return;
}

//Print the values on the integer array passed
void print_sensor_values(char * string,int * array,int n)
{
	int i;
	printf("%s :: ", string);
	for(i=0;i<n;i++)
	{
		printf("%d ",array[i]);
	}
	printf("\n\n");
	return;
}

//Function finds the angle to which the robot has to turn 
int get_angle(float X_intercept,float Y_intercept,float slope_angle)
{
	//The robot position is (0,0)
	int angle;
	if(X_intercept > 0 && Y_intercept > 0) 
	{
		angle = 90 - slope_angle;
		printf("Qudrant 1 :: %d\n", angle);
	}
	else if(X_intercept < 0 && Y_intercept > 0)
	{
		angle = 90 + slope_angle;
		printf("Qudrant 2 :: %d\n", angle);
	}
	else if(X_intercept < 0 && Y_intercept < 0)
	{
		angle = 270 - slope_angle;
		printf("Qudrant 3 :: %d\n", angle);
	}
	else if(X_intercept > 0 && Y_intercept < 0)
	{
		angle = 270 + slope_angle;
		printf("Qudrant 4 :: %d\n", angle);
	}
	else
	{
		angle = 0;
		printf("ORIGIN :: %d\n", angle);
	}
	return angle;
}

//Find the point to which the robot must move to form the line
int find_point_on_line(int * sensor_values,int * min_dist_point)
{
	//Finding the centroid
	float x = 0;
	float y = 0;
	float x_values[8];
	float y_values[8]; 
	int i;
	int counter = 0;
	for(i=0;i<8;i++)
	{
		if(sensor_values[i] < 100)
		{
			x_values[counter] = sensor_values[i] * cos(i * 45 * PI / 180);
			y_values[counter] = sensor_values[i] * sin(i * 45 * PI / 180);
			printf("x_value :: %f y_value :: %f\n",x_values[counter], y_values[counter]);
			x += x_values[counter];
			y += y_values[counter];
			counter++;
		}
	}
	printf("\n");
	printf("Counter :: %d\n", counter);
	//Centroid = sum_of_all_co-ordinates/number_of_vertices
	x = x/(counter+1);
	y = y/(counter+1);
	printf("x_centroid : %f y_centroid : %f\n\n", x,y);
	
	//Below code uses the mea-squared method to find the best fit line
	float sum_of_all_XY = 0;
	float sum_of_all_X2 = 0;
	for(i=0;i<counter;i++)
	{
		printf("Counter :: %d X :: %f Y:: %f\n",i, x_values[i] - x, y_values[i] - y);
		sum_of_all_XY += (x_values[i] - x) * (y_values[i] - y);
		sum_of_all_X2 += pow(x_values[i] - x,2);
	}
	
	//Slope of the best fit line
	double slope_of_line = sum_of_all_XY/sum_of_all_X2;
	printf("slope_of_line :: %lf sum_of_all_XY :: %f sum_of_all_X2 :: %f\n", slope_of_line,sum_of_all_XY,sum_of_all_X2);
	//X and Y intercept of the line
	float Y_intercept = y - slope_of_line * x;
	float X_intercept = - Y_intercept / slope_of_line ;  
	printf("X_intercept :: %f Y_intercept :: %f\n", X_intercept,Y_intercept);
	//Angle the line makes with positive x-axis
	float slope_angle = atan(slope_of_line) * 180 / PI;
	printf("slope_angle :: %f\n\n", slope_angle);
	slope_angle = abs(slope_angle);

	int distance = abs(Y_intercept)/(sqrt(1+pow(slope_of_line,2))); //the distance the robot must move by
	int angle = get_angle(X_intercept,Y_intercept,slope_angle); //the angle the robot must rotate by
	
	printf("distance: %d angle: %d\n\n\n", distance,angle);
	min_dist_point[0] = distance;
	min_dist_point[1] = angle;
	return 0;
}

//Call different function and analyse the output
int main()
{
	int bot1_sensor_values[8];
	int bot2_sensor_values[8];
	int bot3_sensor_values[8];
	int bot4_sensor_values[8];
	generate_sensor_values(bot1_sensor_values);
	generate_sensor_values(bot2_sensor_values);
	generate_sensor_values(bot3_sensor_values);
	generate_sensor_values(bot4_sensor_values);
	print_sensor_values("Bot 1",bot1_sensor_values,8);
	print_sensor_values("Bot 2",bot2_sensor_values,8);
	print_sensor_values("Bot 3",bot3_sensor_values,8);
	print_sensor_values("Bot 4",bot4_sensor_values,8);
	// print_sensor_values("Bot 2",bot2_sensor_values,8);
	int bot1_min_dist_point[2];
	int bot2_min_dist_point[2];
	int bot3_min_dist_point[2];
	int bot4_min_dist_point[2];
	find_point_on_line(bot1_sensor_values,bot1_min_dist_point);
	find_point_on_line(bot2_sensor_values,bot2_min_dist_point);
	find_point_on_line(bot3_sensor_values,bot3_min_dist_point);
	find_point_on_line(bot4_sensor_values,bot4_min_dist_point);
	// print_sensor_values("Shortest Distant point on the line",bot1_min_dist_point,2);
	// print_sensor_values("Centroid Bot 2",bot2_centroid,2);
	return 0;
}