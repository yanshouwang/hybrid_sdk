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
    final device = await _findAndOpenDevice();
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

  Future<UVCDevice> _findAndOpenDevice() async {
    if (Platform.isAndroid) {
      final manager = USBManager();
      final devices = await manager.getDevices();
      USBDevice? device;
      for (var value in devices.values) {
        final deviceClass = await value.getDeviceClass();
        if (deviceClass == USBConstants.usbClassVideo) {
          device = value;
          break;
        } else if (deviceClass == USBConstants.usbClassMisc) {
          final interfaceCount = await value.getInterfaceCount();
          for (var i = 0; i < interfaceCount; i++) {
            final interface = await value.getInterface(i);
            final interfaceClass = await interface.getInterfaceClass();
            if (interfaceClass != USBConstants.usbClassVideo) {
              continue;
            }
            device = value;
            break;
          }
          if (device != null) {
            break;
          }
        }
      }
      if (device == null) {
        throw ArgumentError.notNull('device');
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
      var usbAuthorized = await manager.hasDevicePermission(device);
      if (!usbAuthorized) {
        usbAuthorized = await manager.requestDevicePermission(device);
      }
      if (!usbAuthorized) {
        throw StateError('USB is unauthorized.');
      }
      final vid = await device.getVendorId();
      final pid = await device.getProductId();
      final sn = await device.getSerialNumber();
      final manufacturer = await device.getManufacturerName();
      final product = await device.getProductName();
      logger.info(
          'device: VId $vid, PId $pid, SN $sn, Manufacturer $manufacturer, Product $product.');
      final connection = await manager.openDevice(device);
      final fileDescriptor = await connection.getFileDescriptor();
      _connection = connection;
      return _uvc.wrap(fileDescriptor);
    } else {
      final device = _uvc.findDevice();
      final deviceDescriptor = _uvc.getDeviceDescriptor(device);
      logger.info(
          'deviceDescriptor: VId ${deviceDescriptor.vid}, PId ${deviceDescriptor.pid}, SN ${deviceDescriptor.sn}, Manufacturer ${deviceDescriptor.manufacturer}, Product ${deviceDescriptor.product}.');
      _uvc.open(device);
      return device;
    }
  }
}
