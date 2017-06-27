avr-gcc -g -Os -mmcu=atmega16 -c LCD_interfacing.c
avr-gcc -g -mmcu=atmega16 -o LCD_interfacing.elf LCD_interfacing.o
avr-objcopy -j .text -j .data -O ihex LCD_interfacing.elf LCD_interfacing.hex
pause