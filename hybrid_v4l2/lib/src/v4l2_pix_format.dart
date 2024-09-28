import 'v4l2_field.dart';
import 'v4l2_pix_fmt.dart';

/// struct v4l2_pix_format
///
/// TODO: add bytesperline, sizeimage, colorspace, priv, flags, ycbcr_enc, quantization and xfer_func
abstract interface class V4L2PixFormat {
  /// Image width in pixels.
  int get width;
  set width(int value);

  /// Image height in pixels. If field is one of V4L2_FIELD_TOP, V4L2_FIELD_BOTTOM
  /// or V4L2_FIELD_ALTERNATE then height refers to the number of lines in the
  /// field, otherwise it refers to the number of lines in the frame (which is
  /// twice the field height for interlaced formats).
  int get height;
  set height(int value);

  /// The pixel format or type of compression, set by the application. This is a
  /// little endian four character code. V4L2 defines standard RGB formats in Packed
  /// RGB Image Formats, YUV formats in YUV Formats, and reserved codes in Reserved
  /// Image Formats
  V4L2PixFmt get pixelformat;
  set pixelformat(V4L2PixFmt value);

  /// Video images are typically interlaced. Applications can request to capture
  /// or output only the top or bottom field, or both fields interlaced or sequentially
  /// stored in one buffer or alternating in separate buffers. Drivers return the
  /// actual field order selected. For more details on fields see Field Order.
  V4L2Field get field;
  set field(V4L2Field value);
}
