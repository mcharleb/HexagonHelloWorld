############################################################################
#
# Copyright (c) 2015-2017 Mark Charlebois. All rights reserved.
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
#
############################################################################

# Overview:
# Hexagon SDK paths need to be set based on env variables
#
# PREREQUISITES:
#
# Environment variables:
#	HEXAGON_SDK_ROOT
#
# CMake Variables:
#	BOARD
#
# OPTIONAL:
#	DSP_TYPE (ADSP or SLPI)

if ("$ENV{HEXAGON_SDK_ROOT}" STREQUAL "")
	message(FATAL_ERROR "HEXAGON_SDK_ROOT not set")
endif()

if (NOT "$ENV{HEXAGON_SDK_ROOT}" MATCHES "/Hexagon_SDK/3.2")
        message(FATAL_ERROR "Unsupported/Unknown HEXAGON SDK version")
endif()

set(HEXAGON_SDK_ROOT $ENV{HEXAGON_SDK_ROOT})

set(HEXAGON_SDK_INCLUDES
	${HEXAGON_SDK_ROOT}/incs
	${HEXAGON_SDK_ROOT}/incs/stddef
	${HEXAGON_SDK_ROOT}/libs/common/rpcmem/inc
	)

if ("${BOARD}" STREQUAL "820C")
	if ("${DSP_TYPE}" STREQUAL "")
		set(DSP_TYPE "ADSP")
	endif()
	set(V_ARCH "v55")
	set(HEXAGON_SDK_INCLUDES ${HEXAGON_SDK_INCLUDES}
		${HEXAGON_SDK_ROOT}/libs/common/qurt/ADSPv60MP/include
		)
	# Validate DSP_TYPE
	if (NOT ("${DSP_TYPE}" STREQUAL "ADSP"))
		message(FATAL_ERROR "DSP_TYPE set to invalid value")
	endif()
elseif ("${BOARD}" STREQUAL "410C")
	# Set the default to MDSP
	if ("${DSP_TYPE}" STREQUAL "")
		set(DSP_TYPE "MDSP")
	endif()
	message("DSP is ${DSP_TYPE}")
	set(V_ARCH "v55")
	set(HEXAGON_SDK_INCLUDES ${HEXAGON_SDK_INCLUDES}
		${HEXAGON_SDK_ROOT}/libs/common/qurt/ADSPv55MP/include
		)
	# Validate DSP_TYPE
	if (NOT ("${DSP_TYPE}" STREQUAL "ADSP") AND NOT ("${DSP_TYPE}" STREQUAL "MDSP"))
		message(FATAL_ERROR "DSP_TYPE set to invalid value")
	endif()
else()
	message(FATAL_ERROR "BOARD not set or invalid")
endif()

