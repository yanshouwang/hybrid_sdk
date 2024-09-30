import 'dart:ffi' as ffi;
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as ffi;

import 'ffi.v4l2.dart' as ffi;
import 'ffi.hybrid_v4l2.dart' as ffi;
import 'ffi.x.dart' as ffi;
import 'v4l2.dart';
import 'v4l2_buf_flag.dart';
import 'v4l2_buf_type.dart';
import 'v4l2_buffer.dart';
import 'v4l2_cap.dart';
import 'v4l2_capability.dart';
import 'v4l2_error.dart';
import 'v4l2_field.dart';
import 'v4l2_fmt_flag.dart';
import 'v4l2_fmtdesc.dart';
import 'v4l2_format.dart';
import 'v4l2_in_cap.dart';
import 'v4l2_in_st.dart';
import 'v4l2_input.dart';
import 'v4l2_input_type.dart';
import 'v4l2_map.dart';
import 'v4l2_mapped_buffer.dart';
import 'v4l2_memory.dart';
import 'v4l2_o.dart';
import 'v4l2_pix_fmt.dart';
import 'v4l2_pix_format.dart';
import 'v4l2_plane.dart';
import 'v4l2_prot.dart';
import 'v4l2_requestbuffers.dart';
import 'v4l2_std.dart';
import 'v4l2_tc_flag.dart';
import 'v4l2_tc_type.dart';
import 'v4l2_time_code.dart';
import 'v4l2_timeval.dart';

final finalizer = ffi.NativeFinalizer(ffi.malloc.nativeFree);

final class V4L2Impl implements V4L2 {
  @override
  int open(String file, List<V4L2O> oflag) {
    final filePtr = file.toNativeUtf8().cast<ffi.Char>();
    final fd = ffi.libHybridV4L2.v4l2_open(
      filePtr,
      oflag.fold(0, (total, next) => total | next.value),
    );
    ffi.malloc.free(filePtr);
    if (fd == -1) {
      throw V4L2Error('open failed, $fd.');
    }
    return fd;
  }

  @override
  void close(int fd) {
    final status = ffi.libHybridV4L2.v4l2_close(fd);
    if (status != 0) {
      throw V4L2Error('close failed, $status.');
    }
  }

  @override
  V4L2Capability querycap(int fd) {
    final cap = _ManagedV4L2CapabilityImpl();
    final err = ffi.libHybridV4L2
        .v4l2_ioctlV4l2v4l2_capabilityPtr(fd, ffi.VIDIOC_QUERYCAP, cap.ptr);
    if (err != 0) {
      throw V4L2Error('ioctl `VIDIOC_QUERYCAP` failed, $err.');
    }
    return cap;
  }

  @override
  List<V4L2Input> enuminput(int fd) {
    final inputs = <V4L2Input>[];
    var index = 0;
    while (true) {
      final input = _ManagedV4L2InputImpl()..index = index;
      final err = ffi.libHybridV4L2
          .v4l2_ioctlV4l2v4l2_inputPtr(fd, ffi.VIDIOC_ENUMINPUT, input.ptr);
      if (err != 0) {
        break;
      }
      inputs.add(input);
      index++;
    }
    return inputs;
  }

  @override
  V4L2Input gInput(int fd) {
    final index = ffi.using((arena) {
      final indexPtr = arena<ffi.Int>();
      final err =
          ffi.libHybridV4L2.v4l2_ioctlIntPtr(fd, ffi.VIDIOC_G_INPUT, indexPtr);
      if (err != 0) {
        throw V4L2Error('ioctl `VIDIOC_G_INPUT` failed, $err.');
      }
      return indexPtr.value;
    });
    final input = _ManagedV4L2InputImpl()..index = index;
    final err = ffi.libHybridV4L2
        .v4l2_ioctlV4l2v4l2_inputPtr(fd, ffi.VIDIOC_ENUMINPUT, input.ptr);
    if (err != 0) {
      throw V4L2Error('ioctl `VIDIOC_ENUMINPUT` failed, $err.');
    }
    return input;
  }

