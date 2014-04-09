#!/bin/bash
#此脚本用来 DIY ROM 用
#制作者：陈云
#写于2014年3月 窝窝

PATH=/bin:/sbin:/usr/bin:usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH


processLine(){
	line="$@"
	if [ ! -f $FILE ]; then
		echo "$line does not exist"
	else
		echo $line
	fi
}

if [ ! "$1" == "" ]; then
	FILE="$1"
else 
	echo please enter the file name
	read FILE

fi
if [ ! -f $FILE ]; then
	echo "$FILE does not exist"
	exit 1
elif [ ! -r $FILE ]; then
	echo "$FILE cann't read"

fi
BAKIFS=$IFS
IFS=$(echo -en "\n\b")
exec 3<&0
exec 0<"$FILE"
while read -r line 
do 
	processLine $line

done
exec 0<&3
IFS=$BAKIFS
exit 0