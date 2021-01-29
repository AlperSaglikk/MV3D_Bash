#!/bin/bash
#
#alpersaglik 14122020
#
mv3d_no=(37 40 35 36 38 39 25 17 23 22 33 32 20 28 21 26 27 24 44 46 43 45 41 42)
i=0
mkdir -p "/home/eds_cm/.pcs/`date -d"-1 day" +%Y`/"
log_file="/home/eds_cm/.pcs/`date -d"-1 day" +%Y`/`date -d"-1 day" +"%b%Y_Powercycle".txt`"
touch $log_file
act_date=`date -d"-1 day" "+%Y.%m.%d"`
log_date=`date -d"-1 day" "+%d-%m-%Y"`
echo -n "$log_date" >> $log_file
while [ $i -le 23 ];do
	pc_count=0
	ping -w 1 10.1.10.${mv3d_no[$i]} > /dev/null 2>&1
	if [[ $? -eq 0 ]];then
		log=`ssh -qo ConnectTimeout=1 10.1.10.${mv3d_no[$i]} 'ssh -qo ConnectTimeout=1 scc ls -d -1 /opt/eds/log/diag/trace/diagserv* -tr' | tail -n 2`
		pc_count=`ssh -qo ConnectTimeout=1 10.1.10.${mv3d_no[$i]} ssh -qo ConnectTimeout=1 scc cat $log | grep "=> SHUTDOWN" | grep -c "$act_date"`
		echo -n ";" >> $log_file
		echo -n "   $pc_count" >> $log_file
	else
		echo -n ";" >> $log_file
                echo -n "MV3D OFF" >> $log_file
	fi
	let i++
done
echo >> $log_file
