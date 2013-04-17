Instructions to build NAND image for Olinuxino A13

1. First You nedd working ARM  toolchain , i use linaro toolchain on Debian Wheezy :
    
        wget https://launchpad.net/linaro-toolchain-binaries/trunk/2013.01/+download/gcc-linaro-arm-linux-gnueabihf-4.7-2013.01-20130125_linux.tar.bz2

2. Extract toolchain and add it to your system path 
    
        export PATH=/fullt/path/to/toolchain/bin/:$PATH

3. Download a root file system, you can use any rootfs capable to run on armhf for example : 

        http://linux-sunxi.org/Debian

4. Download linux-sunxi Kernel :

        git clone git://github.com/linux-sunxi/linux-sunxi.git

5. Configure build.sh. Kepp in mind this is simpole build script, and if you want to improve it go ahead :) 
  edit variables pointing to your right directories :

    CROSS="arm-linux-gnueabihf-"
    
    ROOTFS="debarmhf"
    
    OUT="out"
    
    KERNEL_DIR="linux-sunxi"
    
    PACK_DIR="pack"
    
    UBOOT_LOCATION="u-boot"

6. Run build.sh
