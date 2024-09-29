import 'ffi.g.dart' as ffi;

enum V4L2Map {
  shared(ffi.MAP_SHARED),
  private(ffi.MAP_PRIVATE),
  sharedValidate(ffi.MAP_SHARED_VALIDATE),
  hugeShift(ffi.MAP_HUGE_SHIFT),
  hugeMask(ffi.MAP_HUGE_MASK),
  huge64KB(ffi.MAP_HUGE_64KB),
  huge512KB(ffi.MAP_HUGE_512KB),
  huge1MB(ffi.MAP_HUGE_1MB),
  huge2MB(ffi.MAP_HUGE_2MB),
  huge8MB(ffi.MAP_HUGE_8MB),
  huge16MB(ffi.MAP_HUGE_16MB),
  huge32MB(ffi.MAP_HUGE_32MB),
  huge256MB(ffi.MAP_HUGE_256MB),
  huge512MB(ffi.MAP_HUGE_512MB),
  huge1GB(ffi.MAP_HUGE_1GB),
  huge2GB(ffi.MAP_HUGE_2GB),
  huge16GB(ffi.MAP_HUGE_16GB);

  final int value;

  const V4L2Map(this.value);
}
