import 'ffi.g.dart' as ffi;

/// enum v4l2_buf_type
enum V4L2BufType {
  /// Buffer of a single-planar video capture stream, see Video Capture Interface.
  videoCapture(ffi.v4l2_buf_type.V4L2_BUF_TYPE_VIDEO_CAPTURE),

  /// Buffer of a single-planar video output stream, see Video Output Interface.
  videoOutput(ffi.v4l2_buf_type.V4L2_BUF_TYPE_VIDEO_OUTPUT),

  /// Buffer for video overlay, see Video Overlay Interface.
  videoOverlay(ffi.v4l2_buf_type.V4L2_BUF_TYPE_VIDEO_OVERLAY),

  /// Buffer of a raw VBI capture stream, see Raw VBI Data Interface.
  vbiCapture(ffi.v4l2_buf_type.V4L2_BUF_TYPE_VBI_CAPTURE),

  /// Buffer of a raw VBI output stream, see Raw VBI Data Interface.
  vbiOutput(ffi.v4l2_buf_type.V4L2_BUF_TYPE_VBI_OUTPUT),

  /// Buffer of a sliced VBI capture stream, see Sliced VBI Data Interface.
  slicedVBICapture(ffi.v4l2_buf_type.V4L2_BUF_TYPE_SLICED_VBI_CAPTURE),

  /// Buffer of a sliced VBI output stream, see Sliced VBI Data Interface.
  slicedVBIOutput(ffi.v4l2_buf_type.V4L2_BUF_TYPE_SLICED_VBI_OUTPUT),

  /// Buffer for video output overlay (OSD), see Video Output Overlay Interface.
  videoOutputOverlay(ffi.v4l2_buf_type.V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY),

  /// Buffer of a multi-planar video capture stream, see Video Capture Interface.
  videoCaptureMPlane(ffi.v4l2_buf_type.V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE),

  /// Buffer of a multi-planar video output stream, see Video Output Interface.
  videoOutputMPlane(ffi.v4l2_buf_type.V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE),

  /// Buffer for Software Defined Radio (SDR) capture stream, see Software Defined Radio Interface (SDR).
  sdrCapture(ffi.v4l2_buf_type.V4L2_BUF_TYPE_SDR_CAPTURE),

  /// Buffer for Software Defined Radio (SDR) output stream, see Software Defined Radio Interface (SDR).
  sdrOutput(ffi.v4l2_buf_type.V4L2_BUF_TYPE_SDR_OUTPUT),

  ///
  metaCapture(ffi.v4l2_buf_type.V4L2_BUF_TYPE_META_CAPTURE),

  ///
  metaOutput(ffi.v4l2_buf_type.V4L2_BUF_TYPE_META_OUTPUT);

  final int value;

  const V4L2BufType(this.value);
}