  @override
  void sInput(int fd, V4L2Input input) {
    if (input is! _ManagedV4L2InputImpl) {
      throw TypeError();
    }
    final err = ffi.libHybridV4L2
        .v4l2_ioctlV4l2v4l2_inputPtr(fd, ffi.VIDIOC_S_INPUT, input.ptr);
    if (err != 0) {
      throw V4L2Error('ioctl `VIDIOC_S_INPUT` failed, $err.');
    }
  }

  @override
  List<V4L2Fmtdesc> enumFmt(int fd, V4L2BufType type) {
    final fmts = <V4L2Fmtdesc>[];
    var index = 0;
    while (true) {
      final fmt = _ManagedV4L2FmtdescImpl()
        ..index = index
        ..type = type;
      final err = ffi.libHybridV4L2
          .v4l2_ioctlV4l2v4l2_fmtdescPtr(fd, ffi.VIDIOC_ENUM_FMT, fmt.ptr);
      if (err != 0) {
        break;
      }
      fmts.add(fmt);
      index++;
    }
    return fmts;
  }

  @override
  V4L2Format gFmt(int fd, V4L2BufType type) {
    final fmt = _ManagedV4L2FormatImpl()..type = type;
    final err = ffi.libHybridV4L2
        .v4l2_ioctlV4l2v4l2_formatPtr(fd, ffi.VIDIOC_G_FMT, fmt.ptr);
    if (err != 0) {
      throw V4L2Error('ioctl `VIDIOC_G_FMT` failed, $err.');
    }
    return fmt;
  }

  @override
  void sFmt(int fd, V4L2Format fmt) {
    if (fmt is! _ManagedV4L2FormatImpl) {
      throw TypeError();
    }
    final err = ffi.libHybridV4L2
        .v4l2_ioctlV4l2v4l2_formatPtr(fd, ffi.VIDIOC_S_FMT, fmt.ptr);
    if (err != 0) {
      throw V4L2Error('ioctl `VIDIOC_S_FMT` failed, $err.');
    }
  }

  @override
  void tryFmt(int fd, V4L2Format fmt) {
    if (fmt is! _ManagedV4L2FormatImpl) {
      throw TypeError();
    }
    final err = ffi.libHybridV4L2
        .v4l2_ioctlV4l2v4l2_formatPtr(fd, ffi.VIDIOC_TRY_FMT, fmt.ptr);
    if (err != 0) {
      throw V4L2Error('ioctl `VIDIOC_TRY_FMT` failed, $err.');
    }
  }

  @override
  void reqbufs(int fd, V4L2Requestbuffers req) {
    if (req is! _ManagedV4L2RequestbuffersImpl) {
      throw TypeError();
    }
    final err = ffi.libHybridV4L2
        .v4l2_ioctlV4l2v4l2_requestbuffersPtr(fd, ffi.VIDIOC_REQBUFS, req.ptr);
    if (err != 0) {
      throw V4L2Error('ioctl `VIDIOC_REQBUFS` failed, $err.');
    }
  }

  @override
  V4L2Buffer querybuf(int fd, V4L2BufType type, V4L2Memory memory, int index) {
    final buf = _ManagedV4L2BufferImpl()
      ..type = type
      ..memory = memory
      ..index = index;
    final err = ffi.libHybridV4L2
        .v4l2_ioctlV4l2v4l2_bufferPtr(fd, ffi.VIDIOC_QUERYBUF, buf.ptr);
    if (err != 0) {
      throw V4L2Error('ioctl `VIDIOC_QUERYBUF` failed, $err.');
    }
    return buf;
  }

  @override
  void qbuf(int fd, V4L2Buffer buf) {
    if (buf is! _ManagedV4L2BufferImpl) {
      throw TypeError();
    }
    final err = ffi.libHybridV4L2
        .v4l2_ioctlV4l2v4l2_bufferPtr(fd, ffi.VIDIOC_QBUF, buf.ptr);
    if (err != 0) {
      throw V4L2Error('ioctl `VIDIOC_QBUF` faild, $err.');
    }
  }

