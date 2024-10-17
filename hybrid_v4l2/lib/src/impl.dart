import 'dart:ffi' as ffi;
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as ffi;
import 'package:hybrid_logging/hybrid_logging.dart';

import 'ffi.v4l2.dart' as ffi;
import 'ffi.hybrid_v4l2.dart' as ffi;
import 'ffi.x.dart' as ffi;

import 'v4l2.dart';
import 'buf_flag.dart';
import 'buf_type.dart';
import 'buffer.dart';
import 'cap.dart';
import 'capability.dart';
import 'cid.dart';
import 'control.dart';
import 'crop.dart';
import 'cropcap.dart';
import 'ctrl_class.dart';
import 'ctrl_flag.dart';
import 'ctrl_type.dart';
import 'ctrl_which.dart';
import 'error.dart';
import 'ext_control.dart';
import 'ext_controls.dart';
import 'field.dart';
import 'fmt_flag.dart';
import 'fmtdesc.dart';
import 'format.dart';
import 'fract.dart';
import 'frmsize.dart';
import 'in_cap.dart';
import 'in_st.dart';
import 'input.dart';
import 'input_type.dart';
import 'map.dart';
import 'mapped_buffer.dart';
import 'memory.dart';
import 'o.dart';
import 'pix_fmt.dart';
import 'pix_format.dart';
import 'plane.dart';
import 'prot.dart';
import 'query_ext_ctrl.dart';
import 'queryctrl.dart';
import 'querymenu.dart';
import 'rect.dart';
import 'requestbuffers.dart';
import 'rgba_buffer.dart';
import 'std.dart';
import 'tc_flag.dart';
import 'tc_type.dart';
import 'time_code.dart';
import 'timeval.dart';

final finalizer = ffi.NativeFinalizer(ffi.calloc.nativeFree);

final class V4L2Impl with TypeLogger implements V4L2 {
  @override
  int open(String file, List<V4L2O> oflag) {
    logger.info('open');
    final filePtr = file.toNativeUtf8().cast<ffi.Char>();
    final fd = ffi.libHybridV4L2.v4l2_open(
      filePtr,
      oflag.fold(0, (total, next) => total | next.value),
    );
    ffi.calloc.free(filePtr);
    if (fd == -1) {
      throw V4L2Error('open failed, $fd.');
    }
    return fd;
  }

  @override
  void close(int fd) {
    logger.info('close');
    final status = ffi.libHybridV4L2.v4l2_close(fd);
    if (status != 0) {
      throw V4L2Error('close failed, $status.');
    }
  }

