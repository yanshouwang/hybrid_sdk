import 'dart:typed_data';

import 'package:jni/jni.dart';

extension Uint8ListX on Uint8List {
  JArray<jbyte> toJArray() {
    return JArray(jbyte.type, length)..setRange(0, length, this);
  }
}
