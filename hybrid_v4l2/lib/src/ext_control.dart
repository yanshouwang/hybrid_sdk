import 'dart:typed_data';

import 'cid.dart';
import 'impl.dart';

// TODO: Add `ptr` field.
/// struct v4l2_ext_control
abstract interface class V4L2ExtControl {
  factory V4L2ExtControl() => V4L2ExtControlImpl.managed();

  /// Identifies the control, set by the application.
  V4L2CId get id;
  set id(V4L2CId value);

  /// New value or current value. Valid if this control is not of type
  /// V4L2_CTRL_TYPE_INTEGER64 and V4L2_CTRL_FLAG_HAS_PAYLOAD is not set.
  int get value;
  set value(int value);

  /// New value or current value. Valid if this control is of type V4L2_CTRL_TYPE_INTEGER64
  /// and V4L2_CTRL_FLAG_HAS_PAYLOAD is not set.
  int get value64;
  set value64(int value);

  /// A pointer to a string. Valid if this control is of type V4L2_CTRL_TYPE_STRING.
  String get string;
  set string(String value);

  /// A pointer to a matrix control of unsigned 8-bit values. Valid if this control
  /// is of type V4L2_CTRL_TYPE_U8.
  Uint8List get u8;
  set u8(Uint8List value);

  /// A pointer to a matrix control of unsigned 16-bit values. Valid if this
  /// control is of type V4L2_CTRL_TYPE_U16.
  Uint16List get u16;
  set u16(Uint16List value);

  /// A pointer to a matrix control of unsigned 32-bit values. Valid if this
  /// control is of type V4L2_CTRL_TYPE_U32.
  Uint32List get u32;
  set u32(Uint32List value);
}
