import 'package:hybrid_os_platform_interface/hybrid_os_platform_interface.dart';

import 'ios.dart';
import 'macos.dart';

/// HybridOSiOSPlugin.
abstract final class HybridOSiOSPlugin {
  /// Registers the [HybridOSiOSPlugin].
  static void registerWith() {
    OSPlatform.instance = iOSPlatform();
  }
}

/// HybridOSmacOSPlugin.
abstract final class HybridOSmacOSPlugin {
  /// Registers the [HybridOSmacOSPlugin].
  static void registerWith() {
    OSPlatform.instance = macOSPlatform();
  }
}
