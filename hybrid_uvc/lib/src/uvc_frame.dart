import 'dart:typed_data';

class UVCFrame {
  final int width;
  final int height;
  final Uint8List value;

  UVCFrame(this.width, this.height, this.value);
}
