#!/bin/bash
#
#This script shows filament records table
#
#alpersaglik 03072020
#
mv3d_no=(37 40 35 36 38 39 25 17 23 22 33 32 20 28 21 26 27 24 44 46 43 45 41 42)
ed_no=(01 02 03 04 05 06 09 10 11 12 13 14 15 16 17 18 19 20 23 24 25 26 27 28)
month_array=('Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec')
#i=0
correct=1
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
mv3d_select()	{
	echo "Please select MV3D"
	echo "1) ED_01(3D0037)	 7) ED_09(3D0025)	13) ED_15(3D0020)	19) ED_23(3D0044)"
	echo "2) ED_02(3D0040)	 8) ED_10(3D0017)	14) ED_16(3D0028)	20) ED_24(3D0046)"
	echo "3) ED_03(3D0035)	 9) ED_11(3D0023)	15) ED_17(3D0021)	21) ED_25(3D0043)"
	echo "4) ED_04(3D0036)	10) ED_12(3D0022)	16) ED_18(3D0026)	22) ED_26(3D0045)"
	echo "5) ED_05(3D0038)	11) ED_13(3D0033)	17) ED_19(3D0027)	23) ED_27(3D0041)"
	echo "6) ED_06(3D0039)	12) ED_14(3D0032)	18) ED_20(3D0024)	24) ED_28(3D0042)";echo
	read MV3D
	if [[ "$MV3D" -ge "1" ]] &>/dev/null && [[ "$MV3D" -le "24" ]] &>/dev/null;then
		m=$(( $MV3D-1 ))
		MV3D=${mv3d_no[$m]}
		ED_NO=${ed_no[$m]}
	else
		echo "Invalid option selected..";echo
		mv3d_select
	fi
	echo
}

#
echo "***************************"
echo "**                       **"
echo "**    FILAMENT TABLES    **"
echo "**                       **"
echo "***************************"
echo
echo "Please chose date and MV3D to check filament table";echo
mv3d_select
year_select
month_select
#
#column -s";" -t $TABLE_PATH | less #echo "TUBE;1-3;1-1;1-2;2-2;2-3;2-1;3-1;3-2;3-3" > $TEMP_FILE
TEMP_FILE="/tmp/.temp_fil.csv"
TABLE_PATH=`locate $R_MONTH""$R_YEAR""_3D00$MV3D""_filament_table.csv`
if [ $? -eq 0 ];then
	echo "3D00"$MV3D"(ED_"$ED_NO"); 1-3; 1-1; 1-2; 2-2; 2-3; 2-1; 3-1; 3-2; 3-3" > $TEMP_FILE
	cat $TABLE_PATH >> $TEMP_FILE
	column -s";" -t $TEMP_FILE | less
	rm -f $TEMP_FILE
else
	echo "$R_MONTH""$R_YEAR""_3D00$MV3D"" filament table not found..";echo
fi
