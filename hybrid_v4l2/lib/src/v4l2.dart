import 'v4l2_buf_type.dart';
import 'v4l2_buffer.dart';
import 'v4l2_capability.dart';
import 'v4l2_fmtdesc.dart';
import 'v4l2_format.dart';
import 'v4l2_impl.dart';
import 'v4l2_input.dart';
import 'v4l2_map.dart';
import 'v4l2_mapped_buffer.dart';
import 'v4l2_memory.dart';
import 'v4l2_prot.dart';
import 'v4l2_requestbuffers.dart';
import 'v4l2_timeval.dart';

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

  /// VIDIOC_QUERYBUF - Query the status of a buffer
  V4L2Buffer querybuf(int fd, V4L2BufType type, V4L2Memory memory, int index);

  /// VIDIOC_QBUF - Exchange a buffer with the driver
  void qbuf(int fd, V4L2Buffer buf);

  /// VIDIOC_DQBUF - Exchange a buffer with the driver
  V4L2Buffer dqbuf(int fd, V4L2BufType type, V4L2Memory memory);

  /// VIDIOC_STREAMON - Start streaming I/O
  void streamon(int fd, V4L2BufType type);

  /// VIDIOC_STREAMOFF - Stop streaming I/O
  void streamoff(int fd, V4L2BufType type);

  /// v4l2-mmap - Map device memory into application address space
  V4L2MappedBuffer mmap(
    int fd,
    int offset,
    int len,
    List<V4L2Prot> prot,
    List<V4L2Map> flags,
  );

  /// v4l2-munmap - Unmap device memory
  void munmap(V4L2MappedBuffer buf, int len);

  /// v4l2-select - Synchronous I/O multiplexing
  void select(int fd, V4L2Timeval timeout);
}
