import 'package:flutter/foundation.dart';
import 'package:hybrid_vision_platform_interface/hybrid_vision_platform_interface.dart';

import 'src/barcode.dart';
import 'src/jni.dart';

abstract class HybridVisionAndroid {
  static void registerWith() {
    Jni.initDLApi();
    BarcodePlatform.instance = BarcodePlatformImpl();
    debugPrint('hybrid_vision is registered.');
  }
}
