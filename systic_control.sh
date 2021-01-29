#!/bin/bash
#
#This program created to reset systic faults
#
#alpersaglik 18112020
#
#if [[ `find /opt/eds/log/ -name bms.log -mmin -5 | wc -l` -eq "1" ]];then
	fault_log=`tail -n 5000 /opt/eds/log/bms.log | grep "scs_fault_cause"`
	fault_cause=`echo $fault_log | tail -n 1 | awk '{print $NF}'`
	if [[ "$fault_cause" == "22" ]];then
		svc -k /service/scs/
	elif [[ "$fault_cause" == "9" ]];then
		check_systic=`echo "$fault_log" | tail -n 30 | awk '{print $NF}' | grep -c "22"`
		if [[ $check_systic -gt 0 ]];then
			svc -k /service/scs/
		fi
	fi
#fi
