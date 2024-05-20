import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'hybrid_os_platform_interface_method_channel.dart';

abstract class HybridOsPlatformInterfacePlatform extends PlatformInterface {
  /// Constructs a HybridOsPlatformInterfacePlatform.
  HybridOsPlatformInterfacePlatform() : super(token: _token);

  static final Object _token = Object();

  static HybridOsPlatformInterfacePlatform _instance = MethodChannelHybridOsPlatformInterface();

  /// The default instance of [HybridOsPlatformInterfacePlatform] to use.
  ///
  /// Defaults to [MethodChannelHybridOsPlatformInterface].
  static HybridOsPlatformInterfacePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HybridOsPlatformInterfacePlatform] when
  /// they register themselves.
  static set instance(HybridOsPlatformInterfacePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
