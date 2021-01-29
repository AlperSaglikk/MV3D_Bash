#!/bin/bash
#
#This script exports filament records table
#
#alpersaglik 01072020
#
mv3d_no=(37 40 35 36 38 39 25 17 23 22 33 32 20 28 21 26 27 24 44 46 43 45 41 42)
month_array=('Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec')
i=0
created=0
pwd=$PWD
clear
#
year_select()	{
	echo "Please select year"
	echo "1) `date '+%Y'`"	
	echo "2) `date -d'-1 year' '+%Y'`"
	echo "3) `date -d'-2 year' '+%Y'`";echo
	read YEAR
	case $YEAR in 
		1) 
			R_YEAR=`date '+%Y'`
		;;
		2) 
			R_YEAR=`date -d'-1 YEAR' '+%Y'`
		;;
		3) 
			R_YEAR=`date -d'-2 YEAR' '+%Y'`
		;;
		*)
			echo "Invalid option selected.."
			year_select
		;;
	esac
	echo
}
#
month_select()	{
	echo "Please select month"
	echo "1) January	 7) July"
	echo "2) February	 8) August"
	echo "3) March	 9) September"
	echo "4) April	10) Octomber"
	echo "5) May		11) November"
	echo "6) June		12) December";echo
	read MONTH
	if [[ "$MONTH" -ge "1" ]] &>/dev/null && [[ "$MONTH" -le "12" ]] &>/dev/null;then
		m=$(( $MONTH-1 ))
		R_MONTH=${month_array[$m]}
	else
		echo "Invalid option selected..";echo
		month_select
	fi
	echo
}
#
path_select()	{
	echo "Please select correct folder path to copy tables"
	echo "1) /tmp/"
	echo "2) /mnt/"
	echo "3) /home/eds_cm/"
	echo "4) Write manually";echo
	read FOLDER_PATH
	case $FOLDER_PATH in
		1)
			FOLDER="/tmp/"
		;;
		2)
			FOLDER="/mnt/"
		;;
		3)
			FOLDER="/home/eds_cm/"
		;;
		4)
			correct=1
			while [ $correct -ne 0 ];do
				echo "Please write correct FOLDER path"
				read FOLDER
				ls $FOLDER >> /dev/null 2>&1
				if [ $? -eq 0 ];then
					correct=0
				else
					correct=1
					echo "FOLDER path is not found!!"
				fi
			done
		;;
		*)
			echo "Invalid option selected.."
			path_select
		;;
	esac
	echo
}
#
echo "***************************************"
echo "**                                   **"
echo "**    FILAMENT EXPORT APPLICATION    **"
echo "**                                   **"
echo "***************************************"
echo
echo "Welcome to Filament Export Application"
echo;echo "Please chose correct date so that program can gather recorded table correctly"
year_select
month_select
path_select
#
while [ $i -le 23 ];do
	cd /home/eds_cm/filament_records/3D00$(( mv3d_no[$i] ))/$R_YEAR/ >> /dev/null 2>&1
	if [ $? -eq 0 ];then
		tar -rvf $FOLDER/$R_MONTH""$R_YEAR""_filament_tables.tar $R_MONTH*
		created=7
	else
		echo 3D00$(( mv3d_no[$i] )) $R_MONTH""$R_YEAR filament table is not found
	fi
	cd $pwd
	i=$(( $i + 1 ))
	sleep 0.1
done
sync
echo
if [ $created -eq 7 ];then
	echo Tables saved to $FOLDER as $R_MONTH""$R_YEAR""_filament_tables.tar
else
	echo "No tables found.."
fi
echo
echo "Process Completed..."
echo
