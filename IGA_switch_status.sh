#!/bin/bash
#
#This script shows state of switches for IGA TURKEY
#
#alpersaglik 010420
#
#ip=(10 15 20 50)
ip=(1 2 3 4 5)
i=0
clear
while true; do
	ping -c 1 10.1.90.${ip[$i]} > /dev/null
	
	if [ $? -eq 0 ]; then
		echo -e SWITCH 10.1.90.${ip[$i]} State= '\033[0;30;42mUP\033[0m'; echo
	else
		echo -e SWITCH 10.1.90.${ip[$i]} State= '\033[0;37;41mDOWN\033[0m'; echo
	fi

	i=$(( $i + 1 ))
	sleep 1

	if [ $i -eq 5 ]; then
		i=0
		sleep 5
		clear
	fi
done
