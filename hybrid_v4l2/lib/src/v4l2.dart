import 'buf_type.dart';
import 'buffer.dart';
import 'capability.dart';
import 'cid.dart';
import 'control.dart';
import 'crop.dart';
import 'cropcap.dart';
import 'ctrl_class.dart';
import 'ctrl_which.dart';
import 'ext_control.dart';
import 'ext_controls.dart';
import 'fmtdesc.dart';
import 'format.dart';
import 'frmsize.dart';
import 'impl.dart';
import 'input.dart';
import 'map.dart';
import 'mapped_buffer.dart';
import 'memory.dart';
import 'o.dart';
import 'pix_fmt.dart';
import 'prot.dart';
import 'query_ext_ctrl.dart';
import 'queryctrl.dart';
import 'querymenu.dart';
import 'requestbuffers.dart';
import 'rgba_buffer.dart';
import 'timeval.dart';

/// Video for Linux API
abstract interface class V4L2 {
  factory V4L2() => V4L2Impl();

  /// v4l2-open - Open a V4L2 device
  int open(String file, List<V4L2O> oflag);

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

  List<V4L2Frmsize> enumFramesizes(int fd, V4L2PixFmt pixelFormat);

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

  /// VIDIOC_CROPCAP - Information about the video cropping and scaling abilities
  V4L2Cropcap cropcap(int fd, V4L2BufType type);

  /// VIDIOC_G_CROP - Get the current cropping rectangle
  V4L2Crop gCrop(int fd, V4L2BufType type);

  /// VIDIOC_S_CROP - Set the current cropping rectangle
  void sCrop(int fd, V4L2Crop crop);

  /// VIDIOC_QUERYCTRL - Enumerate controls
  V4L2Queryctrl queryctrl(int fd, V4L2CId id);

  /// VIDIOC_QUERY_EXT_CTRL - Enumerate controls
  V4L2QueryExtCtrl queryExtCtrl(int fd, V4L2CId id);

  /// VIDIOC_QUERYMENU - Enumerate menu control items
  V4L2Querymenu querymenu(int fd, V4L2CId id, int index);

  /// VIDIOC_G_CTRL - Get the value of a control
  V4L2Control gCtrl(int fd, V4L2CId id);

  /// VIDIOC_S_CTRL - Set the value of a control
  void sCtrl(int fd, V4L2Control ctrl);

  /// VIDIOC_G_EXT_CTRLS - Get the value of several controls, try control values
  V4L2ExtControls gExtCtrls(
    int fd,
    V4L2CtrlClass ctrlClass,
    V4L2CtrlWhich which,
    List<V4L2ExtControl> controls,
  );

  /// VIDIOC_S_EXT_CTRLS - Set the value of several controls, try control values
  void sExtCtrls(int fd, V4L2ExtControls ctrls);

  /// VIDIOC_TRY_EXT_CTRLS - Set the value of several controls, try control values
  void tryExtCtrls(int fd, V4L2ExtControls ctrls);

  /// v4l2-mmap - Map device memory into application address space
  V4L2MappedBuffer mmap(
    int fd,
    int offset,
    int len,
    List<V4L2Prot> prot,
    List<V4L2Map> flags,
  );

  /// v4l2-munmap - Unmap device memory
  void munmap(V4L2MappedBuffer buf);

  /// v4l2-select - Synchronous I/O multiplexing
  void select(int fd, V4L2Timeval timeout);

  V4L2RGBABuffer mjpegToRGBA(V4L2MappedBuffer buf, double ratio);
}
