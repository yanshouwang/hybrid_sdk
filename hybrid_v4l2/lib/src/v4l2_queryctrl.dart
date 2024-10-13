import 'v4l2_cid.dart';
import 'v4l2_ctrl_flag.dart';
import 'v4l2_ctrl_type.dart';

/// struct v4l2_queryctrl
abstract interface class V4L2Queryctrl {
  /// Identifies the control, set by the application. See Control IDs for predefined
  /// IDs. When the ID is ORed with V4L2_CTRL_FLAG_NEXT_CTRL the driver clears
  /// the flag and returns the first control with a higher ID. Drivers which do not
  /// support this flag yet always return an EINVAL error code.
  V4L2CId get id;

  /// Type of control, see v4l2_ctrl_type.
  V4L2CtrlType get type;

  /// Name of the control, a NUL-terminated ASCII string. This information is
  /// intended for the user.
  String get name;

  /// Minimum value, inclusive. This field gives a lower bound for the control.
  /// See enum v4l2_ctrl_type how the minimum value is to be used for each possible
  /// control type. Note that this a signed 32-bit value.
  int get minimum;

  /// Maximum value, inclusive. This field gives an upper bound for the control.
  /// See enum v4l2_ctrl_type how the maximum value is to be used for each possible
  /// control type. Note that this a signed 32-bit value.
  int get maximum;

  /// This field gives a step size for the control. See enum v4l2_ctrl_type how
  /// the step value is to be used for each possible control type. Note that this
  /// an unsigned 32-bit value.
  ///
  /// Generally drivers should not scale hardware control values. It may be
  /// necessary for example when the name or id imply a particular unit and the
  /// hardware actually accepts only multiples of said unit. If so, drivers must
  /// take care values are properly rounded when scaling, such that errors will
  /// not accumulate on repeated read-write cycles.
  ///
  /// This field gives the smallest change of an integer control actually affecting
  /// hardware. Often the information is needed when the user can change controls
  /// by keyboard or GUI buttons, rather than a slider. When for example a hardware
  /// register accepts values 0-511 and the driver reports 0-65535, step should
  /// be 128.
  ///
  /// Note that although signed, the step value is supposed to be always positive.
  int get step;

  /// The default value of a V4L2_CTRL_TYPE_INTEGER, _BOOLEAN, _BITMASK, _MENU or
  /// _INTEGER_MENU control. Not valid for other types of controls.
  ///
  /// > *Note*
  /// >
  /// > Drivers reset controls to their default value only when the driver is first
  /// > loaded, never afterwards.
  int get defaultValue;

  /// Control flags, see Control Flags.
  List<V4L2CtrlFlag> get flags;
}
