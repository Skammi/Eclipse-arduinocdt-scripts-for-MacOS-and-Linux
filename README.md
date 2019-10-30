# Arduincdt bash scripts for MacOS and Linux
These scripts will allow to reset the upload port for specific Arduino boards from Eclipse CDT with the Arduino Plugin.

	1. avrdudeWrapper
	2. arduino101loadWrapper
	3. cluploadEdison

# 1st is avrdudeWrapper:
This is derived from the windows batch file from: https://github.com/javanaut2018/avrdude_autoreset_wrapper
It brings the port to 1200Baud to reset the Arduino and bring it in upload mode. Which is required for Arduinos based on the ATmega32u4 like the Leonardo.

Script is tested on:

	Macos: HighSierra and Mojava.
	Linux: Ubuntu 18:04
	
	Boards: Leonardo, Arduino Robot, Esplora.

Installation instuctions.

Make sure the script is executable.

Locate the .arduinocdt folder. This is normaly hidden in your user folder

	1: Place this script in:
		/Users/[YOURUSERNAME]/.arduinocdt/packages/arduino/tools/avrdude/[VERSION]/bin
	2: Edit:
	   	/Users/[YOURUSERNAME]/.arduinocdt/packages/arduino/hardware/avr/[VERSION]/platform.txt
		Replace:
		  tools.avrdude.cmd.path={path}/bin/avrdude
		With:
		  tools.avrdude.cmd.path={path}/bin/avrdudeWrapper
	3: (re)start eclipse.


# 2nd is arduino101loadWrapper:
This is similar to the avrdudeWrapper it brings the port to 1200Baud to reset the Arduino101 and bring it in upload mode.

Script is tested on:

	Macos: HighSierra and Mojava.
	Linux: Does not work!! Boards reset but doesn't seem to be regonised by OS.

Installation instuctions.

Make sure the script is executable.

Locate the .arduinocdt folder. This is normaly hidden in your user folder

	1: Place this script in:
		/Users/[YOURUSERNAME]/.arduinocdt/packages/Intel/tools/arduino101load/[VERSION]/
	2: Edit:
		/Users/[YOURUSERNAME]/.arduinocdt/packages/Intel/hardware/arc32/[VERSION]/platform.txt
		Replace:
		 tools.arduino101load.cmd.path={runtime.tools.arduino101load.path}/arduino101load
		With:
		 tools.arduino101load.cmd.path={runtime.tools.arduino101load.path}/arduino101loadWrapper
	3: (re)start eclipse.

# 3rd is cluploadEdison:
This script adds the possibility to download the program to Intel Edison boards using Wifi.

Script is tested on:

	Macos: HighSierra and Mojava.
	Linux: Ubuntu 18:04

Installation instuctions.

Locate the .arduinocdt folder. This is normaly hidden in your user folder

	1. Prepare the Edison:
		Create the user and group "download" on the edison
		Add the user download to the group download.
		change the group of the /sketch directory to download
		Change the mode of the /sketch directory to give group read write and execute privilege.
		Create the ssh keypair for the download user
		Move the private key to the Mac.
		Add the public key to the authorized_keys of the download user
	2. Prepare the Mac Linux
		Make a node file with the hostname of the edison wifi.
		i.e. for hostname is foo
		 MacOS
		  > sudo mknod /dev/cu.wifi.foo c 3 2
		 Linux
		  > sudo mknod /dev/ttyACM0.wifi.foo c 3 2
		NOTE1:	This have to be repeated after a reboot.
		NOTE2:	On MacOS this must start with cu.
			On Linux this must start with ttyACM
			Otherwise it will not be offered in the Serial Port drop down menu
	3. Place this script in:
		/Users/[YOURUSERNAME]/.arduinocdt/packages/Intel/tools/sketchUploader \
		/[VERSION]/clupload/
	4. Edit:
		/Users/[YOURUSERNAME]/.arduinocdt/packages/Intel/hardware/i686 \
		/[VERSION]/platform.txt
		Replace for:
		 MacOS
		  tools.izmirdl.cmd.path={runtime.tools.sketchUploader-1.6.2+1.0.path}/clupload/cluploadEdison_osx.sh
		 Linux
		  tools.izmirdl.cmd.path={runtime.tools.sketchUploader-1.6.2+1.0.path}/clupload/cluploadEdison_linux.sh
		With:
		  tools.izmirdl.cmd.path={runtime.tools.sketchUploader-1.6.2+1.0.path}/clupload/cluploadEdison
	5. (re)start Eclipse
