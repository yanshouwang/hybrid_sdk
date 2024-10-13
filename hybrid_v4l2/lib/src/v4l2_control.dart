import 'v4l2_cid.dart';

/// struct v4l2_control
abstract interface class V4L2Control {
  /// Identifies the control, set by the application.
  V4L2CId get id;

  /// New value or current value.
  int get value;
  set value(int value);
}
