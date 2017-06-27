avr-gcc -g -Os -mmcu=atmega16 -c velocitycontrol.c
avr-gcc -g -mmcu=atmega16 -o velocitycontrol.elf velocitycontrol.o
avr-objcopy -j .text -j .data -O ihex velocitycontrol.elf velocitycontrol.hex
pause