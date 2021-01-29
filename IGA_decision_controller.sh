#!/bin/bash
#
#This program compares plc.log and bhs.log to make sure bag IDs are written to related logs.
#
#alpersaglik 14102020
#
mv3d_number=(37 40 35 38 39 25 17 23 22 33 32 20 28 21 26 27 24 44 46 43 45 41 42)
ed_number=(01 02 03 05 06 09 10 11 12 13 14 15 16 17 18 19 20 23 24 25 26 27 28)
var=0
#
while [ $var -le 22 ];do
	bag_count=0
	total_diff=0
	bag_count=`diff <(ssh -qo ConnectTimeout=1 10.1.10.${mv3d_number[$var]} ssh -qo ConnectTimeout=1 scc tail -n 5000 /opt/eds/log/plc.log | grep IBDR | tail -n 35 | awk '{print $8}') <(ssh -qo ConnectTimeout=1 10.1.10.${mv3d_number[$var]} ssh -qo ConnectTimeout=1 scc cat /opt/eds/log/bhs.log.0 /opt/eds/log/bhs.log | grep 'ReadInBagData' | grep -v 'PSEUDO string: \"90' | tail -n 15 | head -n 10 | awk '{print $18}' | sed -e 's/\"/00/' -e 's/\"//') | grep "<" | wc -l`
	#
	let "total_diff=10-(35-bag_count)"
	#
	if [ $total_diff -ge 3 ] && [ $total_diff -le 10 ];then
		echo -e "\t\t\t   3D00${mv3d_number[$var]} (ED_${ed_number[$var]})\n \t\t\t\t    $total_diff \n       KARARSIZ BAGAJ TESPIT EDILDI! \n\t        CIHAZI KONTROL EDIN\n DEVAM EDIYORSA CIHAZI BYPASSLAYIN" | xmessage -file - -bg white -fg red -title "3D00${mv3d_number[$var]} (ED_${ed_number[$var]})" > /dev/null 2>&1 & disown
		beep -f 3000 -r 2 -l 400 -d 10
	fi
	#
	let var++
	sleep 3
done
