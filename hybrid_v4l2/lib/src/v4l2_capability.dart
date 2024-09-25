import 'ffi.g.dart' as ffi;

/// Values for 'capabilities' field
enum V4L2Capability {
  /// Is a video capture device
  videoCapture(ffi.V4L2_CAP_VIDEO_CAPTURE),

  /// Is a video output device
  videoOutput(ffi.V4L2_CAP_VIDEO_OUTPUT),

  /// Can do video overlay
  videoOverlay(ffi.V4L2_CAP_VIDEO_OVERLAY),

  /// Is a raw VBI capture device
  vbiCapture(ffi.V4L2_CAP_VBI_CAPTURE),

  /// Is a raw VBI output device
  vbiOutput(ffi.V4L2_CAP_VBI_OUTPUT),

  /// Is a sliced VBI capture device
  slicedVBICapture(ffi.V4L2_CAP_VBI_CAPTURE),

  /// Is a sliced VBI output device
  slicedVBIOutput(ffi.V4L2_CAP_VBI_OUTPUT),

  /// RDS data capture
  rdsCapture(ffi.V4L2_CAP_RDS_CAPTURE),

  /// Can do video output overlay
  videoOutputOverlay(ffi.V4L2_CAP_VIDEO_OUTPUT_OVERLAY),

  /// Can do hardware frequency seek
  hwFreqSeek(ffi.V4L2_CAP_HW_FREQ_SEEK),

  /// Is an RDS encoder
  rdsOutput(ffi.V4L2_CAP_RDS_OUTPUT),

  /// Is a video capture device that supports multiplanar formats
  videoCaptureMplane(ffi.V4L2_CAP_VIDEO_CAPTURE_MPLANE),

  /// Is a video output device that supports multiplanar formats
  videoOutputMplane(ffi.V4L2_CAP_VIDEO_OUTPUT_MPLANE),

  /// Is a video mem-to-mem device that supports multiplanar formats
  videoM2MMplane(ffi.V4L2_CAP_VIDEO_M2M_MPLANE),

  /// Is a video mem-to-mem device
  videoM2M(ffi.V4L2_CAP_VIDEO_M2M),

  /// has a tuner
  tuner(ffi.V4L2_CAP_TUNER),

  /// has audio support
  audio(ffi.V4L2_CAP_AUDIO),

  /// is a radio device
  radio(ffi.V4L2_CAP_RADIO),

  /// has a modulator
  modulator(ffi.V4L2_CAP_MODULATOR),

  /// Is a SDR capture device
  sdrCapture(ffi.V4L2_CAP_SDR_CAPTURE),

  /// Supports the extended pixel format
  extPixFormat(ffi.V4L2_CAP_EXT_PIX_FORMAT),

  /// Is a SDR output device
  sdrOutput(ffi.V4L2_CAP_SDR_OUTPUT),

  /// Is a metadata capture device
  metaCapture(ffi.V4L2_CAP_META_CAPTURE),

  /// read/write systemcalls
  readWrite(ffi.V4L2_CAP_READWRITE),

  /// streaming I/O ioctls
  streaming(ffi.V4L2_CAP_STREAMING),

  /// Is a metadata output device
  metaOutput(ffi.V4L2_CAP_META_OUTPUT),

  /// Is a touch device
  touch(ffi.V4L2_CAP_TOUCH),

  /// Is input/output controlled by the media controller
  ioMC(ffi.V4L2_CAP_IO_MC),

  /// sets device capabilities field
  deviceCapabilities(ffi.V4L2_CAP_DEVICE_CAPS);

  final int value;

  const V4L2Capability(this.value);
}
