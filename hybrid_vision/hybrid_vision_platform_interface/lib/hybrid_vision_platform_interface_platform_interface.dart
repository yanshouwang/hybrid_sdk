import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'hybrid_vision_platform_interface_method_channel.dart';

abstract class HybridVisionPlatformInterfacePlatform extends PlatformInterface {
  /// Constructs a HybridVisionPlatformInterfacePlatform.
  HybridVisionPlatformInterfacePlatform() : super(token: _token);

  static final Object _token = Object();

  static HybridVisionPlatformInterfacePlatform _instance = MethodChannelHybridVisionPlatformInterface();

  /// The default instance of [HybridVisionPlatformInterfacePlatform] to use.
  ///
  /// Defaults to [MethodChannelHybridVisionPlatformInterface].
  static HybridVisionPlatformInterfacePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HybridVisionPlatformInterfacePlatform] when
  /// they register themselves.
  static set instance(HybridVisionPlatformInterfacePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
