#!/bin/bash
#
#This script takes filament current and voltage values from mv3d while x-rays on and it creates tables as csv format
#
#alpersaglik 05052020
#
mv3d_no=(37 40 35 36 38 39 25 17 23 22 33 32 20 28 21 26 27 24 44 46 43 45 41 42)
i=0
tmp_file="/tmp/.tmp_bit.txt"
#
while [ $i -le 23 ];do
	#
	#Path and csv file created
	mkdir -p "/home/eds_cm/filament_records/3D00$(( mv3d_no[$i] ))/`date +%Y`/"
	file_path="/home/eds_cm/filament_records/3D00$(( mv3d_no[$i] ))/`date +%Y`/`date +"%b%Y_3D00$(( mv3d_no[$i] ))"_filament_table.csv`"
	touch $file_path
	##########################
	cond=false
	#
	grep `date +%d-%m-%Y` $file_path >> /dev/null
	if [ $? -eq 1 ];then
		log=`ssh -qo ConnectTimeout=1 10.1.10.$(( mv3d_no[$i])) 'ssh -qo ConnectTimeout=1 scc ls -d -1 /opt/eds/log/diag/bit/* -tr' | tail -1`
		beam_mA=`ssh -qo ConnectTimeout=1 10.1.10.$(( mv3d_no[$i] )) ssh -qo ConnectTimeout=1 scc tail -1000 $log | grep "beam_mA \="| tail -1 | cut -d' ' -f6`
		beam_kV=`ssh -qo ConnectTimeout=1 10.1.10.$(( mv3d_no[$i] )) ssh -qo ConnectTimeout=1 scc tail -1000 $log | grep "beam_kV \="| tail -1 | cut -d' ' -f6`
		#
		if [ `echo "$beam_mA>=8.000"|bc -l` -eq 1 ] && [ `echo "$beam_kV>=178.500"|bc -l` -eq 1 ];then
			ssh 10.1.10.$(( mv3d_no[$i] )) ssh scc tail -15000 $log > $tmp_file
			sleep 2.5
			#Date of day added to file
			echo -n `date +%d-%m-%Y` >> $file_path
			###############################################
			#Filament current values added to file
			for hvps_a in 0 1 2; do
				for tube_a in A B C; do
					echo -n ";" >> $file_path
					echo -n `cat $tmp_file | grep filament_A | grep -v setpoint | grep HVPS$hvps_a | grep TUBE_$tube_a | tail -1 | cut -d' ' -f6` | sed -e 's/\./\,/' >> $file_path
				done
			done
			################################################
			sleep 0.2
			echo >> $file_path
			echo -en " " >> $file_path
			#Filament voltage value added to file
			for hvps_v in 0 1 2; do
				for tube_v in A B C; do
					echo -n ";" >> $file_path
					echo -n `cat $tmp_file | grep filament_V | grep -v setpoint | grep HVPS$hvps_v | grep TUBE_$tube_v | tail -1 | cut -d' ' -f6` | sed -e 's/\./\,/' >> $file_path
				done
			done
			##################################################
			echo >> $file_path;
			#Saved filament current and voltage values checked
			fil_A=$(tail -n 2 $file_path | grep `date +%d-%m-%Y` | sed -e 's/.*;//' -e 's/\,/\./')
			if [ `echo "$fil_A<=3.350"|bc -l` -eq 1 ];then
				cond=true
			fi
			#
			tail -n 2 $file_path | grep ";;" >> /dev/null
			if [ $? -eq 0 ] || $cond ;then
				head -n -2 $file_path > /tmp/temp.txt; cat /tmp/temp.txt > $file_path; rm -f /tmp/temp.txt
			fi
			##################################################
			#Temporary file deleted at the end
			rm -f $tmp_file
			##################################
		fi
	fi
	i=$(( $i + 1 ))
done
