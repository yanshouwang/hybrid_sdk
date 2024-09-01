import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:hybrid_usb/hybrid_usb.dart';

import 'ffi.dart';
import 'hybrid_uvc.dart';
import 'uvc.dart';
import 'uvc_device.dart';
import 'uvc_device_descriptor.dart';
import 'uvc_error.dart';
import 'uvc_format_descriptor.dart';
import 'uvc_format_specific_data.dart';
import 'uvc_format_specifier.dart';
import 'uvc_frame.dart';
import 'uvc_frame_descriptor.dart';
import 'uvc_frame_format.dart';
import 'uvc_input_terminal.dart';
import 'uvc_input_terminal_type.dart';
import 'uvc_request_code.dart';
import 'uvc_still_frame_descriptor.dart';
import 'uvc_still_frame_resolution.dart';
import 'uvc_stream_control.dart';
import 'uvc_video_streaming_descriptor_subtype.dart';
import 'uvc_zoom_relative.dart';

const _uvc = 'uvc';

final _dylibUVC = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_uvc.framework/$_uvc');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_uvc.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_uvc.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

final _libUVC = LibUVC(_dylibUVC);

final class HybridUVCPluginImpl extends HybridUVCPlugin {
  final USB _usb;
  Pointer<uvc_context>? _ctxPtr;

  HybridUVCPluginImpl() : _usb = USB() {
    init();
  }

  Pointer<uvc_context> get ctxPtr {
    final ctxPtr = _ctxPtr;
    if (ctxPtr == null) {
      throw UVCError('ctxPtr is null.');
    }
    return ctxPtr;
  }

  set ctxPtr(Pointer<uvc_context> value) {
    _ctxPtr = value;
  }

  void init() {
    if (Platform.isAndroid) {
      _usb.setOption(USBOption.noDeviceDiscovery);
    }
    ctxPtr = using((arena) {
      final ctxPtr2 = arena<Pointer<uvc_context>>();
      final err = _libUVC.uvc_init(ctxPtr2, nullptr);
      if (err != uvc_error.UVC_SUCCESS) {
        _libUVC.uvc_perror(
          err,
          'uvc_init'.toNativeUtf8().cast(),
        );
        throw UVCError('init failed, $err.');
      }
      final ctxPtr = ctxPtr2.value;
      return ctxPtr;
    });
  }

  void exit() {
    _libUVC.uvc_exit(ctxPtr);
  }

  @override
  List<UVCDeviceImpl> findDevices({
    int? vid,
    int? pid,
    String? sn,
  }) {
    return using((arena) {
      final devsPtr2 = arena<Pointer<Pointer<uvc_device>>>();
      final err = _libUVC.uvc_find_devices(
        ctxPtr,
        devsPtr2,
        vid ?? 0,
        pid ?? 0,
        sn?.toNativeUtf8().cast() ?? nullptr,
      );
      if (err != uvc_error.UVC_SUCCESS) {
        _libUVC.uvc_perror(
          err,
          'uvc_find_devices'.toNativeUtf8().cast(),
        );
        throw UVCError('findDevices failed, $err.');
      }
      final deviceImpls = <UVCDeviceImpl>[];
      final devsPtr = devsPtr2.value;
      var i = 0;
      while (true) {
        final devPtr = devsPtr[i];
        if (devPtr == nullptr) {
          break;
        }
        final deviceImpl = UVCDeviceImpl(devPtr);
        deviceImpls.add(deviceImpl);
      }
      return deviceImpls;
    });
  }

  @override
  UVCDeviceImpl findDevice({
    int? vid,
    int? pid,
    String? sn,
  }) {
    return using((arena) {
      final devPtr2 = arena<Pointer<uvc_device>>();
      final err = _libUVC.uvc_find_device(
        ctxPtr,
        devPtr2,
        vid ?? 0,
        pid ?? 0,
        sn?.toNativeUtf8().cast() ?? nullptr,
      );
      if (err != uvc_error.UVC_SUCCESS) {
        _libUVC.uvc_perror(
          err,
          'uvc_find_device'.toNativeUtf8().cast(),
        );
        throw UVCError('findDevice failed, $err.');
      }
      final devPtr = devPtr2.value;
      return UVCDeviceImpl(devPtr);
    });
  }

