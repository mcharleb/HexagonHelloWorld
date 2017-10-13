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

# This demonstrates how to build the dsp lib and apps procportions separately.
# helloworld builds just the apps proc portion and
# libhelloworld just builds the hexagon portion.

.PHONY check_env helloworld libhelloworld:

check_env:
	@if [ "${HEXAGON_SDK_ROOT}" = "" ]; then echo "HEXAGON_SDK_ROOT not set"; false; fi
	@if [ "${ARM_CROSS_GCC_ROOT}" = "" ]; then echo "ARM_CROSS_GCC_ROOT not set"; false; fi
	@if [ "${BOARD}" = "" ]; then echo "BOARD not set"; false; fi

# This target builds only helloworld for apps proc
helloworld: check_env
	@mkdir -p build_appsproc && cd build_appsproc && cmake -Wno-dev ../appsproc -DBOARD=${BOARD} -DCMAKE_TOOLCHAIN_FILE=../cmake/toolchain/Toolchain-aarch64-linux-gnueabihf.cmake
	@cd build_apps && make
	
# This target builds only libhelloworld.so and libhelloworld_skel.so for adsp proc
libhelloworld: check_env
	@mkdir -p build_hexagon && cd build_hexagon && cmake -Wno-dev ../hexagon -DBOARD=${BOARD} -DCMAKE_TOOLCHAIN_FILE=../cmake/toolchain/Toolchain-qurt.cmake
	@cd build_hexagon && make
	
clean:
	@rm -rf build_hexagon build_appsproc

load-helloworld: helloworld
	adb shell rm -f /usr/share/data/adsp/libexample_interface_skel.so /usr/share/data/adsp/libhelloworld.so /home/linaro/helloworld*
	adb shell rm -f /usr/lib/rfsa/adsp/libexample_interface_skel.so /usr/lib/rfsa/adsp/libhelloworld.so
	cd build_hexagon && make libhelloworld-load
	cd build_appsproc && make helloworld-load

load-libhelloworld: libhelloworld
