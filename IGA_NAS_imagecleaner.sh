#!/bin/bash

#This script clears old images from IAC, except last 3 months.

#Written by Alper Saglik

echo
array=(17 21 22 23 24 25 26 27 28 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46)

i=0

while [ $i -le 23 ]; do
	
	y=$(date --date="-3 month" +%Y)
	m=$(date --date="-3 month" +%m)

	while [ $((10#$m)) -gt 0 ]; do
	
		m=$(printf "%02d" $((10#$m)))
		ssh 10.1.10.$((array[$i])) rm -rvf /tmp/$y/$m*
		m=$(( $((10#$m)) - 1 ))
	
	done
	
	i=$(( $i + 1 ))
	
done

exit
