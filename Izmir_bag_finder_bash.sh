#!/bin/bash
#
#This script finds bags by their IATA and PSEUDO number. Created for ADB Izmir Airport
#
#alpersaglik 24092019
#
#alem
#
echo
clear
#
mv3d=(68 69 70 78)
b=true
#
log_select ()	{
	echo
	echo "Please select search mode"
	echo "1: Last Modified Logs"
	echo "2: All Logs"
	echo
	read mode
	echo
#
	case $mode in
#		
		1)
			log="/opt/eds/log/bhs.log.1 /opt/eds/log/bhs.log.0 /opt/eds/log/bhs.log"	
			echo "*****************************************"
			echo "*  LAST MODIFIED LOGS WILL BE SEARCHED  *"
			echo "*****************************************"
			echo
		;;
#
		2)
			log="/opt/eds/log/bhs.log*"
			
			echo "*******************************"
			echo "*  ALL LOGS WILL BE SEARCHED  *"
			echo "*******************************"
			echo
		;;
#		
		*)
			echo
			echo "Invalid Selection try again.."
			sleep 0.75
			log_select
		;;
	esac	
}
#
while $b; do
#
	echo "**********************************"
	echo "**                              **"
	echo "**         BAG FINDER           **"
	echo "**                              **"
	echo "**********************************"
	echo
	echo "Welcome to Bag Finder Application"
	echo
	echo "Please select area to search"
	echo "1: EAST(3D0068 & 3D0069)"
	echo "2: WEST(3D0070 & 3D0078)"
	echo "3: ALL AREA"
	echo "4: EXIT"
	echo
	read area
	echo
#
	case $area in
#
		1)
			echo "***************************"
			echo "*  EAST AREA IS SELECTED  *"
			echo "***************************"			
			echo
			echo "Please enter IATA or PSEUDO code"
			read bag
			echo
			log_select
			i=0
			while [ $i -le 1 ]; do
				echo Searching MV3D 3D00$(( mv3d[$i] ))
        		ssh 10.50.0.$(( mv3d[$i] )) 'ssh scc 'less "$log" | grep 'string' | grep "$bag"''
	        	echo Searched
        		echo
				i=$(( $i + 1 ))
				b=false
			done
		;;
#
      	2)
			echo "***************************"
			echo "*  WEST AREA IS SELECTED  *"
			echo "***************************"
			echo
    		echo "Please enter IATA or PSEUDO code"
			read bag
			echo
			log_select
	    	i=2
			while [ $i -le 3 ]; do
      			echo Searching MV3D 3D00$(( mv3d[$i] ))
              	ssh 10.50.0.$(( mv3d[$i] )) 'ssh scc 'less "$log" | grep 'string' | grep "$bag"''
       			echo Searched
                echo
				i=$(( $i + 1 ))
				b=false
  		        done
	    ;;
#
	    3)
			echo "***************************"
			echo "*  ALL AREA IS SELECTED   *"
			echo "***************************"
			echo
			echo "Please enter IATA or PSEUDO code"
			read bag
			echo
			log_select
			i=0
			while [ $i -le 3 ]; do
                echo Searching MV3D 3D00$(( mv3d[$i] ))
       			ssh 10.50.0.$(( mv3d[$i] )) 'ssh scc 'less "$log" | grep 'string' | grep "$bag"''
      			echo Searched
				echo
               	i=$(( $i + 1 ))
				b=false
            done
       	;;
#	
        4)	
       		b=false
			sleep 0.5
			clear
	    ;;
#		
       	*)
			echo "Invalid selection.."
			sleep 1
			clear
       	;;
#	
   	esac
done