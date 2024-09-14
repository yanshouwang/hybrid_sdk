import 'package:hybrid_media_platform_interface/hybrid_media_platform_interface.dart';

import 'audio_manager_impl.dart';

final class HybridMediaAndroidPlugin extends HybridMediaPlugin {
  /// Registers the [HybridMediaPlugin].
  static void registerWith() {
    HybridMediaPlugin.instance = HybridMediaAndroidPlugin();
  }

  @override
  AudioManager createAudioManager() {
    return AudioManagerImpl();
  }
}
