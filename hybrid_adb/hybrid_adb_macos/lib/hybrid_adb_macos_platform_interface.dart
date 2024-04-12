import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'hybrid_adb_macos_method_channel.dart';

abstract class HybridAdbMacosPlatform extends PlatformInterface {
  /// Constructs a HybridAdbMacosPlatform.
  HybridAdbMacosPlatform() : super(token: _token);

  static final Object _token = Object();

  static HybridAdbMacosPlatform _instance = MethodChannelHybridAdbMacos();

  /// The default instance of [HybridAdbMacosPlatform] to use.
  ///
  /// Defaults to [MethodChannelHybridAdbMacos].
  static HybridAdbMacosPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HybridAdbMacosPlatform] when
  /// they register themselves.
  static set instance(HybridAdbMacosPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
