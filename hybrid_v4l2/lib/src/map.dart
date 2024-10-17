import 'ffi.hybrid_v4l2.dart' as ffi;

enum V4L2Map {
  /// Share changes
  shared(ffi.V4L2_MAP_SHARED),

  /// Changes are private
  private(ffi.V4L2_MAP_PRIVATE),

  ///
  map32Bit(ffi.V4L2_MAP_32BIT),

  /// don't use a file
  anonymous(ffi.V4L2_MAP_ANONYMOUS),

  /// ETXTBSY
  denywrite(ffi.V4L2_MAP_DENYWRITE),

  /// mark it as an executable
  executable(ffi.V4L2_MAP_EXECUTABLE),

  ///
  file(ffi.V4L2_MAP_FILE),

  /// Interpret addr exactly
  fixed(ffi.V4L2_MAP_FIXED),

  /// stack-like segment
  growsdown(ffi.V4L2_MAP_GROWSDOWN),

  /// create a huge page mapping
  hugetlb(ffi.V4L2_MAP_HUGETLB),

  /// pages are locked
  locked(ffi.V4L2_MAP_LOCKED),

  /// do not block on IO
  nonblock(ffi.V4L2_MAP_NONBLOCK),

  /// don't check for reservations
  noreserve(ffi.V4L2_MAP_NORESERVE),

  /// populate (prefault) pagetables
  populate(ffi.V4L2_MAP_POPULATE),

  /// give out an address that is best suited for process/thread stacks
  stack(ffi.V4L2_MAP_STACK);

  /// For anonymous mmap, memory could be uninitialized
  // uninitialized(ffi.V4L2_MAP_UNINITIALIZED);

  final int value;

  const V4L2Map(this.value);
}
