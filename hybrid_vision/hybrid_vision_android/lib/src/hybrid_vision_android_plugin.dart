import 'package:hybrid_vision_platform_interface/hybrid_vision_platform_interface.dart';
import 'package:jni/jni.dart';

import 'barcode_detection.dart';

abstract class HybridVisionAndroidPlugin {
  static void registerWith() {
    Jni.initDLApi();
    BarcodeDetectionPlatform.instance = AndroidBarcodeDetectionPlatform();
  }
}
