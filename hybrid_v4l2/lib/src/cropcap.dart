import 'buf_type.dart';
import 'fract.dart';
import 'rect.dart';

/// VIDIOC_CROPCAP - Information about the video cropping and scaling abilities
abstract interface class V4L2Cropcap {
  /// Type of the data stream, set by the application. Only these types are valid
  /// here: V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_BUF_TYPE_VIDEO_OUTPUT and
  /// V4L2_BUF_TYPE_VIDEO_OVERLAY. See v4l2_buf_type.
  V4L2BufType get type;

  /// Defines the window within capturing or output is possible, this may exclude
  /// for example the horizontal and vertical blanking areas. The cropping rectangle
  /// cannot exceed these limits. Width and height are defined in pixels, the driver
  /// writer is free to choose origin and units of the coordinate system in the
  /// analog domain.
  V4L2Rect get bounds;

  /// Default cropping rectangle, it shall cover the “whole picture”. Assuming
  /// pixel aspect 1/1 this could be for example a 640 × 480 rectangle for NTSC,
  /// a 768 × 576 rectangle for PAL and SECAM centered over the active picture
  /// area. The same co-ordinate system as for bounds is used.
  V4L2Rect get defrect;

  /// This is the pixel aspect (y / x) when no scaling is applied, the ratio of
  /// the actual sampling frequency and the frequency required to get square pixels.
  ///
  /// When cropping coordinates refer to square pixels, the driver sets pixelaspect
  /// to 1/1. Other common values are 54/59 for PAL and SECAM, 11/10 for NTSC
  /// sampled according to [ITU BT.601].
  V4L2Fract get pixelaspect;
}