  @override
  UVCDeviceDescriptorImpl getDeviceDescriptor(UVCDevice device) {
    if (device is! UVCDeviceImpl) {
      throw TypeError();
    }
    return using((arena) {
      final descPtr2 = arena<Pointer<uvc_device_descriptor>>();
      final err = _libUVC.uvc_get_device_descriptor(device.devPtr, descPtr2);
      if (err != uvc_error.UVC_SUCCESS) {
        _libUVC.uvc_perror(
          err,
          'uvc_get_device_descriptor'.toNativeUtf8().cast(),
        );
        throw UVCError('getDeviceDescriptor failed, $err');
      }
      final descPtr = descPtr2.value;
      final desc = descPtr.ref;
      return UVCDeviceDescriptorImpl.ffi(desc);
    });
  }

  @override
  void open(UVCDevice device) {
    if (device is! UVCDeviceImpl) {
      throw TypeError();
    }
    device.devhPtr = using((arena) {
      final devhPtr2 = arena<Pointer<uvc_device_handle>>();
      final err = _libUVC.uvc_open(device.devPtr, devhPtr2);
      if (err != uvc_error.UVC_SUCCESS) {
        _libUVC.uvc_perror(
          err,
          'uvc_open'.toNativeUtf8().cast(),
        );
        throw UVCError('open failed, $err.');
      }
      final devhPtr = devhPtr2.value;
      return devhPtr;
    });
  }

  @override
  void close(UVCDevice device) {
    if (device is! UVCDeviceImpl) {
      throw TypeError();
    }
    _libUVC.uvc_close(device.devhPtr);
  }

  @override
  List<UVCFormatDescriptorImpl> getFormatDescriptors(UVCDevice device) {
    if (device is! UVCDeviceImpl) {
      throw TypeError();
    }
    final formatDescriptorImpls = <UVCFormatDescriptorImpl>[];
    var formatDescPtr = _libUVC.uvc_get_format_descs(device.devhPtr);
    while (formatDescPtr != nullptr) {
      final formatDesc = formatDescPtr.ref;
      final formatDescriptorImpl = UVCFormatDescriptorImpl.ffi(formatDesc);
      formatDescriptorImpls.add(formatDescriptorImpl);
      formatDescPtr = formatDesc.next;
    }
    return formatDescriptorImpls;
  }

  @override
  UVCStreamControlImpl getStreamControl(
    UVCDevice device, {
    required UVCFrameFormat format,
    required int width,
    required int height,
    required int fps,
  }) {
    if (device is! UVCDeviceImpl) {
      throw TypeError();
    }
    final ctrlPtr = calloc<uvc_stream_ctrl>();
    final err = _libUVC.uvc_get_stream_ctrl_format_size(
      device.devhPtr,
      ctrlPtr,
      format.ffiValue,
      width,
      height,
      fps,
    );
    if (err != uvc_error.UVC_SUCCESS) {
      _libUVC.uvc_perror(
        err,
        'uvc_get_stream_ctrl_format_size'.toNativeUtf8().cast(),
      );
      throw UVCError('getStreamControl failed, $err');
    }
    return UVCStreamControlImpl(ctrlPtr);
  }

