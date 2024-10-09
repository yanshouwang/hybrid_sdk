import 'v4l2_ffi.dart' as ffi;

/// Input capabilities
enum V4L2InCap {
  /// This input supports setting video timings by using VIDIOC_S_DV_TIMINGS.
  dvTimings(ffi.V4L2_IN_CAP_DV_TIMINGS),

  ///
  customTimings(ffi.V4L2_IN_CAP_CUSTOM_TIMINGS),

  /// This input supports setting the TV standard by using VIDIOC_S_STD.
  std(ffi.V4L2_IN_CAP_STD),

  /// This input supports setting the native size using the V4L2_SEL_TGT_NATIVE_SIZE
  /// selection target, see Common selection definitions.
  nativeSize(ffi.V4L2_IN_CAP_NATIVE_SIZE);

  final int value;

  const V4L2InCap(this.value);
}
