import 'dart:ui';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'common.dart';

abstract base class BarcodeDetectionImpl extends PlatformInterface
    implements BarcodeDetection {
  /// Constructs a [BarcodeDetectionImpl].
  BarcodeDetectionImpl() : super(token: _token);

  static final Object _token = Object();

  static BarcodeDetectionImpl? _instance;

  /// The default instance of [BarcodeDetectionImpl] to use.
  static BarcodeDetectionImpl get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError('Barcode is not implemented on this platform.');
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BarcodeDetectionImpl] when
  /// they register themselves.
  static set instance(BarcodeDetectionImpl instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}

abstract interface class BarcodeDetection {
  BarcodeDetector createDetector({
    List<BarcodeFormat>? formats,
  });
}

abstract interface class BarcodeDetector {
  Future<List<Barcode>> detect(VisionImage image);

  factory BarcodeDetector({
    List<BarcodeFormat>? formats,
  }) =>
      BarcodeDetectionImpl.instance.createDetector(
        formats: formats,
      );
}

class Barcode {
  final Rect boundingBox;
  final BarcodeFormat format;
  final String? value;

  Barcode({
    required this.boundingBox,
    required this.format,
    this.value,
  });
}

enum BarcodeFormat {
  aztec,
  codabar,
  code128,
  code39,
  code93,
  dataMatrix,
  ean13,
  ean8,
  gs1DataBar,
  itf,
  msiPlessey,
  pdf417,
  qrCode,
  upcA,
  upcE,
}
