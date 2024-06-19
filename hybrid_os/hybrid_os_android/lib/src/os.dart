import 'package:hybrid_os_platform_interface/hybrid_os_platform_interface.dart';

import 'android.dart';

/// HybridOSAndroidPlugin.
abstract final class HybridOSAndroidPlugin {
  /// Registers the [HybridOSAndroidPlugin].
  static void registerWith() {
    OSPlatform.instance = AndroidPlatform();
  }
}
