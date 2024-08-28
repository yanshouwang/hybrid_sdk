import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';

import 'package:ffi/ffi.dart';
import 'package:flutter/services.dart';
import 'package:hybrid_logging/hybrid_logging.dart';
import 'package:logging/logging.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'libuvc.g.dart';
import 'uvc.dart';
import 'uvc_error.dart';

const String _libName = 'uvc';

/// The dynamic library in which the symbols for [HybridUvcBindings] can be found.
final DynamicLibrary _dynamicLibrary = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

/// The bindings to the native functions in [_dynamicLibrary].
final LibUVC _libUVC = LibUVC(_dynamicLibrary);

abstract base class HybridUVC extends PlatformInterface
    implements UVC, LogController {
  /// Constructs a [HybridUVC].
  HybridUVC() : super(token: _token);

  static final Object _token = Object();

  static HybridUVC? _instance = _HybridUVC();

  /// The default instance of [HybridUVC] to use.
  static HybridUVC get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError(
          'HybridUVC is not implemented on this platform.');
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HybridUVC] when
  /// they register themselves.
  static set instance(HybridUVC instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}

final class _HybridUVC extends HybridUVC with TypeLogger, LoggerController {
  @override
  void initialize(UVCFrameCallback frameCallback) {
    final err = using((arena) {
      final ctxPtr = arena<Pointer<uvc_context>>();
      // Initialize a UVC service context. Libuvc will set up its own libusb
      // context. Replace NULL with a libusb_context pointer to run libuvc
      // from an existing libusb context.
      var err = _libUVC.uvc_init(ctxPtr, nullptr);
      if (err != uvc_error.UVC_SUCCESS) {
        final msg = 'uvc_init'.toNativeUtf8().cast<Char>();
        _libUVC.uvc_perror(err, msg);
        return err;
      }
      logger.info('UVC initialized');
      final ctx = ctxPtr.value;
      final devPtr = arena<Pointer<uvc_device>>();
      // Locates the first attached UVC device, stores in dev
      //
      // filter devices: vendor_id, product_id, "serial_num"
      err = _libUVC.uvc_find_device(ctx, devPtr, 0, 0, nullptr);
      if (err != uvc_error.UVC_SUCCESS) {
        // no devices found
        final msg = 'uvc_find_device'.toNativeUtf8().cast<Char>();
        _libUVC.uvc_perror(err, msg);
        return err;
      }
      logger.info('Device found');
      final dev = devPtr.value;
      final devhPtr = arena<Pointer<uvc_device_handle>>();
      // Try to open the device: requires exclusive access
      err = _libUVC.uvc_open(dev, devhPtr);
      if (err != uvc_error.UVC_SUCCESS) {
        // unable to open device
        final msg = 'uvc_open'.toNativeUtf8().cast<Char>();
        _libUVC.uvc_perror(err, msg);
        return err;
      }
      logger.info('Device opened');
      final devh = devhPtr.value;
      // Print out a message containing all the information that libuvc
      // knows about the device
      // _libUVC.uvc_print_diag(devh, stderr);
      final format_desc = _libUVC.uvc_get_format_descs(devh).ref;
      final des_sub_type =
          uvc_vs_desc_subtype.fromValue(format_desc.bDescriptorSubtype);
      final uvc_frame_format frame_format;
      switch (des_sub_type) {
        case uvc_vs_desc_subtype.UVC_VS_FORMAT_MJPEG:
          frame_format = uvc_frame_format.UVC_FRAME_FORMAT_MJPEG;
          break;
        case uvc_vs_desc_subtype.UVC_VS_FORMAT_FRAME_BASED:
          frame_format = uvc_frame_format.UVC_FRAME_FORMAT_H264;
          break;
        default:
          frame_format = uvc_frame_format.UVC_FRAME_FORMAT_YUYV;
          break;
      }
      final frame_desc = format_desc.frame_descs.ref;
      final width = frame_desc.wWidth;
      final height = frame_desc.wHeight;
      final fps = 10 * 1000 * 1000 ~/ frame_desc.dwDefaultFrameInterval;
      logger.info(
          '\nFirst format: (${format_desc.unnamed.fourccFormat}) ${width}x$height ${fps}fps\n');
      final ctrl = arena<uvc_stream_ctrl>();
      // Try to negotiate first stream profile
      err = _libUVC.uvc_get_stream_ctrl_format_size(
          devh, ctrl, frame_format, width, height, fps);
      // Print out the result
      // _libUVC.uvc_print_stream_ctrl(ctrl, stderr);
      if (err != uvc_error.UVC_SUCCESS) {
        final msg = 'get_mode'.toNativeUtf8().cast<Char>();
        _libUVC.uvc_perror(err, msg);
        return err;
      }
      // Start the video stream. The library will call user function cb:
      //   cb(frame, (void *) 12345)
      void callback(
          Pointer<uvc_frame> framePtr, Pointer<void> formatPtr) async {
        if (_any2RGBACompleter != null) {
          return;
        }
        final completer = Completer<UVCFrame>();
        _any2RGBACompleter = completer;
        try {
          final sendPort = await _isolateSendPort;
          final command = _Any2RGBACommand(
            framePtr: framePtr,
            formatPtr: formatPtr,
          );
          sendPort.send(command);
          final frame = await completer.future;
          frameCallback(frame);
        } catch (e) {
          logger.warning(e);
        } finally {
          _any2RGBACompleter = null;
        }
      }

      final nativeCallback =
          NativeCallable<NativeUVCCallback>.listener(callback);
      final user_ptr = Pointer.fromAddress(12345).cast<Void>();
      err = _libUVC.uvc_start_streaming(
          devh, ctrl, nativeCallback.nativeFunction, user_ptr, 0);
      if (err != uvc_error.UVC_SUCCESS) {
        final msg = 'start_streaming'.toNativeUtf8().cast<Char>();
        _libUVC.uvc_perror(err, msg);
      }
      logger.info('Streaming...');
      return err;
    });
    if (err != uvc_error.UVC_SUCCESS) {
      throw err;
    }
  }
}

