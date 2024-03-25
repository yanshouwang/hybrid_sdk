import 'package:hybrid_vision_platform_interface/hybrid_vision_platform_interface.dart';

import 'src/barcode.dart';

abstract class HybridVisionDarwin {
  static void registerWith() {
    BarcodePlatform.instance = BarcodePlatformImpl();
  }
}
