#!/bin/bash

function Preset_dtbTool {
	~/Desktop/Android/TOOLS/dtbToolCM -s 2048 -o arch/arm/boot/dt.img -p scripts/dtc/ arch/arm/boot/dts/
}

function preset_toolchain_path {
	export CROSS_COMPILE=~/Desktop/Android/Kernel/UBERTC_arm-eabi-4.9/bin/arm-eabi-
}

function default_export {
	export ARCH=arm
	preset_toolchain_path
}

function cleaning {	
	echo
	make clean && make mrproper
}

function make_menuconfig {
	echo -n "Enter the architecture:"
	read input_architecture
	export ARCH=$input_architecture
	echo -n "Enter toolchain path:"
	read input_toolchain 
	if [[ $input_toolchain =~ ^[Uu]$ ]]
	then
		preset_toolchain_path
	else
		export CROSS_COMPILE=$input_toolchain
	fi
	echo -n "Enter defconfig name:"
	read input_defconfig
	make $input_defconfig
	make menuconfig
}

function compile_func {
		echo -e "$cyan***********************************************"
		echo "          Initializing needed parameters          "
		echo -e "***********************************************$nocol"
		echo
		echo -n "Export defaults[y/n]?"
		read defaults
		if [[ $defaults =~ ^[Yy]$ ]]
		then
			default_export
		else
		echo -n "Enter the architecture:"
		read input_architecture
		export ARCH=$input_architecture
		echo -n "Enter toolchain path:"
		read input_toolchain 
			if [[ $input_toolchain =~ ^[Uu]$ ]]
		then
			preset_toolchain_path
		else
			export CROSS_COMPILE=$input_toolchain
			fi
		fi
		echo -n "Enter the defconfig name:"
		unset input_defconfig
		read input_defconfig
		make $input_defconfig
		echo -n "Enter number of threads:"
		read input_threads
		echo -e "$blue You entered: $input_threads $nocol"
		sleep 1
		make -j$input_threads
		echo
}

BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
nocol='\033[0m'

echo -e "$blue***********************************************"
echo "          Kernel compiler script          "
echo -e "***********************************************$nocol"
sleep 2
echo
echo -n "Do you want to clean[y/n]?:"
read clean
if [[ $clean =~ ^[Yy]$ ]]
then
	cleaning
	echo -n "Do you want to enter menuconfig[y/n]?"
	read menu
	if [[ $menu =~ ^[Yy]$ ]]
	then
		echo -e "$cyan***********************************************"
		echo "          Initializing needed parameters          "
		echo -e "***********************************************$nocol"
		sleep 1
		make_menuconfig
		echo -e "$cyan***Cleaning***$nocol"
		cleaning
		echo -n "Do you want to compile kernel[y/n]?:"
		read compile
		if [[ $compile =~ ^[Yy]$ ]]
		then
			compile_func
			echo
		fi
	elif [[ $menu =~ ^[Nn]$ ]]
	then
		echo
		echo -n "Do you want to compile kernel[y/n]?:"
		read compile
		if [[ $compile =~ ^[Yy]$ ]]
		then
			compile_func
			echo
		fi
	fi	
elif [[ $clean =~ ^[Nn]$ ]]
then
	echo -n "Do you want to enter menuconfig[y/n]?"
	read menu
	if [[ $menu =~ ^[Yy]$ ]]
	then
		echo -e "$cyan***********************************************"
		echo "          Initializing needed parameters          "
		echo -e "***********************************************$nocol"
		sleep 1
		make_menuconfig
		echo "Do you want to compile kernel[y/n]?:"
		read compile
		if [[ $compile =~ ^[Yy]$ ]]
		then
			compile_func
			echo
		fi
	else
	echo -n "Do you want to compile kernel[y/n]?:"
	read compile
		if [[ $compile =~ ^[Yy]$ ]]
		then
			compile_func
			echo
		fi
	fi
fi

echo -n "Do you want to generate dt.img[y/n]?:"
read dtimg
if [[ $dtimg =~ ^[Yy]$ ]]
then
	echo Enter dtbTool path with options.	eg:/path_to_dtb_executable/dtbToolCM -s 2048 -o arch/arm/boot/dt.img -p scripts/dtc/ arch/arm/boot/dts/
	echo -n Path:
	read dtbTool_path
		if [[ $dtbTool_path =~ ^[Pp]$ ]]
		then
			Preset_dtbTool
		else
			$dtbTool_path
		fi
fi
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$blue Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
read -rsp $'Press any key to continue...\n' -n 1 key
clear
