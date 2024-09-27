import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart' as ffi;

import 'ffi.g.dart' as ffi;
import 'ffi.x.dart' as ffi;
import 'v4l2.dart';
import 'v4l2_cap.dart';
import 'v4l2_capability.dart';
import 'v4l2_error.dart';
import 'v4l2_fmt_flag.dart';
import 'v4l2_fmtdesc.dart';
import 'v4l2_format.dart';
import 'v4l2_pix_fmt.dart';
import 'v4l2_pix_format.dart';

final class V4L2Impl implements V4L2 {
  @override
  int open(String file) {
    final filePtr = file.toNativeUtf8().cast<ffi.Char>();
    final fd = ffi.libV4L2.open(filePtr, ffi.O_RDWR | ffi.O_NONBLOCK, 0);
    ffi.malloc.free(filePtr);
    if (fd == -1) {
      throw V4L2Error('open failed, $fd.');
    }
    return fd;
  }

  @override
  void close(int fd) {
    final status = ffi.libV4L2.close(fd);
    if (status != 0) {
      throw V4L2Error('close failed, $status.');
    }
  }

  @override
  V4L2Capability querycap(int fd) {
    final cap = V4L2CapabilityImpl();
    final err =
        ffi.libV4L2.ioctlV4l2_capabilityPtr(fd, ffi.VIDIOC_QUERYCAP, cap.ptr);
    if (err != 0) {
      throw V4L2Error('ioctl failed, $err.');
    }
    return cap;
  }

  @override
  List<V4L2Fmtdesc> enumFmt(int fd) {
    final fmts = <V4L2Fmtdesc>[];
    var index = 0;
    while (true) {
      final fmt = V4L2FmtdescImpl();
      fmt.ptr.ref.type = ffi.v4l2_buf_type.V4L2_BUF_TYPE_VIDEO_CAPTURE.value;
      fmt.ptr.ref.index = index;
      final err =
          ffi.libV4L2.ioctlV4l2_fmtdescPtr(fd, ffi.VIDIOC_ENUM_FMT, fmt.ptr);
      if (err != 0) {
        break;
      }
      fmts.add(fmt);
      index++;
    }
    return fmts;
  }

  @override
  void sFmt(int fd, V4L2Format fmt) {
    if (fmt is! V4L2FormatImpl) {
      throw TypeError();
    }
  }
}

final class V4L2CapabilityImpl implements V4L2Capability, ffi.Finalizable {
  static final finalizer = ffi.NativeFinalizer(ffi.malloc.nativeFree);

  final ffi.Pointer<ffi.v4l2_capability> ptr;

  V4L2CapabilityImpl() : ptr = ffi.malloc() {
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  String get driver => ptr.ref.driver.toDart();

  @override
  String get card => ptr.ref.card.toDart();

  @override
  String get busInfo => ptr.ref.bus_info.toDart();

  @override
  int get version => ptr.ref.version;

  @override
  List<V4L2Cap> get capabilities => ptr.ref.capabilities.toDartCaps();

  @override
  List<V4L2Cap> get deviceCaps => ptr.ref.device_caps.toDartCaps();
}

final class V4L2FmtdescImpl implements V4L2Fmtdesc, ffi.Finalizable {
  static final finalizer = ffi.NativeFinalizer(ffi.malloc.nativeFree);

  final ffi.Pointer<ffi.v4l2_fmtdesc> ptr;

  V4L2FmtdescImpl() : ptr = ffi.malloc() {
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  String get description => ptr.ref.description.toDart();

  @override
  List<V4L2FmtFlag> get flags => ptr.ref.flags.toDartFmtFlags();

  @override
  V4L2PixFmt get pixelformat => ptr.ref.pixelformat.toDartPixFmt();
}

final class V4L2FormatImpl implements V4L2Format, ffi.Finalizable {
  static final finalizer = ffi.NativeFinalizer(ffi.malloc.nativeFree);

  final ffi.Pointer<ffi.v4l2_format> ptr;

  V4L2FormatImpl({
    V4L2PixFormatImpl? pix,
  }) : ptr = ffi.malloc() {
    if (pix != null) {
      ptr.ref.fmt.pix = pix.ptr.ref;
    }
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  V4L2PixFormat get pix => ptr.ref.fmt.pix.toDart();
}

class V4L2PixFormatImpl implements V4L2PixFormat, ffi.Finalizable {
  static final finalizer = ffi.NativeFinalizer(ffi.malloc.nativeFree);

  final ffi.Pointer<ffi.v4l2_pix_format> ptr;

  V4L2PixFormatImpl({
    int? width,
    int? height,
    V4L2PixFmt? pixelformat,
    int? field,
  }) : ptr = ffi.malloc() {
    if (width != null) {
      ptr.ref.width = width;
    }
    if (height != null) {
      ptr.ref.height = height;
    }
    if (pixelformat != null) {
      ptr.ref.pixelformat = pixelformat.value;
    }
    if (field != null) {
      ptr.ref.field = field;
    }
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  int get width => ptr.ref.width;
  @override
  int get height => ptr.ref.height;
  @override
  V4L2PixFmt get pixelformat => ptr.ref.pixelformat.toDartPixFmt();
  @override
  int get field => ptr.ref.field;
}
