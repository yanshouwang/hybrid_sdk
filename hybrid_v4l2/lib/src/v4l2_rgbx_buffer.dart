import 'dart:typed_data';

abstract interface class V4L2RGBXBuffer {
  Uint8List get value;
  int get width;
  int get height;
}
