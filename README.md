# arduincdt-scripts-for-arduino
These scripts allow to reset the upload port for specific Arduino boards.

First is avrdudeWrapper:

This is derived from the windows batch file from: https://github.com/javanaut2018/avrdude_autoreset_wrapper

Script is tested on:

	Macos: HighSierra and Mojava.
	Linux: Ubuntu 18:04

Installation instuctions.

Make sure the script is executable.

Locate the .arduinocdt folder. This is normaly hidden in your user folder

	1:	Place this script in:
		/Users/[YOURUSERNAME]/.arduinocdt/packages/arduino/tools/avrdude/[VERSION]/bin
	2:	Edit:
		/Users/[YOURUSERNAME]/.arduinocdt/packages/arduino/hardware/avr/[VERSION]/platform.txt
		Replace:
			tools.avrdude.cmd.path={path}/bin/avrdude
		With:
			tools.avrdude.cmd.path={path}/bin/avrdude_wrapper.bat
	3:	(re)start eclipse.
