import 'package:hybrid_adb_platform_interface/hybrid_adb_platform_interface.dart';

base class WindowsADB extends NativeADB {
  static void registerWith() {
    NativeADB.instance = WindowsADB();
  }

  @override
  String get executable => 'platform-tools/adb.exe';
}
