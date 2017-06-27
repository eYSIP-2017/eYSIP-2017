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

// Timer 5 initialized in PWM mode for velocity control
// Prescale:256
// PWM 8bit fast, TOP=0x00FF
// Timer Frequency:225.000Hz
void timer5_init()
{
	TCCR1B = 0x00;	//Stop
	TCNT1H = 0xFF;	//Counter higher 8-bit value to which OCR5xH value is compared with
	TCNT1L = 0x01;	//Counter lower 8-bit value to which OCR5xH value is compared with
	OCR1AH = 0x00;	//Output compare register high value for Left Motor
	OCR1AL = 0xFF;	//Output compare register low value for Left Motor
	OCR1BH = 0x00;	//Output compare register high value for Right Motor
	OCR1BL = 0xFF;	//Output compare register low value for Right Motor
	TCCR1A = 0xA9;	/*{COM5A1=1, COM5A0=0; COM5B1=1, COM5B0=0; COM5C1=1 COM5C0=0}
 					  For Overriding normal port functionality to OCRnA outputs.
				  	  {WGM51=0, WGM50=1} Along With WGM52 in TCCR5B for Selecting FAST PWM 8-bit Mode*/
	
	TCCR1B = 0x0B;	//WGM12=1; CS12=0, CS11=1, CS10=1 (Prescaler=64)
}

// Function for robot velocity control
void velocity (unsigned char left_motor, unsigned char right_motor)
{
	OCR1AL = (unsigned char)left_motor;
	OCR1BL = (unsigned char)right_motor;
}

//Main Function
int main()
{
	init_devices();
		
	while(1)
	{

		velocity (100, 100); //Smaller the value lesser will be the velocity.Try different valuse between 0 to 255
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