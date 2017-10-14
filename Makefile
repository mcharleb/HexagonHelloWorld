############################################################################
# Copyright (c) 2017 Mark Charlebois. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in
#    the documentation and/or other materials provided with the
#    distribution.
# 3. Neither the name DBOpenSource nor the names of its contributors may be
#    used to endorse or promote products derived from this software
#    without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
# OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
# AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
############################################################################

# This demonstrates how to build the dsp lib and apps proc portions separately.
# helloworld builds just the apps proc portion and
# libhelloworld just builds the hexagon portion.

all: helloworld libhelloworld

all_targets:
	BOARD=410C make
	BOARD=820C make

.PHONY check_env check_cross_env helloworld libhelloworld binary upload clean:

check_env:
	@if [ "${HEXAGON_SDK_ROOT}" = "" ]; then echo "HEXAGON_SDK_ROOT not set"; false; fi
	@if [ "${BOARD}" = "" ]; then echo "BOARD not set"; false; fi

SYSROOT=linaro-stretch-developer-20170802-73.tar.gz

export HEXAGON_ARM_SYSROOT=$(shell pwd)/binary

check_cross_env: check_env
	@if [ "${ARM_CROSS_GCC_ROOT}" = "" ]; then echo "ARM_CROSS_GCC_ROOT not set"; false; fi

downloads/${SYSROOT}:
	cd downloads && wget http://snapshots.linaro.org/debian/images/stretch/developer-arm64/73/${SYSROOT}

# This is the extracted sysroot fakeroot is used to handle the device nodes
binary:
	fakeroot tar xvzf downloads/${SYSROOT}

helloworld: check_cross_env binary
	@mkdir -p build_appsproc_${BOARD} && cd build_appsproc_${BOARD} && cmake -Wno-dev ../appsproc -DBOARD=${BOARD} -DCMAKE_TOOLCHAIN_FILE=../cmake/toolchain/Toolchain-aarch64-linux-gnueabihf.cmake
	@cd build_appsproc_${BOARD} && make
	
# This target builds only libhelloworld.so and libhelloworld_skel.so for Hexagon and can only be built on the PC
libhelloworld: check_env
	@mkdir -p build_hexagon_${BOARD} && cd build_hexagon_${BOARD} && cmake -Wno-dev ../hexagon -DBOARD=${BOARD} -DCMAKE_TOOLCHAIN_FILE=../cmake/toolchain/Toolchain-qurt.cmake
	@cd build_hexagon_${BOARD} && make
	

# Use: IPADDR=1.2.3.4 BOARD=410C make upload
upload: check_env cross
	@if [ "${IPADDR}" = "" ]; then echo "IPADDR not set"; false; fi
	if [ "${BOARD}" = "820C" ]; then scp build_hexagon_${BOARD}/lib*.so linaro@${IPADDR}:/usr/lib/rfsa/adsp; fi
	if [ "${BOARD}" = "410C" ]; then scp build_hexagon_${BOARD}/lib*.so linaro@${IPADDR}:/usr/share/data/mdsp/; fi
	
clean:
	@rm -rf build_hexagon_* build_appsproc_*

