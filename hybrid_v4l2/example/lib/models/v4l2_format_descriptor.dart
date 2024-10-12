import 'package:hybrid_v4l2/hybrid_v4l2.dart';

class V4L2FormatDescriptor {
  final V4L2PixFmt format;
  final List<V4L2Frmsize> sizes;

  V4L2FormatDescriptor(this.format, this.sizes);
}
