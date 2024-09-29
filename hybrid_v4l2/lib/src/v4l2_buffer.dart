import 'v4l2_buf_flag.dart';
import 'v4l2_buf_type.dart';
import 'v4l2_field.dart';
import 'v4l2_memory.dart';
import 'v4l2_plane.dart';
import 'v4l2_time_code.dart';
import 'v4l2_timeval.dart';

/// struct v4l2_buffer
abstract interface class V4L2Buffer {
  /// Number of the buffer, set by the application except when calling VIDIOC_DQBUF,
  /// then it is set by the driver. This field can range from zero to the number
  /// of buffers allocated with the ioctl VIDIOC_REQBUFS ioctl (struct
  /// v4l2_requestbuffers count), plus any buffers allocated with ioctl
  /// VIDIOC_CREATE_BUFS minus one.
  int get index;

  /// Type of the buffer, same as struct v4l2_format type or struct v4l2_requestbuffers
  /// type, set by the application. See v4l2_buf_type
  V4L2BufType get type;

  /// The number of bytes occupied by the data in the buffer. It depends on the
  /// negotiated data format and may change with each buffer for compressed variable
  /// size data like JPEG images. Drivers must set this field when type refers to
  /// a capture stream, applications when it refers to an output stream. For
  /// multiplanar formats this field is ignored and the planes pointer is used
  /// instead.
  int get byteused;

  /// Flags set by the application or driver, see Buffer Flags.
  List<V4L2BufFlag> get flags;

  /// Indicates the field order of the image in the buffer, see v4l2_field. This
  /// field is not used when the buffer contains VBI data. Drivers must set it
  /// when type refers to a capture stream, applications when it refers to an
  /// output stream.
  V4L2Field get field;

  /// For capture streams this is time when the first data byte was captured, as
  /// returned by the clock_gettime() function for the relevant clock id; see
  /// V4L2_BUF_FLAG_TIMESTAMP_* in Buffer Flags. For output streams the driver
  /// stores the time at which the last data byte was actually sent out in the
  /// timestamp field. This permits applications to monitor the drift between the
  /// video and system clock. For output streams that use V4L2_BUF_FLAG_TIMESTAMP_COPY
  /// the application has to fill in the timestamp which will be copied by the
  /// driver to the capture stream.
  V4L2Timeval get timestamp;

  /// When the V4L2_BUF_FLAG_TIMECODE flag is set in flags, this structure contains
  /// a frame timecode. In V4L2_FIELD_ALTERNATE mode the top and bottom field
  /// contain the same timecode. Timecodes are intended to help video editing and
  /// are typically recorded on video tapes, but also embedded in compressed
  /// formats like MPEG. This field is independent of the timestamp and sequence
  /// fields.
  V4L2TimeCode get timecode;

  /// Set by the driver, counting the frames (not fields!) in sequence. This field
  /// is set for both input and output devices.
  int get sequence;

  /// This field must be set by applications and/or drivers in accordance with
  /// the selected I/O method. See v4l2_memory
  V4L2Memory get memory;

  /// For the single-planar API and when memory is V4L2_MEMORY_MMAP this is the
  /// offset of the buffer from the start of the device memory. The value is
  /// returned by the driver and apart of serving as parameter to the mmap()
  /// function not useful for applications. See Streaming I/O (Memory Mapping)
  /// for details
  int get offset;

  /// For the single-planar API and when memory is V4L2_MEMORY_USERPTR this is a
  /// pointer to the buffer (casted to unsigned long type) in virtual memory, set
  /// by the application. See Streaming I/O (User Pointers) for details.
  int get userptr;

  /// When using the multi-planar API, contains a userspace pointer to an array
  /// of struct v4l2_plane. The size of the array should be put in the length
  /// field of this struct v4l2_buffer structure.
  List<V4L2Plane> get planes;

  /// For the single-plane API and when memory is V4L2_MEMORY_DMABUF this is the
  /// file descriptor associated with a DMABUF buffer.
  int get fd;

  /// Size of the buffer (not the payload) in bytes for the single-planar API.
  /// This is set by the driver based on the calls to ioctl VIDIOC_REQBUFS and/or
  /// ioctl VIDIOC_CREATE_BUFS. For the multi-planar API the application sets this
  /// to the number of elements in the planes array. The driver will fill in the
  /// actual number of valid elements in that array.
  int get length;

  /// The file descriptor of the request to queue the buffer to. If the flag
  /// V4L2_BUF_FLAG_REQUEST_FD is set, then the buffer will be queued to this
  /// request. If the flag is not set, then this field will be ignored.
  ///
  /// The V4L2_BUF_FLAG_REQUEST_FD flag and this field are only used by ioctl
  /// VIDIOC_QBUF and ignored by other ioctls that take a v4l2_buffer as argument.
  ///
  /// Applications should not set V4L2_BUF_FLAG_REQUEST_FD for any ioctls other
  /// than VIDIOC_QBUF.
  ///
  /// If the device does not support requests, then EBADR will be returned. If
  /// requests are supported but an invalid request file descriptor is given, then
  /// EINVAL will be returned.
  int get requestFd;
}
