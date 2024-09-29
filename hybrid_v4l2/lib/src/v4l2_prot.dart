import 'ffi.g.dart' as ffi;

enum V4L2Prot {
  /// page can be read
  read(ffi.PROT_READ),

  /// page can be written
  write(ffi.PROT_WRITE),

  /// page can be executed
  exec(ffi.PROT_EXEC),

  /// page may be used for atomic ops
  sem(ffi.PROT_SEM),

  /// page can not be accessed
  none(ffi.PROT_NONE),

  /// mprotect flag: extend change to start of growsdown vma
  growsdown(ffi.PROT_GROWSDOWN),

  /// mprotect flag: extend change to end of growsup vma
  grwosup(ffi.PROT_GROWSUP);

  final int value;

  const V4L2Prot(this.value);
}
