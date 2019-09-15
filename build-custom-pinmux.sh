#!/bin/sh

if [ $# -lt 3 ];
    then
        echo "\nLess than 3 arguments specified. Usage is ./build-custom-pinmux.sh PINMUX_CSV_FILE PINMUX_DTSI_FILE GPIO_DTSI FILE, where:\n"
	echo "PINMUX_CSV_FILE  is the full path and filename of the UTF-8 formatted CSV export of the pinmux spreadsheet configuration"
	echo "PINMUX_DTSI_FILE is the device tree dtsi file generated from the spreadsheet 'generate DT File' button that includes pinmux in the filename"
	echo "GPIO_DTSI_FILE   is the device tree dtsi file generated from the spreadsheet 'generate DT File' button that includes gpio in the filename"
	exit 1
fi

if [ ! -f "${1}" ];
    then
	echo "${1} does not exist. Exiting"
	exit 1
fi

if [ ! -f "${2}" ];
    then
        echo "${2} does not exist. Exiting"
	exit 1
fi

if [ ! -f "${3}" ];
    then
        echo "${3} does not exist. Exiting"
	exit 1
fi

NANO_VERSION="b00"

echo "Assuming the Jetson Nano board device tree version is ${NANO_VERSION}. Edit this script and change NANO_VERSION to \"a02\" if the last few characters of 'cat /proc/device-tree/nvidia,dtsfilename' on your nano have the text a02.dts"

echo "=== Updating U-Boot Pinmux using custom device tree file ${1} ==="
cp $1 /jetson-build/tegra-pinmux-scripts/csv/p3450-porg.csv
cd /jetson-build/tegra-pinmux-scripts
./csv-to-board.py p3450-porg
./board-to-uboot.py p3450-porg > pinmux-config-p3450-porg.h
cp /jetson-build/tegra-pinmux-scripts/pinmux-config-p3450-porg.h /jetson-build/Linux_for_Tegra/sources/u-boot/board/nvidia/p3450-porg/

cd /jetson-build/Linux_for_Tegra/sources/u-boot/
make distclean
make p3450-porg_defconfig
make

cp u-boot.bin /jetson-build/Linux_for_Tegra/bootloader/t210ref/p3450-porg/

echo "=== updating CBoot Pinmux using custom device tree files:\n${2}, and \n${3}\n-------------------------------------------------------"
cp $2 /jetson-build/Linux_for_Tegra/sources/hardware/nvidia/platform/t210/porg/kernel-dts/porg-platforms/tegra210-porg-pinmux-p3448-0000-${NANO_VERSION}.dtsi
cp $3 /jetson-build/Linux_for_Tegra/sources/hardware/nvidia/platform/t210/porg/kernel-dts/porg-platforms/tegra210-porg-gpio-p3448-0000-${NANO_VERSION}.dtsi

  
cd /jetson-build/Linux_for_Tegra/sources/kernel/kernel-4.9
make ARCH=arm64 tegra_defconfig
make ARCH=arm64 dtbs
cp arch/arm64/boot/dts/tegra210-p3448-0000-p3449-0000-${NANO_VERSION}.dtb ../../../kernel/dtb/

echo "Compilation complete. If there were no errors, you can now cd to /jetson-build/Linux_for_Tegra and flash your jetson with 'sudo ./flash.sh jetson-nano-qspi-sd mmcblk0p1'"
