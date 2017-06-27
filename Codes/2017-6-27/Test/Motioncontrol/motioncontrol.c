#define F_CPU 16000000
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>


void motion_pin_config (void)
{
 DDRB|=(1<<PB4)|(1<<PB2); //set direction of the PORTA 3 to PORTA 0 pins as output
 PORTB = PORTB & (~(1<<PB4)|(1<<PB2)); // set initial value of the PORTA 3 to PORTA 0 pins to logic 0
 DDRD|=(1<<PD6)|(1<<PD7); //set direction of the PORTA 3 to PORTA 0 pins as output
 PORTD = PORTD & (~(1<<PD6)|(1<<PD7)); // set initial value of the PORTA 3 to PORTA 0 pins to logic 0
 DDRD = DDRD | (1<<PD4)|(1<<PD5);   //Setting PL3 and PL4 pins as output for PWM generation
 PORTD = PORTD | (1<<PD4)|(1<<PD5); //PL3 and PL4 pins are for velocity control using PWM
}

//Function to initialize ports
void port_init()
{
 motion_pin_config();
}

void forward (void) //both wheels forward
{
  PORTB|=(1<<PB4);
  PORTB&=~(1<<PB2);
  PORTD|=(1<<PD7);
  PORTD&=~(1<<PD6);
}

void back (void) //both wheels backward
{
  PORTB|=(1<<PB2);
  PORTB&=~(1<<PB4);
  PORTD|=(1<<PD6);
  PORTD&=~(1<<PD7);
}

void left (void) //Left wheel backward, Right wheel forward
{
  PORTB|=(1<<PB2);
  PORTB&=~(1<<PB4);
  PORTD|=(1<<PD7);
  PORTD&=~(1<<PD6);
}

void right (void) //Left wheel forward, Right wheel backward
{
  PORTB|=(1<<PB4);
  PORTB&=~(1<<PB2);
  PORTD|=(1<<PD6);
  PORTD&=~(1<<PD7);
}

void stop (void) //Both wheels stop
{
  PORTB|=(1<<PB4)|(1<<PB2);
  PORTD|=(1<<PD6)|(1<<PD7);
}

void init_devices (void)
{
 cli(); //Clears the global interrupts
 port_init();
 sei(); //Enables the global interrupts
}


//Main Function
int main()
{
	init_devices();
		
	while(1)
	{
	
		forward(); //both wheels forward
		_delay_ms(1000);

		stop();						
		_delay_ms(500);
	
		back(); //both wheels backward						
		_delay_ms(1000);

		stop();						
		_delay_ms(500);
		
		left(); //Left wheel backward, Right wheel forward
		_delay_ms(1000);
		
		stop();						
		_delay_ms(500);
		
		right(); //Left wheel forward, Right wheel backward
		_delay_ms(1000);

		stop();						
		_delay_ms(500);

		stop();						
		_delay_ms(1000); 
	}
}