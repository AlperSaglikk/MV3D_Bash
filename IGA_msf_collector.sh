#!/bin/bash
#
#This program creatred to collect MSF from all machine
#
#alpersaglik 24112020
#
clear
echo "*********************************"
echo "**                             **"
echo "**    MSF KAYDETME PROGRAMI    **"
echo "**                             **"
echo "*********************************"
echo
read -p "24 cihazin MSF'i sirayla kaydedilecek. Kabul ediyor musun? (e veya h) " answer
if [ "$answer" == "e" ];then
	mv3d_no=(37 40 35 36 38 39 25 17 23 22 33 32 20 28 21 26 27 24 44 46 43 45 41 42)
	i=0
	count=0
	folder_name="/tmp/`date "+%d-%m-%Y_MSF_FILES"`"
	mkdir -p $folder_name
	while [ $i -le 23 ];do
		ping -w 1 10.1.10.${mv3d_no[$i]} > /dev/null
		if [ $? -eq 0 ];then
			echo "			3D00${mv3d_no[$i]}"
			ssh -qo ConnectTimeout=1 10.1.10.${mv3d_no[$i]} mv3d_msf save all
			scp 10.1.10.${mv3d_no[$i]}:/tmp/`ssh 10.1.10.${mv3d_no[$i]} 'ls /tmp/ | grep machine-specific-files | tail -n 1 | sed s+\(+\\\\\(+ | sed  s+\)+\\\\\)+ | sed s+^+\"+ | sed s+$+\"+'` $folder_name
			echo
			let count++
		else
			echo "3D00${mv3d_no[$i]} seri numarali cihaz kapali MSF alinamadi.."
		fi
	let i++
	done
	echo -e "$count adet MSF $folder_name klasorune kaydedildi."\\n
fi
