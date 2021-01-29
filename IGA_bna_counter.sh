#!/bin/bash
#
#This script pop-up BnA limit exceeded message according to set value
#
#alem	23082019
#
mv3d_no=(37 40 35 36 38 39 25 17 23 22 33 32 20 28 21 26 27 24 44 46 43 45 41 42)
counter=()
last_bag=()
last_saved=()
i=0
#
clear
#
while [ $i -le 23 ]; do
	#Last Bag Check#
	last_bag[$i]=$(ssh 10.1.10.$(( mv3d_no[$i] )) 'ssh scc 'tail -n 500 /opt/eds/log/bhs.log'' | grep "bag disposition" | tail -1 | cut -d' ' -f4)
	if [[ "${last_bag[$i]}" = "${last_saved[$i]}" ]]; then
		(( counter[$i]++ ))
	else
		last_saved[$i]=${last_bag[$i]}
		counter[$i]=0
	fi
	
	if [[ "${counter[$i]}" -le 1 ]]; then
		#BnA COUNT#
		bna_count=$(ls | ssh 10.1.10.$(( mv3d_no[$i] )) 'ssh scc 'tail -n 1000 /opt/eds/log/bhs.log'' | grep "bag disposition " | tail -n 10 | grep "\- 3" | grep -vc "??????????")	

		#No IATA and PSEUDO bag#
		no_iata=$(ls | ssh 10.1.10.$(( mv3d_no[$i] )) 'ssh scc 'tail -n 1000 /opt/eds/log/bhs.log'' | grep "bag disposition" | tail -n 10 | grep -c "PSEUDO decimal: 90")
	
	if [[ "$bna_count" -ge 3 ]]; then
		echo -e "\t    3D00$(( mv3d_no[$i] ))\n BnA limit exceeded!!" | xmessage -file - -bg white -fg red -timeout 10 & disown
		beep -f 385 -r 2 -l 100
	fi
	if [[ "$no_iata" -ge 1 ]]; then
		echo -e "\t\t\t   3D00$(( mv3d_no[$i] ))\nNO IATA and PSEUDO BAG DETECTED!!\n  \tPLEASE CHECK PHOTOCELLS " | xmessage -file - -bg white -fg red -timeout 10 & disown
		beep -f 600 -r 2 -l 100
	fi			
	fi
	i=$(( $i + 1 ))
	sleep 1
	if [[ "$i" -eq 24 ]]; then
	i=0
	fi
done
