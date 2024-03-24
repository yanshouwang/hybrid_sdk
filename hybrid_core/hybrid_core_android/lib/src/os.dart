import 'package:hybrid_core_platform_interface/hybrid_core_platform_interface.dart';

import 'jni.dart' as jni;

class OSPlatformImpl extends OSPlatform {
  @override
  final OS os;

  OSPlatformImpl() : os = AndroidOSImpl();
}

class AndroidOSImpl implements AndroidOS {
  @override
  int get api => jni.Build_VERSION.SDK_INT;

  @override
  bool atLeastAPI(int api) {
    return jni.Build_VERSION.SDK_INT >= api;
  }
}
