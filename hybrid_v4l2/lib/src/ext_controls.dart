import 'ctrl_class.dart';
import 'ctrl_which.dart';
import 'ext_control.dart';

/// struct v4l2_ext_controls
abstract interface class V4L2ExtControls {
  /// The control class to which all controls belong, see Control classes. Drivers
  /// that use a kernel framework for handling controls will also accept a value
  /// of 0 here, meaning that the controls can belong to any control class. Whether
  /// drivers support this can be tested by setting ctrl_class to 0 and calling
  /// VIDIOC_TRY_EXT_CTRLS with a count of 0. If that succeeds, then the driver
  /// supports this feature.
  V4L2CtrlClass get ctrlClass;

  /// Which value of the control to get/set/try. V4L2_CTRL_WHICH_CUR_VAL will
  /// return the current value of the control and V4L2_CTRL_WHICH_DEF_VAL will
  /// return the default value of the control.
  ///
  /// > *Note*
  /// >
  /// > You can only get the default value of the control, you cannot set or try
  /// > it.
  ///
  /// For backwards compatibility you can also use a control class here (see
  /// Control classes). In that case all controls have to belong to that control
  /// class. This usage is deprecated, instead just use V4L2_CTRL_WHICH_CUR_VAL.
  /// There are some very old drivers that do not yet support V4L2_CTRL_WHICH_CUR_VAL
  /// and that require a control class here. You can test for such drivers by
  /// setting ctrl_class to V4L2_CTRL_WHICH_CUR_VAL and calling VIDIOC_TRY_EXT_CTRLS
  /// with a count of 0. If that fails, then the driver does not support
  /// V4L2_CTRL_WHICH_CUR_VAL.
  V4L2CtrlWhich get which;
  set which(V4L2CtrlWhich value);

  /// Pointer to an array of count v4l2_ext_control structures.
  ///
  /// Ignored if count equals zero.
  List<V4L2ExtControl> get controls;
}
