#!/bin/sh
#
# 	Name: cluploadEdison_osx.sh
#
#	Version	Date	Comment
#	-------	----	-------
#	0.0.2	191028	change from sshfs to scp with key-pair
#	0.0.1	170815	Initial version fork from Intel cluploadEdison using sshfs
#
#	Created on: 170815
#	Author: Jacob
#
#	Purpose:
#	To either use the serial connection to download the executable to the Intel Edison.
#	Or to use a wifiConnection.
#	The wificonnection name is determined from the "usb port name"
#	The distinction between USB or WiFi is made on the usbport name.
#	On MacOS they contain the word usbmodem.
#	Based on that either the USB or the WiFi part is executed.
#	The WiFi part uses scp using the user download with a rsa key edison_rsa.
#
#	The required information is extracted out of the command line send by
#	arduinocdt
#
#	Usage:
#	1.	Prepare the Edison:
#		Create the user and group "download" on the Intel Edison
#		  > sudo groupadd download
#		  > sudo useradd -G download download
#		change the group of the /sketch directory to download
#		  > sudo chgrp download /sketch
#		Change the mode of the /sketch directory to give group read write and execute privilege.
#		  > sudo chmod 0776 /sketch
#		Create the ssh keypair for the download user name the edison_rsa with no password.
#		  > ssh-keygen
#		Move the private key to the Mac. scp from mac
#		Add the public key to the authorized_keys of the download user
#		  > cp edison_rsa.pub to /home/download/.ssh/authorized_keys
#	2.	Prepare the Mac
#		Make a node file with the hostname of the the edison wifi.
#		i.e. for hostname is foo
#		  > sudo mknode /dev/cu.foo c 3 2
#	3.	Make a backup of the original file in:
#		  /Users/[YOURUSERNAME]/.arduinocdt/packages/Intel/tools/sketchUploader/[VERSION]/clupload/cluploadEdison_osx.sh
#		to:
#		  /Users/[YOURUSERNAME]/.arduinocdt/packages/Intel/tools/sketchUploader/[VERSION]/clupload/cluploadEdison_osx.sh.org
#	4.	Copy this file to:
#		  /Users/[YOURUSERNAME]/.arduinocdt/packages/Intel/tools/sketchUploader/[VERSION]/clupload/cluploadEdison_osx.sh
#	5.	(re)start Eclipse
#
#
# Set DEBUG to non zero for additional output
DEBUG=0

ME=`basename "$0"`
echo "$ME: starting download script"
#
# print  parameters when in debug mode
if [ $DEBUG -ne 0 ]
then
	echo "$ME: Args to shell:" $*
fi
#
# ARG 1: Path to lsz executable.
# ARG 2: Elf File to download
# ARG 3: TTY port to use.
#
# The tty_port provides the clue if we are using USB or WiFi
# if it contains usbmodem
#  then its USB
#  else it is wifi and contains the name of the host
#
port_id=$3
#
if [[ "$port_id" =~ "usbmodem" ]]
then
	echo "Serial Port PORT" $com_port_id "(note: should be /dev/cu.xxxxxx for OSX)"
	echo "Using tty Port" $port_id 
	#
	#path may contain \ need to change all to /
	path_to_exe=$1
	fixed_path=${path_to_exe//\\/\/}
	#
	echo "$ME: Sending Command String to move to download if not already in download mode"
	echo "~sketch downloadEdison" > $port_id
	#Give the host time to stop the process and wait for download
	sleep 1
	#
	#Move the existing sketch on target.
	echo "$ME: Deleting existing sketch on target"
	"$fixed_path/lsz" --escape -c "mv -f /sketch/sketch.elf /sketch/sketch.elf.old" < $port_id > $port_id
	#"$fixed_path/lsz.exe" --escape -c "mv -f /sketch/sketch.elf /sketch/sketch.elf.old" < $port_id > $port 1>&0
	#
	# Execute the target download command
	#
	#Download the file.
	host_file_name=$2
	"$fixed_path/lsz" --escape --binary --overwrite $host_file_name < $port_id  > $port_id
	#
	#mv the downloaded file to /sketch/sketch.elf 
	target_download_name="${host_file_name##*/}" 
	echo "$ME: Moving downloaded file to /sketch/sketch.elf on target"
	"$fixed_path/lsz" --escape -c "mv $target_download_name /sketch/sketch.elf; chmod +x /sketch/sketch.elf" < $port_id > $port_id
	exit 0

else		# It is WIFI
	# Prepair the file
	ELFILE=$2
	FILE=${ELFILE%.*}
	FILE=${FILE##*/}
	# add the execution privilege
	chmod +x $ELFILE
	#
	PORT=$3
	HOST="${PORT##*.}"

	if [ $DEBUG -ne 0 ]
	then
		echo "$ME: Destination file is: $FILE"
		echo "$ME: Port is: $PORT"
		echo "$ME: Destination host is: $HOST"
		echo "$ME: /usr/bin/scp -i ~/.ssh/edison_rsa $ELFILE download@$HOST.sjakio.com:/sketch/$FILE"
	fi	
	
	echo "$ME: send file $ELFILE to $HOST.sjakio.com"
	/usr/bin/scp -pi ~/.ssh/edison_rsa $ELFILE download@$HOST.sjakio.com:/sketch/$FILE
	if [ $? = 0 ]
	then
		echo "$ME: file $FILE send"
	fi
	# remove the execution privilege
	chmod -x $ELFILE
fi
exit 0