typedef UVCCallback = void Function(Pointer<uvc_frame>, Pointer<Void>);
typedef NativeUVCCallback = Void Function(Pointer<uvc_frame>, Pointer<Void>);

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
  final Pointer<void> formatPtr;

  _Any2RGBACommand({
    required this.framePtr,
    required this.formatPtr,
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

/// The SendPort belonging to the helper isolate.
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
      final logger = Logger('hybrid_uvc');
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
                final formatPtr = message.formatPtr;
                final frame = framePtr.ref;
                final rgbPtr =
                    _libUVC.uvc_allocate_frame(frame.width * frame.height * 3);
                if (rgbPtr == nullptr) {
                  throw UVCError('Unable to allocate RBG frame!');
                }
                logger.info(
                    'callback! frame_format = ${frame.frame_format}, width = ${frame.width}, height = ${frame.height}, length = ${frame.data_bytes}, ptr = $formatPtr\n');
                final frame_format =
                    uvc_frame_format.fromValue(frame.frame_format);
                switch (frame_format) {
                  case uvc_frame_format.UVC_FRAME_FORMAT_H264:
                  case uvc_frame_format.UVC_FRAME_FORMAT_MJPEG:
                  case uvc_frame_format.UVC_FRAME_FORMAT_YUYV:
                    final err = _libUVC.uvc_any2rgb(framePtr, rgbPtr);
                    if (err != uvc_error.UVC_SUCCESS) {
                      final msg = 'uvc_any2rgb'.toNativeUtf8().cast<Char>();
                      _libUVC.uvc_perror(err, msg);
                      _libUVC.uvc_free_frame(rgbPtr);
                      throw UVCError('uvc_any2rgb failed, $err');
                    }
                    break;
                  default:
                    throw UVCError('Unknown frame format $frame_format.');
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
