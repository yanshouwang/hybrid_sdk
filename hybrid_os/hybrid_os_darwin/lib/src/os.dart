import 'dart:ffi';

import 'package:hybrid_os_platform_interface/hybrid_os_platform_interface.dart';

import 'ios.dart';
import 'macos.dart';

const _foundationPath =
    '/System/Library/Frameworks/Foundation.framework/Foundation';

/// HybridOSiOSPlugin.
abstract final class HybridOSiOSPlugin {
  /// Registers the [HybridOSiOSPlugin].
  static void registerWith() {
    _openLibs();
    OSPlatform.instance = iOSPlatform();
  }
}

/// HybridOSmacOSPlugin.
abstract final class HybridOSmacOSPlugin {
  /// Registers the [HybridOSmacOSPlugin].
  static void registerWith() {
    _openLibs();
    OSPlatform.instance = macOSPlatform();
  }
}

void _openLibs() {
  DynamicLibrary.open(_foundationPath);
}
