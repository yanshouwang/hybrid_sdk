// ignore_for_file: always_specify_types
// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint
import 'dart:ffi' as ffi;
import 'v4l2_ffi.dart' as v4l2;

/// Bindings for `hybrid_v4l2`.
///
class LibHybridV4L2 {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  LibHybridV4L2(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  LibHybridV4L2.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  int v4l2_open(
    ffi.Pointer<ffi.Char> file,
    int oflag,
  ) {
    return _v4l2_open(
      file,
      oflag,
    );
  }

  late final _v4l2_openPtr = _lookup<
          ffi.NativeFunction<ffi.Int Function(ffi.Pointer<ffi.Char>, ffi.Int)>>(
      'v4l2_open');
  late final _v4l2_open =
      _v4l2_openPtr.asFunction<int Function(ffi.Pointer<ffi.Char>, int)>();

  int v4l2_close(
    int fd,
  ) {
    return _v4l2_close(
      fd,
    );
  }

  late final _v4l2_closePtr =
      _lookup<ffi.NativeFunction<ffi.Int Function(ffi.Int)>>('v4l2_close');
  late final _v4l2_close = _v4l2_closePtr.asFunction<int Function(int)>();

  int v4l2_ioctlIntPtr(
    int fd,
    int request,
    ffi.Pointer<ffi.Int> va,
  ) {
    return _v4l2_ioctlIntPtr(
      fd,
      request,
      va,
    );
  }

  late final _v4l2_ioctlIntPtrPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Int, ffi.UnsignedLong,
              ffi.VarArgs<(ffi.Pointer<ffi.Int>,)>)>>('v4l2_ioctl');
  late final _v4l2_ioctlIntPtr = _v4l2_ioctlIntPtrPtr
      .asFunction<int Function(int, int, ffi.Pointer<ffi.Int>)>();

  int v4l2_ioctlV4l2v4l2_capabilityPtr(
    int fd,
    int request,
    ffi.Pointer<v4l2.v4l2_capability> va,
  ) {
    return _v4l2_ioctlV4l2v4l2_capabilityPtr(
      fd,
      request,
      va,
    );
  }

  late final _v4l2_ioctlV4l2v4l2_capabilityPtrPtr = _lookup<
          ffi.NativeFunction<
              ffi.Int Function(ffi.Int, ffi.UnsignedLong,
                  ffi.VarArgs<(ffi.Pointer<v4l2.v4l2_capability>,)>)>>(
      'v4l2_ioctl');
  late final _v4l2_ioctlV4l2v4l2_capabilityPtr =
      _v4l2_ioctlV4l2v4l2_capabilityPtrPtr.asFunction<
          int Function(int, int, ffi.Pointer<v4l2.v4l2_capability>)>();

  int v4l2_ioctlV4l2v4l2_inputPtr(
    int fd,
    int request,
    ffi.Pointer<v4l2.v4l2_input> va,
  ) {
    return _v4l2_ioctlV4l2v4l2_inputPtr(
      fd,
      request,
      va,
    );
  }

