/*
Author : R Hariharan
Description: Example code to potray the behaviour of PID controller for angular velocity
*/

#include <stdio.h>
#include <stdlib.h>

//Define the gains here
#define KP 20
#define KI 10
#define KD 0

//Function that calculates the angular velocity based of the error in the current angle
int propotional_rotate(int error_angle)
{
	int total_error = 0; 
	int previous_error = error_angle;
	float angular_velocity = 0;
	// Controller Loop
	while(error_angle != 0)
	{
		// New angular_velocity = Propotional_gain * error_in_angle + Integration_gain * (total_error_till_now) + Differential_gain * (change_in_error_from_the_previous_error)
		angular_velocity = KP * error_angle + KI * (total_error + error_angle) + KD * (previous_error - error_angle);
		previous_error = error_angle;
		total_error += error_angle;
		printf("angular_velocity %f __ %d %d\n", angular_velocity, error_angle, total_error);
		printf("Rotate left\n") ? angular_velocity > 0 : printf("Rotate right\n");
		sleep(0.2);
		error_angle -= angular_velocity  * 0.02;
	}
}

int main()
{
	propotional_rotate(225); //Rotate to 225
}