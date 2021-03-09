// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart' as path;

// int add(int a, int b);
typedef addC = Int32 Function(Int32 a, Int32 b);
typedef addDart = int Function(int a, int b);

void main(List<String> arguments) {
  final mathPath = path.join(
      Directory.current.path, 'mathlib', 'libmath.dylib');
  final mathLib = DynamicLibrary.open(mathPath);
  final add = mathLib.lookupFunction<addC, addDart>('add');
  var result = add(40, 2);
  print('Result is $result.');
}
