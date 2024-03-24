import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'hybrid_core_platform_interface_method_channel.dart';

abstract class HybridCorePlatformInterfacePlatform extends PlatformInterface {
  /// Constructs a HybridCorePlatformInterfacePlatform.
  HybridCorePlatformInterfacePlatform() : super(token: _token);

  static final Object _token = Object();

  static HybridCorePlatformInterfacePlatform _instance = MethodChannelHybridCorePlatformInterface();

  /// The default instance of [HybridCorePlatformInterfacePlatform] to use.
  ///
  /// Defaults to [MethodChannelHybridCorePlatformInterface].
  static HybridCorePlatformInterfacePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HybridCorePlatformInterfacePlatform] when
  /// they register themselves.
  static set instance(HybridCorePlatformInterfacePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
