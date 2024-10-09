import 'v4l2_ffi.dart' as ffi;

/// Timecode Types
enum V4L2TCType {
  /// 24 frames per second, i. e. film.
  type24FPS(ffi.V4L2_TC_TYPE_24FPS),

  /// 25 frames per second, i. e. PAL or SECAM video.
  type25FPS(ffi.V4L2_TC_TYPE_25FPS),

  /// 30 frames per second, i. e. NTSC video.
  type30FPS(ffi.V4L2_TC_TYPE_30FPS),

  ///
  type50PFS(ffi.V4L2_TC_TYPE_50FPS),

  ///
  type60FPS(ffi.V4L2_TC_TYPE_60FPS);

  final int value;

  const V4L2TCType(this.value);
}
