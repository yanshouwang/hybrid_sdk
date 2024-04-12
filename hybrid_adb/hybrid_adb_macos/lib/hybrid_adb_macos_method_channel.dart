import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'hybrid_adb_macos_platform_interface.dart';

/// An implementation of [HybridAdbMacosPlatform] that uses method channels.
class MethodChannelHybridAdbMacos extends HybridAdbMacosPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('hybrid_adb_macos');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
