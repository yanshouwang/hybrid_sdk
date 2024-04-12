import 'package:hybrid_adb_platform_interface/hybrid_adb_platform_interface.dart';

abstract class HybridADBWindowsPlugin {
  static void registerWith() {
    ADBImpl.instance = WindowsADBImpl();
  }
}

base class WindowsADBImpl extends ADBImpl {
  @override
  String get executable => 'platform-tools/adb.exe';
}
