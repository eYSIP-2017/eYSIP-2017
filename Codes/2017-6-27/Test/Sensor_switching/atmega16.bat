avr-gcc -g -Os -mmcu=atmega16 -c sensor_switching.c
avr-gcc -g -mmcu=atmega16 -o sensor_switching.elf sensor_switching.o
avr-objcopy -j .text -j .data -O ihex sensor_switching.elf sensor_switching.hex
pause