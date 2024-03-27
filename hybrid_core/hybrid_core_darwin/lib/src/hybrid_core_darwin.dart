import 'dart:io';

import 'package:hybrid_core_platform_interface/hybrid_core_platform_interface.dart';

import 'os.dart';

abstract class HybridCoreDarwin {
  static void registerWith() {
    OSPlatform.instance = Platform.isIOS ? iOSPlatform() : macOSPlatform();
  }
}
