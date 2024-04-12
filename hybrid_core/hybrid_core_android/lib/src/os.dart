import 'package:hybrid_core_platform_interface/hybrid_core_platform_interface.dart';

import 'jni.g.dart';

base class AndroidImpl extends OSImpl implements Android {
  @override
  int get api => Build_VERSION.SDK_INT;

  @override
  bool atLeastAPI(int api) {
    return Build_VERSION.SDK_INT >= api;
  }
}

abstract class Android implements OS {
  int get api;

  bool atLeastAPI(int api);
}
