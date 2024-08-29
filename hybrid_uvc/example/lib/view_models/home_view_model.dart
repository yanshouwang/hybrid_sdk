import 'dart:ui' as ui;

import 'package:clover/clover.dart';
import 'package:hybrid_logging/hybrid_logging.dart';
import 'package:hybrid_uvc/hybrid_uvc.dart';

final class HomeViewModel extends ViewModel with TypeLogger {
  final UVC _uvc;
  UVCDevice? _device;
  ui.Image? _image;
  bool _handling = false;

  HomeViewModel() : _uvc = UVC();

  bool get streaming => _device != null;
  ui.Image? get image => _image;

  void startStreaming() {
    if (_device != null) {
      throw StateError('Streaming.');
    }
    final device = _uvc.findDevice();
    final descriptor = _uvc.getDevicedescriptor(device);
    logger.info(
        'Device found: VId: ${descriptor.vid}, PId: ${descriptor.pid}, SN: ${descriptor.sn}, Manufacturer Name: ${descriptor.manufacturerName}, Product Name: ${descriptor.productName}');
    _uvc.open(device);
    _uvc.startStreaming(device, _decode);
    _device = device;
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
