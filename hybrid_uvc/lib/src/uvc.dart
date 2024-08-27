import 'dart:typed_data';

import 'hybrid_uvc.dart';

abstract interface class UVC {
  void initialize(UVCFrameCallback frameCallback);

  factory UVC() => HybridUVC.instance;
}

typedef UVCFrameCallback = void Function(UVCFrame frame);

class UVCFrame {
  final int width;
  final int height;
  final Uint8List value;

  UVCFrame(this.width, this.height, this.value);
}
