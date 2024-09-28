import 'v4l2_buf_type.dart';
import 'v4l2_fmt_flag.dart';
import 'v4l2_pix_fmt.dart';

/// struct v4l2_fmtdesc
abstract interface class V4L2Fmtdesc {
  /// Type of the data stream, set by the application. Only these types are valid
  /// here: V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
  /// V4L2_BUF_TYPE_VIDEO_OUTPUT, V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE and
  /// V4L2_BUF_TYPE_VIDEO_OVERLAY. See v4l2_buf_type.
  V4L2BufType get type;

  /// See Image Format Description Flags
  List<V4L2FmtFlag> get flags;

  /// Description of the format, a NUL-terminated ASCII string. This information
  /// is intended for the user, for example: “YUV 4:2:2”.
  String get description;

  /// The image format identifier. This is a four character code as computed by
  /// the v4l2_fourcc() macro:
  V4L2PixFmt get pixelformat;
}
