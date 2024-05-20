import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'hybrid_os_platform_interface_platform_interface.dart';

/// An implementation of [HybridOsPlatformInterfacePlatform] that uses method channels.
class MethodChannelHybridOsPlatformInterface extends HybridOsPlatformInterfacePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('hybrid_os_platform_interface');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
