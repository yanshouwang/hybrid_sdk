// ignore_for_file: use_super_parameters
// Autogenerated by jnigen. DO NOT EDIT!

// ignore_for_file: annotate_overrides
// ignore_for_file: camel_case_extensions
// ignore_for_file: camel_case_types
// ignore_for_file: constant_identifier_names
// ignore_for_file: file_names
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: overridden_fields
// ignore_for_file: unnecessary_cast
// ignore_for_file: unused_element
// ignore_for_file: unused_field
// ignore_for_file: unused_import
// ignore_for_file: unused_local_variable
// ignore_for_file: unused_shown_name

import "dart:isolate" show ReceivePort;
import "dart:ffi" as ffi;
import "package:jni/internal_helpers_for_jnigen.dart";
import "package:jni/jni.dart" as jni;

import "../../_init.dart";

/// from: android.graphics.Rect
class Rect extends jni.JObject {
  @override
  late final jni.JObjType<Rect> $type = type;

  Rect.fromRef(
    jni.JObjectPtr ref,
  ) : super.fromRef(ref);

  /// The type which includes information such as the signature of this class.
  static const type = $RectType();
  static final _get_CREATOR =
      jniLookup<ffi.NativeFunction<jni.JniResult Function()>>(
              "get_Rect__CREATOR")
          .asFunction<jni.JniResult Function()>();

  /// from: static public final android.os.Parcelable$Creator CREATOR
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JObject get CREATOR =>
      const jni.JObjectType().fromRef(_get_CREATOR().object);

