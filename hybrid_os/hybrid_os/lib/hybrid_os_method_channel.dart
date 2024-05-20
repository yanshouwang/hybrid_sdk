import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'hybrid_os_platform_interface.dart';

/// An implementation of [HybridOsPlatform] that uses method channels.
class MethodChannelHybridOs extends HybridOsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('hybrid_os');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