  @override
  V4L2Buffer dqbuf(int fd, V4L2BufType type, V4L2Memory memory) {
    final buf = _ManagedV4L2BufferImpl()
      ..type = type
      ..memory = memory;
    final err = ffi.libHybridV4L2
        .v4l2_ioctlV4l2v4l2_bufferPtr(fd, ffi.VIDIOC_DQBUF, buf.ptr);
    if (err != 0) {
      throw V4L2Error('ioctl `VIDIOC_DQBUF` faild, $err.');
    }
    return buf;
  }

  @override
  void streamon(int fd, V4L2BufType type) {
    ffi.using((arena) {
      final typePtr = arena<ffi.Int>()..value = type.value;
      final err =
          ffi.libHybridV4L2.v4l2_ioctlIntPtr(fd, ffi.VIDIOC_STREAMON, typePtr);
      if (err != 0) {
        throw V4L2Error('ioctl `VIDIOC_STREAMON` failed, $err.');
      }
    });
  }

  @override
  void streamoff(int fd, V4L2BufType type) {
    ffi.using((arena) {
      final typePtr = arena<ffi.Int>()..value = type.value;
      final err =
          ffi.libHybridV4L2.v4l2_ioctlIntPtr(fd, ffi.VIDIOC_STREAMOFF, typePtr);
      if (err != 0) {
        throw V4L2Error('ioctl `VIDIOC_STREAMOFF` failed, $err.');
      }
    });
  }

  @override
  V4L2MappedBuffer mmap(
    int fd,
    int offset,
    int len,
    List<V4L2Prot> prot,
    List<V4L2Map> flags,
  ) {
    final buf = _ManagedV4L2MappedBufferImpl();
    final err = ffi.libHybridV4L2.v4l2_mmap(
      fd,
      offset,
      len,
      prot.fold(0, (total, next) => total | next.value),
      flags.fold(0, (total, element) => total | element.value),
      buf.ptr,
    );
    if (err != 0) {
      throw V4L2Error('mmap failed.');
    }
    return buf;
  }

  @override
  void munmap(V4L2MappedBuffer buf) {
    if (buf is! _ManagedV4L2MappedBufferImpl) {
      throw TypeError();
    }
    final err = ffi.libHybridV4L2.v4l2_munmap(buf.ptr);
    if (err != 0) {
      throw V4L2Error('munmap failed, $err.');
    }
  }

  @override
  void select(int fd, V4L2Timeval timeout) {
    if (timeout is! _ManagedV4L2TimevalImpl) {
      throw TypeError();
    }
    final err = ffi.libHybridV4L2.v4l2_select(fd, timeout.ptr);
    if (err <= 0) {
      throw V4L2Error('select failed, $err.');
    }
  }
}

/* V4L2Capability */
abstract base class V4L2CapabilityImpl implements V4L2Capability {
  V4L2CapabilityImpl();
  factory V4L2CapabilityImpl.managed() => _ManagedV4L2CapabilityImpl();

  ffi.v4l2_capability get ref;

  @override
  String get driver => ref.driver.toDart();
  @override
  String get card => ref.card.toDart();
  @override
  String get busInfo => ref.bus_info.toDart();
  @override
  int get version => ref.version;
  @override
  List<V4L2Cap> get capabilities => ref.capabilities.toDartCaps();
  @override
  List<V4L2Cap> get deviceCaps => ref.device_caps.toDartCaps();
}

