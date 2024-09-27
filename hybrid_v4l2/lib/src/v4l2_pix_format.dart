import 'v4l2_pix_fmt.dart';

abstract interface class V4L2PixFormat {
  int get width;
  int get height;
  V4L2PixFmt get pixelformat;
  int get field;
}
