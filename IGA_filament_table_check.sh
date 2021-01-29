#!/bin/bash
#
#This script checks filament records table
#
#alpersaglik 09062020
#
mv3d_no=(37 40 35 36 38 39 25 17 23 22 33 32 20 28 21 26 27 24 44 46 43 45 41 42)
ed_no=(01 02 03 04 05 06 09 10 11 12 13 14 15 16 17 18 19 20 23 24 25 26 27 28)
i=0
count=0
clear
while [ $i -le 23 ];do
	file_path="/home/eds_cm/filament_records/3D00$(( mv3d_no[$i] ))/`date +%Y`/`date +"%b%Y_3D00$(( mv3d_no[$i] ))"_filament_table.csv`"
	grep `date +%d.%m.%Y` $file_path >> /dev/null
	if [ $? -eq 1 ];then
		echo 3D00$(( mv3d_no[$i] ))'('ED$(( ed_no[$i] ))')' filament table is not created.
		echo
		count=$(( $count + 1 ))
	fi
	i=$(( $i + 1 ))
	sleep 0.1
done
#
if [ $count -eq 0 ];then
	echo All filament tables are created for `date +%d/%m/%Y.`;echo
else
	echo $count MV3Ds left..;echo
fi
