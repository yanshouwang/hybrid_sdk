import 'dart:ui' as ui;

import 'package:clover/clover.dart';
import 'package:hybrid_logging/hybrid_logging.dart';
import 'package:hybrid_uvc/hybrid_uvc.dart';

final class HomeViewModel extends ViewModel with TypeLogger {
  final UVC _uvc;
  UVCDevice? _device;
  UVCStreamControl? _control;
  ui.Image? _image;
  bool _handling = false;

  HomeViewModel() : _uvc = UVC();

  bool get streaming => _device != null && _control != null;
  ui.Image? get image => _image;

  void startStreaming() {
    if (_device != null) {
      throw StateError('Streaming.');
    }
    final device = _uvc.findDevice();
    final deviceDescriptor = _uvc.getDeviceDescriptor(device);
    logger.info(
        'deviceDescriptor: VId ${deviceDescriptor.vid}, PId ${deviceDescriptor.pid}, SN ${deviceDescriptor.sn}, Manufacturer ${deviceDescriptor.manufacturer}, Product ${deviceDescriptor.product}');
    _uvc.open(device);
    final formatDescriptors = _uvc.getFormatDescriptors(device);
    for (var formatDescriptor in formatDescriptors) {
      logger.info('formatDescriptor: ${formatDescriptor.descriptorSubtype}');
      final frameDescriptors = formatDescriptor.frameDescriptors;
      for (var frameDescriptor in frameDescriptors) {
        logger.info(
            'frameDescriptor: ${frameDescriptor.width}x${frameDescriptor.height}');
      }
    }
    final formatDescriptor = formatDescriptors[0];
    final frameDescriptors = formatDescriptor.frameDescriptors;
    final frameDescriptor = frameDescriptors[0];
    final UVCFrameFormat frameFormat;
    switch (frameDescriptor.descriptorSubtype) {
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
    final fps = 1000 * 1000 * 10 ~/ frameDescriptor.defaultFrameInterval;
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
      callback: _decode,
    );
    _device = device;
    _control = control;
    notifyListeners();
  }

  void stopStreaming() {
    final device = _device;
    if (device == null) {
      throw StateError('Not Streaming.');
    }
    _uvc.stopStreaming(device);
    _uvc.close(device);
    _device = null;
    _image = null;
    notifyListeners();
  }

  void _decode(UVCFrame frame) async {
    if (_handling) {
      return;
    }
    _handling = true;
    try {
      final buffer = await ui.ImmutableBuffer.fromUint8List(frame.value);
      final descriptor = ui.ImageDescriptor.raw(
        buffer,
        width: frame.width,
        height: frame.height,
        pixelFormat: ui.PixelFormat.rgba8888,
      );
      final codec = await descriptor.instantiateCodec();
      final info = await codec.getNextFrame();
      if (!streaming) {
        return;
      }
      _image = info.image;
      notifyListeners();
    } finally {
      _handling = false;
    }
  }

  @override
  void dispose() {
    final device = _device;
    if (device != null) {
      _uvc.close(device);
    }
    super.dispose();
  }
}
