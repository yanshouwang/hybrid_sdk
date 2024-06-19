import 'package:hybrid_os_platform_interface/hybrid_os_platform_interface.dart';

import 'android.dart';

abstract final class HybridOSAndroidPlugin {
  static void registerWith() {
    OSPlatform.instance = AndroidPlatform();
  }
}