  late final _v4l2_ioctlV4l2v4l2_inputPtrPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Int, ffi.UnsignedLong,
              ffi.VarArgs<(ffi.Pointer<v4l2.v4l2_input>,)>)>>('v4l2_ioctl');
  late final _v4l2_ioctlV4l2v4l2_inputPtr = _v4l2_ioctlV4l2v4l2_inputPtrPtr
      .asFunction<int Function(int, int, ffi.Pointer<v4l2.v4l2_input>)>();

  int v4l2_ioctlV4l2v4l2_fmtdescPtr(
    int fd,
    int request,
    ffi.Pointer<v4l2.v4l2_fmtdesc> va,
  ) {
    return _v4l2_ioctlV4l2v4l2_fmtdescPtr(
      fd,
      request,
      va,
    );
  }

  late final _v4l2_ioctlV4l2v4l2_fmtdescPtrPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Int, ffi.UnsignedLong,
              ffi.VarArgs<(ffi.Pointer<v4l2.v4l2_fmtdesc>,)>)>>('v4l2_ioctl');
  late final _v4l2_ioctlV4l2v4l2_fmtdescPtr = _v4l2_ioctlV4l2v4l2_fmtdescPtrPtr
      .asFunction<int Function(int, int, ffi.Pointer<v4l2.v4l2_fmtdesc>)>();

  int v4l2_ioctlV4l2v4l2_frmsizeenumPtr(
    int fd,
    int request,
    ffi.Pointer<v4l2.v4l2_frmsizeenum> va,
  ) {
    return _v4l2_ioctlV4l2v4l2_frmsizeenumPtr(
      fd,
      request,
      va,
    );
  }

  late final _v4l2_ioctlV4l2v4l2_frmsizeenumPtrPtr = _lookup<
          ffi.NativeFunction<
              ffi.Int Function(ffi.Int, ffi.UnsignedLong,
                  ffi.VarArgs<(ffi.Pointer<v4l2.v4l2_frmsizeenum>,)>)>>(
      'v4l2_ioctl');
  late final _v4l2_ioctlV4l2v4l2_frmsizeenumPtr =
      _v4l2_ioctlV4l2v4l2_frmsizeenumPtrPtr.asFunction<
          int Function(int, int, ffi.Pointer<v4l2.v4l2_frmsizeenum>)>();

  int v4l2_ioctlV4l2v4l2_formatPtr(
    int fd,
    int request,
    ffi.Pointer<v4l2.v4l2_format> va,
  ) {
    return _v4l2_ioctlV4l2v4l2_formatPtr(
      fd,
      request,
      va,
    );
  }

  late final _v4l2_ioctlV4l2v4l2_formatPtrPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Int, ffi.UnsignedLong,
              ffi.VarArgs<(ffi.Pointer<v4l2.v4l2_format>,)>)>>('v4l2_ioctl');
  late final _v4l2_ioctlV4l2v4l2_formatPtr = _v4l2_ioctlV4l2v4l2_formatPtrPtr
      .asFunction<int Function(int, int, ffi.Pointer<v4l2.v4l2_format>)>();

  int v4l2_ioctlV4l2v4l2_requestbuffersPtr(
    int fd,
    int request,
    ffi.Pointer<v4l2.v4l2_requestbuffers> va,
  ) {
    return _v4l2_ioctlV4l2v4l2_requestbuffersPtr(
      fd,
      request,
      va,
    );
  }

  late final _v4l2_ioctlV4l2v4l2_requestbuffersPtrPtr = _lookup<
          ffi.NativeFunction<
              ffi.Int Function(ffi.Int, ffi.UnsignedLong,
                  ffi.VarArgs<(ffi.Pointer<v4l2.v4l2_requestbuffers>,)>)>>(
      'v4l2_ioctl');
  late final _v4l2_ioctlV4l2v4l2_requestbuffersPtr =
      _v4l2_ioctlV4l2v4l2_requestbuffersPtrPtr.asFunction<
          int Function(int, int, ffi.Pointer<v4l2.v4l2_requestbuffers>)>();

  int v4l2_ioctlV4l2v4l2_bufferPtr(
    int fd,
    int request,
    ffi.Pointer<v4l2.v4l2_buffer> va,
  ) {
    return _v4l2_ioctlV4l2v4l2_bufferPtr(
      fd,
      request,
      va,
    );
  }

  late final _v4l2_ioctlV4l2v4l2_bufferPtrPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Int, ffi.UnsignedLong,
              ffi.VarArgs<(ffi.Pointer<v4l2.v4l2_buffer>,)>)>>('v4l2_ioctl');
  late final _v4l2_ioctlV4l2v4l2_bufferPtr = _v4l2_ioctlV4l2v4l2_bufferPtrPtr
      .asFunction<int Function(int, int, ffi.Pointer<v4l2.v4l2_buffer>)>();

  int v4l2_mmap(
    int fd,
    int offset,
    int len,
    int prot,
    int flags,
    ffi.Pointer<v4l2_mapped_buffer> buf,
  ) {
    return _v4l2_mmap(
      fd,
      offset,
      len,
      prot,
      flags,
      buf,
    );
  }

  late final _v4l2_mmapPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Int, off_t, ffi.Size, ffi.Int, ffi.Int,
              ffi.Pointer<v4l2_mapped_buffer>)>>('v4l2_mmap');
  late final _v4l2_mmap = _v4l2_mmapPtr.asFunction<
      int Function(int, int, int, int, int, ffi.Pointer<v4l2_mapped_buffer>)>();

  int v4l2_munmap(
    ffi.Pointer<v4l2_mapped_buffer> buf,
  ) {
    return _v4l2_munmap(
      buf,
    );
  }

  late final _v4l2_munmapPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Pointer<v4l2_mapped_buffer>)>>('v4l2_munmap');
  late final _v4l2_munmap = _v4l2_munmapPtr
      .asFunction<int Function(ffi.Pointer<v4l2_mapped_buffer>)>();

  int v4l2_select(
    int fd,
    ffi.Pointer<v4l2.timeval> timeout,
  ) {
    return _v4l2_select(
      fd,
      timeout,
    );
  }

  late final _v4l2_selectPtr = _lookup<
      ffi.NativeFunction<
          ffi.Int Function(ffi.Int, ffi.Pointer<v4l2.timeval>)>>('v4l2_select');
  late final _v4l2_select = _v4l2_selectPtr
      .asFunction<int Function(int, ffi.Pointer<v4l2.timeval>)>();

  ffi.Pointer<v4l2_rgbx_buffer> v4l2_mjpeg2rgbx(
    ffi.Pointer<v4l2_mapped_buffer> buf,
  ) {
    return _v4l2_mjpeg2rgbx(
      buf,
    );
  }

  late final _v4l2_mjpeg2rgbxPtr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<v4l2_rgbx_buffer> Function(
              ffi.Pointer<v4l2_mapped_buffer>)>>('v4l2_mjpeg2rgbx');
  late final _v4l2_mjpeg2rgbx = _v4l2_mjpeg2rgbxPtr.asFunction<
      ffi.Pointer<v4l2_rgbx_buffer> Function(
          ffi.Pointer<v4l2_mapped_buffer>)>();

  void v4l2_free_rgbx(
    ffi.Pointer<v4l2_rgbx_buffer> buf,
  ) {
    return _v4l2_free_rgbx(
      buf,
    );
  }

  late final _v4l2_free_rgbxPtr = _lookup<
          ffi.NativeFunction<ffi.Void Function(ffi.Pointer<v4l2_rgbx_buffer>)>>(
      'v4l2_free_rgbx');
  late final _v4l2_free_rgbx = _v4l2_free_rgbxPtr
      .asFunction<void Function(ffi.Pointer<v4l2_rgbx_buffer>)>();
}

