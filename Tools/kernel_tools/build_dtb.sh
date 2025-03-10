#!/bin/bash

#build-essential libc6-armel-cross libc6-dev-armel-cross binutils-arm-linux-gnueabi libncurses5-dev gcc-arm-linux-gnueabi lsb-release libssl-dev

kernel_ver="$1"

mkdir -p dts/$kernel_ver
mkdir -p dtb/$kernel_ver

dtbs="$(ls dts/$kernel_ver | grep .dts | sed 's/dts/dtb/g')"

cd linux-source-$kernel_ver
cp  ../configs/custom-config-$kernel_ver .config

rm ../dtb/$kernel_ver/*.dtb 2>/dev/null
rm arch/arm/boot/dts/*.dtb 2>/dev/null
cp ../dts/$kernel_ver/*.dts arch/arm/boot/dts/
cp arch/arm/boot/dts/Makefile arch/arm/boot/dts/Makefile.old
echo 'dtb-y="'$dtbs'"' > arch/arm/boot/dts/Makefile
#tail -n 4 arch/arm/boot/dts/Makefile.old >> arch/arm/boot/dts/Makefile

make -j$(nproc) ARCH=arm CROSS_COMPILE="arm-linux-gnueabi-" $dtbs
cp arch/arm/boot/dts/*.dtb ../dtb/$kernel_ver/
mv arch/arm/boot/dts/Makefile.old arch/arm/boot/dts/Makefile
