import 'v4l2_cid.dart';

/// struct v4l2_querymenu
abstract interface class V4L2Querymenu {
  /// Identifies the control, set by the application from the respective struct
  /// v4l2_queryctrl id.
  V4L2CId get id;

  /// Index of the menu item, starting at zero, set by the application.
  int get index;

  /// Name of the menu item, a NUL-terminated ASCII string. This information is
  /// intended for the user. This field is valid for V4L2_CTRL_FLAG_MENU type
  /// controls.
  String get name;

  /// Value of the integer menu item. This field is valid for V4L2_CTRL_FLAG_INTEGER_MENU
  /// type controls.
  int get value;
}
