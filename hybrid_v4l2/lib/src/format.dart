import 'buf_type.dart';
import 'pix_format.dart';

/// struct v4l2_format
///
/// TODO: add pixMP, win, vbi, sliced, sdr and rawData.
abstract interface class V4L2Format {
  /// Type of the data stream, see v4l2_buf_type.
  V4L2BufType get type;
  set type(V4L2BufType value);

  /// Definition of an image format, see Image Formats, used by video capture and
  /// output devices.
  V4L2PixFormat get pix;
  set pix(V4L2PixFormat value);
}
