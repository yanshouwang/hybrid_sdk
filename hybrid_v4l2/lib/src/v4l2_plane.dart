/// struct v4l2_plane
abstract interface class V4L2Plane {
  /// The number of bytes occupied by data in the plane (its payload). Drivers
  /// must set this field when type refers to a capture stream, applications when
  /// it refers to an output stream.
  int get byteused;

  /// Size in bytes of the plane (not its payload). This is set by the driver
  /// based on the calls to ioctl VIDIOC_REQBUFS and/or ioctl VIDIOC_CREATE_BUFS.
  int get length;

  /// When the memory type in the containing struct v4l2_buffer is V4L2_MEMORY_MMAP,
  /// this is the value that should be passed to mmap(), similar to the offset
  /// field in struct v4l2_buffer.
  int get memOffset;

  /// When the memory type in the containing struct v4l2_buffer is V4L2_MEMORY_USERPTR,
  /// this is a userspace pointer to the memory allocated for this plane by an
  /// application.
  int get userptr;

  /// When the memory type in the containing struct v4l2_buffer is V4L2_MEMORY_DMABUF,
  /// this is a file descriptor associated with a DMABUF buffer, similar to the
  /// fd field in struct v4l2_buffer.
  int get fd;

  /// Offset in bytes to video data in the plane. Drivers must set this field when
  /// type refers to a capture stream, applications when it refers to an output
  /// stream.
  int get dataOffset;
}
