import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'hybrid_core_method_channel.dart';

abstract class HybridCorePlatform extends PlatformInterface {
  /// Constructs a HybridCorePlatform.
  HybridCorePlatform() : super(token: _token);

  static final Object _token = Object();

  static HybridCorePlatform _instance = MethodChannelHybridCore();

  /// The default instance of [HybridCorePlatform] to use.
  ///
  /// Defaults to [MethodChannelHybridCore].
  static HybridCorePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HybridCorePlatform] when
  /// they register themselves.
  static set instance(HybridCorePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
