import 'dart:async';
import 'dart:io';

import 'package:clover/clover.dart';
import 'package:hybrid_logging/hybrid_logging.dart';
import 'package:hybrid_uvc/hybrid_uvc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:usb/usb.dart';

final class HomeViewModel extends ViewModel with TypeLogger {
  final UVC _uvc;
  USBDeviceConnection? _connection;
  UVCDevice? _device;
  UVCStreamControl? _control;
  UVCZoomRelative? _zoomRelative;
  UVCFrame? _frame;
  int _frames;
  int _fps;
  late final Timer _fpsTimer;

  HomeViewModel()
      : _uvc = UVC(),
        _frames = 0,
        _fps = 0 {
    _fpsTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        _fps = _frames;
        logger.info('Streaming with $_fps FPS.');
        _frames = 0;
        notifyListeners();
      },
    );
  }

  bool get streaming => _device != null && _control != null;
  UVCZoomRelative? get zoomRelative => _zoomRelative;
  UVCFrame? get frame => _frame;

  void startStreaming() async {
    if (_device != null) {
      throw StateError('Streaming.');
    }
    final UVCDevice device;
    if (Platform.isAndroid) {
      final usbManager = USBManager();
      final usbDevices = await usbManager.getDevices();
      USBDevice? usbDevice;
      for (var value in usbDevices.values) {
        final deviceClass = await value.getDeviceClass();
        if (deviceClass != USBConstants.usbClassVideo) {
          continue;
        }
        final vid = await value.getVendorId();
        final pid = await value.getProductId();
        final sn = await value.getSerialNumber();
        final manufacturer = value.getManufacturerName();
        final product = value.getProductName();
        logger.info(
            'usbDevice: VId $vid, PId $pid, SN $sn, Manufacturer $manufacturer, Product $product.');
        usbDevice = value;
        break;
      }
      if (usbDevice == null) {
        throw ArgumentError.notNull('usbDevice');
      }
      // UVC need CAMERA is authorized.
      var cameraAuthorized = await Permission.camera.isGranted;
      if (!cameraAuthorized) {
        final status = await Permission.camera.request();
        cameraAuthorized = status == PermissionStatus.granted;
      }
      if (!cameraAuthorized) {
        throw StateError('Camera is unauthorized.');
      }
      var usbAuthorized = await usbManager.hasDevicePermission(usbDevice);
      if (!usbAuthorized) {
        usbAuthorized = await usbManager.requestDevicePermission(usbDevice);
      }
      if (!usbAuthorized) {
        throw StateError('USB is unauthorized.');
      }
      final connection = await usbManager.openDevice(usbDevice);
      final fileDescriptor = await connection.getFileDescriptor();
      device = _uvc.wrap(fileDescriptor);
      _connection = connection;
    } else {
      device = _uvc.findDevice();
      final deviceDescriptor = _uvc.getDeviceDescriptor(device);
      logger.info(
          'deviceDescriptor: VId ${deviceDescriptor.vid}, PId ${deviceDescriptor.pid}, SN ${deviceDescriptor.sn}, Manufacturer ${deviceDescriptor.manufacturer}, Product ${deviceDescriptor.product}.');
      _uvc.open(device);
    }
    final formatDescriptors = _uvc.getFormatDescriptors(device);
    for (var formatDescriptor in formatDescriptors) {
      logger.info('formatDescriptor: ${formatDescriptor.subtype}');
      final frameDescriptors = formatDescriptor.frameDescriptors;
      for (var frameDescriptor in frameDescriptors) {
        final width = frameDescriptor.width;
        final height = frameDescriptor.height;
        final fps = 1000 * 1000 * 10 ~/ frameDescriptor.defaultInterval;
        logger.info('frameDescriptor: ${width}x$height, $fps fps.');
      }
    }
    final formatDescriptor = formatDescriptors[0];
    final frameDescriptors = formatDescriptor.frameDescriptors;
    final frameDescriptor = frameDescriptors[0];
    final UVCFrameFormat frameFormat;
    switch (frameDescriptor.subtype) {
      case UVCVideoStreamingDescriptorSubtype.frameMJPEG:
        frameFormat = UVCFrameFormat.mjpeg;
        break;
      case UVCVideoStreamingDescriptorSubtype.frameFrameBased:
        frameFormat = UVCFrameFormat.h264;
        break;
      default:
        frameFormat = UVCFrameFormat.yuyv;
        break;
    }
    final width = frameDescriptor.width;
    final height = frameDescriptor.height;
    final fps = 1000 * 1000 * 10 ~/ frameDescriptor.defaultInterval;
    final control = _uvc.getStreamControl(
      device,
      format: frameFormat,
      width: width,
      height: height,
      fps: fps,
    );
    logger.info('stream control: $frameFormat, ${width}x$height, $fps');
    _uvc.startStreaming(
      device,
      control: control,
      callback: (frame) {
        _frame = frame;
        _frames++;
        notifyListeners();
      },
    );
    final inputTerminals = _uvc.getInputTerminals(device);
    for (var inputTermianl in inputTerminals) {
      logger.info(
          'inputTerminal: terminalId ${inputTermianl.id}, terminalType ${inputTermianl.type}, minimumObjectiveFocalLength ${inputTermianl.minimumObjectiveFocalLength}, maximumObjectiveFocalLength ${inputTermianl.maximumObjectiveFocalLength}, ocularFocalLength ${inputTermianl.ocularFocalLength}, controls ${inputTermianl.controls}');
      final canZoomAbsolute = (inputTermianl.controls &
              UVCCameraTerminalControlSelector.zoomAbsoluteControl.value) !=
          0;
      final canZoomRelative = (inputTermianl.controls &
              UVCCameraTerminalControlSelector.zoomRelativeControl.value) !=
          0;
      logger.info(
          'canZoomAbsolute $canZoomAbsolute, canZoomRelative $canZoomRelative');
    }
    // final zoomAbsolute = _uvc.getZoomAbsolute(
    //   device,
    //   requestCode: UVCRequestCode.getMinimum,
    // );
    // logger.info(
    //     'zoomAbsolute: minimum ${zoomAbsolute.minimum}, maximum ${zoomAbsolute.maximum}, resolution ${zoomAbsolute.resolution}, undefined ${zoomAbsolute.undefined}, current ${zoomAbsolute.current}');
    // final zoomRelative = _uvc.getZoomRelative(device);
    // logger.info(
    //     'zoomRelative: direction ${zoomRelative.direction}, digitalZoom ${zoomRelative.digitalZoom}, minimumSpeed ${zoomRelative.minimumSpeed}, maximumSpeed ${zoomRelative.maximumSpeed}, resolutionSpeed ${zoomRelative.resolutionSpeed}, undefinedSpeed ${zoomRelative.undefinedSpeed}, currentSpeed ${zoomRelative.currentSpeed}');
    _device = device;
    _control = control;
    notifyListeners();
  }

  void stopStreaming() async {
    final device = _device;
    if (device == null) {
      throw StateError('Not Streaming.');
    }
    _uvc.stopStreaming(device);
    if (Platform.isAndroid) {
      final connection = _connection;
      if (connection == null) {
        throw ArgumentError.notNull('connection');
      }
      await connection.close();
    }
    _uvc.close(device);
    _device = null;
    _frame = null;
    _fps = _frames = 0;
    notifyListeners();
  }

  void setZoomAbsolute(int focalLength) {
    final device = _device;
    if (device == null) {
      throw StateError('Not Streaming.');
    }
    _uvc.setZoomAbsolute(
      device,
      focalLength: focalLength,
    );
  }

  void setZoomRelative(int zoomRelative, int digitalZoom, int speed) {
    final device = _device;
    if (device == null) {
      throw StateError('Not Streaming.');
    }
    _uvc.setZoomRelative(
      device,
      zoomRelative: zoomRelative,
      digitalZoom: digitalZoom,
      speed: speed,
    );
  }

  @override
  void dispose() {
    final device = _device;
    if (device != null) {
      _uvc.stopStreaming(device);
      if (Platform.isAndroid) {
        _connection?.close();
      }
      _uvc.close(device);
    }
    _fpsTimer.cancel();
    super.dispose();
  }
}
