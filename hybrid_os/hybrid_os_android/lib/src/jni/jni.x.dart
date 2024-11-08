import 'package:jni/jni.dart';

import 'android/content/Context.dart';

abstract base class Env {
  static Context get context {
    final reference = Jni.getCurrentActivity();
    return Context.fromReference(reference);
  }
}
