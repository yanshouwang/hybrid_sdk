import 'buf_type.dart';
import 'rect.dart';

/// struct v4l2_crop
abstract interface class V4L2Crop {
  /// Type of the data stream, set by the application. Only these types are valid
  /// here: V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_BUF_TYPE_VIDEO_OUTPUT and
  /// V4L2_BUF_TYPE_VIDEO_OVERLAY. See v4l2_buf_type.
  V4L2BufType get type;

  /// Cropping rectangle. The same co-ordinate system as for struct v4l2_cropcap
  /// bounds is used.
  V4L2Rect get c;
}
