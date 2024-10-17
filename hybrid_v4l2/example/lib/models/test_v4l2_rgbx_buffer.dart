import 'dart:typed_data';

import 'package:hybrid_v4l2/hybrid_v4l2.dart';

class TestV4L2RGBXBuffer implements V4L2RGBABuffer {
  @override
  final Uint8List value;
  @override
  final int width;
  @override
  final int height;

  TestV4L2RGBXBuffer({
    required this.value,
    required this.width,
    required this.height,
  });
}
