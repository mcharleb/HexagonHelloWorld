# HexagonHelloWorld

The upstream kernel does not yet support FastRPC and diag which are needed for Hexagon development. These are in the process of being added but until the kernel supports them, the following instructions will only work on a downstream kernel running with Debian on a Dragonboard.

## Prerequisites

The following instructions have only been tested from x86_64 Linux Ubuntu 16.04. These instructions will work for Dragonboard 410C/E and Dragonboard 820C (AArch64) but not Dragonboard 600C (armhf). 

### Hexagon SDK
Download and install the [Hexagon 3.2 SDK](https://developer.qualcomm.com/software/hexagon-dsp-sdk/tools) from [Qualcomm developer Network](https://developer.qualcomm.com). You will have to register if you have not already done so.

Export the location of  your SDK installation root:
```
export HEXAGON_SDK_ROOT=~/Qualcomm/Hexagon_SDK/3.2
```

### Linaro AArch64 GCC cross compiler

Create a directory to hold the AArch64 cross compiler, extract it and export its location.

```
export GCC_CROSS_VER=gcc-linaro-5.4.1-2017.05-x86_64_aarch64-linux-gnu
export ARM_CROSS_GCC_ROOT=~/ARM_Tools/${GCC_CROSS_VER}
mkdir -p ${ARM_CROSS_GCC_ROOT}
wget https://releases.linaro.org/components/toolchain/binaries/latest-5/aarch64-linux-gnu/${GCC_CROSS_VER}.tar.xz
tar xJvf ${GCC_CROSS_VER}.tar.xz -C ${ARM_CROSS_GCC_ROOT}/..
```

## Cross Build

The cross build on PC requires HEXAGON_SDK_ROOT and ARM_CROSS_GCC_ROOT to be set.

```
git clone http://github.com/DBOpenSource/HexagonHelloWorld
cd HexagonHelloWorld
```

Supported BOARD values are 410C and 820C.

To build for 410C/E run:
```
BOARD=410C make
```

To build for 820C run:
```
BOARD=820C make
```

### Upload to target

To upload the program to the device, you will need to get the IP address of the target from the device serial console or the terminal connected to the device:
```
ip addr
```
If connected via wifi you will see a wlan0 interface.

Then scp the files to the target:
```
IPADDR=<ADDR> BOARD=410C make upload
```

