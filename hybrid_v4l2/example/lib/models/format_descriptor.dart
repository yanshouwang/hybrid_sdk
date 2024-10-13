import 'package:hybrid_v4l2/hybrid_v4l2.dart';

class FormatDescriptor {
  final V4L2PixFmt format;
  final List<V4L2Frmsize> sizes;

  FormatDescriptor(this.format, this.sizes);
}
