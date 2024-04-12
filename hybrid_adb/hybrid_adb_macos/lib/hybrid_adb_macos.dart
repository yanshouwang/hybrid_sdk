
import 'hybrid_adb_macos_platform_interface.dart';

class HybridAdbMacos {
  Future<String?> getPlatformVersion() {
    return HybridAdbMacosPlatform.instance.getPlatformVersion();
  }
}