final class v4l2_mapped_buffer extends ffi.Struct {
  external ffi.Pointer<ffi.Void> addr;

  @ffi.Size()
  external int len;
}

final class v4l2_rgbx_buffer extends ffi.Struct {
  external ffi.Pointer<ffi.Uint8> addr;

  @ffi.Uint32()
  external int width;

  @ffi.Uint32()
  external int height;
}

typedef off_t = __off_t;
typedef __off_t = ffi.Long;
typedef Dart__off_t = int;

const int V4L2_O_RDONLY = 0;

const int V4L2_O_WRONLY = 1;

const int V4L2_O_RDWR = 2;

const int V4L2_O_APPEND = 1024;

const int V4L2_O_ASYNC = 8192;

const int V4L2_O_CLOEXEC = 524288;

const int V4L2_O_CREAT = 64;

const int V4L2_O_DIRECT = 16384;

const int V4L2_O_DIRECTORY = 65536;

const int V4L2_O_DSYNC = 4096;

const int V4L2_O_EXCL = 128;

const int V4L2_O_LARGEFILE = 0;

const int V4L2_O_NOATIME = 262144;

const int V4L2_O_NOCTTY = 256;

const int V4L2_O_NOFOLLOW = 131072;

const int V4L2_O_NONBLOCK = 2048;

const int V4L2_O_PATH = 2097152;

const int V4L2_O_SYNC = 1052672;

const int V4L2_O_TMPFILE = 4259840;

const int V4L2_O_TRUNC = 512;

const int V4L2_PROT_EXEC = 4;

const int V4L2_PROT_READ = 1;

const int V4L2_PROT_WRITE = 2;

const int V4L2_PROT_NONE = 0;

const int V4L2_MAP_SHARED = 1;

const int V4L2_MAP_PRIVATE = 2;

const int V4L2_MAP_32BIT = 64;

const int V4L2_MAP_ANONYMOUS = 32;

const int V4L2_MAP_DENYWRITE = 2048;

const int V4L2_MAP_EXECUTABLE = 4096;

const int V4L2_MAP_FILE = 0;

const int V4L2_MAP_FIXED = 16;

const int V4L2_MAP_GROWSDOWN = 256;

const int V4L2_MAP_HUGETLB = 262144;

const int V4L2_MAP_LOCKED = 8192;

const int V4L2_MAP_NONBLOCK = 65536;

const int V4L2_MAP_NORESERVE = 16384;

const int V4L2_MAP_POPULATE = 32768;

const int V4L2_MAP_STACK = 131072;
