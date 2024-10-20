import 'dart:typed_data';

class V4L2Frame {
  final Uint8List buffer;
  final int width;
  final int height;

  V4L2Frame(this.buffer, this.width, this.height);
}
