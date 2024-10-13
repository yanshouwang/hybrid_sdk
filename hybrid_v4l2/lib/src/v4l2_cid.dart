import 'v4l2_ffi.dart' as ffi;

enum V4L2CId {
  focusAbsolute(ffi.V4L2_CID_FOCUS_ABSOLUTE),
  focusRelative(ffi.V4L2_CID_FOCUS_RELATIVE),
  focusAuto(ffi.V4L2_CID_FOCUS_AUTO),
  zoomAbsolute(ffi.V4L2_CID_ZOOM_ABSOLUTE),
  zoomRelative(ffi.V4L2_CID_ZOOM_RELATIVE),
  zoomContinuous(ffi.V4L2_CID_ZOOM_CONTINUOUS);

  final int value;

  const V4L2CId(this.value);
}
