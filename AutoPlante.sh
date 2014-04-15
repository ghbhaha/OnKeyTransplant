#!/bin/bash
#此脚本用来 DIY ROM 用
#制作者：陈云
#写于2014年4月 于深圳语信公司

PATH=/bin:/sbin:/usr/bin:usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

DATE=`date "+%Y%m%d%H%M%S" `


if [ ! -d "OffcialPackage" ]; then
  	mkdir OffcialPackage
fi
if [ ! -d "BasePackage" ]; then
  	mkdir BasePackage
fi
reset
echo 请选择你想移植的UI或者OS
echo 1： 乐蛙 OS5 或者 乐蛙 OS4
echo 2： MIUI V5 
echo 3：	百度云 （未测试）
echo 4： color OS （未测试）
echo 5： 其他 （未测试）
echo
echo
read  -p "请根据提示输入序号:  "  OS
echo
echo
case $OS in
	1 ) OS=LEWA;;
	2 ) OS=MIUI;;
	3 ) OS=baidu;;
	4 ) OS=COLOR;;
	5 ) OS=OTHER;;
esac
echo 

echo "===========================欢迎使用$OS一键移植工具========================"
echo
echo "请将$OS包放置于BasePackage中 将官方包放置于OffcialPackage中"
echo "整个过程中，你可能需要手动对比修改三四个文件"
echo "所以你需要beyond compare软件"
echo ""
echo  
echo
echo "准备好了啊？"
echo
read -p "请按任意键继续" any
#for (( i = 0; i < 1000; i++ )); do
#	cd ./OffcialPackage
#	if [ ! -f "*.zip" ]; then
# 	echo "没有发现官方包……你玩我呢？"
# 	OffcialPackage=1
#	fi
#	cd ../BasePackage
#	if [ ! -f "*.zip" ]; then
#  	echo "没有发现$OS包……你玩我呢？"
#  	BasePackage=1
#	fi
#	cd ../
#	if [ "$BasePackage" != 1 ] && [ "$OffcialPackage" != 1 ]; then
#		break 
#	fi
#	echo
#	echo
#	read -p "请将官方包或者 $OS底包放入相应文件夹!!!" dasdsa
#done
rm -rf $OS offcial 2>/dev/null
mkdir $OS
mkdir offcial
echo "开始解压到各个文件夹"
echo
echo
./tools/chosen_roms.sh BasePackage
./tools/chosen_roms.sh OffcialPackage
basepackage=`./tools/readinfomation.sh 1.yun`
offcial=`./tools/readinfomation.sh 2.yun`
rm 1.yun 2.yun
echo
echo 
echo "开始解压到各个文件夹"
rm -rf ./$OS
rm -rf ./offcial
cd ./BasePackage
unzip $basepackage -d ../$OS/
cd ../OffcialPackage
unzip $offcial -d ../offcial/
cd ../
echo
echo
echo "解压完成"
echo "开始修改boot.img...."
echo
sleep 1
echo
cp ./$OS/boot.img ./${OS}boot.img
cp ./offcial/boot.img ./offcialboot.img
./tools/unpack-MT65xx.pl ./${OS}boot.img

echo
echo
./tools/unpack-MT65xx.pl ./offcialboot.img
echo
echo
echo "即将打开两个文件对比，请将官方包里的init.rc中的BOOTCLASSPATH 对比$OS中的替换"
echo "注意（mtk的init.rc有两到三个BOOTCLASSPATH，都需要替换）"
echo
echo
echo
sleep 2
bcompare ${OS}boot.img-ramdisk/init.rc offcialboot.img-ramdisk/init.rc
./tools/repack-MT65xx.pl -boot offcialboot.img-kernel.img offcialboot.img-ramdisk boot.img 
rm ./$OS/boot.img
mv boot.img ./$OS/
rm -rf ${OS}boot.img-ramdisk
rm -rf offcialboot.img-ramdisk
rm offcialboot.img-kernel.img
rm ${OS}boot.img-kernel.img
rm ${OS}boot.img
rm offcialboot.img
echo "boot.img修改完成，现在开始修改modules...."
cp -r ./offcial/system/lib/modules ./$OS/system/lib
echo
echo
echo "修改完成......"
echo
echo
echo "开始移植传感器......"
sleep 1
echo
echo
rm -rf ./$OS/system/lib/hw
rm -rf ./$OS/system/vendor/lib
cp -r ./offcial/system/lib/hw ./$OS/system/lib
cp -r ./offcial/system/vendor/lib ./$OS/system/vendor
echo
echo "移植完成，开始移植相机系统"
sleep 1
echo 
echo
echo
cp ./offcial/system/lib/camera.default.so ./$OS/system/lib/
cp ./offcial/system/lib/libcam*.so ./$OS/system/lib/
echo
echo
echo "相机移植完成,开始移植电话，FM，radio系统"
echo
echo
rm -rf ./$OS/system/etc/firmware
cp -r ./offcial/system/etc/firmware ./$OS/system/etc
echo
echo
echo "FM和RADIO系统移植完成，开始移植按键配置"
echo
echo
rm -rf ./$OS/system/usr/keychars ./$OS/system/usr/keylayout
cp -r ./offcial/system/usr/keylayout ./$OS/system/usr
cp -r ./offcial/system/usr/keychars ./$OS/system/usr
echo
echo
echo "按键配置移植完成，开始移植通信系统"
echo
echo
echo
cp ./offcial/system/lib/libreference-ril.so ./$OS/system/lib
cp ./offcial/system/lib/libril*.so ./$OS/system/lib
cp ./offcial/system/lib/libutilrilmtk.so ./$OS/system/lib
cp ./offcial/system/lib/mtk-ril*.so ./$OS/system/lib
echo
echo
echo
echo "通信系统移植完成"
echo
echo "开始移植音频系统....."
sleep 1
cp ./offcial/system/lib/libaudio.primary.default.so ./$OS/system/lib
echo
echo
# YUN ADD 20140415
echo "开始移植sensor系统"
cp ./offcial/system/lib/libsensorservice.so ./$OS/system/lib
echo
echo
echo
read -p "是否需要去掉官方recovery刷写?" flashrecovery
echo
echo
echo
if [ "$flashrecovery" == "y" ] || [ "$flashrecovery" == "Y" ]; then
	rm -rf ./$OS/recovery
fi
echo "请在打开的文本编辑器中删掉开头的验证信息以及recovery刷写信息"
#YUN END
echo
echo
echo
bcompare ./$OS/META-INF/com/google/android/updater-script ./offcial/META-INF/com/google/android/updater-script
echo
echo
echo
echo "请在打开的文本编辑器中对比修改成自己的机型文件"
echo
sleep 1
echo
echo
echo
bcompare ./$OS/system/build.prop ./offcial/system/build.prop
sleep 1
bcompare ./$OS/system/etc/custom.conf ./offcial/system/etc/custom.conf
echo
echo
echo "大部分工作移植完成，现在开始打包测试......"
echo
echo
cd ./$OS
zip -r update.zip *
if [ ! -d "../output" ]; then
mkdir ../output
fi
mv update.zip ../output/${OS}_update$DATE.zip
echo
echo
echo
echo "移植完成，请测试！"
echo
echo
echo
exit
