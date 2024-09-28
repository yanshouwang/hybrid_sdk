import 'ffi.g.dart' as ffi;

/// enum v4l2_memory
enum V4L2Memory {
  /// The buffer is used for memory mapping I/O.
  mmap(ffi.v4l2_memory.V4L2_MEMORY_MMAP),

  /// The buffer is used for user pointer I/O.
  userptr(ffi.v4l2_memory.V4L2_MEMORY_USERPTR),

  /// [to do]
  overlay(ffi.v4l2_memory.V4L2_MEMORY_OVERLAY),

  /// The buffer is used for DMA shared buffer I/O.
  dmabuf(ffi.v4l2_memory.V4L2_MEMORY_DMABUF);

  final int value;

  const V4L2Memory(this.value);
}
