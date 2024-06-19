import 'package:hybrid_os_platform_interface/hybrid_os_platform_interface.dart';

import 'windows.dart';

/// HybridOSWindowsPlugin.
abstract final class HybridOSWindowsPlugin {
  /// Registers the [HybridOSWindowsPlugin].
  static void registerWith() {
    OSPlatform.instance = WindowsPlatform();
  }
}
