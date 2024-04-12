import 'package:hybrid_core_platform_interface/hybrid_core_platform_interface.dart';

import 'os.dart';

abstract class WindowsCorePlugin {
  static void registerWith() {
    OSImpl.instance = WindowsImpl();
  }
}
