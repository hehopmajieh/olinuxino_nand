#!/bin/bash
#To Do FS
CROSS="arm-linux-gnueabihf-"
ROOTFS="debarmhf"
OUT="out"	
KERNEL_DIR="linux-sunxi"
PACK_DIR="pack"
UBOOT_LOCATION="u-boot"

export PATH=$PATH:$(pwd)/tools/
#little cleanup
if [ -d "out" ]; then
	rm -rf out/
fi

	mkdir out
echo "Copy u-boot to out dir";
	cd u-boot
	cp u-boot.bin ../out/.
	cd ..
patch  linux-sunxi/arch/arm/mach-sun5i/include/mach/i2c.h < i2c.patch
cp olinuxino_config ${KERNEL_DIR}/.config
echo "Building kernel"
	cd ${KERNEL_DIR}
	make ARCH=arm CROSS_COMPILE=${CROSS} -j4 uImage
	make ARCH=arm CROSS_COMPILE=${CROSS} -j4 INSTALL_MOD_PATH=out modules
	make ARCH=arm CROSS_COMPILE=${CROSS} -j4 INSTALL_MOD_PATH=out modules_install

	cp arch/arm/boot/uImage ../pack/chips/sun5i/wboot/bootfs/.
	cp -aR out/* ../out/
	cd ..
rootfs_size=$(du -s ${ROOTFS} | awk '{print $1}');
modules_size=$(du -s ${OUT}/lib/modules | awk '{print $1}');
total_size=$(( $rootfs_size + $modules_size + 10000 ))
echo "make rootfs.ext4"
dd if=/dev/zero of=rootfs.ext4 bs=1024 count=$total_size
losetup /dev/loop0 rootfs.ext4
mkfs -t ext3 -m 1 -v /dev/loop0
if [ -d "tmp" ]; then
        rm -rf tmp/
fi

mkdir tmp
mount -t ext3 /dev/loop0 tmp
cp -ar ${ROOTFS}/* tmp/
mkdir -p tmp/lib/modules
cp -avr ${OUT}/lib/modules/* tmp/lib/modules/.
umount tmp
losetup -d /dev/loop0
cp rootfs.ext4 out/.
cp ${UBOOT_LOCATION}/u-boot.bin out/.
pwd
cd ${PACK_DIR}
echo "Packing for NAND"
bash pack -csun5i -plinux -ba13-evb

