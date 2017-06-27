avr-gcc -g -Os -mmcu=atmega16 -c motioncontrol.c
avr-gcc -g -mmcu=atmega16 -o motioncontrol.elf motioncontrol.o
avr-objcopy -j .text -j .data -O ihex motioncontrol.elf motioncontrol.hex
pause