// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:ffi';

import 'package:ffi/ffi.dart';

void main(List<String> arguments) {
  final dylib = DynamicLibrary.open('utilslib/lib/libutils.1.0.0.dylib');
  final add = dylib.lookupFunction<Int32 Function(Int32, Int32),
      int Function(int, int)>('add');
  final result = add(40, 2);
  print(result);

  final hello = 'Hello'.toNativeUtf8();
  final reverse = dylib.lookupFunction<Void Function(Pointer<Utf8>),
      void Function(Pointer<Utf8>)>('reverse');
  reverse(hello);
  print(hello.toDartString());
  malloc.free(hello);
}
