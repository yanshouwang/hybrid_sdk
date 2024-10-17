import 'cid.dart';
import 'ctrl_flag.dart';
import 'ctrl_type.dart';

/// struct v4l2_query_ext_ctrl
abstract interface class V4L2QueryExtCtrl {
  /// Identifies the control, set by the application. See Control IDs for predefined
  /// IDs. When the ID is ORed with V4L2_CTRL_FLAG_NEXT_CTRL the driver clears
  /// the flag and returns the first non-compound control with a higher ID. When
  /// the ID is ORed with V4L2_CTRL_FLAG_NEXT_COMPOUND the driver clears the flag
  /// and returns the first compound control with a higher ID. Set both to get the
  /// first control (compound or not) with a higher ID.
  V4L2CId get id;

  /// Type of control, see v4l2_ctrl_type.
  V4L2CtrlType get type;

  /// Name of the control, a NUL-terminated ASCII string. This information is
  /// intended for the user.
  String get name;

  /// Minimum value, inclusive. This field gives a lower bound for the control.
  /// See enum v4l2_ctrl_type how the minimum value is to be used for each possible
  /// control type. Note that this a signed 64-bit value.
  int get minimum;

  /// Maximum value, inclusive. This field gives an upper bound for the control.
  /// See enum v4l2_ctrl_type how the maximum value is to be used for each possible
  /// control type. Note that this a signed 64-bit value.
  int get maximum;

  /// This field gives a step size for the control. See enum v4l2_ctrl_type how
  /// the step value is to be used for each possible control type. Note that this
  /// an unsigned 64-bit value.
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
  int get step;

  /// The default value of a V4L2_CTRL_TYPE_INTEGER, _INTEGER64, _BOOLEAN, _BITMASK,
  /// _MENU, _INTEGER_MENU, _U8 or _U16 control. Not valid for other types of
  /// controls.
  ///
  /// > *Note*
  /// >
  /// > Drivers reset controls to their default value only when the driver is first
  /// > loaded, never afterwards.
  int get defaultValue;

  /// Control flags, see Control Flags.
  List<V4L2CtrlFlag> get flags;

  /// The size in bytes of a single element of the array. Given a char pointer p
  /// to a 3-dimensional array you can find the position of cell (z, y, x) as
  /// follows: p + ((z * dims[1] + y) * dims[0] + x) * elem_size. elem_size is
  /// always valid, also when the control isn’t an array. For string controls
  /// elem_size is equal to maximum + 1.
  int get elemSize;

  /// The number of elements in the N-dimensional array. If this control is not
  /// an array, then elems is 1. The elems field can never be 0.
  int get elems;

  /// The number of dimension in the N-dimensional array. If this control is not
  /// an array, then this field is 0.
  int get nrOfDims;

  /// The size of each dimension. The first nr_of_dims elements of this array must
  /// be non-zero, all remaining elements must be zero.
  List<int> get dims;
}
