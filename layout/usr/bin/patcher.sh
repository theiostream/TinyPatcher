#!/bin/bash

# Run the -p flag on a deb"s postinst
# Run the -r flag on a deb"s prerm

if [ "$1" = "" ]; then
	echo "For usage, read <http://matoe.co.cc/patcher.txt>"
fi

# Handle -p
if [ "$1" = "-p" ]; then
	if [ "$2" = "" ]; then
		echo "For usage, read <http://matoe.co.cc/patcher.txt>"
	fi
	if [ "$3" = "" ]; then
		echo "For usage, read <http://matoe.co.cc/patcher.txt>"
	fi
	
	# Copy old file; that is useful for the -r option
	echo Backuping...
	cp $2 /var/mobile/Library/TinyPatcher/Plists
	
	# Run the TinyPatcher tool
	echo Running TinyPatcher tool...
	
	if [ "$5" != "" ]; then
		TinyPatcher $2 $3 $4 $5
	elif [ "$4" != "" ]; then
		TinyPatcher $2 $3 $4
	else
		TinyPatcher $2 $3
	fi
fi

# Handle -r
if [ "$1" = "-r" ]; then
	if [ "$2" = "" ]; then
		echo "For usage, read <http://matoe.co.cc/patcher.txt>"
	fi
	
	# Get old file back with patch
	diff $2 /var/mobile/Library/TinyPatcher/Plists/${2##*/} > /var/mobile/Library/TinyPatcher/reverse.patch
	patch $2 < /var/mobile/Library/TinyPatcher/reverse.patch
	
	# Clean-up
	rm /var/mobile/Library/TinyPatcher/reverse.patch
	rm /var/mobile/Library/TinyPatcher/Plists/${2##*/}
fi