  @override
  void startStreaming(
    UVCDevice device, {
    required UVCStreamControl control,
    required UVCFrameCallback callback,
  }) {
    if (device is! UVCDeviceImpl || control is! UVCStreamControlImpl) {
      throw TypeError();
    }
    device.cbPtr = using((arena) {
      void cb(Pointer<uvc_frame> framePtr, Pointer<void> formatPtr) async {
        final frameImpl = UVCFrameImpl(framePtr);
        callback(frameImpl);
      }

      final cbPtr = NativeCallable<
          Void Function(
              Pointer<uvc_frame> framePtr, Pointer<Void> userPtr)>.listener(cb);
      final userPtr = arena<Int32>()..value = 12345;
      final err = _libUVC.uvc_start_streaming(
        device.devhPtr,
        control.ctrlPtr,
        cbPtr.nativeFunction,
        userPtr.cast(),
        0,
      );
      if (err != uvc_error.UVC_SUCCESS) {
        _libUVC.uvc_perror(
          err,
          'uvc_start_streaming'.toNativeUtf8().cast(),
        );
        throw UVCError('startStreaming failed, $err');
      }
      return cbPtr;
    });
  }

  @override
  void stopStreaming(UVCDevice device) {
    if (device is! UVCDeviceImpl) {
      throw TypeError();
    }
    _libUVC.uvc_stop_streaming(device.devhPtr);
    device.cbPtr.close();
  }

  @override
  List<UVCInputTerminalImpl> getInputTerminals(UVCDevice device) {
    if (device is! UVCDeviceImpl) {
      throw TypeError();
    }
    final inputTerminalImpls = <UVCInputTerminalImpl>[];
    var inputTerminalPtr = _libUVC.uvc_get_input_terminals(device.devhPtr);
    while (inputTerminalPtr != nullptr) {
      final inputTerminal = inputTerminalPtr.ref;
      final inputTerminalImpl = UVCInputTerminalImpl.ffi(inputTerminal);
      inputTerminalImpls.add(inputTerminalImpl);
      inputTerminalPtr = inputTerminal.next;
    }
    return inputTerminalImpls;
  }

  @override
  int getZoomAbsolute(
    UVCDevice device, {
    required UVCRequestCode requestCode,
  }) {
    if (device is! UVCDeviceImpl) {
      throw TypeError();
    }
    return using((arena) {
      final focalLengthPtr = arena<Uint16>();
      var err = _libUVC.uvc_get_zoom_abs(
        device.devhPtr,
        focalLengthPtr,
        requestCode.ffiValue,
      );
      if (err != uvc_error.UVC_SUCCESS) {
        _libUVC.uvc_perror(
          err,
          'uvc_get_zoom_abs'.toNativeUtf8().cast(),
        );
        throw UVCError('getZoomAbsolute failed, $err.');
      }
      return focalLengthPtr.value;
    });
  }

  @override
  void setZoomAbsolute(
    UVCDevice device, {
    required int focalLength,
  }) {
    if (device is! UVCDeviceImpl) {
      throw TypeError();
    }
    final err = _libUVC.uvc_set_zoom_abs(
      device.devhPtr,
      focalLength,
    );
    if (err != uvc_error.UVC_SUCCESS) {
      _libUVC.uvc_perror(
        err,
        'uvc_set_zoom_abs'.toNativeUtf8().cast(),
      );
      throw UVCError('setZoomAbsolute failed, $err');
    }
  }

  @override
  UVCZoomRelativeImpl getZoomRelative(
    UVCDevice device, {
    required UVCRequestCode requestCode,
  }) {
    if (device is! UVCDeviceImpl) {
      throw TypeError();
    }
    return using((arena) {
      final zoomRelativePtr = arena<Int8>();
      final digitalZoomPtr = arena<Uint8>();
      final speedPtr = arena<Uint8>();
      var err = _libUVC.uvc_get_zoom_rel(
        device.devhPtr,
        zoomRelativePtr,
        digitalZoomPtr,
        speedPtr,
        requestCode.ffiValue,
      );
      if (err != uvc_error.UVC_SUCCESS) {
        _libUVC.uvc_perror(
          err,
          'uvc_get_zoom_rel'.toNativeUtf8().cast(),
        );
        throw UVCError('getZoomRelative failed, $err.');
      }
      return UVCZoomRelativeImpl(
        zoomRelative: zoomRelativePtr.value,
        digitalZoom: digitalZoomPtr.value,
        speed: speedPtr.value,
      );
    });
  }

