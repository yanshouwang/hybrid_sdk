import 'v4l2_ffi.dart' as ffi;

/// Control classes
enum V4L2CtrlClass {
  /// The class containing user controls. These controls are described in User
  /// Controls. All controls that can be set using the VIDIOC_S_CTRL and VIDIOC_G_CTRL
  /// ioctl belong to this class.
  user(ffi.V4L2_CTRL_CLASS_USER),

  /// The class containing camera controls. These controls are described in Camera
  /// Control Reference.
  camera(ffi.V4L2_CTRL_CLASS_CAMERA),

  /// The class containing FM Transmitter (FM TX) controls. These controls are
  /// described in FM Transmitter Control Reference.
  fmTX(ffi.V4L2_CTRL_CLASS_FM_TX),

  /// The class containing flash device controls. These controls are described in
  /// Flash Control Reference.
  flash(ffi.V4L2_CTRL_CLASS_FLASH),

  /// The class containing JPEG compression controls. These controls are described
  /// in JPEG Control Reference.
  jpeg(ffi.V4L2_CTRL_CLASS_JPEG),

  /// The class containing image source controls. These controls are described in
  /// Image Source Control Reference.
  imageSource(ffi.V4L2_CTRL_CLASS_IMAGE_SOURCE),

  /// The class containing image processing controls. These controls are described
  /// in Image Process Control Reference.
  imageProc(ffi.V4L2_CTRL_CLASS_IMAGE_PROC),

  ///
  dv(ffi.V4L2_CTRL_CLASS_DV),

  /// The class containing FM Receiver (FM RX) controls. These controls are
  /// described in FM Receiver Control Reference.
  fmRX(ffi.V4L2_CTRL_CLASS_FM_RX),

  /// The class containing RF tuner controls. These controls are described in RF
  /// Tuner Control Reference.
  rfTuner(ffi.V4L2_CTRL_CLASS_RF_TUNER),

  ///
  detect(ffi.V4L2_CTRL_CLASS_DETECT),

  /// The class containing MPEG compression controls. These controls are described
  /// in Codec Control Reference.
  mpeg(ffi.V4L2_CTRL_CLASS_MPEG);

  final int value;

  const V4L2CtrlClass(this.value);
}
