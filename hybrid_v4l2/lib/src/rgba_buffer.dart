import 'dart:ffi' as ffi;
import 'dart:typed_data';

abstract interface class V4L2RGBABuffer implements ffi.Finalizable {
  Uint8List get value;
  int get width;
  int get height;
}