  @override
  void setZoomRelative(
    UVCDevice device, {
    required int zoomRelative,
    required int digitalZoom,
    required int speed,
  }) {
    if (device is! UVCDeviceImpl) {
      throw TypeError();
    }
    final err = _libUVC.uvc_set_zoom_rel(
      device.devhPtr,
      zoomRelative,
      digitalZoom,
      speed,
    );
    if (err != uvc_error.UVC_SUCCESS) {
      _libUVC.uvc_perror(
        err,
        'uvc_set_zoom_rel'.toNativeUtf8().cast(),
      );
      throw UVCError('setZoomRelative failed, $err');
    }
  }

  @override
  UVCFrame mjpeg2RGB(UVCFrame frame) {
    // TODO: implement mjpeg2RGB
    throw UnimplementedError();
  }

  @override
  UVCFrame mjpeg2Gray(UVCFrame frame) {
    // TODO: implement mjpeg2Gray
    throw UnimplementedError();
  }

  @override
  UVCFrame yuyv2RGB(UVCFrame frame) {
    // TODO: implement yuyv2RGB
    throw UnimplementedError();
  }

  @override
  UVCFrame yuyv2BGR(UVCFrame frame) {
    // TODO: implement yuyv2BGR
    throw UnimplementedError();
  }

  @override
  UVCFrame yuyv2Y(UVCFrame frame) {
    // TODO: implement yuyv2Y
    throw UnimplementedError();
  }

  @override
  UVCFrame yuyv2UV(UVCFrame frame) {
    // TODO: implement yuyv2UV
    throw UnimplementedError();
  }

  @override
  UVCFrame uyvy2RGB(UVCFrame frame) {
    // TODO: implement uyvy2RGB
    throw UnimplementedError();
  }

  @override
  UVCFrame uyvy2BGR(UVCFrame frame) {
    // TODO: implement uyvy2BGR
    throw UnimplementedError();
  }

  @override
  UVCFrame any2RGB(UVCFrame frame) {
    // TODO: implement any2RGB
    throw UnimplementedError();
  }

  @override
  UVCFrame any2BGR(UVCFrame frame) {
    // TODO: implement any2BGR
    throw UnimplementedError();
  }
}

final class UVCDeviceImpl implements UVCDevice {
  final Pointer<uvc_device> devPtr;

  Pointer<uvc_device_handle>? _devhPtr;
  NativeCallable<
          Void Function(Pointer<uvc_frame> framePtr, Pointer<Void> userPtr)>?
      _cbPtr;

  Pointer<uvc_device_handle> get devhPtr {
    final devhPtr = _devhPtr;
    if (devhPtr == null) {
      throw UVCError('devhPtr is null.');
    }
    return devhPtr;
  }

  set devhPtr(Pointer<uvc_device_handle> value) {
    _devhPtr = value;
  }

  NativeCallable<
          Void Function(Pointer<uvc_frame> framePtr, Pointer<Void> userPtr)>
      get cbPtr {
    final cbPtr = _cbPtr;
    if (cbPtr == null) {
      throw UVCError('cbPtr is null.');
    }
    return cbPtr;
  }

  set cbPtr(
      NativeCallable<
              Void Function(Pointer<uvc_frame> framePtr, Pointer<Void> userPtr)>
          value) {
    _cbPtr = value;
  }

  UVCDeviceImpl(this.devPtr);
}

final class UVCDeviceDescriptorImpl implements UVCDeviceDescriptor {
  @override
  final int vid;
  @override
  final int pid;
  @override
  final String? sn;
  @override
  final String? manufacturer;
  @override
  final String? product;

  UVCDeviceDescriptorImpl({
    required this.vid,
    required this.pid,
    required this.sn,
    required this.manufacturer,
    required this.product,
  });

