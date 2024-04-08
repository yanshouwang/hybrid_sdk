import 'package:hybrid_core_platform_interface/hybrid_core_platform_interface.dart';
import 'package:jni/jni.dart';

import 'os.dart';

abstract class HybridCoreAndroidPlugin {
  static void registerWith() {
    Jni.initDLApi();
    OSPlatform.instance = AndroidPlatform();
  }
}
