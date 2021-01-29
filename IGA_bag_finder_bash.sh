#!/bin/bash
#
#This script finds bags from their IATA and PSEUDO number
#
#alpersaglik 24092019
#
#alem
#
echo
clear
mv3d=(37 40 35 36 38 39 25 17 23 22 33 32 20 28 21 26 27 24 44 46 43 45 41 42)
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
		
		1)
			log="/opt/eds/log/bhs.log.2 /opt/eds/log/bhs.log.1 /opt/eds/log/bhs.log.0 /opt/eds/log/bhs.log"
			
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
	echo "1: 2-1(WEST)"
	echo "2: 2-3(Mid-WEST)"
	echo "3: 2-1 & 2-3(WEST SIDE)"
	echo "4: 2-4(Mid-EAST)"
	echo "5: 2-6(EAST)"  
	echo "6: 2-4 & 2-6 (EAST AREA)"
	echo "7: ALL AREA"
	echo "8: EXIT"
	echo
	read area
	echo
#	
	case $area in
#
		1)
			echo "***************************"
			echo "*  WEST AREA IS SELECTED  *"
			echo "***************************"			
			echo
			echo "Please enter IATA or PSEUDO code"
			read bag
			echo
			log_select
			i=0
			while [ $i -le 5 ]; do
				echo Searching MV3D 3D00$(( mv3d[$i] ))
        		ssh 10.1.10.$(( mv3d[$i] )) 'ssh scc 'less "$log" | grep 'string' | grep "$bag"''
	       		echo Searched
        		echo
				i=$(( $i + 1 ))
				b=false
			done
		;;
#
		2)
			echo "*******************************"
			echo "*  Mid-WEST AREA IS SELECTED  *"
			echo "*******************************"
			echo
			echo "Please enter IATA or PSEUDO code"
			read bag
			echo
			log_select
			i=6
			while [ $i -le 11 ]; do
				echo Searching MV3D 3D00$(( mv3d[$i] ))
				ssh 10.1.10.$(( mv3d[$i] )) 'ssh scc 'less "$log" | grep 'string' | grep "$bag"''
		      	echo Searched
	        	echo
				i=$(( $i + 1 ))
				b=false
			done
	    ;;
#
		3)
			echo "********************************"
			echo "*  WEST SIDE AREA IS SELECTED  *"
			echo "********************************"
			echo
			echo "Please enter IATA or PSEUDO code"
			read bag
			echo
			log_select
			i=0
			while [ $i -le 11 ]; do
				echo Searching MV3D 3D00$(( mv3d[$i] ))
            	ssh 10.1.10.$(( mv3d[$i] )) 'ssh scc 'less "$log" | grep 'string' | grep "$bag"''
		        echo Searched
	        	echo
				i=$(( $i + 1 ))
				b=false
			done
	    ;;
#		
	    4)
			echo "*******************************"
			echo "*  Mid-EAST AREA IS SELECTED  *"
			echo "*******************************"
			echo
	    	echo "Please enter IATA or PSEUDO code"
			read bag
			echo
			log_select
			i=12
			while [ $i -le 17 ]; do
				echo Searching MV3D 3D00$(( mv3d[$i] ))
	       		ssh 10.1.10.$(( mv3d[$i] )) 'ssh scc 'less "$log" | grep 'string' | grep "$bag"''
           		echo Searched
           		echo
				i=$(( $i + 1 ))
				b=false
	        	done
	    ;;
#
        5)
			echo "***************************"
			echo "*  EAST AREA IS SELECTED  *"
			echo "***************************"
			echo
	    	echo "Please enter IATA or PSEUDO code"
			read bag
			echo
			log_select
		    i=18
			while [ $i -le 23 ]; do
				echo Searching MV3D 3D00$(( mv3d[$i] ))
		        ssh 10.1.10.$(( mv3d[$i] )) 'ssh scc 'less "$log" | grep 'string' | grep "$bag"''
               	echo Searched
		        echo
				i=$(( $i + 1 ))
				b=false
  		    done
	    ;;
#
	     6)
			echo "********************************"
			echo "*  EAST SIDE AREA IS SELECTED  *"
			echo "********************************"
			echo
	    	echo "Please enter IATA or PSEUDO code"
			read bag
			echo
			log_select
			i=12
			while [ $i -le 23 ]; do
		        echo Searching MV3D 3D00$(( mv3d[$i] ))
        		ssh 10.1.10.$(( mv3d[$i] )) 'ssh scc 'less "$log" | grep 'string' | grep "$bag"''
		       	echo Searched
				echo
              	i=$(( $i + 1 ))
				b=false
          	done
       	;;
#		
	    7)
			echo "***************************"
			echo "*  ALL AREA IS SELECTED  *"
			echo "***************************"
			echo
			echo "Please enter IATA or PSEUDO code"
			read bag
			echo
			log_select
			i=0
			while [ $i -le 23 ]; do
		        echo Searching MV3D 3D00$(( mv3d[$i] ))
        		ssh 10.1.10.$(( mv3d[$i] )) 'ssh scc 'less "$log" | grep 'string' | grep "$bag"''
        		echo Searched
				echo
        		i=$(( $i + 1 ))
				b=false
            done
       	;;
#		
        8)	
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