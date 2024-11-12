import 'package:jni/jni.dart';

import 'android/app/Activity.dart';
import 'android/content/Context.dart';

abstract base class Env {
  static Activity get activity {
    final reference = Jni.getCurrentActivity();
    return Activity.fromReference(reference);
  }

  static Context get context {
    final reference = Jni.getCurrentActivity();
    return Context.fromReference(reference);
  }
}
