#define F_CPU 16000000
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>


//MOSFET switch port configuration
void MOSFET_switch_config (void)
{
 DDRB = DDRB | (1<<PB3); //make PORTH 3 and PORTH 1 pins as output
 PORTB = PORTB & (~(1<<PB3)); //set PORTH 3 and PORTH 1 pins to 0
}

//Function to Initialize PORTS
void port_init()
{
 MOSFET_switch_config();	
}

void turn_on_ir_proxi_sensors (void) //turn on IR Proximity sensors
{
 PORTB = PORTB & (~(1<<PB3));
}

void turn_off_ir_proxi_sensors (void) //turn off IR Proximity sensors
{
 PORTB = PORTB | (1<<PB3);
}

void init_devices (void)
{
 cli(); //Clears the global interrupts
 port_init();
 sei(); //Enables the global interrupts
}

//Main Function
int main(void)
{
	while(1)
	{
	init_devices();
	
	turn_on_ir_proxi_sensors();
	_delay_ms(1500);
	
	turn_off_ir_proxi_sensors();
	_delay_ms(1500);
	}
}