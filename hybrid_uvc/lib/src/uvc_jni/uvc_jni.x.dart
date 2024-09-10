import 'dart:typed_data';

import 'package:jni/jni.dart' as jni;

abstract final class Env {
  static jni.JObject get context {
    final reference = jni.Jni.getCachedApplicationContext();
    return jni.JObject.fromReference(reference);
  }
}

extension Uint8ListX on Uint8List {
  jni.JArray<jni.jbyte> toJArray() {
    return jni.JArray(jni.jbyte.type, length)..setRange(0, length, this);
  }
}
