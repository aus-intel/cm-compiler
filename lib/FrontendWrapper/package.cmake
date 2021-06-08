#=========================== begin_copyright_notice ============================
#
# Copyright (C) 2020-2021 Intel Corporation
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice (including the next
# paragraph) shall be included in all copies or substantial portions of the
# Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
#
# SPDX-License-Identifier: MIT
#============================ end_copyright_notice =============================

# Variables to manipulate packages:
# FEWRAPPER_MAJOR, FEWRAPPER_MINOR, FEWRAPPER_PATCH - version provided in 3 separate values
# FEWRAPPER_VERSION - version provided in form 1.2.34
# FEWRAPPER_REQUIRES - package dependecies in format "intel-igc-core >= 1.0.2490"

if(NOT (DEFINED FEWRAPPER_MAJOR AND DEFINED FEWRAPPER_MINOR AND DEFINED FEWRAPPER_PATCH) )
  if(DEFINED FEWRAPPER_VERSION)
    set(GIT_TAG "cmclang-${FEWRAPPER_VERSION}-0-0000000")
  else()
    find_package(Git)
    execute_process(
      COMMAND ${GIT_EXECUTABLE} describe --long --tags
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      OUTPUT_VARIABLE GIT_TAG
      RESULT_VARIABLE EXIT_STATUS
      ERROR_VARIABLE GET_TAG_ERROR
    )
    if(NOT EXIT_STATUS EQUAL 0)
      message(WARNING "[CMFE] Could not get package revision: ${GET_TAG_ERROR}")
      set(GIT_TAG "cmclang-1.0.1-0-00000000")
    endif()
  endif()

  string(REGEX MATCH "^cmclang-([0-9]+)\.([0-9]+)\.([0-9]+)-([0-9]+)-" FEVERSION "${GIT_TAG}")
  if(CMAKE_MATCH_COUNT EQUAL 4)
    set(FEWRAPPER_MAJOR ${CMAKE_MATCH_1})
    set(FEWRAPPER_MINOR ${CMAKE_MATCH_2})
    set(BASE_PATCH ${CMAKE_MATCH_3})
    set(ADD_PATCH ${CMAKE_MATCH_4})
    math(EXPR FEWRAPPER_PATCH "${BASE_PATCH} + ${ADD_PATCH}")
  else()
    message(WARNING "[CMFE] Could not understand package version: ${GIT_TAG}")
    set(FEWRAPPER_MAJOR 1)
    set(FEWRAPPER_MINOR 0)
    set(FEWRAPPER_PATCH 1)
  endif()
endif()
message("[CMFE] Detected CMFE version ${FEWRAPPER_MAJOR}.${FEWRAPPER_MINOR}.${FEWRAPPER_PATCH}")

set(CPACK_PACKAGE_ARCHITECTURE "x86_64")
set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE "amd64")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Intel")
set(CPACK_DEBIAN_COMPRESSION_TYPE "xz")
set(CPACK_RPM_PACKAGE_ARCHITECTURE "x86_64")
set(CPACK_RPM_PACKAGE_RELEASE 1)
set(CPACK_RPM_COMPRESSION_TYPE "xz")

set(CPACK_RESOURCE_FILE_LICENSE ${CMAKE_SOURCE_DIR}/LICENSE.TXT)

if(NOT DEFINED DISTRO_NAME)
  find_program(LSB_RELEASE_EXEC lsb_release)
  execute_process(COMMAND ${LSB_RELEASE_EXEC} -is
      OUTPUT_VARIABLE LSB_RELEASE_ID_SHORT
      OUTPUT_STRIP_TRAILING_WHITESPACE
  )
  string(TOLOWER "${LSB_RELEASE_ID_SHORT}" DISTRO_NAME)
    execute_process(COMMAND ${LSB_RELEASE_EXEC} -rs
    OUTPUT_VARIABLE DISTRO_VERSION
    OUTPUT_STRIP_TRAILING_WHITESPACE
  )
endif()

if("${DISTRO_NAME}" STREQUAL "ubuntu")
set(DISTRO_INITIAL "u")
elseif("${DISTRO_NAME}" STREQUAL "fedora")
set(DISTRO_INITIAL "f")
elseif("${DISTRO_NAME}" STREQUAL "clear-linux-os")
set(DISTRO_INITIAL "cl")
elseif("${DISTRO_NAME}" STREQUAL "centos")
set(DISTRO_INITIAL "ce")
else()
set(DISTRO_INITIAL "generic")
endif()

string(TOLOWER "${CMAKE_BUILD_TYPE}" PACKAGE_BUILD_TYPE)

set(UMD_PACKAGE_TYPE "${DISTRO_INITIAL}${DISTRO_VERSION}-${PACKAGE_BUILD_TYPE}.${CPACK_RPM_PACKAGE_ARCHITECTURE}")

set(CPACK_PACKAGE_VERSION_MAJOR ${FEWRAPPER_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${FEWRAPPER_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${FEWRAPPER_PATCH})
set(CPACK_DEBIAN_PACKAGE_NAME "intel-igc-cm")
set(CPACK_RPM_PACKAGE_NAME "intel-igc-cm")
set(CPACK_DEBIAN_PACKAGE_DESCRIPTION "The Intel(R) C for Metal compiler is a open source compiler that implements C for Metal programming language. C for Metal is a new GPU kernel programming language for Intel HD Graphics.")
set(CPACK_RPM_PACKAGE_DESCRIPTION "The Intel(R) C for Metal compiler is a open source compiler that implements C for Metal programming language. C for Metal is a new GPU kernel programming language for Intel HD Graphics.")
set(CPACK_DEBIAN_PACKAGE_DESCRIPTION_SUMMARY "Intel(R) C for Metal Compiler")
set(CPACK_RPM_PACKAGE_DESCRIPTION_SUMMARY "Intel(R) C for Metal Compiler")
set(CPACK_DEBIAN_FILE_NAME "intel-igc-cm-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}-${CPACK_PACKAGE_VERSION_PATCH}.${UMD_PACKAGE_TYPE}.deb")
set(CPACK_RPM_FILE_NAME "intel-igc-cm-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}-${CPACK_PACKAGE_VERSION_PATCH}.${UMD_PACKAGE_TYPE}.rpm")
set(CPACK_ARCHIVE_FILE_NAME "intel-igc-cm-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}-${CPACK_PACKAGE_VERSION_PATCH}.${UMD_PACKAGE_TYPE}")
set(CPACK_PACKAGE_VERSION "${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")

set(CPACK_COMPONENTS_GROUPING ALL_COMPONENTS_IN_ONE)

if(DEFINED FEWRAPPER_REQUIRES)
  set(CPACK_DEBIAN_CLANGFEWRAPPER_PACKAGE_DEPENDS "${FEWRAPPER_REQUIRES}")
  set(CPACK_RPM_CLANGFEWRAPPER_PACKAGE_REQUIRES "${FEWRAPPER_REQUIRES}")
endif()

set(CPACK_COMPONENT_INSTALL ON)
set(CPACK_DEB_COMPONENT_INSTALL ON)
set(CPACK_RPM_COMPONENT_INSTALL ON)
set(CPACK_ARCHIVE_COMPONENT_INSTALL ON)

set(CMC_TOOL_NAME cmc)
set(CPACK_COMPONENTS_ALL clangFEWrapper ${CMC_TOOL_NAME})
set(CPACK_GENERATOR "RPM" "DEB" "TXZ")
include(CPack)
