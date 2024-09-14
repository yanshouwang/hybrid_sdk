import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'os.dart';

abstract base class OSPlugin extends PlatformInterface {
  /// Constructs a [OSPlugin].
  OSPlugin() : super(token: _token);

  static final Object _token = Object();

  static OSPlugin? _instance;

  /// The default instance of [OSPlugin] to use.
  static OSPlugin get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError('OS is not implemented on this platform.');
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [OSPlugin] when
  /// they register themselves.
  static set instance(OSPlugin instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  OS createOS();
}
