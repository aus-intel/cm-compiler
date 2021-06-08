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

// RUN: %cmc -emit-llvm -- %s 2>&1 | FileCheck %s

#include <cm/cm.h>

matrix<int,4,6> m;
vector<int,4> v;
int i;
SurfaceIndex si;
struct S1 {
  int a;
} s1;
struct S2 {
  int n_elems;
} s2;

_GENX_MAIN_
void test() {
  int r1 = v.n_elems;                // expected '('
  int r2 = v.n_elems(;               // expected ')'
  int r3 = v.n_elems(1;              // expected ')'
  int r4 = v.n_elems(0);             // unexpected expression
  int r5 = v.n_elems();              // OK
  int r6 = v.template n_elems();     // OK
  int r7 = m.n_elems;                // expected '('
  int r8 = m.n_elems(;               // expected ')'
  int r9 = m.n_elems(0);             // unexpected expression
  int r10 = m.n_elems();             // OK
  int r11 = m.template n_elems();    // OK
  int r12 = s1.n_elems;              // no n_elems in s1
  int r13 = s1.n_elems();            // no n_elems() in s1
  int r14 = s2.n_elems;              // OK
  int r15 = s2.n_elems();            // n_elems not a function
  int r16 = s2.template n_elems();   // not a template
  s2.n_elems = 1;                    // OK
  s2.template n_elems = 2;           // not a template
  v.n_elems() = 2;                   // not assignable
}
// CHECK: n_elems.cpp(18,21):  error: expected '('
// CHECK: n_elems.cpp(19,22):  error: expected ')'
// CHECK: n_elems.cpp(20,22):  error: expected ')'
// CHECK: n_elems.cpp(21,22):  error: expected ')'
// CHECK: n_elems.cpp(24,21):  error: expected '('
// CHECK: n_elems.cpp(25,22):  error: expected ')'
// CHECK: n_elems.cpp(26,22):  error: expected ')'
// CHECK: n_elems.cpp(29,16):  error: no member named 'n_elems' in 'S1'
// CHECK: n_elems.cpp(30,16):  error: no member named 'n_elems' in 'S1'
// CHECK: n_elems.cpp(32,23):  error: called object type 'int' is not a function or function pointer
// CHECK: n_elems.cpp(33,25):  error: 'n_elems' following the 'template' keyword does not refer to a template
// CHECK: n_elems.cpp(35,15):  error: 'n_elems' following the 'template' keyword does not refer to a template
// CHECK: n_elems.cpp(36,15):  error: expression is not assignable
// CHECK: 13 errors generated.
