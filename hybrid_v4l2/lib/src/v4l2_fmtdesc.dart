import 'v4l2_fmt_flag.dart';
import 'v4l2_pix_fmt.dart';

abstract interface class V4L2Fmtdesc {
  List<V4L2FmtFlag> get flags;
  String get description;
  V4L2PixFmt get pixelformat;
}
