import 'dart:typed_data';

import 'uvc_frame_format.dart';

abstract interface class UVCFrame {
  Uint8List get data;
  int get width;
  int get height;
  UVCFrameFormat get format;
  int get step;
  int get sequence;
  DateTime get captureTime;
  DateTime get captureTimeFinished;
  Uint8List get metadata;
}
