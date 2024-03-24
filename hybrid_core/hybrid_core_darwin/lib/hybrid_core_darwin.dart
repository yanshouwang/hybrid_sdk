import 'package:flutter/foundation.dart';
import 'package:hybrid_core_platform_interface/hybrid_core_platform_interface.dart';

import 'src/os.dart';

abstract class HybridCoreDarwin {
  static void registerWith() {
    OSPlatform.instance = OSPlatformImpl();
    debugPrint('hybrid_core is registered.');
  }
}
