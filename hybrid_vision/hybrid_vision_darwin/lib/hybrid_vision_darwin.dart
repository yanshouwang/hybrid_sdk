import 'package:flutter/foundation.dart';
import 'package:hybrid_vision_platform_interface/hybrid_vision_platform_interface.dart';

import 'src/barcode.dart';

abstract class HybridVisionDarwin {
  static void registerWith() {
    BarcodePlatform.instance = BarcodePlatformImpl();
    debugPrint('hybrid_vision is registered.');
  }
}
