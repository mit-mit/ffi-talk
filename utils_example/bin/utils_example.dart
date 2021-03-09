// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:ffi/ffi.dart';

void main(List<String> arguments) {
  // Look up the shared `libutils` library.
  final utilsPath =
      path.join(Directory.current.path, 'utilslib', 'lib', 'libutils.dylib');
  final utilsLib = DynamicLibrary.open(utilsPath);

  // Look up the `add` function.
  final add = utilsLib.lookupFunction<
      // int add(int a, int b)
      Int32 Function(Int32, Int32),
      int Function(int, int)>('add');

  // Call add.
  var result = add(40, 2);
  print('Result is $result.');

  // Look up the `reverse` function.
  final reverse = utilsLib.lookupFunction<
      // void reverse(char str*)
      Void Function(Pointer<Utf8>),
      void Function(Pointer<Utf8> str)>('reverse');

  // Call hello.
  final hello = 'Hello Michael'.toNativeUtf8();
  reverse(hello);
  print('Result is ${hello.toDartString()}');
  calloc.free(hello);
}
