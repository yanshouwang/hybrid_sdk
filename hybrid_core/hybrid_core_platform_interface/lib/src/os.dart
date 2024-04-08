import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class OSPlatform extends PlatformInterface implements OS {
  /// Constructs a OSPlatform.
  OSPlatform() : super(token: _token);

  static final Object _token = Object();

  static OSPlatform? _instance;

  /// The default instance of [OSPlatform] to use.
  static OSPlatform get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError('OS is not implemented on this platform.');
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [OSPlatform] when
  /// they register themselves.
  static set instance(OSPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}

abstract class OS {
  static OS get instance => OSPlatform.instance;
}
