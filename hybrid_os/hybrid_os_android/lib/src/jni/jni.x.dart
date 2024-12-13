import 'package:jni/jni.dart';

import 'android/app/_package.dart';
import 'android/content/_package.dart';

Activity get activity {
  final reference = Jni.getCurrentActivity();
  return Activity.fromReference(reference);
}

Context get context {
  final reference = Jni.getCachedApplicationContext();
  return Context.fromReference(reference);
}
