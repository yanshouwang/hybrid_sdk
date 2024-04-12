import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract base class NativeOS extends PlatformInterface implements OS {
  /// Constructs a [NativeOS].
  NativeOS() : super(token: _token);

  static final Object _token = Object();

  static NativeOS? _instance;

  /// The default instance of [NativeOS] to use.
  static NativeOS get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError('OS is not implemented on this platform.');
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NativeOS] when
  /// they register themselves.
  static set instance(NativeOS instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}

abstract interface class OS {
  static OS get instance => NativeOS.instance;
}
