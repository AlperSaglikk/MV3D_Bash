#!/bin/bash
#
#alpersaglik 03072020
#
month_array=('Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec')
clear
#
year_select()	{
	echo "Please select year"
	echo "1) `date '+%Y'`"	
	echo "2) `date -d'-1 year' '+%Y'`"
	echo "3) `date -d'-2 year' '+%Y'`"
	echo "4) Write manually";echo
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
		4) 
			echo "Please write year"
			read mYEAR
			R_YEAR="$mYEAR"
		;;
		*)
			echo "Invalid option selected..";echo
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
		i=$(( $MONTH-1 ))
		R_MONTH=${month_array[$i]}
	else
		echo "Invalid option selected..";echo
		month_select
	fi
	echo
}
#
#
echo "***************************"
echo "**                       **"
echo "**      POWERCYCLES      **"
echo "**                       **"
echo "***************************"
echo
echo "Please chose date";echo
year_select
month_select
#
TEMP_FILE="/tmp/.temp_pc.txt"
TABLE_PATH=`locate $R_MONTH""$R_YEAR"""_Powercycle.txt"`
if [ $? -eq 0 ];then
	echo ""POWERCYCLES";3D0037;3D0040;3D0035;3D0036;3D0038;3D0039;3D0025;3D0017;3D0023;3D0022;3D0033;3D0032;3D0020;3D0028;3D0021;3D0026;3D0027;3D0024;3D0044;3D0046;3D0043;3D0045;3D0041;3D0042" > $TEMP_FILE
	cat $TABLE_PATH >> $TEMP_FILE
	column -s";" -t $TEMP_FILE | less
	rm -f $TEMP_FILE
else
	echo "$R_MONTH""$R_YEAR"_Powercycle" table not found..";echo
fi
