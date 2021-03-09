// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:ffi/ffi.dart';

// int add(int a, int b);
typedef addC = Int32 Function(Int32 a, Int32 b);
typedef addDart = int Function(int a, int b);

// void reverse(char str*);
typedef reverseC = Void Function(Pointer<Utf8> str);
typedef reverseDart = void Function(Pointer<Utf8> str);

void main(List<String> arguments) {
  final utilsPath =
      path.join(Directory.current.path, 'utilslib', 'lib', 'libutils.dylib');
  final utilsLib = DynamicLibrary.open(utilsPath);
  final add = utilsLib.lookupFunction<addC, addDart>('add');
  var result = add(40, 2);
  print('Result is $result.');

  final reverse = utilsLib.lookupFunction<reverseC, reverseDart>('reverse');
  final hello = 'Hello Michael'.toNativeUtf8();
  reverse(hello);
  print('Result is ${hello.toDartString()}');
  calloc.free(hello);
}
