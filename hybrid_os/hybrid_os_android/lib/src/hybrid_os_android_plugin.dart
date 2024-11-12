import 'package:hybrid_os_platform_interface/hybrid_os_platform_interface.dart';

import 'android.dart';

/// HybridOSAndroidPlugin.
final class HybridOSAndroidPlugin extends HybridOSPlugin {
  /// Registers the [HybridOSAndroidPlugin].
  static void registerWith() {
    HybridOSPlugin.instance = HybridOSAndroidPlugin();
  }

  @override
  OS createOS() => Android();
}