final class _ManagedV4L2CapabilityImpl extends V4L2CapabilityImpl
    implements ffi.Finalizable {
  final ffi.Pointer<ffi.v4l2_capability> ptr;

  _ManagedV4L2CapabilityImpl() : ptr = ffi.malloc() {
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  ffi.v4l2_capability get ref => ptr.ref;
}

/* V4L2Input */
abstract base class V4L2InputImpl implements V4L2Input {
  V4L2InputImpl();
  factory V4L2InputImpl.managed() => _ManagedV4L2InputImpl();

  ffi.v4l2_input get ref;

  int get index => ref.index;
  set index(int value) => ref.index = value;
  @override
  String get name => ref.name.toDart();
  @override
  V4L2InputType get type => ref.type.toDartInputType();
  @override
  int get audioset => ref.audioset;
  @override
  int get tuner => ref.tuner;
  @override
  List<V4L2Std> get std => ref.std.toDartStds();
  @override
  List<V4L2InSt> get status => ref.status.toDartInSts();
  @override
  List<V4L2InCap> get capabilities => ref.capabilities.toDartInCaps();
}

final class _ManagedV4L2InputImpl extends V4L2InputImpl
    implements ffi.Finalizable {
  final ffi.Pointer<ffi.v4l2_input> ptr;

  _ManagedV4L2InputImpl() : ptr = ffi.malloc() {
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  ffi.v4l2_input get ref => ptr.ref;
}

/* V4L2Fmtdesc */
abstract base class V4L2FmtdescImpl implements V4L2Fmtdesc {
  V4L2FmtdescImpl();
  factory V4L2FmtdescImpl.managed() => _ManagedV4L2FmtdescImpl();

  ffi.v4l2_fmtdesc get ref;

  int get index => ref.index;
  set index(int value) => ref.index = value;

  @override
  V4L2BufType get type => ref.type.toDartBufType();
  set type(V4L2BufType value) => ref.type = value.value;

  @override
  String get description => ref.description.toDart();

  @override
  List<V4L2FmtFlag> get flags => ref.flags.toDartFmtFlags();

  @override
  V4L2PixFmt get pixelformat => ref.pixelformat.toDartPixFmt();
}

final class _ManagedV4L2FmtdescImpl extends V4L2FmtdescImpl
    implements ffi.Finalizable {
  final ffi.Pointer<ffi.v4l2_fmtdesc> ptr;

  _ManagedV4L2FmtdescImpl() : ptr = ffi.malloc() {
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  ffi.v4l2_fmtdesc get ref => ptr.ref;
}

/* V4L2Format */
abstract base class V4L2FormatImpl implements V4L2Format {
  V4L2FormatImpl();
  factory V4L2FormatImpl.managed() => _ManagedV4L2FormatImpl();

  ffi.v4l2_format get ref;

  @override
  V4L2BufType get type => ref.type.toDartBufType();
  @override
  set type(V4L2BufType value) => ref.type = value.value;

  @override
  V4L2PixFormat get pix => V4L2PixFormatImpl.unmanaged(ref.fmt.pix);
  @override
  set pix(V4L2PixFormat value) {
    if (value is! V4L2PixFormatImpl) {
      throw TypeError();
    }
    ref.fmt.pix = value.ref;
  }
}

final class _ManagedV4L2FormatImpl extends V4L2FormatImpl
    implements ffi.Finalizable {
  final ffi.Pointer<ffi.v4l2_format> ptr;

  _ManagedV4L2FormatImpl() : ptr = ffi.malloc() {
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  ffi.v4l2_format get ref => ptr.ref;
}

/* V4L2PixFormat */
abstract base class V4L2PixFormatImpl implements V4L2PixFormat {
  V4L2PixFormatImpl();
  factory V4L2PixFormatImpl.unmanaged(ffi.v4l2_pix_format ref) =>
      _UnmanagedV4L2PixFormatImpl(ref);
  factory V4L2PixFormatImpl.managed() => _ManagedV4L2PixFormatImpl();

  ffi.v4l2_pix_format get ref;

  @override
  int get width => ref.width;
  @override
  set width(int value) => ref.width = value;

  @override
  int get height => ref.height;
  @override
  set height(int value) => ref.height = value;

  @override
  V4L2PixFmt get pixelformat => ref.pixelformat.toDartPixFmt();
  @override
  set pixelformat(V4L2PixFmt value) => ref.pixelformat = value.value;

  @override
  V4L2Field get field => ref.field.toDartField();
  @override
  set field(V4L2Field value) => ref.field = value.value;
}

final class _UnmanagedV4L2PixFormatImpl extends V4L2PixFormatImpl {
  @override
  final ffi.v4l2_pix_format ref;

  _UnmanagedV4L2PixFormatImpl(this.ref);
}

final class _ManagedV4L2PixFormatImpl extends V4L2PixFormatImpl
    implements ffi.Finalizable {
  final ffi.Pointer<ffi.v4l2_pix_format> ptr;

  _ManagedV4L2PixFormatImpl() : ptr = ffi.malloc() {
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  ffi.v4l2_pix_format get ref => ptr.ref;
}

/* V4L2Requestbuffers */
abstract base class V4L2RequestbuffersImpl implements V4L2Requestbuffers {
  V4L2RequestbuffersImpl();
  factory V4L2RequestbuffersImpl.managed() => _ManagedV4L2RequestbuffersImpl();

  ffi.v4l2_requestbuffers get ref;

  @override
  int get count => ref.count;
  @override
  set count(int value) => ref.count = value;

  @override
  V4L2BufType get type => ref.type.toDartBufType();
  @override
  set type(V4L2BufType value) => ref.type = value.value;

  @override
  V4L2Memory get memory => ref.memory.toDartMemory();
  @override
  set memory(V4L2Memory value) => ref.memory = value.value;
}

final class _ManagedV4L2RequestbuffersImpl extends V4L2RequestbuffersImpl
    implements ffi.Finalizable {
  final ffi.Pointer<ffi.v4l2_requestbuffers> ptr;

  _ManagedV4L2RequestbuffersImpl() : ptr = ffi.malloc() {
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  ffi.v4l2_requestbuffers get ref => ptr.ref;
}

/* V4L2Buffer */
abstract base class V4L2BufferImpl implements V4L2Buffer {
  V4L2BufferImpl();
  factory V4L2BufferImpl.managed() => _ManagedV4L2BufferImpl();

  ffi.v4l2_buffer get ref;

  @override
  int get index => ref.index;
  @override
  set index(int value) => ref.index = value;
  @override
  V4L2BufType get type => ref.type.toDartBufType();
  @override
  set type(V4L2BufType value) => ref.type = value.value;
  @override
  int get byteused => ref.bytesused;
  @override
  List<V4L2BufFlag> get flags => ref.flags.toDartBufFlags();
  @override
  V4L2Field get field => ref.field.toDartField();
  @override
  V4L2Timeval get timestamp => V4L2TimevalImpl.unmanaged(ref.timestamp);
  @override
  V4L2TimeCode get timecode => V4L2TimeCodeImpl.unmanaged(ref.timecode);
  @override
  int get sequence => ref.sequence;
  @override
  V4L2Memory get memory => ref.memory.toDartMemory();
  @override
  set memory(V4L2Memory value) => ref.memory = value.value;
  @override
  int get offset => ref.m.offset;
  @override
  int get userptr => ref.m.userptr;
  @override
  List<V4L2Plane> get planes {
    final planes = <V4L2Plane>[];
    for (var i = 0; i < length; i++) {
      final plane = V4L2PlaneImpl.unmanaged(ref.m.planes[i]);
      planes.add(plane);
    }
    return planes;
  }

  @override
  int get fd => ref.m.fd;
  @override
  int get length => ref.length;
  @override
  int get requestFd => ref.unnamed.request_fd;
}

final class _ManagedV4L2BufferImpl extends V4L2BufferImpl
    implements ffi.Finalizable {
  final ffi.Pointer<ffi.v4l2_buffer> ptr;

  _ManagedV4L2BufferImpl() : ptr = ffi.malloc() {
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  ffi.v4l2_buffer get ref => ptr.ref;
}

/* V4L2Timeval */
abstract base class V4L2TimevalImpl implements V4L2Timeval {
  V4L2TimevalImpl();
  factory V4L2TimevalImpl.unmanaged(ffi.timeval ref) =>
      _UnmanagedV4L2TimevalImpl(ref);
  factory V4L2TimevalImpl.managed() => _ManagedV4L2TimevalImpl();

  ffi.timeval get ref;

  @override
  int get tvSec => ref.tv_sec;
  @override
  set tvSec(int value) => ref.tv_sec = value;
  @override
  int get tvUsec => ref.tv_usec;
  @override
  set tvUsec(int value) => ref.tv_usec = value;
}

final class _UnmanagedV4L2TimevalImpl extends V4L2TimevalImpl {
  @override
  final ffi.timeval ref;

  _UnmanagedV4L2TimevalImpl(this.ref);
}

final class _ManagedV4L2TimevalImpl extends V4L2TimevalImpl
    implements ffi.Finalizable {
  final ffi.Pointer<ffi.timeval> ptr;

  _ManagedV4L2TimevalImpl() : ptr = ffi.malloc() {
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  ffi.timeval get ref => ptr.ref;
}

/* V4L2TimeCode */
abstract base class V4L2TimeCodeImpl implements V4L2TimeCode {
  V4L2TimeCodeImpl();
  factory V4L2TimeCodeImpl.unmanaged(ffi.v4l2_timecode ref) =>
      _UnmanagedV4L2TimeCodeImpl(ref);
  factory V4L2TimeCodeImpl.managed() => _ManagedV4L2TimeCodeImpl();

  ffi.v4l2_timecode get ref;

  @override
  V4L2TCType get type => ref.type.toDartTCType();
  @override
  List<V4L2TCFlag> get flags => ref.flags.toDartTCFlags();
  @override
  int get frames => ref.frames;
  @override
  int get seconds => ref.seconds;
  @override
  int get minutes => ref.minutes;
  @override
  int get hours => ref.hours;
  @override
  String get userbits => ref.userbits.toDart();
}

final class _UnmanagedV4L2TimeCodeImpl extends V4L2TimeCodeImpl {
  @override
  final ffi.v4l2_timecode ref;

  _UnmanagedV4L2TimeCodeImpl(this.ref);
}

final class _ManagedV4L2TimeCodeImpl extends V4L2TimeCodeImpl
    implements ffi.Finalizable {
  final ffi.Pointer<ffi.v4l2_timecode> ptr;

  _ManagedV4L2TimeCodeImpl() : ptr = ffi.malloc() {
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  ffi.v4l2_timecode get ref => ptr.ref;
}

/* V4L2Plane */
abstract base class V4L2PlaneImpl implements V4L2Plane {
  V4L2PlaneImpl();
  factory V4L2PlaneImpl.unmanaged(ffi.v4l2_plane ref) =>
      _UnmanagedV4L2PlaneImpl(ref);
  factory V4L2PlaneImpl.managed() => _ManagedV4L2PlaneImpl();

  ffi.v4l2_plane get ref;

  @override
  int get byteused => ref.bytesused;
  @override
  int get length => ref.length;
  @override
  int get memOffset => ref.m.mem_offset;
  @override
  int get userptr => ref.m.userptr;
  @override
  int get fd => ref.m.fd;
  @override
  int get dataOffset => ref.data_offset;
}

final class _UnmanagedV4L2PlaneImpl extends V4L2PlaneImpl {
  @override
  final ffi.v4l2_plane ref;

  _UnmanagedV4L2PlaneImpl(this.ref);
}

final class _ManagedV4L2PlaneImpl extends V4L2PlaneImpl
    implements ffi.Finalizable {
  final ffi.Pointer<ffi.v4l2_plane> ptr;

  _ManagedV4L2PlaneImpl() : ptr = ffi.malloc() {
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  ffi.v4l2_plane get ref => ptr.ref;
}

/* V4L2MappedBuffer */
abstract base class V4L2MappedBufferImpl implements V4L2MappedBuffer {
  V4L2MappedBufferImpl();
  factory V4L2MappedBufferImpl.managed() => _ManagedV4L2MappedBufferImpl();

  ffi.v4l2_mapped_buffer get ref;

  ffi.Pointer<ffi.Void> get addr => ref.addr;
  int get len => ref.len;

  @override
  Uint8List get value => addr.cast<ffi.Uint8>().asTypedList(len);
}

final class _ManagedV4L2MappedBufferImpl extends V4L2MappedBufferImpl
    implements ffi.Finalizable {
  final ffi.Pointer<ffi.v4l2_mapped_buffer> ptr;

  _ManagedV4L2MappedBufferImpl() : ptr = ffi.malloc() {
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  ffi.v4l2_mapped_buffer get ref => ptr.ref;
}
