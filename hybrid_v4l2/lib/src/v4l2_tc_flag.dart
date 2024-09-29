import 'ffi.g.dart' as ffi;

/// Timecode Flags
enum V4L2TCFlag {
  /// Indicates “drop frame” semantics for counting frames in 29.97 fps material.
  /// When set, frame numbers 0 and 1 at the start of each minute, except minutes
  /// 0, 10, 20, 30, 40, 50 are omitted from the count.
  dropframe(ffi.V4L2_TC_FLAG_DROPFRAME),

  /// The “color frame” flag.
  colorframe(ffi.V4L2_TC_FLAG_COLORFRAME),

  /// Field mask for the “binary group flags”.
  userbitsField(ffi.V4L2_TC_USERBITS_field),

  /// Unspecified format.
  userbitsUserdefined(ffi.V4L2_TC_USERBITS_USERDEFINED),

  /// 8-bit ISO characters.
  userbits8Bitchars(ffi.V4L2_TC_USERBITS_8BITCHARS);

  final int value;

  const V4L2TCFlag(this.value);
}
