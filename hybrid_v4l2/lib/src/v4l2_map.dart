import 'ffi.g.dart' as ffi;

enum V4L2Map {
  /// Share changes
  shared(ffi.MAP_SHARED),

  /// Changes are private
  private(ffi.MAP_PRIVATE),

  /// share + validate extension flags
  sharedValidate(ffi.MAP_SHARED_VALIDATE),

  /// Mask for type of mapping
  type(ffi.MAP_TYPE),

  /// Interpret addr exactly
  fixed(ffi.MAP_FIXED),

  /// don't use a file
  anonymous(ffi.MAP_ANONYMOUS),

  /// stack-like segment
  growsdown(ffi.MAP_GROWSDOWN),

  /// ETXTBSY
  denywrite(ffi.MAP_DENYWRITE),

  /// mark it as an executable
  executable(ffi.MAP_EXECUTABLE),

  /// pages are locked
  locked(ffi.MAP_LOCKED),

  /// don't check for reservations
  noreserve(ffi.MAP_NORESERVE),

  /// populate (prefault) pagetables
  populate(ffi.MAP_POPULATE),

  /// do not block on IO
  nonblock(ffi.MAP_NONBLOCK),

  /// give out an address that is best suited for process/thread stacks
  stack(ffi.MAP_STACK),

  /// create a huge page mapping
  hugetlb(ffi.MAP_HUGETLB),

  /// perform synchronous page faults for the mapping
  sync(ffi.MAP_SYNC),

  /// MAP_FIXED which doesn't unmap underlying mapping
  fixedNoReplace(ffi.MAP_FIXED_NOREPLACE),

  /// For anonymous mmap, memory could be uninitialized
  uninitialized(ffi.MAP_UNINITIALIZED);

  final int value;

  const V4L2Map(this.value);
}
