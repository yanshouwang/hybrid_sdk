import 'v4l2_capability.dart';
import 'v4l2_fmtdesc.dart';
import 'v4l2_format.dart';
import 'v4l2_impl.dart';

abstract interface class V4L2 {
  factory V4L2() => V4L2Impl();

  int open(String file);
  void close(int fd);
  V4L2Capability querycap(int fd);
  List<V4L2Fmtdesc> enumFmt(int fd);
  void sFmt(int fd, V4L2Format fmt);
}
