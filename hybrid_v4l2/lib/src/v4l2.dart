import 'v4l2_buf_type.dart';
import 'v4l2_capability.dart';
import 'v4l2_fmtdesc.dart';
import 'v4l2_format.dart';
import 'v4l2_impl.dart';
import 'v4l2_input.dart';
import 'v4l2_requestbuffers.dart';

/// Video for Linux API
abstract interface class V4L2 {
  factory V4L2() => V4L2Impl();

  /// v4l2-open - Open a V4L2 device
  int open(String file);

  /// v4l2-close - Close a V4L2 device
  void close(int fd);

  /// VIDIOC_QUERYCAP - Query device capabilities
  V4L2Capability querycap(int fd);

  /// VIDIOC_ENUMINPUT - Enumerate video inputs
  List<V4L2Input> enuminput(int fd);

  /// VIDIOC_G_INPUT - Query the current video input
  V4L2Input gInput(int fd);

  /// VIDIOC_S_INPUT - Select the current video input
  void sInput(int fd, V4L2Input input);

  /// VIDIOC_ENUM_FMT - Enumerate image formats
  List<V4L2Fmtdesc> enumFmt(int fd, V4L2BufType type);

  /// VIDIOC_G_FMT - Get the data format
  V4L2Format gFmt(int fd, V4L2BufType type);

  /// VIDIOC_S_FMT - Set the data format
  void sFmt(int fd, V4L2Format fmt);

  /// VIDIOC_TRY_FMT - Try a format
  void tryFmt(int fd, V4L2Format fmt);

  /// VIDIOC_REQBUFS - Initiate Memory Mapping, User Pointer I/O or DMA buffer
  /// I/O
  void reqbufs(int fd, V4L2Requestbuffers req);
}
