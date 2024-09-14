import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'os.dart';

abstract base class HybridOSPlugin extends PlatformInterface {
  /// Constructs a [HybridOSPlugin].
  HybridOSPlugin() : super(token: _token);

  static final Object _token = Object();

  static HybridOSPlugin? _instance;

  /// The default instance of [HybridOSPlugin] to use.
  static HybridOSPlugin get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError('OS is not implemented on this platform.');
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HybridOSPlugin] when
  /// they register themselves.
  static set instance(HybridOSPlugin instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  OS createOS();
}
