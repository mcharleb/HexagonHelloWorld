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

export ARM_TOOLS_DIR=${HEXAGON_SDK_ROOT}/../../ARM_Tools
mkdir -p ${ARM_TOOLS_DIR}

wget https://releases.linaro.org/components/toolchain/binaries/latest-5/aarch64-linux-gnu/gcc-linaro-5.4.1-2017.05-x86_64_aarch64-linux-gnu.tar.xz
tar xJvf gcc-linaro-5.4.1-2017.05-x86_64_aarch64-linux-gnu.tar.xz -C ${ARM_TOOLS_DIR}
export ARM_CROSS_GCC_ROOT=${ARM_TOOLS_DIR}/gcc-linaro-5.4.1-2017.05-x86_64_aarch64-linux-gnu
```

## Build

The build requires HEXAGON_SDK_ROOT and ARM_CROSS_GCC_ROOT to be set.

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

## Upload to target

To upload the program to the device, connect the micro UDB cable to device and PC and verify that it is connected:
```
sudo adb devices
```

You should see your device listed. Then upload the software:

```
BOARD=410C make upload
```


