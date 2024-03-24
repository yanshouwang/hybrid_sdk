import 'dart:typed_data';
import 'dart:ui';

import 'package:hybrid_vision_platform_interface/hybrid_vision_platform_interface.dart';

import 'jni.dart' as jni;

extension MemoryVisionImageX on MemoryVisionImage {
  jni.InputImage toCInputImage() {
    final bitmap = jni.BitmapFactory.decodeByteArray1(
      memory.toJArray(),
      0,
      memory.length,
    );
    return jni.InputImage.fromBitmap(
      bitmap,
      rotationDegrees,
    );
  }
}

extension UriVisionImageX on UriVisionImage {
  jni.InputImage toCInputImage() {
    final activityPtr = jni.Jni.getCurrentActivity();
    final activity = jni.JObject.fromRef(activityPtr);
    final uri = this.uri.toCUri();
    return jni.InputImage.fromFilePath(
      activity,
      uri,
    );
  }
}

extension UriX on Uri {
  jni.Uri toCUri() {
    final urlString = toString().toJString();
    return jni.Uri.parse(urlString);
  }
}

extension Uint8ListX on Uint8List {
  jni.JArray<jni.jbyte> toJArray() {
    final array = jni.JArray(jni.jbyte.type, length);
    array.setRange(0, length, this);
    return array;
  }
}

extension IntIterableX on Iterable<int> {
  jni.JArray<jni.jint> toJArray() {
    final array = jni.JArray(jni.jint.type, length);
    array.setRange(0, length, this);
    return array;
  }
}

extension JStringArrayX on jni.JArray<jni.JString> {
  List<String> toList() {
    final strings = <String>[];
    for (var i = 0; i < length; i++) {
      final string = this[i].toDartString(releaseOriginal: true);
      strings.add(string);
    }
    return List.unmodifiable(strings);
  }
}

extension JRectX on jni.Rect {
  Rect toRect() {
    final left = this.left.toDouble();
    final top = this.top.toDouble();
    final right = this.right.toDouble();
    final bottom = this.bottom.toDouble();
    return Rect.fromLTRB(left, top, right, bottom);
  }
}