  factory UVCDeviceDescriptorImpl.ffi(uvc_device_descriptor desc) {
    return UVCDeviceDescriptorImpl(
      vid: desc.idVendor,
      pid: desc.idProduct,
      sn: desc.serialNumber.toDartString(),
      manufacturer: desc.manufacturer.toDartString(),
      product: desc.product.toDartString(),
    );
  }
}

final class UVCFormatDescriptorImpl implements UVCFormatDescriptor {
  @override
  final UVCVideoStreamingDescriptorSubtype subtype;
  @override
  final int index;
  @override
  final UVCFormatSpecifierImpl specifier;
  @override
  final UVCFormatSpecificDataImpl specificData;
  @override
  final int defaultIndex;
  @override
  final int aspectRatioX;
  @override
  final int aspectRatioY;
  @override
  final int interlaceFlags;
  @override
  final int copyProtect;
  @override
  final int variableSize;
  @override
  final List<UVCFrameDescriptorImpl> frameDescriptors;
  @override
  final List<UVCStillFrameDescriptorImpl> stillFrameDescriptors;

  UVCFormatDescriptorImpl({
    required this.subtype,
    required this.index,
    required this.specifier,
    required this.specificData,
    required this.defaultIndex,
    required this.aspectRatioX,
    required this.aspectRatioY,
    required this.interlaceFlags,
    required this.copyProtect,
    required this.variableSize,
    required this.frameDescriptors,
    required this.stillFrameDescriptors,
  });

  factory UVCFormatDescriptorImpl.ffi(uvc_format_desc desc) {
    final frameDescriptorImpls = <UVCFrameDescriptorImpl>[];
    var frameDescPtr = desc.frame_descs;
    while (frameDescPtr != nullptr) {
      final frameDesc = frameDescPtr.ref;
      final frameDescriptorImpl = UVCFrameDescriptorImpl.ffi(frameDesc);
      frameDescriptorImpls.add(frameDescriptorImpl);
      frameDescPtr = frameDesc.next;
    }
    final stillFrameDescriptorImpls = <UVCStillFrameDescriptorImpl>[];
    var stillFrameDescPtr = desc.still_frame_desc;
    while (stillFrameDescPtr != nullptr) {
      final stillFrameDesc = stillFrameDescPtr.ref;
      final stillFrameDescriptorImpl =
          UVCStillFrameDescriptorImpl.ffi(stillFrameDesc);
      stillFrameDescriptorImpls.add(stillFrameDescriptorImpl);
      stillFrameDescPtr = stillFrameDesc.next;
    }
    return UVCFormatDescriptorImpl(
      subtype: uvc_vs_desc_subtype.fromValue(desc.bDescriptorSubtype).dartValue,
      index: desc.bFormatIndex,
      specifier: UVCFormatSpecifierImpl.ffi(desc.unnamed),
      specificData: UVCFormatSpecificDataImpl.ffi(desc.unnamed1),
      defaultIndex: desc.bDefaultFrameIndex,
      aspectRatioX: desc.bAspectRatioX,
      aspectRatioY: desc.bAspectRatioY,
      interlaceFlags: desc.bmInterlaceFlags,
      copyProtect: desc.bCopyProtect,
      variableSize: desc.bVariableSize,
      frameDescriptors: frameDescriptorImpls,
      stillFrameDescriptors: stillFrameDescriptorImpls,
    );
  }
}

final class UVCFormatSpecifierImpl implements UVCFormatSpecifier {
  @override
  final List<int> guid;
  @override
  final List<int> fourCC;

  UVCFormatSpecifierImpl({
    required this.guid,
    required this.fourCC,
  });

  factory UVCFormatSpecifierImpl.ffi(UnnamedUnion1 unnamed) {
    return UVCFormatSpecifierImpl(
      guid: unnamed.guidFormat.toList(16),
      fourCC: unnamed.fourccFormat.toList(4),
    );
  }
}

final class UVCFormatSpecificDataImpl implements UVCFormatSpecificData {
  @override
  final int bitsPerPixel;
  @override
  final int flags;

