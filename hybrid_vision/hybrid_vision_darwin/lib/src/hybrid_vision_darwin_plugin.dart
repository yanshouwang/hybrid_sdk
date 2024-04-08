import 'package:hybrid_vision_platform_interface/hybrid_vision_platform_interface.dart';

import 'barcode_detection.dart';

abstract class HybridVisionDarwinPlugin {
  static void registerWith() {
    BarcodeDetectionPlatform.instance = DarwinBarcodeDetectionPlatform();
  }
}
