import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'hybrid_vision_method_channel.dart';

abstract class HybridVisionPlatform extends PlatformInterface {
  /// Constructs a HybridVisionPlatform.
  HybridVisionPlatform() : super(token: _token);

  static final Object _token = Object();

  static HybridVisionPlatform _instance = MethodChannelHybridVision();

  /// The default instance of [HybridVisionPlatform] to use.
  ///
  /// Defaults to [MethodChannelHybridVision].
  static HybridVisionPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HybridVisionPlatform] when
  /// they register themselves.
  static set instance(HybridVisionPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