  UVCFormatSpecificDataImpl({
    required this.bitsPerPixel,
    required this.flags,
  });

  factory UVCFormatSpecificDataImpl.ffi(UnnamedUnion2 unnamed) {
    return UVCFormatSpecificDataImpl(
      bitsPerPixel: unnamed.bBitsPerPixel,
      flags: unnamed.bmFlags,
    );
  }
}

final class UVCFrameDescriptorImpl implements UVCFrameDescriptor {
  @override
  final UVCVideoStreamingDescriptorSubtype subtype;
  @override
  final int index;
  @override
  final int capabilities;
  @override
  final int width;
  @override
  final int height;
  @override
  final int minimumBitRate;
  @override
  final int maximumBitRate;
  @override
  final int maximumVideoFrameBufferSize;
  @override
  final int defaultInterval;
  @override
  final int minimumInterval;
  @override
  final int maximumInterval;
  @override
  final int intervalStep;
  @override
  final int intervalType;
  @override
  final int bytesPerLine;
  @override
  final List<int> intervals;

  UVCFrameDescriptorImpl({
    required this.subtype,
    required this.index,
    required this.capabilities,
    required this.width,
    required this.height,
    required this.minimumBitRate,
    required this.maximumBitRate,
    required this.maximumVideoFrameBufferSize,
    required this.defaultInterval,
    required this.minimumInterval,
    required this.maximumInterval,
    required this.intervalStep,
    required this.intervalType,
    required this.bytesPerLine,
    required this.intervals,
  });

  factory UVCFrameDescriptorImpl.ffi(uvc_frame_desc desc) {
    return UVCFrameDescriptorImpl(
      subtype: uvc_vs_desc_subtype.fromValue(desc.bDescriptorSubtype).dartValue,
      index: desc.bFrameIndex,
      capabilities: desc.bmCapabilities,
      width: desc.wWidth,
      height: desc.wHeight,
      minimumBitRate: desc.dwMinBitRate,
      maximumBitRate: desc.dwMaxBitRate,
      maximumVideoFrameBufferSize: desc.dwMaxVideoFrameBufferSize,
      defaultInterval: desc.dwDefaultFrameInterval,
      minimumInterval: desc.dwMinFrameInterval,
      maximumInterval: desc.dwMaxFrameInterval,
      intervalStep: desc.dwFrameIntervalStep,
      intervalType: desc.bFrameIntervalType,
      bytesPerLine: desc.dwBytesPerLine,
      intervals: desc.intervals.toList(),
    );
  }
}

final class UVCStillFrameDescriptorImpl implements UVCStillFrameDescriptor {
  @override
  final UVCVideoStreamingDescriptorSubtype subtype;
  @override
  final int endpointAddress;
  @override
  final List<UVCStillFrameResolutionImpl> imageSizePatterns;
  @override
  final int compression;

  UVCStillFrameDescriptorImpl({
    required this.subtype,
    required this.endpointAddress,
    required this.imageSizePatterns,
    required this.compression,
  });

  factory UVCStillFrameDescriptorImpl.ffi(uvc_still_frame_desc desc) {
    final imageSizePatternImpls = <UVCStillFrameResolutionImpl>[];
    var imageSizePatternPtr = desc.imageSizePatterns;
    while (imageSizePatternPtr != nullptr) {
      final imageSizePattern = imageSizePatternPtr.ref;
      final imageSizePatternImpl =
          UVCStillFrameResolutionImpl.ffi(imageSizePattern);
      imageSizePatternImpls.add(imageSizePatternImpl);
      imageSizePatternPtr = imageSizePattern.next;
    }
    return UVCStillFrameDescriptorImpl(
      subtype: uvc_vs_desc_subtype.fromValue(desc.bDescriptorSubtype).dartValue,
      endpointAddress: desc.bEndPointAddress,
      imageSizePatterns: imageSizePatternImpls,
      compression: desc.bCompression.value,
    );
  }
}

