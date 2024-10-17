import 'ffi.v4l2.dart' as ffi;

enum V4L2CtrlWhich {
  curVal(ffi.V4L2_CTRL_WHICH_CUR_VAL),
  defVal(ffi.V4L2_CTRL_WHICH_DEF_VAL),
  requestVal(ffi.V4L2_CTRL_WHICH_REQUEST_VAL);

  final int value;

  const V4L2CtrlWhich(this.value);
}
