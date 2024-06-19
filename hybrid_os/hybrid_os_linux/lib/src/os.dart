import 'package:hybrid_os_platform_interface/hybrid_os_platform_interface.dart';

import 'linux.dart';

/// HybridOSLinuxPlugin.
abstract final class HybridOSLinuxPlugin {
  /// Registers the [HybridOSLinuxPlugin].
  static void registerWith() {
    OSPlatform.instance = LinuxPlatform();
  }
}