final class UVCStillFrameResolutionImpl implements UVCStillFrameResolution {
  @override
  final int index;
  @override
  final int width;
  @override
  final int height;

  UVCStillFrameResolutionImpl({
    required this.index,
    required this.width,
    required this.height,
  });

  factory UVCStillFrameResolutionImpl.ffi(uvc_still_frame_res res) {
    return UVCStillFrameResolutionImpl(
      index: res.bResolutionIndex,
      width: res.wWidth,
      height: res.wHeight,
    );
  }
}

final class UVCStreamControlImpl implements UVCStreamControl {
  final Pointer<uvc_stream_ctrl> ctrlPtr;

  UVCStreamControlImpl(this.ctrlPtr);
}

final class UVCFrameImpl implements UVCFrame {
  final Pointer<uvc_frame> framePtr;

  UVCFrameImpl(this.framePtr);

  uvc_frame get frame => framePtr.ref;

  @override
  Uint8List get data => frame.data.cast<Uint8>().asTypedList(frame.data_bytes);
  @override
  int get width => frame.width;
  @override
  int get height => frame.height;
  @override
  UVCFrameFormat get format =>
      uvc_frame_format.fromValue(frame.frame_format).dartValue;
  @override
  int get step => frame.step;
  @override
  int get sequence => frame.sequence;
  @override
  DateTime get captureTime => frame.capture_time.dartValue;
  @override
  DateTime get captureTimeFinished => frame.capture_time_finished.dartValue;
  @override
  Uint8List get metadata =>
      frame.metadata.cast<Uint8>().asTypedList(frame.metadata_bytes);
}

final class UVCInputTerminalImpl implements UVCInputTerminal {
  @override
  final int id;
  @override
  final UVCInputTerminalType type;
  @override
  final int minimumObjectiveFocalLength;
  @override
  final int maximumObjectiveFocalLength;
  @override
  final int ocularFocalLength;
  @override
  final int controls;

  UVCInputTerminalImpl({
    required this.id,
    required this.type,
    required this.minimumObjectiveFocalLength,
    required this.maximumObjectiveFocalLength,
    required this.ocularFocalLength,
    required this.controls,
  });

  factory UVCInputTerminalImpl.ffi(uvc_input_terminal terminal) {
    return UVCInputTerminalImpl(
      id: terminal.bTerminalID,
      type: uvc_it_type.fromValue(terminal.wTerminalType).dartValue,
      minimumObjectiveFocalLength: terminal.wObjectiveFocalLengthMin,
      maximumObjectiveFocalLength: terminal.wObjectiveFocalLengthMax,
      ocularFocalLength: terminal.wOcularFocalLength,
      controls: terminal.bmControls,
    );
  }
}

final class UVCZoomRelativeImpl implements UVCZoomRelative {
  @override
  final int zoomRelative;
  @override
  final int digitalZoom;
  @override
  final int speed;

  UVCZoomRelativeImpl({
    required this.zoomRelative,
    required this.digitalZoom,
    required this.speed,
  });
}

// class _IsolateMessage {
//   final SendPort sendPort;
//   final RootIsolateToken token;

//   _IsolateMessage({
//     required this.sendPort,
//     required this.token,
//   });
// }

// class _Any2RGBACommand {
//   final Pointer<uvc_frame> framePtr;
//   final Pointer<void> userPtr;

//   _Any2RGBACommand({
//     required this.framePtr,
//     required this.userPtr,
//   });
// }

// class _Any2RGBAReply {
//   final int width;
//   final int height;
//   final Uint8List value;
//   final Object? error;

//   _Any2RGBAReply({
//     required this.width,
//     required this.height,
//     required this.value,
//     this.error,
//   });
// }

// Completer<UVCFrame>? _any2RGBACompleter;

// Future<SendPort> _isolateSendPort = () async {
//   // The helper isolate is going to send us back a SendPort, which we want to
//   // wait for.
//   final completer = Completer<SendPort>();

