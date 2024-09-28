import 'v4l2_buf_type.dart';
import 'v4l2_memory.dart';

/// struct v4l2_requestbuffers
///
/// TODO: add capalities & flags
abstract interface class V4L2Requestbuffers {
  /// The number of buffers requested or granted.
  int get count;
  set count(int value);

  /// Type of the stream or buffers, this is the same as the struct v4l2_format
  /// type field. See v4l2_buf_type for valid values.
  V4L2BufType get type;
  set type(V4L2BufType value);

  /// Applications set this field to V4L2_MEMORY_MMAP, V4L2_MEMORY_DMABUF or
  /// V4L2_MEMORY_USERPTR. See v4l2_memory.
  V4L2Memory get memory;
  set memory(V4L2Memory value);
}
