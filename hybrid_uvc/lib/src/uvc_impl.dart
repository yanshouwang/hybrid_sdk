import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:ffi/ffi.dart' as ffi;
import 'package:flutter/services.dart';
import 'package:hybrid_logging/hybrid_logging.dart';
import 'package:hybrid_usb/hybrid_usb.dart';

import 'uvc_ffi.dart' as ffi;
import 'hybrid_uvc_plugin.dart';
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

final class HybridUVCPluginImpl extends HybridUVCPlugin {
  @override
  UVC createUVC() {
    return UVCImpl();
  }
}

final class UVCImpl with TypeLogger, LoggerController implements UVC {
  final USB _usb;
  ffi.Pointer<ffi.uvc_context>? _ctxPtr;

  UVCImpl() : _usb = USB() {
    init();
  }

  ffi.Pointer<ffi.uvc_context> get ctxPtr {
    final ctxPtr = _ctxPtr;
    if (ctxPtr == null) {
      throw UVCError('ctxPtr is null.');
    }
    return ctxPtr;
  }

  set ctxPtr(ffi.Pointer<ffi.uvc_context> value) {
    _ctxPtr = value;
  }

  void init() {
    if (Platform.isAndroid) {
      _usb.setOption(USBOption.noDeviceDiscovery);
    }
    ctxPtr = ffi.using((arena) {
      final ctxPtr2 = arena<ffi.Pointer<ffi.uvc_context>>();
      final err = ffi.libUVC.uvc_init(ctxPtr2, ffi.nullptr);
      if (err != ffi.uvc_error.UVC_SUCCESS) {
        ffi.libUVC.uvc_perror(
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
    ffi.libUVC.uvc_exit(ctxPtr);
  }

  @override
  List<UVCDeviceImpl> findDevices({
    int? vid,
    int? pid,
    String? sn,
  }) {
    return ffi.using((arena) {
      final devsPtr2 = arena<ffi.Pointer<ffi.Pointer<ffi.uvc_device>>>();
      final err = ffi.libUVC.uvc_find_devices(
        ctxPtr,
        devsPtr2,
        vid ?? 0,
        pid ?? 0,
        sn?.toNativeUtf8().cast() ?? ffi.nullptr,
      );
      if (err != ffi.uvc_error.UVC_SUCCESS) {
        ffi.libUVC.uvc_perror(
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
        if (devPtr == ffi.nullptr) {
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
    return ffi.using((arena) {
      final devPtr2 = arena<ffi.Pointer<ffi.uvc_device>>();
      final err = ffi.libUVC.uvc_find_device(
        ctxPtr,
        devPtr2,
        vid ?? 0,
        pid ?? 0,
        sn?.toNativeUtf8().cast() ?? ffi.nullptr,
      );
      if (err != ffi.uvc_error.UVC_SUCCESS) {
        ffi.libUVC.uvc_perror(
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
    return ffi.using((arena) {
      final descPtr2 = arena<ffi.Pointer<ffi.uvc_device_descriptor>>();
      final err = ffi.libUVC.uvc_get_device_descriptor(device.devPtr, descPtr2);
      if (err != ffi.uvc_error.UVC_SUCCESS) {
        ffi.libUVC.uvc_perror(
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
    device.devhPtr = ffi.using((arena) {
      final devhPtr2 = arena<ffi.Pointer<ffi.uvc_device_handle>>();
      final err = ffi.libUVC.uvc_open(device.devPtr, devhPtr2);
      if (err != ffi.uvc_error.UVC_SUCCESS) {
        ffi.libUVC.uvc_perror(
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
    ffi.libUVC.uvc_close(device.devhPtr);
  }

  @override
  UVCDeviceImpl wrap(int fileDescriptor) {
    return ffi.using((arena) {
      final devhPtr2 = arena<ffi.Pointer<ffi.uvc_device_handle>>();
      final err = ffi.libUVC.uvc_wrap(fileDescriptor, ctxPtr, devhPtr2);
      if (err != ffi.uvc_error.UVC_SUCCESS) {
        ffi.libUVC.uvc_perror(
          err,
          'uvc_wrap'.toNativeUtf8().cast(),
        );
        throw UVCError('wrap failed, $err.');
      }
      return UVCDeviceImpl(ffi.nullptr)..devhPtr = devhPtr2.value;
    });
  }

  @override
  List<UVCFormatDescriptorImpl> getFormatDescriptors(UVCDevice device) {
    if (device is! UVCDeviceImpl) {
      throw TypeError();
    }
    final formatDescriptorImpls = <UVCFormatDescriptorImpl>[];
    var formatDescPtr = ffi.libUVC.uvc_get_format_descs(device.devhPtr);
    while (formatDescPtr != ffi.nullptr) {
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
    final ctrlPtr = ffi.calloc<ffi.uvc_stream_ctrl>();
    final err = ffi.libUVC.uvc_get_stream_ctrl_format_size(
      device.devhPtr,
      ctrlPtr,
      format.ffiValue,
      width,
      height,
      fps,
    );
    if (err != ffi.uvc_error.UVC_SUCCESS) {
      ffi.libUVC.uvc_perror(
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
    device.cbPtr = ffi.using((arena) {
      void cb(ffi.Pointer<ffi.uvc_frame> framePtr,
          ffi.Pointer<void> formatPtr) async {
        final frameImpl = UVCFrameImpl(framePtr);
        callback(frameImpl);
      }

      final cbPtr = ffi.NativeCallable<
          ffi.Void Function(ffi.Pointer<ffi.uvc_frame> framePtr,
              ffi.Pointer<ffi.Void> userPtr)>.listener(cb);
      final userPtr = arena<ffi.Int32>()..value = 12345;
      final err = ffi.libUVC.uvc_start_streaming(
        device.devhPtr,
        control.ctrlPtr,
        cbPtr.nativeFunction,
        userPtr.cast(),
        0,
      );
      if (err != ffi.uvc_error.UVC_SUCCESS) {
        ffi.libUVC.uvc_perror(
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
    ffi.libUVC.uvc_stop_streaming(device.devhPtr);
    device.cbPtr.close();
  }

  @override
  List<UVCInputTerminalImpl> getInputTerminals(UVCDevice device) {
    if (device is! UVCDeviceImpl) {
      throw TypeError();
    }
    final inputTerminalImpls = <UVCInputTerminalImpl>[];
    var inputTerminalPtr = ffi.libUVC.uvc_get_input_terminals(device.devhPtr);
    while (inputTerminalPtr != ffi.nullptr) {
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
    return ffi.using((arena) {
      final focalLengthPtr = arena<ffi.Uint16>();
      var err = ffi.libUVC.uvc_get_zoom_abs(
        device.devhPtr,
        focalLengthPtr,
        requestCode.ffiValue,
      );
      if (err != ffi.uvc_error.UVC_SUCCESS) {
        ffi.libUVC.uvc_perror(
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
    final err = ffi.libUVC.uvc_set_zoom_abs(
      device.devhPtr,
      focalLength,
    );
    if (err != ffi.uvc_error.UVC_SUCCESS) {
      ffi.libUVC.uvc_perror(
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
    return ffi.using((arena) {
      final zoomRelativePtr = arena<ffi.Int8>();
      final digitalZoomPtr = arena<ffi.Uint8>();
      final speedPtr = arena<ffi.Uint8>();
      var err = ffi.libUVC.uvc_get_zoom_rel(
        device.devhPtr,
        zoomRelativePtr,
        digitalZoomPtr,
        speedPtr,
        requestCode.ffiValue,
      );
      if (err != ffi.uvc_error.UVC_SUCCESS) {
        ffi.libUVC.uvc_perror(
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
    final err = ffi.libUVC.uvc_set_zoom_rel(
      device.devhPtr,
      zoomRelative,
      digitalZoom,
      speed,
    );
    if (err != ffi.uvc_error.UVC_SUCCESS) {
      ffi.libUVC.uvc_perror(
        err,
        'uvc_set_zoom_rel'.toNativeUtf8().cast(),
      );
      throw UVCError('setZoomRelative failed, $err');
    }
  }

  @override
  UVCFrameImpl mjpeg2RGB(UVCFrame frame) {
    if (frame is! UVCFrameImpl) {
      throw TypeError();
    }
    final outPtr =
        ffi.libUVC.uvc_allocate_frame(frame.width * frame.height * 3);
    final err = ffi.libUVC.uvc_mjpeg2rgb(frame.framePtr, outPtr);
    if (err != ffi.uvc_error.UVC_SUCCESS) {
      ffi.libUVC.uvc_free_frame(outPtr);
      ffi.libUVC.uvc_perror(
        err,
        'uvc_mjpeg2rgb'.toNativeUtf8().cast(),
      );
      throw UVCError('mjpeg2RGB failed, $err');
    }
    return UVCFrameImpl(outPtr);
  }

  @override
  UVCFrameImpl mjpeg2Gray(UVCFrame frame) {
    if (frame is! UVCFrameImpl) {
      throw TypeError();
    }
    final outPtr =
        ffi.libUVC.uvc_allocate_frame(frame.width * frame.height * 3);
    final err = ffi.libUVC.uvc_mjpeg2gray(frame.framePtr, outPtr);
    if (err != ffi.uvc_error.UVC_SUCCESS) {
      ffi.libUVC.uvc_free_frame(outPtr);
      ffi.libUVC.uvc_perror(
        err,
        'uvc_mjpeg2gray'.toNativeUtf8().cast(),
      );
      throw UVCError('mjpeg2Gray failed, $err');
    }
    return UVCFrameImpl(outPtr);
  }

  @override
  UVCFrameImpl yuyv2RGB(UVCFrame frame) {
    if (frame is! UVCFrameImpl) {
      throw TypeError();
    }
    final outPtr =
        ffi.libUVC.uvc_allocate_frame(frame.width * frame.height * 3);
    final err = ffi.libUVC.uvc_yuyv2rgb(frame.framePtr, outPtr);
    if (err != ffi.uvc_error.UVC_SUCCESS) {
      ffi.libUVC.uvc_free_frame(outPtr);
      ffi.libUVC.uvc_perror(
        err,
        'uvc_yuyv2rgb'.toNativeUtf8().cast(),
      );
      throw UVCError('yuyv2RGB failed, $err');
    }
    return UVCFrameImpl(outPtr);
  }

  @override
  UVCFrameImpl yuyv2BGR(UVCFrame frame) {
    if (frame is! UVCFrameImpl) {
      throw TypeError();
    }
    final outPtr =
        ffi.libUVC.uvc_allocate_frame(frame.width * frame.height * 3);
    final err = ffi.libUVC.uvc_yuyv2bgr(frame.framePtr, outPtr);
    if (err != ffi.uvc_error.UVC_SUCCESS) {
      ffi.libUVC.uvc_free_frame(outPtr);
      ffi.libUVC.uvc_perror(
        err,
        'uvc_yuyv2bgr'.toNativeUtf8().cast(),
      );
      throw UVCError('yuyv2BGR failed, $err');
    }
    return UVCFrameImpl(outPtr);
  }

  @override
  UVCFrameImpl yuyv2Y(UVCFrame frame) {
    if (frame is! UVCFrameImpl) {
      throw TypeError();
    }
    final outPtr = ffi.libUVC.uvc_allocate_frame(frame.width * frame.height);
    final err = ffi.libUVC.uvc_yuyv2y(frame.framePtr, outPtr);
    if (err != ffi.uvc_error.UVC_SUCCESS) {
      ffi.libUVC.uvc_free_frame(outPtr);
      ffi.libUVC.uvc_perror(
        err,
        'uvc_yuyv2y'.toNativeUtf8().cast(),
      );
      throw UVCError('yuyv2Y failed, $err');
    }
    return UVCFrameImpl(outPtr);
  }

  @override
  UVCFrameImpl yuyv2UV(UVCFrame frame) {
    if (frame is! UVCFrameImpl) {
      throw TypeError();
    }
    final outPtr =
        ffi.libUVC.uvc_allocate_frame(frame.width * frame.height * 2);
    final err = ffi.libUVC.uvc_yuyv2uv(frame.framePtr, outPtr);
    if (err != ffi.uvc_error.UVC_SUCCESS) {
      ffi.libUVC.uvc_free_frame(outPtr);
      ffi.libUVC.uvc_perror(
        err,
        'uvc_yuyv2uv'.toNativeUtf8().cast(),
      );
      throw UVCError('yuyv2UV failed, $err');
    }
    return UVCFrameImpl(outPtr);
  }

  @override
  UVCFrameImpl uyvy2RGB(UVCFrame frame) {
    if (frame is! UVCFrameImpl) {
      throw TypeError();
    }
    final outPtr =
        ffi.libUVC.uvc_allocate_frame(frame.width * frame.height * 3);
    final err = ffi.libUVC.uvc_uyvy2rgb(frame.framePtr, outPtr);
    if (err != ffi.uvc_error.UVC_SUCCESS) {
      ffi.libUVC.uvc_free_frame(outPtr);
      ffi.libUVC.uvc_perror(
        err,
        'uvc_uyvy2rgb'.toNativeUtf8().cast(),
      );
      throw UVCError('uyvy2RGB failed, $err');
    }
    return UVCFrameImpl(outPtr);
  }

  @override
  UVCFrameImpl uyvy2BGR(UVCFrame frame) {
    if (frame is! UVCFrameImpl) {
      throw TypeError();
    }
    final outPtr =
        ffi.libUVC.uvc_allocate_frame(frame.width * frame.height * 3);
    final err = ffi.libUVC.uvc_uyvy2bgr(frame.framePtr, outPtr);
    if (err != ffi.uvc_error.UVC_SUCCESS) {
      ffi.libUVC.uvc_free_frame(outPtr);
      ffi.libUVC.uvc_perror(
        err,
        'uvc_uyvy2bgr'.toNativeUtf8().cast(),
      );
      throw UVCError('uyvy2BGR failed, $err');
    }
    return UVCFrameImpl(outPtr);
  }

  @override
  UVCFrameImpl any2RGB(UVCFrame frame) {
    if (frame is! UVCFrameImpl) {
      throw TypeError();
    }
    final outPtr =
        ffi.libUVC.uvc_allocate_frame(frame.width * frame.height * 3);
    final err = ffi.libUVC.uvc_any2rgb(frame.framePtr, outPtr);
    if (err != ffi.uvc_error.UVC_SUCCESS) {
      ffi.libUVC.uvc_free_frame(outPtr);
      ffi.libUVC.uvc_perror(
        err,
        'uvc_any2rgb'.toNativeUtf8().cast(),
      );
      throw UVCError('any2RGB failed, $err');
    }
    return UVCFrameImpl(outPtr);
  }

  @override
  UVCFrameImpl any2BGR(UVCFrame frame) {
    if (frame is! UVCFrameImpl) {
      throw TypeError();
    }
    final outPtr =
        ffi.libUVC.uvc_allocate_frame(frame.width * frame.height * 3);
    final err = ffi.libUVC.uvc_any2bgr(frame.framePtr, outPtr);
    if (err != ffi.uvc_error.UVC_SUCCESS) {
      ffi.libUVC.uvc_free_frame(outPtr);
      ffi.libUVC.uvc_perror(
        err,
        'uvc_any2bgr'.toNativeUtf8().cast(),
      );
      throw UVCError('any2BGR failed, $err');
    }
    return UVCFrameImpl(outPtr);
  }
}

final class UVCDeviceImpl implements UVCDevice {
  final ffi.Pointer<ffi.uvc_device> devPtr;

  ffi.Pointer<ffi.uvc_device_handle>? _devhPtr;
  ffi.NativeCallable<
      ffi.Void Function(ffi.Pointer<ffi.uvc_frame> framePtr,
          ffi.Pointer<ffi.Void> userPtr)>? _cbPtr;

  ffi.Pointer<ffi.uvc_device_handle> get devhPtr {
    final devhPtr = _devhPtr;
    if (devhPtr == null) {
      throw UVCError('devhPtr is null.');
    }
    return devhPtr;
  }

  set devhPtr(ffi.Pointer<ffi.uvc_device_handle> value) {
    _devhPtr = value;
  }

  ffi.NativeCallable<
      ffi.Void Function(ffi.Pointer<ffi.uvc_frame> framePtr,
          ffi.Pointer<ffi.Void> userPtr)> get cbPtr {
    final cbPtr = _cbPtr;
    if (cbPtr == null) {
      throw UVCError('cbPtr is null.');
    }
    return cbPtr;
  }

  set cbPtr(
      ffi.NativeCallable<
              ffi.Void Function(ffi.Pointer<ffi.uvc_frame> framePtr,
                  ffi.Pointer<ffi.Void> userPtr)>
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

  factory UVCDeviceDescriptorImpl.ffi(ffi.uvc_device_descriptor desc) {
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

  factory UVCFormatDescriptorImpl.ffi(ffi.uvc_format_desc desc) {
    final frameDescriptorImpls = <UVCFrameDescriptorImpl>[];
    var frameDescPtr = desc.frame_descs;
    while (frameDescPtr != ffi.nullptr) {
      final frameDesc = frameDescPtr.ref;
      final frameDescriptorImpl = UVCFrameDescriptorImpl.ffi(frameDesc);
      frameDescriptorImpls.add(frameDescriptorImpl);
      frameDescPtr = frameDesc.next;
    }
    final stillFrameDescriptorImpls = <UVCStillFrameDescriptorImpl>[];
    var stillFrameDescPtr = desc.still_frame_desc;
    while (stillFrameDescPtr != ffi.nullptr) {
      final stillFrameDesc = stillFrameDescPtr.ref;
      final stillFrameDescriptorImpl =
          UVCStillFrameDescriptorImpl.ffi(stillFrameDesc);
      stillFrameDescriptorImpls.add(stillFrameDescriptorImpl);
      stillFrameDescPtr = stillFrameDesc.next;
    }
    return UVCFormatDescriptorImpl(
      subtype:
          ffi.uvc_vs_desc_subtype.fromValue(desc.bDescriptorSubtype).dartValue,
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

  factory UVCFormatSpecifierImpl.ffi(ffi.UnnamedUnion1 unnamed) {
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

  factory UVCFormatSpecificDataImpl.ffi(ffi.UnnamedUnion2 unnamed) {
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

  factory UVCFrameDescriptorImpl.ffi(ffi.uvc_frame_desc desc) {
    return UVCFrameDescriptorImpl(
      subtype:
          ffi.uvc_vs_desc_subtype.fromValue(desc.bDescriptorSubtype).dartValue,
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

  factory UVCStillFrameDescriptorImpl.ffi(ffi.uvc_still_frame_desc desc) {
    final imageSizePatternImpls = <UVCStillFrameResolutionImpl>[];
    var imageSizePatternPtr = desc.imageSizePatterns;
    while (imageSizePatternPtr != ffi.nullptr) {
      final imageSizePattern = imageSizePatternPtr.ref;
      final imageSizePatternImpl =
          UVCStillFrameResolutionImpl.ffi(imageSizePattern);
      imageSizePatternImpls.add(imageSizePatternImpl);
      imageSizePatternPtr = imageSizePattern.next;
    }
    return UVCStillFrameDescriptorImpl(
      subtype:
          ffi.uvc_vs_desc_subtype.fromValue(desc.bDescriptorSubtype).dartValue,
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

  factory UVCStillFrameResolutionImpl.ffi(ffi.uvc_still_frame_res res) {
    return UVCStillFrameResolutionImpl(
      index: res.bResolutionIndex,
      width: res.wWidth,
      height: res.wHeight,
    );
  }
}

final class UVCStreamControlImpl implements UVCStreamControl {
  final ffi.Pointer<ffi.uvc_stream_ctrl> ctrlPtr;

  UVCStreamControlImpl(this.ctrlPtr);
}

final class UVCFrameImpl implements UVCFrame {
  final ffi.Pointer<ffi.uvc_frame> framePtr;

  UVCFrameImpl(this.framePtr);

  ffi.uvc_frame get frame => framePtr.ref;

  @override
  Uint8List get data =>
      frame.data.cast<ffi.Uint8>().asTypedList(frame.data_bytes);
  @override
  int get width => frame.width;
  @override
  int get height => frame.height;
  @override
  UVCFrameFormat get format =>
      ffi.uvc_frame_format.fromValue(frame.frame_format).dartValue;
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
      frame.metadata.cast<ffi.Uint8>().asTypedList(frame.metadata_bytes);
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

  factory UVCInputTerminalImpl.ffi(ffi.uvc_input_terminal terminal) {
    return UVCInputTerminalImpl(
      id: terminal.bTerminalID,
      type: ffi.uvc_it_type.fromValue(terminal.wTerminalType).dartValue,
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
