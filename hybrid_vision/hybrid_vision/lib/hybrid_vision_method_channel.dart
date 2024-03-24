import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'hybrid_vision_platform_interface.dart';

/// An implementation of [HybridVisionPlatform] that uses method channels.
class MethodChannelHybridVision extends HybridVisionPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('hybrid_vision');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
