import 'package:hybrid_os_platform_interface/hybrid_os_platform_interface.dart';

import 'windows.dart';

abstract final class HybridOSWindowsPlugin {
  static void registerWith() {
    OSPlatform.instance = WindowsPlatform();
  }
}
