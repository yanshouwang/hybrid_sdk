import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'hybrid_core_platform_interface.dart';

/// An implementation of [HybridCorePlatform] that uses method channels.
class MethodChannelHybridCore extends HybridCorePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('hybrid_core');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
