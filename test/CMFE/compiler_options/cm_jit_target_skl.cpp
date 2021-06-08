/*========================== begin_copyright_notice ============================

Copyright (C) 2015-2021 Intel Corporation

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice (including the next
paragraph) shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.

SPDX-License-Identifier: MIT
============================= end_copyright_notice ===========================*/

// XFAIL: *

#include <cm/cm.h>

_GENX_MAIN_
void test() {
}


#define STRING2(x) #x
#define STRING(x) STRING2(x)

#ifdef CM_GENX
#pragma message ( "CM_GENX defined with value " STRING(CM_GENX) )
#else
#warning CM_GENX not defined
#endif

#ifdef CM_GEN7_5
#warning CM_GEN7_5 defined
#endif

#ifdef CM_GEN8
#warning CM_GEN8 defined
#endif

#ifdef CM_GEN8_5
#warning CM_GEN8_5 defined
#endif

#ifdef CM_GEN9
#warning CM_GEN9 defined
#endif

#ifdef CM_GEN9_5
#warning CM_GEN9_5 defined
#endif

#ifdef CM_GEN10
#warning CM_GEN10 defined
#endif

#ifdef CM_GEN10_5
#warning CM_GEN10_5 defined
#endif

#ifdef CM_GEN11
#warning CM_GEN11 defined
#endif

// We test a number of different ways to specify a SKL jit target option.
// All are equivalent, and should produce the same results, so we only need
// one set of CHECK values for all of these tests.
// We check the expected Gen variant macros are defined (and no others), and
// that the Finalizer is called with the expected platform option.
// We also check that the expected files are generated by deleting them, 
// which also leaves things tidy for the next test.

// RUN: %cmc -emit-llvm -Qxcm_jit_target=skl -- %s 2>&1 | FileCheck %s

// RUN: %cmc -emit-llvm -Qxcm_jit_target:skl -- %s 2>&1 | FileCheck %s

// RUN: %cmc -emit-llvm -Qxcm_jit_targethsw -Qxcm_jit_targetskl -- %s 2>&1 | FileCheck %s

// RUN: %cmc -emit-llvm -Qxcm_jit_targetskl -- %s 2>&1 | FileCheck %s

// RUN: %cmc -emit-llvm -Qxcm_jit_target=gen9 -- %s 2>&1 | FileCheck %s

// RUN: %cmc -emit-llvm -Qxcm_jit_target=GEN9 -- %s 2>&1 | FileCheck %s

// RUN: %cmc -emit-llvm /Qxcm_jit_target=SKL -- %s 2>&1 | FileCheck %s

// RUN: %cmc -emit-llvm /Qxcm_jit_target:skL -- %s 2>&1 | FileCheck %s

// RUN: %cmc -emit-llvm /Qxcm_jit_targetSkl -- %s 2>&1 | FileCheck %s

// RUN: %cmc -emit-llvm /Qxcm_jit_targetsKl -- %s 2>&1 | FileCheck %s

// RUN: %cmc -emit-llvm -mcpu=hsw -Qxcm_jit_target=SKl -- %s 2>&1 | FileCheck %s

// RUN: %cmc -emit-llvm -march=bdw -Qxcm_jit_target=SKl -mcpu=hsw -- %s 2>&1 | FileCheck %s

// RUN: %cmc -emit-llvm -Qxcm_jit_target -mcpu=SKL -- %s 2>&1 | FileCheck %s

// RUN: %cmc -emit-llvm -Qxcm_jit_target -mcpu=gEN9 -- %s 2>&1 | FileCheck %s

// RUN: %cmc -emit-llvm -march=Skl -Qxcm_jit_target -- %s 2>&1 | FileCheck %s

// RUN: %cmc -emit-llvm -Qxcm_jit_target -march=Gen9 -- %s 2>&1 | FileCheck %s

// CHECK: cm_jit_target_skl.cpp(12,9):  warning: CM_GENX defined with value 900 [-W#pragma-messages]
// CHECK: cm_jit_target_skl.cpp(30,2):  warning: CM_GEN9 defined [-W#warnings]
// CHECK: 2 warnings generated.
// CHECK: -platform SKL
