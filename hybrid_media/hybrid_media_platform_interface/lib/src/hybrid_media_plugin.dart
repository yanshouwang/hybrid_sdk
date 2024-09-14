import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'audio_manager.dart';

abstract class HybridMediaPlugin extends PlatformInterface {
  /// Constructs a [HybridMediaPlugin].
  HybridMediaPlugin() : super(token: _token);

  static final Object _token = Object();

  static HybridMediaPlugin? _instance;

  /// The default instance of [HybridMediaPlugin] to use.
  static HybridMediaPlugin get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError('Media is not implemented on this platform.');
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [HybridMediaPlugin] when
  /// they register themselves.
  static set instance(HybridMediaPlugin instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  AudioManager createAudioManager();
}
