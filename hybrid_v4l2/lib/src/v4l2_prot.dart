import 'ffi.g.dart' as ffi;

enum V4L2Prot {
  read(ffi.PROT_READ),
  write(ffi.PROT_WRITE),
  exec(ffi.PROT_EXEC),
  sem(ffi.PROT_SEM),
  none(ffi.PROT_NONE),
  growsdown(ffi.PROT_GROWSDOWN),
  grwosup(ffi.PROT_GROWSUP);

  final int value;

  const V4L2Prot(this.value);
}
