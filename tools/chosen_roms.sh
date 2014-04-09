#!/bin/bash
#此脚本用来 DIY ROM 用
#制作者：陈云
#写于2014年3月 窝窝

PATH=/bin:/sbin:/usr/bin:usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

location=$1 2>/dev/null
if [ "$location" == "" ] ; then
	location=BasePackage
fi
roms=`./tools/check_roms.sh $location`

if [ "$roms" == "" ]
    then
      echo "没有发现ROM包"
      exit 0
fi
count=0
    rm -f temp.list

    echo >> temp.list
    if [ "$location" == "BasePackage" ]; then
    	echo "可用的第三方ROM底包有: " >> temp.list
    else echo "可用的官方ROM包有:" >> temp.list
    fi
    
    echo >> temp.list

    for filename in $roms 
    do
      count=$(($count+1))

      filename=`echo $filename | sed 's/temp_space/ /g'`

      # Store file names in an array
      file_array[$count]=$filename

      echo "  ($count) $filename" >> temp.list
    done

    more temp.list
    rm -f temp.list

    echo
    if [ "$location" == "BasePackage" ]; then
    	echo -n "请选择底包 (默认1, 取消 0 ， 刷新 请按R): "
    else echo -n "请选择官方包 (默认1, 取消 0 ， 刷新 请按R): "
    fi
    

    read enterNumber

    echo $enterNumber

    if [ "$enterNumber" == "0" ]
    then
      exit 0
    fi

    if [ "$enterNumber" == "" ]
    then
      enterNumber=1
    fi

    if [ "$enterNumber" == "r" ]
    then
      continue
    fi

    if [ "`echo $enterNumber | sed 's/[0-9]*//'`" == "" ] || [ "enterNumber"=="1" ]
    then
      file_chosen=${file_array[$enterNumber]}
      if [ "$location" == "BasePackage" ]; then
      	echo $file_chosen > 1.yun
      else echo $file_chosen > 2.yun
      fi
      if [ "$file_chosen" == "" ]
      then
        echo "Error: Invalid selection"
     #   continue
      else
       # break
       echo 
      fi
    else
      echo "Error: Invalid selection"
     # continue
    fi