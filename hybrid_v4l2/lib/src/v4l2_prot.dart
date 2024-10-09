import 'v4l2_ffi.hybrid.dart' as ffi;

enum V4L2Prot {
  /// page can be executed
  exec(ffi.V4L2_PROT_EXEC),

  /// page can be read
  read(ffi.V4L2_PROT_READ),

  /// page can be written
  write(ffi.V4L2_PROT_WRITE),

  /// page can not be accessed
  none(ffi.V4L2_PROT_NONE);

  final int value;

  const V4L2Prot(this.value);
}