//   // Receive port on the main isolate to receive messages from the helper.
//   // We receive two types of messages:
//   // 1. A port to send messages on.
//   // 2. Responses to requests we sent.
//   final receivePort = ReceivePort()
//     ..listen(
//       (message) {
//         if (message is SendPort) {
//           // The helper isolate sent us the port on which we can sent it requests.
//           completer.complete(message);
//         } else if (message is _Any2RGBAReply) {
//           final completer = _any2RGBACompleter;
//           if (completer == null) {
//             return;
//           }
//           final error = message.error;
//           if (error == null) {
//             final frame =
//                 UVCFrame(message.width, message.height, message.value);
//             completer.complete(frame);
//           } else {
//             completer.completeError(error);
//           }
//         } else {
//           throw UnsupportedError(
//             'Unsupported message type: ${message.runtimeType}',
//           );
//         }
//       },
//     );

//   // Start the helper isolate.
//   await Isolate.spawn(
//     (message) {
//       final sendPort = message.sendPort;
//       final token = message.token;
//       // Register the background isolate with the root isolate.
//       BackgroundIsolateBinaryMessenger.ensureInitialized(token);
//       final isolatePort = ReceivePort()
//         ..listen(
//           (message) async {
//             // On the isolate listen to requests and respond to them.
//             if (message is _Any2RGBACommand) {
//               try {
//                 final framePtr = message.framePtr;
//                 final frame = framePtr.ref;
//                 final rgbPtr =
//                     _libUVC.uvc_allocate_frame(frame.width * frame.height * 3);
//                 if (rgbPtr == nullptr) {
//                   throw UVCError('Unable to allocate RBG frame!');
//                 }
//                 final format = uvc_frame_format.fromValue(frame.frame_format);
//                 switch (format) {
//                   case uvc_frame_format.UVC_FRAME_FORMAT_H264:
//                   case uvc_frame_format.UVC_FRAME_FORMAT_MJPEG:
//                   case uvc_frame_format.UVC_FRAME_FORMAT_YUYV:
//                     final err = _libUVC.uvc_any2rgb(framePtr, rgbPtr);
//                     if (err != uvc_error.UVC_SUCCESS) {
//                       _libUVC.uvc_perror(
//                         err,
//                         'uvc_any2rgb'.toNativeUtf8().cast(),
//                       );
//                       _libUVC.uvc_free_frame(rgbPtr);
//                       throw UVCError('UVC any to RGB failed, $err');
//                     }
//                     break;
//                   default:
//                     throw UVCError('Unknown frame format $format.');
//                 }
//                 final rgb = rgbPtr.ref;
//                 final width = rgb.width;
//                 final height = rgb.height;
//                 final data = rgb.data.cast<Uint8>().asTypedList(rgb.data_bytes);
//                 final value = Uint8List(width * height * 4);
//                 for (var i = 0; i < width * height; i++) {
//                   final start = i * 4;
//                   final end = start + 3;
//                   final skipCount = i * 3;
//                   value.setRange(start, end, data, skipCount);
//                   value[end] = 0xff;
//                 }
//                 final reply = _Any2RGBAReply(
//                   width: width,
//                   height: height,
//                   value: value,
//                 );
//                 sendPort.send(reply);
//               } catch (e) {
//                 final reply = _Any2RGBAReply(
//                   width: 0,
//                   height: 0,
//                   value: Uint8List(0),
//                   error: e,
//                 );
//                 sendPort.send(reply);
//               }
//             } else {
//               throw UnsupportedError(
//                 'Unsupported message type: ${message.runtimeType}',
//               );
//             }
//           },
//         );

//       // Send the port to the main isolate on which we can receive requests.
//       sendPort.send(isolatePort.sendPort);
//     },
//     _IsolateMessage(
//       sendPort: receivePort.sendPort,
//       token: ArgumentError.checkNotNull(RootIsolateToken.instance),
//     ),
//   );

//   // Wait until the helper isolate has sent us back the SendPort on which we
//   // can start sending requests.
//   return completer.future;
// }();
