import 'dart:ffi';
import 'package:ffi/ffi.dart';

void main(List<String> arguments) {
  final utilsLib = DynamicLibrary.open('utilslib/lib/libutils.1.0.0.dylib');
  final add = utilsLib.lookupFunction<Int32 Function(Int32, Int32),
      int Function(int, int)>('add');
  final result = add(2, 3);
  print(result);

  final hello = 'Hello'.toNativeUtf8();
  final reverse = utilsLib.lookupFunction<Void Function(Pointer<Utf8>),
      void Function(Pointer<Utf8>)>('reverse');
  reverse(hello);
  print(hello.toDartString());
  malloc.free(hello);
}
