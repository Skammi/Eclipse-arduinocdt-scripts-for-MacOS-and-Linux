# arduincdt bash scripts for MacOS and Linux
These scripts will allow to reset the upload port for specific Arduino boards from Eclipse CDT with the Arduino Plugin.

*First is avrdudeWrapper:

This is derived from the windows batch file from: https://github.com/javanaut2018/avrdude_autoreset_wrapper
It brings the port to 1200Baud to reset the Arduino and bring it in upload mode. Which is required for Arduinos based on the ATmega32u4 like the Leonardo.

Script is tested on:

	Macos: HighSierra and Mojava.
	Linux: Ubuntu 18:04
	
	Boards: Leonardo, Arduino Robot, Esplora.

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
			tools.avrdude.cmd.path={path}/bin/avrdudeWrapper
	3:	(re)start eclipse.


* Second is arduino101loadWrapper:

This is similar to the avrdudeWrapper it brings the port to 1200Baud to reset the Arduino101 and bring it in upload mode.

Script is tested on:

	Macos: HighSierra and Mojava.
	Linux: Does not work!! Boards reset but doesn't seem to be regonised by OS.

Installation instuctions.

Make sure the script is executable.

Locate the .arduinocdt folder. This is normaly hidden in your user folder

	1:	Place this script in:
		/Users/[YOURUSERNAME]/.arduinocdt/packages/Intel/tools/arduino101load/[VERSION]/
	2:	Edit:
		/Users/[YOURUSERNAME]/.arduinocdt/packages/Intel/hardware/arc32/[VERSION]/platform.txt
		Replace:
			tools.arduino101load.cmd.path={runtime.tools.arduino101load.path}/arduino101load
		With:
			tools.arduino101load.cmd.path={runtime.tools.arduino101load.path}/arduino101loadWrapper
	3:	(re)start eclipse.
