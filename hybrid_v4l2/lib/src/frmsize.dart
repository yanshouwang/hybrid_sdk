/// struct v4l2_frmsize_discrete & v4l2_frmsize_stepwise
abstract interface class V4L2Frmsize {
  /// Width of the frame [pixel].
  int get width;

  /// Height of the frame [pixel].
  int get height;
}
