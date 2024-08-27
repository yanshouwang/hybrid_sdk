import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:hybrid_logging/hybrid_logging.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'libuvc.g.dart';
import 'uvc.dart';

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
      void callback(Pointer<uvc_frame> framePtr, Pointer<void> formatPtr) {
        final frame = framePtr.ref;
        final rgbPtr =
            _libUVC.uvc_allocate_frame(frame.width * frame.height * 3);
        if (rgbPtr == nullptr) {
          logger.info('unable to allocate bgr frame!\n');
          return;
        }
        logger.info(
            'callback! frame_format = ${frame.frame_format}, width = ${frame.width}, height = ${frame.height}, length = ${frame.data_bytes}, ptr = $formatPtr\n');
        final frame_format = uvc_frame_format.fromValue(frame.frame_format);
        switch (frame_format) {
          case uvc_frame_format.UVC_FRAME_FORMAT_H264:
          case uvc_frame_format.UVC_FRAME_FORMAT_MJPEG:
          case uvc_frame_format.UVC_FRAME_FORMAT_YUYV:
            final err = _libUVC.uvc_any2rgb(framePtr, rgbPtr);
            if (err != uvc_error.UVC_SUCCESS) {
              final msg = 'uvc_any2rgb'.toNativeUtf8().cast<Char>();
              _libUVC.uvc_perror(err, msg);
              _libUVC.uvc_free_frame(rgbPtr);
              return;
            }
            break;
          default:
            break;
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
          try {
            value.setRange(start, end, data, skipCount);
            value[end] = 0xff;
          } catch (e) {
            logger.shout(
                'i=$i, start=$start, end=$end, skipCount=$skipCount\n$e');
          }
        }
        final item = UVCFrame(width, height, value);
        frameCallback(item);
      }

      final cb = NativeCallable<NativeUVCCallback>.listener(callback);
      final user_ptr = Pointer.fromAddress(12345).cast<Void>();
      err = _libUVC.uvc_start_streaming(
          devh, ctrl, cb.nativeFunction, user_ptr, 0);
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
