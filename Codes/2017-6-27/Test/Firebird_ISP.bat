title Firebird_V NEX-USB-ISP loading batch file.
::The title can be found at the top
::Uncomment below code to load bootloader to firebird V
::avrdude -c stk500v2 -p m2560 -P NEX-USB-ISP -U flash:w:"D:\E yantra\e-yantra_dvd\Fire Bird V ATMEGA2560 Robot\Software and Drivers\AVR Bootloader\AVR Bootloader Microcontroller firmware\M2560-14_7456MHz. USB-UART 2.a90":i

::Uncomment below code to read lfuse and hfuse of atmega16
::avrdude -c stk500v2 -p m16 -P NEX-USB-ISP -U lfuse:r:lfuse_val.hex:h -U hfuse:r:hfuse_val.hex:h

::Uncomment below code to write lfuse and hfuse of atmega16
::avrdude -c stk500v2 -p m16 -P NEX-USB-ISP -U lfuse:w:0xff:m -U hfuse:w:0xd9:m

::Uncomment below code to write flash to atmega16 having file motioncontrol.hex
::avrdude -c stk500v2 -p m16 -P NEX-USB-ISP -U flash:w:motioncontrol.hex:i

::Uncomment below code to write flash to atmega16 having file sensor_switching.hex
::avrdude -c stk500v2 -p m16 -P NEX-USB-ISP -U flash:w:sensor_switching.hex:i

::Uncomment below code to write flash to atmega16 having file velocitycontrol.hex
::avrdude -c stk500v2 -p m16 -P NEX-USB-ISP -U flash:w:velocitycontrol.hex:i

::Uncomment below code to write flash to atmega16 having file LCD_interfacing.hex
avrdude -c stk500v2 -p m16 -P NEX-USB-ISP -U flash:w:LCD_interfacing.hex:i
pause