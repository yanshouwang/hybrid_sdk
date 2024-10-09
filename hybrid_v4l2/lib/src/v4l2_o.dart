import 'v4l2_ffi.hybrid.dart' as ffi;

enum V4L2O {
  rdonly(ffi.V4L2_O_RDONLY),
  wronly(ffi.V4L2_O_WRONLY),
  rdwr(ffi.V4L2_O_RDWR),
  append(ffi.V4L2_O_APPEND),
  async(ffi.V4L2_O_ASYNC),
  cloexec(ffi.V4L2_O_CLOEXEC),
  creat(ffi.V4L2_O_CREAT),
  direct(ffi.V4L2_O_DIRECT),
  directory(ffi.V4L2_O_DIRECTORY),
  dsync(ffi.V4L2_O_DSYNC),
  excl(ffi.V4L2_O_EXCL),
  largefile(ffi.V4L2_O_LARGEFILE),
  noatime(ffi.V4L2_O_NOATIME),
  nocitty(ffi.V4L2_O_NOCTTY),
  nofollow(ffi.V4L2_O_NOFOLLOW),
  nonblock(ffi.V4L2_O_NONBLOCK),
  opath(ffi.V4L2_O_PATH),
  sync(ffi.V4L2_O_SYNC),
  tmpfile(ffi.V4L2_O_TMPFILE),
  trunc(ffi.V4L2_O_TRUNC);

  final int value;

  const V4L2O(this.value);
}
