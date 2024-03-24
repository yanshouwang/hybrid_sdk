import 'package:hybrid_core_platform_interface/hybrid_core_platform_interface.dart';

import 'src/jni.dart';
import 'src/os.dart';

abstract class HybridCoreAndroid {
  static void registerWith() {
    Jni.initDLApi();
    OSPlatform.instance = OSPlatformImpl();
  }
}
