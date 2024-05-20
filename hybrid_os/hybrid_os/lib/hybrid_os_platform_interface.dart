import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'hybrid_os_method_channel.dart';

abstract class HybridOsPlatform extends PlatformInterface {
  /// Constructs a HybridOsPlatform.
  HybridOsPlatform() : super(token: _token);

  static final Object _token = Object();

  static HybridOsPlatform _instance = MethodChannelHybridOs();

  /// The default instance of [HybridOsPlatform] to use.
  ///
  /// Defaults to [MethodChannelHybridOs].
  static HybridOsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HybridOsPlatform] when
  /// they register themselves.
  static set instance(HybridOsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
