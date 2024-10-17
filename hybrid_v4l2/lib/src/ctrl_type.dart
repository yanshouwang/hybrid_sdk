import 'ffi.v4l2.dart' as ffi;

/// enum v4l2_ctrl_type
enum V4L2CtrlType {
  /// An integer-valued control ranging from minimum to maximum inclusive. The step value indicates the increment between values.
  ///
  /// |minimum|step|maximum|
  /// |:-|:-|:-|
  /// |any|any|any|
  integer(ffi.v4l2_ctrl_type.V4L2_CTRL_TYPE_INTEGER),

  /// A boolean-valued control. Zero corresponds to “disabled”, and one means “enabled”.
  ///
  /// |minimum|step|maximum|
  /// |:-|:-|:-|
  /// |0|1|1|
  boolean(ffi.v4l2_ctrl_type.V4L2_CTRL_TYPE_BOOLEAN),

  /// The control has a menu of N choices. The names of the menu items can be enumerated with the VIDIOC_QUERYMENU ioctl.
  ///
  /// |minimum|step|maximum|
  /// |:-|:-|:-|
  /// |>=0|1|N-1|
  menu(ffi.v4l2_ctrl_type.V4L2_CTRL_TYPE_MENU),

  /// A control which performs an action when set. Drivers must ignore the value passed with VIDIOC_S_CTRL and return an EINVAL error code on a VIDIOC_G_CTRL attempt.
  ///
  /// |minimum|step|maximum|
  /// |:-|:-|:-|
  /// |0|0|0|
  button(ffi.v4l2_ctrl_type.V4L2_CTRL_TYPE_BUTTON),

  /// A 64-bit integer valued control. Minimum, maximum and step size cannot be queried using VIDIOC_QUERYCTRL. Only VIDIOC_QUERY_EXT_CTRL can retrieve the 64-bit min/max/step values, they should be interpreted as n/a when using VIDIOC_QUERYCTRL.
  ///
  /// |minimum|step|maximum|
  /// |:-|:-|:-|
  /// |any|any|any|
  integer64(ffi.v4l2_ctrl_type.V4L2_CTRL_TYPE_INTEGER64),

  /// This is not a control. When VIDIOC_QUERYCTRL is called with a control ID equal to a control class code (see Control classes) + 1, the ioctl returns the name of the control class and this control type. Older drivers which do not support this feature return an EINVAL error code.
  ///
  /// |minimum|step|maximum|
  /// |:-|:-|:-|
  /// |n/a|n/a|n/a|
  ctrlClass(ffi.v4l2_ctrl_type.V4L2_CTRL_TYPE_CTRL_CLASS),

  /// The minimum and maximum string lengths. The step size means that the string must be (minimum + N * step) characters long for N ≥ 0. These lengths do not include the terminating zero, so in order to pass a string of length 8 to VIDIOC_S_EXT_CTRLS you need to set the size field of struct v4l2_ext_control to 9. For VIDIOC_G_EXT_CTRLS you can set the size field to maximum + 1. Which character encoding is used will depend on the string control itself and should be part of the control documentation.
  ///
  /// |minimum|step|maximum|
  /// |:-|:-|:-|
  /// |>=0|>=1|>=0|
  string(ffi.v4l2_ctrl_type.V4L2_CTRL_TYPE_STRING),

  /// A bitmask field. The maximum value is the set of bits that can be used, all other bits are to be 0. The maximum value is interpreted as a __u32, allowing the use of bit 31 in the bitmask.
  ///
  /// |minimum|step|maximum|
  /// |:-|:-|:-|
  /// |0|n/a|any|
  bitmask(ffi.v4l2_ctrl_type.V4L2_CTRL_TYPE_BITMASK),

  /// The control has a menu of N choices. The values of the menu items can be enumerated with the VIDIOC_QUERYMENU ioctl. This is similar to V4L2_CTRL_TYPE_MENU except that instead of strings, the menu items are signed 64-bit integers.
  ///
  /// |minimum|step|maximum|
  /// |:-|:-|:-|
  /// |>=0|1|N-1|
  integerMenu(ffi.v4l2_ctrl_type.V4L2_CTRL_TYPE_INTEGER_MENU),

  /// An unsigned 8-bit valued control ranging from minimum to maximum inclusive. The step value indicates the increment between values.
  ///
  /// |minimum|step|maximum|
  /// |:-|:-|:-|
  /// |any|any|any|
  u8(ffi.v4l2_ctrl_type.V4L2_CTRL_TYPE_U8),

  /// An unsigned 16-bit valued control ranging from minimum to maximum inclusive. The step value indicates the increment between values.
  ///
  /// |minimum|step|maximum|
  /// |:-|:-|:-|
  /// |any|any|any|
  u16(ffi.v4l2_ctrl_type.V4L2_CTRL_TYPE_U16),

  /// An unsigned 32-bit valued control ranging from minimum to maximum inclusive. The step value indicates the increment between values.
  ///
  /// |minimum|step|maximum|
  /// |:-|:-|:-|
  /// |any|any|any|
  u32(ffi.v4l2_ctrl_type.V4L2_CTRL_TYPE_U32);

  final int value;

  const V4L2CtrlType(this.value);
}