  @override
  V4L2Capability querycap(int fd) {
    logger.info('ioctl VIDIOC_QUERYCAP');
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
    logger.info('ioctl VIDIOC_ENUMINPUT');
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
    logger.info('ioctl VIDIOC_G_INPUT');
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
    logger.info('ioctl VIDIOC_S_INPUT');
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
    logger.info('ioctl VIDIOC_ENUM_FMT');
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
  List<V4L2Frmsize> enumFramesizes(int fd, V4L2PixFmt pixelFormat) {
    logger.info('ioctl VIDIOC_ENUM_FRAMESIZES');
    final frmsizes = <V4L2Frmsize>[];
    var index = 0;
    while (true) {
      final frmsizeenum = _ManagedV4L2FrmsizeenumImpl()
        ..index = index
        ..pixelFormat = pixelFormat;
      final err = ffi.libHybridV4L2.v4l2_ioctlV4l2v4l2_frmsizeenumPtr(
          fd, ffi.VIDIOC_ENUM_FRAMESIZES, frmsizeenum.ptr);
      if (err != 0) {
        break;
      }
      switch (frmsizeenum.type) {
        case ffi.v4l2_frmsizetypes.V4L2_FRMSIZE_TYPE_DISCRETE:
          final frmsize = V4L2FrmsizeImpl.discrete(frmsizeenum);
          frmsizes.add(frmsize);
          break;
        default:
          var steps = 0;
          while (true) {
            if (frmsizeenum.stepwise.min_width +
                        steps * frmsizeenum.stepwise.step_width >
                    frmsizeenum.stepwise.max_width ||
                frmsizeenum.stepwise.min_height +
                        steps * frmsizeenum.stepwise.step_height >
                    frmsizeenum.stepwise.max_height) {
              break;
            }
            final frmsize = V4L2FrmsizeImpl.stepwise(frmsizeenum, steps);
            frmsizes.add(frmsize);
          }
      }
      index++;
    }
    return frmsizes;
  }

  @override
  V4L2Format gFmt(int fd, V4L2BufType type) {
    logger.info('ioctl VIDIOC_G_FMT');
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
    logger.info('ioctl VIDIOC_S_FMT');
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
    logger.info('ioctl VIDIOC_TRY_FMT');
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
    logger.info('ioctl VIDIOC_REQBUFS');
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
    logger.info('ioctl VIDIOC_QUERYBUF');
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
    logger.info('BEGIN ioctl VIDIOC_QBUF');
    final err = ffi.libHybridV4L2
        .v4l2_ioctlV4l2v4l2_bufferPtr(fd, ffi.VIDIOC_QBUF, buf.ptr);
    logger.info('END ioctl VIDIOC_QBUF $err');
    if (err != 0) {
      throw V4L2Error('ioctl `VIDIOC_QBUF` faild, $err.');
    }
  }

  @override
  V4L2Buffer dqbuf(int fd, V4L2BufType type, V4L2Memory memory) {
    final buf = _ManagedV4L2BufferImpl()
      ..type = type
      ..memory = memory;
    logger.info('BEGIN ioctl VIDIOC_DQBUF');
    final err = ffi.libHybridV4L2
        .v4l2_ioctlV4l2v4l2_bufferPtr(fd, ffi.VIDIOC_DQBUF, buf.ptr);
    logger.info('END ioctl VIDIOC_DQBUF $err');
    if (err != 0) {
      throw V4L2Error('ioctl `VIDIOC_DQBUF` faild, $err.');
    }
    return buf;
  }

  @override
  void streamon(int fd, V4L2BufType type) {
    logger.info('ioctl VIDIOC_STREAMON');
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
    logger.info('ioctl VIDIOC_STREAMOFF');
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
  V4L2Cropcap cropcap(int fd, V4L2BufType type) {
    logger.info('ioctl VIDIOC_CROPCAP');
    final cropcap = _ManagedV4L2CropcapImpl()..type = type;
    final err = ffi.libHybridV4L2
        .v4l2_ioctlV4l2v4l2_cropcapPtr(fd, ffi.VIDIOC_CROPCAP, cropcap.ptr);
    if (err != 0) {
      throw V4L2Error('ioctl `VIDIOC_CROPCAP` failed, $err.');
    }
    return cropcap;
  }

  @override
  V4L2Crop gCrop(int fd, V4L2BufType type) {
    logger.info('ioctl VIDIOC_G_CROP');
    final crop = _ManagedV4L2CropImpl()..type = type;
    final err = ffi.libHybridV4L2
        .v4l2_ioctlV4l2v4l2_cropPtr(fd, ffi.VIDIOC_G_CROP, crop.ptr);
    if (err != 0) {
      throw V4L2Error('ioctl `VIDIOC_G_CROP` failed, $err.');
    }
    return crop;
  }

  @override
  void sCrop(int fd, V4L2Crop crop) {
    logger.info('ioctl VIDIOC_S_CROP');
    if (crop is! _ManagedV4L2CropImpl) {
      throw TypeError();
    }
    final err = ffi.libHybridV4L2
        .v4l2_ioctlV4l2v4l2_cropPtr(fd, ffi.VIDIOC_S_CROP, crop.ptr);
    if (err != 0) {
      throw V4L2Error('ioctl `VIDIOC_S_CROP` failed, $err.');
    }
  }

  @override
  V4L2Queryctrl queryctrl(int fd, V4L2CId id) {
    logger.info('ioctl VIDIOC_QUERYCTRL');
    final ctrl = _ManagedV4L2QueryctrlImpl()..id = id;
    final err = ffi.libHybridV4L2
        .v4l2_ioctlV4l2v4l2_queryctrlPtr(fd, ffi.VIDIOC_QUERYCTRL, ctrl.ptr);
    if (err != 0) {
      throw V4L2Error('ioctl `VIDIOC_QUERYCTRL` failed, $err.');
    }
    return ctrl;
  }

  @override
  V4L2QueryExtCtrl queryExtCtrl(int fd, V4L2CId id) {
    logger.info('ioctl VIDIOC_QUERY_EXT_CTRL');
    final ctrl = _ManagedV4L2QueryExtCtrlImpl()..id = id;
    final err = ffi.libHybridV4L2.v4l2_ioctlV4l2v4l2_query_ext_ctrlPtr(
        fd, ffi.VIDIOC_QUERY_EXT_CTRL, ctrl.ptr);
    if (err != 0) {
      throw V4L2Error('ioctl `VIDIOC_QUERY_EXT_CTRL` failed, $err.');
    }
    return ctrl;
  }

  @override
  V4L2Querymenu querymenu(int fd, V4L2CId id, int index) {
    logger.info('ioctl VIDIOC_QUERYMENU');
    final menu = _ManagedV4L2QuerymenuImpl()
      ..id = id
      ..index = index;
    final err = ffi.libHybridV4L2
        .v4l2_ioctlV4l2v4l2_querymenuPtr(fd, ffi.VIDIOC_QUERYMENU, menu.ptr);
    if (err != 0) {
      throw V4L2Error('ioctl `VIDIOC_QUERYMENU` failed, $err.');
    }
    return menu;
  }

  @override
  V4L2Control gCtrl(int fd, V4L2CId id) {
    logger.info('ioctl VIDIOC_G_CTRL');
    final control = _ManagedV4L2ControlImpl()..id = id;
    final err = ffi.libHybridV4L2
        .v4l2_ioctlV4l2v4l2_controlPtr(fd, ffi.VIDIOC_G_CTRL, control.ptr);
    if (err != 0) {
      throw V4L2Error('ioctl `VIDIOC_G_CTRL` failed, $err.');
    }
    return control;
  }

  @override
  void sCtrl(int fd, V4L2Control ctrl) {
    logger.info('ioctl VIDIOC_S_CTRL');
    if (ctrl is! _ManagedV4L2ControlImpl) {
      throw TypeError();
    }
    final err = ffi.libHybridV4L2
        .v4l2_ioctlV4l2v4l2_controlPtr(fd, ffi.VIDIOC_S_CTRL, ctrl.ptr);
    if (err != 0) {
      throw V4L2Error('ioctl `VIDIOC_S_CTRL` failed, $err.');
    }
  }

  @override
  V4L2ExtControls gExtCtrls(int fd, V4L2CtrlClass ctrlClass,
      V4L2CtrlWhich which, List<V4L2ExtControl> controls) {
    logger.info('ioctl VIDIOC_G_EXT_CTRLS');
    final ctrls = _ManagedV4L2ExtControlsImpl()
      ..ctrlClass = ctrlClass
      ..which = which
      ..controls = controls;
    final err = ffi.libHybridV4L2.v4l2_ioctlV4l2v4l2_ext_controlsPtr(
        fd, ffi.VIDIOC_G_EXT_CTRLS, ctrls.ptr);
    if (err != 0) {
      throw V4L2Error('ioctl `VIDIOC_G_EXT_CTRLS` failed, $err.');
    }
    return ctrls;
  }

  @override
  void sExtCtrls(int fd, V4L2ExtControls ctrls) {
    logger.info('ioctl VIDIOC_S_EXT_CTRLS');
    if (ctrls is! _ManagedV4L2ExtControlsImpl) {
      throw TypeError();
    }
    final err = ffi.libHybridV4L2.v4l2_ioctlV4l2v4l2_ext_controlsPtr(
        fd, ffi.VIDIOC_S_EXT_CTRLS, ctrls.ptr);
    if (err != 0) {
      throw V4L2Error('ioctl `VIDIOC_S_EXT_CTRLS` failed, $err.');
    }
  }

  @override
  void tryExtCtrls(int fd, V4L2ExtControls ctrls) {
    logger.info('ioctl VIDIOC_TRY_EXT_CTRLS');
    if (ctrls is! _ManagedV4L2ExtControlsImpl) {
      throw TypeError();
    }
    final err = ffi.libHybridV4L2.v4l2_ioctlV4l2v4l2_ext_controlsPtr(
        fd, ffi.VIDIOC_TRY_EXT_CTRLS, ctrls.ptr);
    if (err != 0) {
      throw V4L2Error('ioctl `VIDIOC_TRY_EXT_CTRLS` failed, $err.');
    }
  }

  @override
  V4L2MappedBuffer mmap(
    int fd,
    int offset,
    int len,
    List<V4L2Prot> prot,
    List<V4L2Map> flags,
  ) {
    logger.info('mmap');
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
    logger.info('munmap');
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
    logger.info('BEGIN select');
    final err = ffi.libHybridV4L2.v4l2_select(fd, timeout.ptr);
    logger.info('END select $err');
    if (err <= 0) {
      throw V4L2Error('select failed, $err.');
    }
  }

  @override
  V4L2RGBABuffer mjpegToRGBA(V4L2MappedBuffer buf) {
    logger.info('mjpegToRGBA');
    if (buf is! _ManagedV4L2MappedBufferImpl) {
      throw TypeError();
    }
    return ffi.using((arena) {
      final samplePtr = buf.ref.addr.cast<ffi.Uint8>();
      final sampleSize = buf.ref.len;
      final widthPtr = arena<ffi.Int>();
      final heightPtr = arena<ffi.Int>();
      var err = ffi.libYUV.MJPGSize(
        samplePtr,
        sampleSize,
        widthPtr,
        heightPtr,
      );
      if (err != 0) {
        throw V4L2Error('MJPGSize err $err.');
      }
      final width = widthPtr.value;
      final height = heightPtr.value;
      final stride = width * 4;
      final argbPtr = arena<ffi.Uint8>(width * height * 4);
      err = ffi.libYUV.MJPGToARGB(
        samplePtr,
        sampleSize,
        argbPtr,
        stride,
        width,
        height,
        width,
        height,
      );
      if (err != 0) {
        throw V4L2Error('MJPGToARGB err $err.');
      }
      final rgba = _ManagedV4L2RGBABufferImpl(width, height);
      err = ffi.libYUV.ARGBToABGR(
        argbPtr,
        stride,
        rgba.ptr,
        stride,
        width,
        height,
      );
      if (err != 0) {
        throw V4L2Error('ARGBToABGR err $err.');
      }
      return rgba;
    });
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

  _ManagedV4L2CapabilityImpl() : ptr = ffi.calloc() {
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

  _ManagedV4L2InputImpl() : ptr = ffi.calloc() {
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

  _ManagedV4L2FmtdescImpl() : ptr = ffi.calloc() {
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  ffi.v4l2_fmtdesc get ref => ptr.ref;
}

/* V4L2Frmsizeenum */
abstract class V4L2FrmsizeenumImpl {
  V4L2FrmsizeenumImpl();
  factory V4L2FrmsizeenumImpl.managed() => _ManagedV4L2FrmsizeenumImpl();

  ffi.v4l2_frmsizeenum get ref;

  set index(int value) => ref.index = value;
  set pixelFormat(V4L2PixFmt value) => ref.pixel_format = value.value;
  int get type => ref.type;
  ffi.v4l2_frmsize_discrete get discrete => ref.unnamed.discrete;
  ffi.v4l2_frmsize_stepwise get stepwise => ref.unnamed.stepwise;
}

final class _ManagedV4L2FrmsizeenumImpl extends V4L2FrmsizeenumImpl
    implements ffi.Finalizable {
  final ffi.Pointer<ffi.v4l2_frmsizeenum> ptr;

  _ManagedV4L2FrmsizeenumImpl() : ptr = ffi.calloc() {
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  ffi.v4l2_frmsizeenum get ref => ptr.ref;
}

/* V4L2Frmsize */
abstract class V4L2FrmsizeImpl implements V4L2Frmsize {
  final V4L2FrmsizeenumImpl frmsizeenum;

  V4L2FrmsizeImpl(this.frmsizeenum);

  factory V4L2FrmsizeImpl.discrete(V4L2FrmsizeenumImpl frmsizeenum) =>
      _V4L2FrmsizeDiscreteImpl(frmsizeenum);
  factory V4L2FrmsizeImpl.stepwise(
          V4L2FrmsizeenumImpl frmsizeenum, int index) =>
      _V4L2FrmsizeStepwiseImpl(frmsizeenum, index);
}

final class _V4L2FrmsizeDiscreteImpl extends V4L2FrmsizeImpl {
  _V4L2FrmsizeDiscreteImpl(super.frmsizeenum)
      : assert(frmsizeenum.type ==
            ffi.v4l2_frmsizetypes.V4L2_FRMSIZE_TYPE_DISCRETE);

  @override
  int get width => frmsizeenum.discrete.width;
  @override
  int get height => frmsizeenum.discrete.height;
}

final class _V4L2FrmsizeStepwiseImpl extends V4L2FrmsizeImpl {
  final int steps;

  _V4L2FrmsizeStepwiseImpl(super.frmsizeenum, this.steps)
      : assert(frmsizeenum.type !=
            ffi.v4l2_frmsizetypes.V4L2_FRMSIZE_TYPE_DISCRETE);

  @override
  int get width {
    final width = frmsizeenum.stepwise.min_width +
        steps * frmsizeenum.stepwise.step_width;
    if (width > frmsizeenum.stepwise.max_width) {
      throw ArgumentError.value(steps);
    }
    return width;
  }

  @override
  int get height {
    final height = frmsizeenum.stepwise.min_height +
        steps * frmsizeenum.stepwise.step_height;
    if (height > frmsizeenum.stepwise.max_height) {
      throw ArgumentError.value(steps);
    }
    return height;
  }
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

  _ManagedV4L2FormatImpl() : ptr = ffi.calloc() {
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

  _ManagedV4L2PixFormatImpl() : ptr = ffi.calloc() {
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

  _ManagedV4L2RequestbuffersImpl() : ptr = ffi.calloc() {
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

  _ManagedV4L2BufferImpl() : ptr = ffi.calloc() {
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

final class _ManagedV4L2TimevalImpl extends V4L2TimevalImpl {
  final ffi.Pointer<ffi.timeval> ptr;

  _ManagedV4L2TimevalImpl() : ptr = ffi.calloc() {
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

  _ManagedV4L2TimeCodeImpl() : ptr = ffi.calloc() {
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

  _ManagedV4L2PlaneImpl() : ptr = ffi.calloc() {
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

  _ManagedV4L2MappedBufferImpl() : ptr = ffi.calloc() {
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  ffi.v4l2_mapped_buffer get ref => ptr.ref;
}

/* V4L2RGBXBuffer */
abstract base class V4L2RGBABufferImpl implements V4L2RGBABuffer {
  V4L2RGBABufferImpl();
  factory V4L2RGBABufferImpl.managed(int width, int height) =>
      _ManagedV4L2RGBABufferImpl(width, height);
}

final class _ManagedV4L2RGBABufferImpl extends V4L2RGBABufferImpl {
  @override
  final int width;
  @override
  final int height;
  final ffi.Pointer<ffi.Uint8> ptr;

  _ManagedV4L2RGBABufferImpl(this.width, this.height)
      : ptr = ffi.calloc(width * height * 4) {
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  Uint8List get value => ptr.asTypedList(width * height * 4);
}

/* V4L2Cropcap */
abstract base class V4L2CropcapImpl implements V4L2Cropcap {
  V4L2CropcapImpl();
  factory V4L2CropcapImpl.managed() => _ManagedV4L2CropcapImpl();

  ffi.v4l2_cropcap get ref;

  @override
  V4L2BufType get type => ref.type.toDartBufType();
  set type(V4L2BufType value) => ref.type = value.value;
  @override
  V4L2Rect get bounds => V4L2RectImpl.unmanaged(ref.bounds);
  @override
  V4L2Rect get defrect => V4L2RectImpl.unmanaged(ref.defrect);
  @override
  V4L2Fract get pixelaspect => V4L2FractImpl.unmanaged(ref.pixelaspect);
}

final class _ManagedV4L2CropcapImpl extends V4L2CropcapImpl
    implements ffi.Finalizable {
  final ffi.Pointer<ffi.v4l2_cropcap> ptr;

  _ManagedV4L2CropcapImpl() : ptr = ffi.calloc() {
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  ffi.v4l2_cropcap get ref => ptr.ref;
}

/* V4L2Rect */
abstract base class V4L2RectImpl implements V4L2Rect {
  V4L2RectImpl();
  factory V4L2RectImpl.unmanaged(ffi.v4l2_rect ref) =>
      _UnmanagedV4L2RectImpl(ref);

  ffi.v4l2_rect get ref;

  @override
  int get left => ref.left;
  @override
  set left(int value) => ref.left = value;
  @override
  int get top => ref.top;
  @override
  set top(int value) => ref.top = value;
  @override
  int get width => ref.width;
  @override
  set width(int value) => ref.width = value;
  @override
  int get height => ref.height;
  @override
  set height(int value) => ref.height = value;
}

final class _UnmanagedV4L2RectImpl extends V4L2RectImpl {
  @override
  final ffi.v4l2_rect ref;

  _UnmanagedV4L2RectImpl(this.ref);
}

/* V4L2Fract */
abstract base class V4L2FractImpl implements V4L2Fract {
  V4L2FractImpl();
  factory V4L2FractImpl.unmanaged(ffi.v4l2_fract ref) =>
      _UnmanagedV4L2FractImpl(ref);

  ffi.v4l2_fract get ref;

  @override
  int get numerator => ref.numerator;
  @override
  int get denominator => ref.denominator;
}

final class _UnmanagedV4L2FractImpl extends V4L2FractImpl {
  @override
  final ffi.v4l2_fract ref;

  _UnmanagedV4L2FractImpl(this.ref);
}

/* V4L2Crop */
abstract interface class V4L2CropImpl implements V4L2Crop {
  V4L2CropImpl();
  factory V4L2CropImpl.managed() => _ManagedV4L2CropImpl();

  ffi.v4l2_crop get ref;

  @override
  V4L2BufType get type => ref.type.toDartBufType();
  set type(V4L2BufType value) => ref.type = value.value;

  @override
  V4L2Rect get c => V4L2RectImpl.unmanaged(ref.c);
}

final class _ManagedV4L2CropImpl extends V4L2CropImpl
    implements ffi.Finalizable {
  final ffi.Pointer<ffi.v4l2_crop> ptr;

  _ManagedV4L2CropImpl() : ptr = ffi.calloc() {
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  ffi.v4l2_crop get ref => ptr.ref;
}

/* V4L2Queryctrl */
abstract base class V4L2QueryctrlImpl implements V4L2Queryctrl {
  V4L2QueryctrlImpl();
  factory V4L2QueryctrlImpl.managed() => _ManagedV4L2QueryctrlImpl();

  ffi.v4l2_queryctrl get ref;

  @override
  V4L2CId get id => ref.id.toDartCId();
  set id(V4L2CId value) => ref.id = value.value;
  @override
  V4L2CtrlType get type => ref.type.toDartCtrlType();
  @override
  String get name => ref.name.toDart();
  @override
  int get minimum => ref.minimum;
  @override
  int get maximum => ref.maximum;
  @override
  int get step => ref.step;
  @override
  int get defaultValue => ref.default_value;
  @override
  List<V4L2CtrlFlag> get flags => ref.flags.toDartCtrlFlags();
}

final class _ManagedV4L2QueryctrlImpl extends V4L2QueryctrlImpl
    implements ffi.Finalizable {
  final ffi.Pointer<ffi.v4l2_queryctrl> ptr;

  _ManagedV4L2QueryctrlImpl() : ptr = ffi.calloc() {
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  ffi.v4l2_queryctrl get ref => ptr.ref;
}

/* V4L2QueryExtCtrl */
abstract base class V4L2QueryExtCtrlImpl implements V4L2QueryExtCtrl {
  V4L2QueryExtCtrlImpl();
  factory V4L2QueryExtCtrlImpl.managed() => _ManagedV4L2QueryExtCtrlImpl();

  ffi.v4l2_query_ext_ctrl get ref;

  @override
  V4L2CId get id => ref.id.toDartCId();
  set id(V4L2CId value) => ref.id = value.value;
  @override
  V4L2CtrlType get type => ref.type.toDartCtrlType();
  @override
  String get name => ref.name.toDart();
  @override
  int get minimum => ref.minimum;
  @override
  int get maximum => ref.maximum;
  @override
  int get step => ref.step;
  @override
  int get defaultValue => ref.default_value;
  @override
  List<V4L2CtrlFlag> get flags => ref.flags.toDartCtrlFlags();
  @override
  int get elemSize => ref.elem_size;
  @override
  int get elems => ref.elems;
  @override
  int get nrOfDims => ref.nr_of_dims;
  @override
  List<int> get dims => ref.dims.toDart(ffi.V4L2_CTRL_MAX_DIMS);
}

final class _ManagedV4L2QueryExtCtrlImpl extends V4L2QueryExtCtrlImpl
    implements ffi.Finalizable {
  final ffi.Pointer<ffi.v4l2_query_ext_ctrl> ptr;

  _ManagedV4L2QueryExtCtrlImpl() : ptr = ffi.calloc() {
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  ffi.v4l2_query_ext_ctrl get ref => ptr.ref;
}

/* V4L2Querymenu */
abstract base class V4L2QuerymenuImpl implements V4L2Querymenu {
  V4L2QuerymenuImpl();
  factory V4L2QuerymenuImpl.managed() => _ManagedV4L2QuerymenuImpl();

  ffi.v4l2_querymenu get ref;

  @override
  V4L2CId get id => ref.id.toDartCId();
  set id(V4L2CId value) => ref.id = value.value;
  @override
  int get index => ref.index;
  set index(int value) => ref.index = value;
  @override
  String get name => ref.unnamed.name.toDart();
  @override
  int get value => ref.unnamed.value;
}

final class _ManagedV4L2QuerymenuImpl extends V4L2QuerymenuImpl
    implements ffi.Finalizable {
  final ffi.Pointer<ffi.v4l2_querymenu> ptr;

  _ManagedV4L2QuerymenuImpl() : ptr = ffi.calloc() {
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  ffi.v4l2_querymenu get ref => ptr.ref;
}

/* V4L2Control */
abstract interface class V4L2ControlImpl implements V4L2Control {
  V4L2ControlImpl();
  factory V4L2ControlImpl.managed() => _ManagedV4L2ControlImpl();

  ffi.v4l2_control get ref;

  @override
  V4L2CId get id => ref.id.toDartCId();
  set id(V4L2CId value) => ref.id = value.value;
  @override
  int get value => ref.value;
  @override
  set value(int value) => ref.value = value;
}

final class _ManagedV4L2ControlImpl extends V4L2ControlImpl
    implements ffi.Finalizable {
  final ffi.Pointer<ffi.v4l2_control> ptr;

  _ManagedV4L2ControlImpl() : ptr = ffi.calloc() {
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  ffi.v4l2_control get ref => ptr.ref;
}

/* V4L2ExtControls */
abstract base class V4L2ExtControlsImpl implements V4L2ExtControls {
  V4L2ExtControlsImpl();
  factory V4L2ExtControlsImpl.managed() => _ManagedV4L2ExtControlsImpl();

  ffi.v4l2_ext_controls get ref;

  @override
  V4L2CtrlClass get ctrlClass => ref.unnamed.ctrl_class.toDartCtrlClass();
  set ctrlClass(V4L2CtrlClass value) => ref.unnamed.ctrl_class = value.value;
  @override
  V4L2CtrlWhich get which => ref.unnamed.which.toDartCtrlWhich();
  @override
  set which(V4L2CtrlWhich value) => ref.unnamed.which = value.value;
  @override
  List<V4L2ExtControl> get controls {
    final controls = <V4L2ExtControl>[];
    for (var i = 0; i < ref.count; i++) {
      final control = V4L2ExtControlImpl.unmanaged(ref.controls[i]);
      controls.add(control);
    }
    return controls;
  }
}

final class _ManagedV4L2ExtControlsImpl extends V4L2ExtControlsImpl
    implements ffi.Finalizable {
  final ffi.Pointer<ffi.v4l2_ext_controls> ptr;

  _ManagedV4L2ExtControlsImpl() : ptr = ffi.calloc() {
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  ffi.v4l2_ext_controls get ref => ptr.ref;

  set controls(List<V4L2ExtControl> value) {
    final controls = ffi.calloc<ffi.v4l2_ext_control>(value.length);
    finalizer.attach(
      this,
      controls.cast(),
    );
    for (var i = 0; i < value.length; i++) {
      final control = controls[i];
      final ref = value.cast<_ManagedV4L2ExtControlImpl>()[i].ref;
      control.id = ref.id;
      control.reserved2 = ref.reserved2;
      control.unnamed = ref.unnamed;
    }
    ref.controls = controls;
    ref.count = value.length;
  }
}

/* V4L2ExtControl */
abstract base class V4L2ExtControlImpl implements V4L2ExtControl {
  V4L2ExtControlImpl();
  factory V4L2ExtControlImpl.managed() => _ManagedV4L2ExtControlImpl();
  factory V4L2ExtControlImpl.unmanaged(ffi.v4l2_ext_control ref) =>
      _UnmanagedV4L2ExtControlImpl(ref);

  ffi.v4l2_ext_control get ref;

  @override
  V4L2CId get id => ref.id.toDartCId();
  @override
  set id(V4L2CId value) => ref.id = value.value;
  @override
  int get value => ref.unnamed.value;
  @override
  set value(int value) => ref.unnamed.value = value;
  @override
  int get value64 => ref.unnamed.value64;
  @override
  set value64(int value) => ref.unnamed.value64 = value;
  @override
  String get string => ref.unnamed.string.cast<ffi.Utf8>().toDartString();
  @override
  set string(String value) =>
      ref.unnamed.string = value.toNativeUtf8().cast<ffi.Char>();
  @override
  Uint8List get u8 => throw UnimplementedError();
  @override
  set u8(Uint8List value) => throw UnimplementedError();
  @override
  Uint16List get u16 => throw UnimplementedError();
  @override
  set u16(Uint16List value) => throw UnimplementedError();
  @override
  Uint32List get u32 => throw UnimplementedError();
  @override
  set u32(Uint32List value) => throw UnimplementedError();
}

final class _ManagedV4L2ExtControlImpl extends V4L2ExtControlImpl
    implements ffi.Finalizable {
  final ffi.Pointer<ffi.v4l2_ext_control> ptr;

  _ManagedV4L2ExtControlImpl() : ptr = ffi.calloc() {
    finalizer.attach(
      this,
      ptr.cast(),
    );
  }

  @override
  ffi.v4l2_ext_control get ref => ptr.ref;
}

final class _UnmanagedV4L2ExtControlImpl extends V4L2ExtControlImpl {
  @override
  final ffi.v4l2_ext_control ref;

  _UnmanagedV4L2ExtControlImpl(this.ref);
}
