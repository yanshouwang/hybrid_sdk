import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:hybrid_usb/hybrid_usb.dart';
import 'package:hybrid_uvc/src/uvc_input_terminal.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ffi.dart';
import 'uvc.dart';
import 'uvc_device.dart';
import 'uvc_device_descriptor.dart';
import 'uvc_error.dart';
import 'uvc_format_descriptor.dart';
import 'uvc_frame.dart';
import 'uvc_frame_format.dart';
import 'uvc_stream_control.dart';
import 'uvc_zoom_absolute.dart';
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

abstract base class HybridUVCPlugin extends PlatformInterface implements UVC {
  /// Constructs a [HybridUVCPlugin].
  HybridUVCPlugin() : super(token: _token);

  static final Object _token = Object();

  static HybridUVCPlugin _instance = _HybridUVCPlugin();

  /// The default instance of [HybridUVCPlugin] to use.
  static HybridUVCPlugin get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HybridUVCPlugin] when
  /// they register themselves.
  static set instance(HybridUVCPlugin instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}

// TODO: free native resources when finalize.
final class _HybridUVCPlugin extends HybridUVCPlugin {
  final USB _usb;
  Pointer<uvc_context>? _ctxPtr;

  _HybridUVCPlugin() : _usb = USB() {
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
        throw UVCError('init failed, $err');
      }
      final ctxPtr = ctxPtr2.value;
      return ctxPtr;
    });
  }

  void exit() {
    _libUVC.uvc_exit(ctxPtr);
  }

  @override
  List<UVCDevice> findDevices({
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
      final devices = <UVCDevice>[];
      final devsPtr = devsPtr2.value;
      var i = 0;
      while (true) {
        final devPtr = devsPtr[i];
        if (devPtr == nullptr) {
          break;
        }
        final device = _UVCDevice(devPtr);
        devices.add(device);
      }
      return devices;
    });
  }

  @override
  UVCDevice findDevice({
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
      final device = _UVCDevice(devPtr);
      return device;
    });
  }

  @override
  UVCDeviceDescriptor getDeviceDescriptor(UVCDevice device) {
    if (device is! _UVCDevice) {
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
      return desc.dartValue;
    });
  }

  @override
  void open(UVCDevice device) {
    if (device is! _UVCDevice) {
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
    if (device is! _UVCDevice) {
      throw TypeError();
    }
    _libUVC.uvc_close(device.devhPtr);
  }

  @override
  List<UVCFormatDescriptor> getFormatDescriptors(UVCDevice device) {
    if (device is! _UVCDevice) {
      throw TypeError();
    }
    final formatDescriptors = <UVCFormatDescriptor>[];
    var formatDescPtr = _libUVC.uvc_get_format_descs(device.devhPtr);
    while (formatDescPtr != nullptr) {
      final formatDesc = formatDescPtr.ref;
      formatDescriptors.add(formatDesc.dartValue);
      formatDescPtr = formatDesc.next;
    }
    return formatDescriptors;
  }

  @override
  UVCStreamControl getStreamControl(
    UVCDevice device, {
    required UVCFrameFormat format,
    required int width,
    required int height,
    required int fps,
  }) {
    if (device is! _UVCDevice) {
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
    return _UVCStreamControl(ctrlPtr);
  }

  @override
  void startStreaming(
    UVCDevice device, {
    required UVCStreamControl control,
    required UVCFrameCallback callback,
  }) {
    if (device is! _UVCDevice || control is! _UVCStreamControl) {
      throw TypeError();
    }
    device.cbPtr = using((arena) {
      void cb(Pointer<uvc_frame> framePtr, Pointer<void> formatPtr) async {
        if (_any2RGBACompleter != null) {
          return;
        }
        final completer = Completer<UVCFrame>();
        _any2RGBACompleter = completer;
        try {
          final sendPort = await _isolateSendPort;
          final command = _Any2RGBACommand(
            framePtr: framePtr,
            userPtr: formatPtr,
          );
          sendPort.send(command);
          final frame = await completer.future;
          callback(frame);
        } finally {
          _any2RGBACompleter = null;
        }
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
    if (device is! _UVCDevice) {
      throw TypeError();
    }
    _libUVC.uvc_stop_streaming(device.devhPtr);
    device.cbPtr.close();
  }

  @override
  List<UVCInputTerminal> getInputTerminals(UVCDevice device) {
    if (device is! _UVCDevice) {
      throw TypeError();
    }
    final inputTerminals = <UVCInputTerminal>[];
    var inputTerminalPtr = _libUVC.uvc_get_input_terminals(device.devhPtr);
    while (inputTerminalPtr != nullptr) {
      final inputTerminal = inputTerminalPtr.ref;
      inputTerminals.add(inputTerminal.dartValue);
      inputTerminalPtr = inputTerminal.next;
    }
    return inputTerminals;
  }

  @override
  UVCZoomAbsolute getZoomAbsolute(UVCDevice device) {
    if (device is! _UVCDevice) {
      throw TypeError();
    }
    return using((arena) {
      final minimumPtr = arena<Uint16>();
      var err = _libUVC.uvc_get_zoom_abs(
        device.devhPtr,
        minimumPtr,
        uvc_req_code.UVC_GET_MIN,
      );
      if (err != uvc_error.UVC_SUCCESS) {
        _libUVC.uvc_perror(
          err,
          'uvc_get_zoom_abs'.toNativeUtf8().cast(),
        );
        throw UVCError('getZoomAbsolute failed, $err.');
      }
      final maximumPtr = arena<Uint16>();
      err = _libUVC.uvc_get_zoom_abs(
        device.devhPtr,
        maximumPtr,
        uvc_req_code.UVC_GET_MAX,
      );
      if (err != uvc_error.UVC_SUCCESS) {
        _libUVC.uvc_perror(
          err,
          'uvc_get_zoom_abs'.toNativeUtf8().cast(),
        );
        throw UVCError('getZoomAbsolute failed, $err.');
      }
      final resolutionPtr = arena<Uint16>();
      err = _libUVC.uvc_get_zoom_abs(
        device.devhPtr,
        resolutionPtr,
        uvc_req_code.UVC_GET_RES,
      );
      if (err != uvc_error.UVC_SUCCESS) {
        _libUVC.uvc_perror(
          err,
          'uvc_get_zoom_abs'.toNativeUtf8().cast(),
        );
        throw UVCError('getZoomAbsolute failed, $err.');
      }
      final undefinedPtr = arena<Uint16>();
      err = _libUVC.uvc_get_zoom_abs(
        device.devhPtr,
        undefinedPtr,
        uvc_req_code.UVC_GET_DEF,
      );
      if (err != uvc_error.UVC_SUCCESS) {
        _libUVC.uvc_perror(
          err,
          'uvc_get_zoom_abs'.toNativeUtf8().cast(),
        );
        throw UVCError('getZoomAbsolute failed, $err.');
      }
      final currentPtr = arena<Uint16>();
      err = _libUVC.uvc_get_zoom_abs(
        device.devhPtr,
        currentPtr,
        uvc_req_code.UVC_GET_CUR,
      );
      if (err != uvc_error.UVC_SUCCESS) {
        _libUVC.uvc_perror(
          err,
          'uvc_get_zoom_abs'.toNativeUtf8().cast(),
        );
        throw UVCError('getZoomAbsolute failed, $err.');
      }
      return UVCZoomAbsolute(
        minimum: minimumPtr.value,
        maximum: maximumPtr.value,
        resolution: resolutionPtr.value,
        undefined: undefinedPtr.value,
        current: currentPtr.value,
      );
    });
  }

  @override
  void setZoomAbsolute(
    UVCDevice device, {
    required int focalLength,
  }) {
    if (device is! _UVCDevice) {
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
  UVCZoomRelative getZoomRelative(UVCDevice device) {
    if (device is! _UVCDevice) {
      throw TypeError();
    }
    return using((arena) {
      final directionPtr = arena<Int8>();
      final digitalZoomPtr = arena<Uint8>();
      final minimumSpeedPtr = arena<Uint8>();
      var err = _libUVC.uvc_get_zoom_rel(
        device.devhPtr,
        directionPtr,
        digitalZoomPtr,
        minimumSpeedPtr,
        uvc_req_code.UVC_GET_MIN,
      );
      if (err != uvc_error.UVC_SUCCESS) {
        _libUVC.uvc_perror(
          err,
          'uvc_get_zoom_rel'.toNativeUtf8().cast(),
        );
        throw UVCError('getZoomRelative failed, $err.');
      }
      final maximumSpeedPtr = arena<Uint8>();
      err = _libUVC.uvc_get_zoom_rel(
        device.devhPtr,
        directionPtr,
        digitalZoomPtr,
        maximumSpeedPtr,
        uvc_req_code.UVC_GET_MAX,
      );
      if (err != uvc_error.UVC_SUCCESS) {
        _libUVC.uvc_perror(
          err,
          'uvc_get_zoom_rel'.toNativeUtf8().cast(),
        );
        throw UVCError('getZoomRelative failed, $err.');
      }
      final resolutionSpeedPtr = arena<Uint8>();
      err = _libUVC.uvc_get_zoom_rel(
        device.devhPtr,
        directionPtr,
        digitalZoomPtr,
        resolutionSpeedPtr,
        uvc_req_code.UVC_GET_RES,
      );
      if (err != uvc_error.UVC_SUCCESS) {
        _libUVC.uvc_perror(
          err,
          'uvc_get_zoom_rel'.toNativeUtf8().cast(),
        );
        throw UVCError('getZoomRelative failed, $err.');
      }
      final undefinedSpeedPtr = arena<Uint8>();
      err = _libUVC.uvc_get_zoom_rel(
        device.devhPtr,
        directionPtr,
        digitalZoomPtr,
        undefinedSpeedPtr,
        uvc_req_code.UVC_GET_DEF,
      );
      if (err != uvc_error.UVC_SUCCESS) {
        _libUVC.uvc_perror(
          err,
          'uvc_get_zoom_rel'.toNativeUtf8().cast(),
        );
        throw UVCError('getZoomRelative failed, $err.');
      }
      final currentSpeedPtr = arena<Uint8>();
      err = _libUVC.uvc_get_zoom_rel(
        device.devhPtr,
        directionPtr,
        digitalZoomPtr,
        currentSpeedPtr,
        uvc_req_code.UVC_GET_CUR,
      );
      if (err != uvc_error.UVC_SUCCESS) {
        _libUVC.uvc_perror(
          err,
          'uvc_get_zoom_rel'.toNativeUtf8().cast(),
        );
        throw UVCError('getZoomRelative failed, $err.');
      }
      return UVCZoomRelative(
        direction: directionPtr.value,
        digitalZoom: digitalZoomPtr.value,
        minimumSpeed: minimumSpeedPtr.value,
        maximumSpeed: maximumSpeedPtr.value,
        resolutionSpeed: resolutionSpeedPtr.value,
        undefinedSpeed: undefinedSpeedPtr.value,
        currentSpeed: currentSpeedPtr.value,
      );
    });
  }

  @override
  void setZoomRelative(
    UVCDevice device, {
    required int direction,
    required int digitalZoom,
    required int speed,
  }) {
    if (device is! _UVCDevice) {
      throw TypeError();
    }
    final err = _libUVC.uvc_set_zoom_rel(
      device.devhPtr,
      direction,
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
  UVCFrame any2BGR(UVCFrame frame) {
    // TODO: implement any2BGR
    throw UnimplementedError();
  }

  @override
  UVCFrame any2RGB(UVCFrame frame) {
    // TODO: implement any2RGB
    throw UnimplementedError();
  }

  @override
  UVCFrame mjpeg2Gray(UVCFrame frame) {
    // TODO: implement mjpeg2Gray
    throw UnimplementedError();
  }

  @override
  UVCFrame mjpeg2RGB(UVCFrame frame) {
    // TODO: implement mjpeg2RGB
    throw UnimplementedError();
  }

  @override
  UVCFrame uyvy2BGR(UVCFrame frame) {
    // TODO: implement uyvy2BGR
    throw UnimplementedError();
  }

  @override
  UVCFrame uyvy2RGB(UVCFrame frame) {
    // TODO: implement uyvy2RGB
    throw UnimplementedError();
  }

  @override
  UVCFrame yuyv2BGR(UVCFrame frame) {
    // TODO: implement yuyv2BGR
    throw UnimplementedError();
  }

  @override
  UVCFrame yuyv2RGB(UVCFrame frame) {
    // TODO: implement yuyv2RGB
    throw UnimplementedError();
  }

  @override
  UVCFrame yuyv2UV(UVCFrame frame) {
    // TODO: implement yuyv2UV
    throw UnimplementedError();
  }

  @override
  UVCFrame yuyv2Y(UVCFrame frame) {
    // TODO: implement yuyv2Y
    throw UnimplementedError();
  }
}

// TODO: free native resources when finalize.
final class _UVCDevice implements UVCDevice {
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

  _UVCDevice(this.devPtr);
}

// TODO: free native resources when finalize.
final class _UVCStreamControl implements UVCStreamControl {
  final Pointer<uvc_stream_ctrl> ctrlPtr;

  _UVCStreamControl(this.ctrlPtr);
}

class _IsolateMessage {
  final SendPort sendPort;
  final RootIsolateToken token;

  _IsolateMessage({
    required this.sendPort,
    required this.token,
  });
}

class _Any2RGBACommand {
  final Pointer<uvc_frame> framePtr;
  final Pointer<void> userPtr;

  _Any2RGBACommand({
    required this.framePtr,
    required this.userPtr,
  });
}

class _Any2RGBAReply {
  final int width;
  final int height;
  final Uint8List value;
  final Object? error;

  _Any2RGBAReply({
    required this.width,
    required this.height,
    required this.value,
    this.error,
  });
}

Completer<UVCFrame>? _any2RGBACompleter;

Future<SendPort> _isolateSendPort = () async {
  // The helper isolate is going to send us back a SendPort, which we want to
  // wait for.
  final completer = Completer<SendPort>();

  // Receive port on the main isolate to receive messages from the helper.
  // We receive two types of messages:
  // 1. A port to send messages on.
  // 2. Responses to requests we sent.
  final receivePort = ReceivePort()
    ..listen(
      (message) {
        if (message is SendPort) {
          // The helper isolate sent us the port on which we can sent it requests.
          completer.complete(message);
        } else if (message is _Any2RGBAReply) {
          final completer = _any2RGBACompleter;
          if (completer == null) {
            return;
          }
          final error = message.error;
          if (error == null) {
            final frame =
                UVCFrame(message.width, message.height, message.value);
            completer.complete(frame);
          } else {
            completer.completeError(error);
          }
        } else {
          throw UnsupportedError(
            'Unsupported message type: ${message.runtimeType}',
          );
        }
      },
    );

  // Start the helper isolate.
  await Isolate.spawn(
    (message) {
      final sendPort = message.sendPort;
      final token = message.token;
      // Register the background isolate with the root isolate.
      BackgroundIsolateBinaryMessenger.ensureInitialized(token);
      final isolatePort = ReceivePort()
        ..listen(
          (message) async {
            // On the isolate listen to requests and respond to them.
            if (message is _Any2RGBACommand) {
              try {
                final framePtr = message.framePtr;
                final frame = framePtr.ref;
                final rgbPtr =
                    _libUVC.uvc_allocate_frame(frame.width * frame.height * 3);
                if (rgbPtr == nullptr) {
                  throw UVCError('Unable to allocate RBG frame!');
                }
                final format = uvc_frame_format.fromValue(frame.frame_format);
                switch (format) {
                  case uvc_frame_format.UVC_FRAME_FORMAT_H264:
                  case uvc_frame_format.UVC_FRAME_FORMAT_MJPEG:
                  case uvc_frame_format.UVC_FRAME_FORMAT_YUYV:
                    final err = _libUVC.uvc_any2rgb(framePtr, rgbPtr);
                    if (err != uvc_error.UVC_SUCCESS) {
                      _libUVC.uvc_perror(
                        err,
                        'uvc_any2rgb'.toNativeUtf8().cast(),
                      );
                      _libUVC.uvc_free_frame(rgbPtr);
                      throw UVCError('UVC any to RGB failed, $err');
                    }
                    break;
                  default:
                    throw UVCError('Unknown frame format $format.');
                }
                final rgb = rgbPtr.ref;
                final width = rgb.width;
                final height = rgb.height;
                final data = rgb.data.cast<Uint8>().asTypedList(rgb.data_bytes);
                final value = Uint8List(width * height * 4);
                for (var i = 0; i < width * height; i++) {
                  final start = i * 4;
                  final end = start + 3;
                  final skipCount = i * 3;
                  value.setRange(start, end, data, skipCount);
                  value[end] = 0xff;
                }
                final reply = _Any2RGBAReply(
                  width: width,
                  height: height,
                  value: value,
                );
                sendPort.send(reply);
              } catch (e) {
                final reply = _Any2RGBAReply(
                  width: 0,
                  height: 0,
                  value: Uint8List(0),
                  error: e,
                );
                sendPort.send(reply);
              }
            } else {
              throw UnsupportedError(
                'Unsupported message type: ${message.runtimeType}',
              );
            }
          },
        );

      // Send the port to the main isolate on which we can receive requests.
      sendPort.send(isolatePort.sendPort);
    },
    _IsolateMessage(
      sendPort: receivePort.sendPort,
      token: ArgumentError.checkNotNull(RootIsolateToken.instance),
    ),
  );

  // Wait until the helper isolate has sent us back the SendPort on which we
  // can start sending requests.
  return completer.future;
}();
