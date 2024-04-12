import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract base class OSImpl extends PlatformInterface implements OS {
  /// Constructs a [OSImpl].
  OSImpl() : super(token: _token);

  static final Object _token = Object();

  static OSImpl? _instance;

  /// The default instance of [OSImpl] to use.
  static OSImpl get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError('OS is not implemented on this platform.');
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [OSImpl] when
  /// they register themselves.
  static set instance(OSImpl instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}

abstract interface class OS {
  static OS get instance => OSImpl.instance;
}
