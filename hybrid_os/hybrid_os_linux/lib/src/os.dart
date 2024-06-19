import 'package:hybrid_os_platform_interface/hybrid_os_platform_interface.dart';

import 'linux.dart';

abstract class HybridOSLinuxPlugin {
  static void registerWith() {
    OSPlatform.instance = LinuxPlatform();
  }
}
