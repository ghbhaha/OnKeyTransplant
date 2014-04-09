#!/bin/bash
#此脚本用来 DIY ROM 用
#制作者：陈云
#写于2014年3月 窝窝

PATH=/bin:/sbin:/usr/bin:usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

location=$1
cd ./$location 
roms=`find . -maxdepth 1 -type f | grep -i \\.zip$ | sed 's/ /temp_space/g' 2>/dev/null`
echo $roms