  static final _get_bottom = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                jni.JObjectPtr,
              )>>("get_Rect__bottom")
      .asFunction<
          jni.JniResult Function(
            jni.JObjectPtr,
          )>();

  static final _set_bottom = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                  jni.JObjectPtr, ffi.Int32)>>("set_Rect__bottom")
      .asFunction<jni.JniResult Function(jni.JObjectPtr, int)>();

  /// from: public int bottom
  int get bottom => _get_bottom(reference).integer;

  /// from: public int bottom
  set bottom(int value) => _set_bottom(reference, value).check();

  static final _get_left = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                jni.JObjectPtr,
              )>>("get_Rect__left")
      .asFunction<
          jni.JniResult Function(
            jni.JObjectPtr,
          )>();

  static final _set_left = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                  jni.JObjectPtr, ffi.Int32)>>("set_Rect__left")
      .asFunction<jni.JniResult Function(jni.JObjectPtr, int)>();

  /// from: public int left
  int get left => _get_left(reference).integer;

  /// from: public int left
  set left(int value) => _set_left(reference, value).check();

  static final _get_right = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                jni.JObjectPtr,
              )>>("get_Rect__right")
      .asFunction<
          jni.JniResult Function(
            jni.JObjectPtr,
          )>();

  static final _set_right = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                  jni.JObjectPtr, ffi.Int32)>>("set_Rect__right")
      .asFunction<jni.JniResult Function(jni.JObjectPtr, int)>();

  /// from: public int right
  int get right => _get_right(reference).integer;

  /// from: public int right
  set right(int value) => _set_right(reference, value).check();

  static final _get_top = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                jni.JObjectPtr,
              )>>("get_Rect__top")
      .asFunction<
          jni.JniResult Function(
            jni.JObjectPtr,
          )>();

  static final _set_top = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                  jni.JObjectPtr, ffi.Int32)>>("set_Rect__top")
      .asFunction<jni.JniResult Function(jni.JObjectPtr, int)>();

  /// from: public int top
  int get top => _get_top(reference).integer;

  /// from: public int top
  set top(int value) => _set_top(reference, value).check();

  static final _new0 =
      jniLookup<ffi.NativeFunction<jni.JniResult Function()>>("Rect__new0")
          .asFunction<jni.JniResult Function()>();

  /// from: public void <init>()
  /// The returned object must be released after use, by calling the [release] method.
  factory Rect() {
    return Rect.fromRef(_new0().object);
  }

  static final _new1 = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                  ffi.Int32, ffi.Int32, ffi.Int32, ffi.Int32)>>("Rect__new1")
      .asFunction<jni.JniResult Function(int, int, int, int)>();

  /// from: public void <init>(int i, int i1, int i2, int i3)
  /// The returned object must be released after use, by calling the [release] method.
  factory Rect.new1(
    int i,
    int i1,
    int i2,
    int i3,
  ) {
    return Rect.fromRef(_new1(i, i1, i2, i3).object);
  }

  static final _new2 = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>)>>("Rect__new2")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public void <init>(android.graphics.Rect rect)
  /// The returned object must be released after use, by calling the [release] method.
  factory Rect.new2(
    Rect rect,
  ) {
    return Rect.fromRef(_new2(rect.reference).object);
  }

  static final _equals1 = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>,
                  ffi.Pointer<ffi.Void>)>>("Rect__equals1")
      .asFunction<
          jni.JniResult Function(
              ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// from: public boolean equals(java.lang.Object object)
  bool equals1(
    jni.JObject object,
  ) {
    return _equals1(reference, object.reference).boolean;
  }

  static final _hashCode1 = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>)>>("Rect__hashCode1")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public int hashCode()
  int hashCode1() {
    return _hashCode1(reference).integer;
  }

  static final _toString1 = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>)>>("Rect__toString1")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public java.lang.String toString()
  /// The returned object must be released after use, by calling the [release] method.
  jni.JString toString1() {
    return const jni.JStringType().fromRef(_toString1(reference).object);
  }

  static final _toShortString = jniLookup<
              ffi
              .NativeFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>>(
          "Rect__toShortString")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public java.lang.String toShortString()
  /// The returned object must be released after use, by calling the [release] method.
  jni.JString toShortString() {
    return const jni.JStringType().fromRef(_toShortString(reference).object);
  }

  static final _flattenToString = jniLookup<
              ffi
              .NativeFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>>(
          "Rect__flattenToString")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public java.lang.String flattenToString()
  /// The returned object must be released after use, by calling the [release] method.
  jni.JString flattenToString() {
    return const jni.JStringType().fromRef(_flattenToString(reference).object);
  }

  static final _unflattenFromString = jniLookup<
              ffi
              .NativeFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>>(
          "Rect__unflattenFromString")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: static public android.graphics.Rect unflattenFromString(java.lang.String string)
  /// The returned object must be released after use, by calling the [release] method.
  static Rect unflattenFromString(
    jni.JString string,
  ) {
    return const $RectType()
        .fromRef(_unflattenFromString(string.reference).object);
  }

  static final _isEmpty = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>)>>("Rect__isEmpty")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public boolean isEmpty()
  bool isEmpty() {
    return _isEmpty(reference).boolean;
  }

  static final _width = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>)>>("Rect__width")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public int width()
  int width() {
    return _width(reference).integer;
  }

  static final _height = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>)>>("Rect__height")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public int height()
  int height() {
    return _height(reference).integer;
  }

  static final _centerX = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>)>>("Rect__centerX")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public int centerX()
  int centerX() {
    return _centerX(reference).integer;
  }

  static final _centerY = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>)>>("Rect__centerY")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public int centerY()
  int centerY() {
    return _centerY(reference).integer;
  }

  static final _exactCenterX = jniLookup<
              ffi
              .NativeFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>>(
          "Rect__exactCenterX")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public float exactCenterX()
  double exactCenterX() {
    return _exactCenterX(reference).float;
  }

  static final _exactCenterY = jniLookup<
              ffi
              .NativeFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>>(
          "Rect__exactCenterY")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public float exactCenterY()
  double exactCenterY() {
    return _exactCenterY(reference).float;
  }

  static final _setEmpty = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>)>>("Rect__setEmpty")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public void setEmpty()
  void setEmpty() {
    return _setEmpty(reference).check();
  }

  static final _set0 = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>, ffi.Int32,
                  ffi.Int32, ffi.Int32, ffi.Int32)>>("Rect__set0")
      .asFunction<
          jni.JniResult Function(ffi.Pointer<ffi.Void>, int, int, int, int)>();

  /// from: public void set(int i, int i1, int i2, int i3)
  void set0(
    int i,
    int i1,
    int i2,
    int i3,
  ) {
    return _set0(reference, i, i1, i2, i3).check();
  }

  static final _set1 = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                  ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>>("Rect__set1")
      .asFunction<
          jni.JniResult Function(
              ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// from: public void set(android.graphics.Rect rect)
  void set1(
    Rect rect,
  ) {
    return _set1(reference, rect.reference).check();
  }

  static final _offset = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                  ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32)>>("Rect__offset")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>, int, int)>();

  /// from: public void offset(int i, int i1)
  void offset(
    int i,
    int i1,
  ) {
    return _offset(reference, i, i1).check();
  }

  static final _offsetTo = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>, ffi.Int32,
                  ffi.Int32)>>("Rect__offsetTo")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>, int, int)>();

  /// from: public void offsetTo(int i, int i1)
  void offsetTo(
    int i,
    int i1,
  ) {
    return _offsetTo(reference, i, i1).check();
  }

  static final _inset = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                  ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32)>>("Rect__inset")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>, int, int)>();

  /// from: public void inset(int i, int i1)
  void inset(
    int i,
    int i1,
  ) {
    return _inset(reference, i, i1).check();
  }

  static final _inset1 = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>,
                  ffi.Pointer<ffi.Void>)>>("Rect__inset1")
      .asFunction<
          jni.JniResult Function(
              ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// from: public void inset(android.graphics.Insets insets)
  void inset1(
    jni.JObject insets,
  ) {
    return _inset1(reference, insets.reference).check();
  }

  static final _inset2 = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>, ffi.Int32,
                  ffi.Int32, ffi.Int32, ffi.Int32)>>("Rect__inset2")
      .asFunction<
          jni.JniResult Function(ffi.Pointer<ffi.Void>, int, int, int, int)>();

  /// from: public void inset(int i, int i1, int i2, int i3)
  void inset2(
    int i,
    int i1,
    int i2,
    int i3,
  ) {
    return _inset2(reference, i, i1, i2, i3).check();
  }

  static final _contains = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>, ffi.Int32,
                  ffi.Int32)>>("Rect__contains")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>, int, int)>();

  /// from: public boolean contains(int i, int i1)
  bool contains(
    int i,
    int i1,
  ) {
    return _contains(reference, i, i1).boolean;
  }

  static final _contains1 = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>, ffi.Int32,
                  ffi.Int32, ffi.Int32, ffi.Int32)>>("Rect__contains1")
      .asFunction<
          jni.JniResult Function(ffi.Pointer<ffi.Void>, int, int, int, int)>();

  /// from: public boolean contains(int i, int i1, int i2, int i3)
  bool contains1(
    int i,
    int i1,
    int i2,
    int i3,
  ) {
    return _contains1(reference, i, i1, i2, i3).boolean;
  }

  static final _contains2 = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>,
                  ffi.Pointer<ffi.Void>)>>("Rect__contains2")
      .asFunction<
          jni.JniResult Function(
              ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// from: public boolean contains(android.graphics.Rect rect)
  bool contains2(
    Rect rect,
  ) {
    return _contains2(reference, rect.reference).boolean;
  }

  static final _intersect = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>, ffi.Int32,
                  ffi.Int32, ffi.Int32, ffi.Int32)>>("Rect__intersect")
      .asFunction<
          jni.JniResult Function(ffi.Pointer<ffi.Void>, int, int, int, int)>();

  /// from: public boolean intersect(int i, int i1, int i2, int i3)
  bool intersect(
    int i,
    int i1,
    int i2,
    int i3,
  ) {
    return _intersect(reference, i, i1, i2, i3).boolean;
  }

  static final _intersect1 = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>,
                  ffi.Pointer<ffi.Void>)>>("Rect__intersect1")
      .asFunction<
          jni.JniResult Function(
              ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// from: public boolean intersect(android.graphics.Rect rect)
  bool intersect1(
    Rect rect,
  ) {
    return _intersect1(reference, rect.reference).boolean;
  }

  static final _setIntersect = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                  ffi.Pointer<ffi.Void>,
                  ffi.Pointer<ffi.Void>,
                  ffi.Pointer<ffi.Void>)>>("Rect__setIntersect")
      .asFunction<
          jni.JniResult Function(ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>,
              ffi.Pointer<ffi.Void>)>();

  /// from: public boolean setIntersect(android.graphics.Rect rect, android.graphics.Rect rect1)
  bool setIntersect(
    Rect rect,
    Rect rect1,
  ) {
    return _setIntersect(reference, rect.reference, rect1.reference).boolean;
  }

  static final _intersects = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>, ffi.Int32,
                  ffi.Int32, ffi.Int32, ffi.Int32)>>("Rect__intersects")
      .asFunction<
          jni.JniResult Function(ffi.Pointer<ffi.Void>, int, int, int, int)>();

  /// from: public boolean intersects(int i, int i1, int i2, int i3)
  bool intersects(
    int i,
    int i1,
    int i2,
    int i3,
  ) {
    return _intersects(reference, i, i1, i2, i3).boolean;
  }

  static final _intersects1 = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>,
                  ffi.Pointer<ffi.Void>)>>("Rect__intersects1")
      .asFunction<
          jni.JniResult Function(
              ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// from: static public boolean intersects(android.graphics.Rect rect, android.graphics.Rect rect1)
  static bool intersects1(
    Rect rect,
    Rect rect1,
  ) {
    return _intersects1(rect.reference, rect1.reference).boolean;
  }

  static final _union = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>, ffi.Int32,
                  ffi.Int32, ffi.Int32, ffi.Int32)>>("Rect__union")
      .asFunction<
          jni.JniResult Function(ffi.Pointer<ffi.Void>, int, int, int, int)>();

  /// from: public void union(int i, int i1, int i2, int i3)
  void union(
    int i,
    int i1,
    int i2,
    int i3,
  ) {
    return _union(reference, i, i1, i2, i3).check();
  }

  static final _union1 = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>,
                  ffi.Pointer<ffi.Void>)>>("Rect__union1")
      .asFunction<
          jni.JniResult Function(
              ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// from: public void union(android.graphics.Rect rect)
  void union1(
    Rect rect,
  ) {
    return _union1(reference, rect.reference).check();
  }

  static final _union2 = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                  ffi.Pointer<ffi.Void>, ffi.Int32, ffi.Int32)>>("Rect__union2")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>, int, int)>();

  /// from: public void union(int i, int i1)
  void union2(
    int i,
    int i1,
  ) {
    return _union2(reference, i, i1).check();
  }

  static final _sort = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>)>>("Rect__sort")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public void sort()
  void sort() {
    return _sort(reference).check();
  }

  static final _describeContents = jniLookup<
              ffi
              .NativeFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>>(
          "Rect__describeContents")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public int describeContents()
  int describeContents() {
    return _describeContents(reference).integer;
  }

  static final _writeToParcel = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>,
                  ffi.Pointer<ffi.Void>, ffi.Int32)>>("Rect__writeToParcel")
      .asFunction<
          jni.JniResult Function(
              ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>, int)>();

  /// from: public void writeToParcel(android.os.Parcel parcel, int i)
  void writeToParcel(
    jni.JObject parcel,
    int i,
  ) {
    return _writeToParcel(reference, parcel.reference, i).check();
  }

  static final _readFromParcel = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>,
                  ffi.Pointer<ffi.Void>)>>("Rect__readFromParcel")
      .asFunction<
          jni.JniResult Function(
              ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// from: public void readFromParcel(android.os.Parcel parcel)
  void readFromParcel(
    jni.JObject parcel,
  ) {
    return _readFromParcel(reference, parcel.reference).check();
  }
}

final class $RectType extends jni.JObjType<Rect> {
  const $RectType();

  @override
  String get signature => r"Landroid/graphics/Rect;";

  @override
  Rect fromRef(jni.JObjectPtr ref) => Rect.fromRef(ref);

  @override
  jni.JObjType get superType => const jni.JObjectType();

  @override
  final superCount = 1;

  @override
  int get hashCode => ($RectType).hashCode;

  @override
  bool operator ==(Object other) {
    return other.runtimeType == ($RectType) && other is $RectType;
  }
}