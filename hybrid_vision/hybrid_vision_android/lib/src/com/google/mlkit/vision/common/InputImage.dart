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

import "../../../../../android/graphics/Bitmap.dart" as bitmap_;

import "../../../../../android/net/Uri.dart" as uri_;
import "../../../../../_init.dart";

/// from: com.google.mlkit.vision.common.InputImage$ImageFormat
class InputImage_ImageFormat extends jni.JObject {
  @override
  late final jni.JObjType<InputImage_ImageFormat> $type = type;

  InputImage_ImageFormat.fromRef(
    jni.JObjectPtr ref,
  ) : super.fromRef(ref);

  /// The type which includes information such as the signature of this class.
  static const type = $InputImage_ImageFormatType();

  /// Maps a specific port to the implemented interface.
  static final Map<int, $InputImage_ImageFormatImpl> _$impls = {};
  ReceivePort? _$p;

  static jni.JObjectPtr _$invoke(
    int port,
    jni.JObjectPtr descriptor,
    jni.JObjectPtr args,
  ) {
    return _$invokeMethod(
      port,
      $MethodInvocation.fromAddresses(
        0,
        descriptor.address,
        args.address,
      ),
    );
  }

  static final ffi.Pointer<
          ffi.NativeFunction<
              jni.JObjectPtr Function(
                  ffi.Uint64, jni.JObjectPtr, jni.JObjectPtr)>>
      _$invokePointer = ffi.Pointer.fromFunction(_$invoke);

  static ffi.Pointer<ffi.Void> _$invokeMethod(
    int $p,
    $MethodInvocation $i,
  ) {
    try {
      final $d = $i.methodDescriptor.toDartString(releaseOriginal: true);
      final $a = $i.args;
    } catch (e) {
      return ProtectedJniExtensions.newDartException(e.toString());
    }
    return jni.nullptr;
  }

  factory InputImage_ImageFormat.implement(
    $InputImage_ImageFormatImpl $impl,
  ) {
    final $p = ReceivePort();
    final $x = InputImage_ImageFormat.fromRef(
      ProtectedJniExtensions.newPortProxy(
        r"com.google.mlkit.vision.common.InputImage$ImageFormat",
        $p,
        _$invokePointer,
      ),
    ).._$p = $p;
    final $a = $p.sendPort.nativePort;
    _$impls[$a] = $impl;
    $p.listen(($m) {
      if ($m == null) {
        _$impls.remove($p.sendPort.nativePort);
        $p.close();
        return;
      }
      final $i = $MethodInvocation.fromMessage($m as List<dynamic>);
      final $r = _$invokeMethod($p.sendPort.nativePort, $i);
      ProtectedJniExtensions.returnResult($i.result, $r);
    });
    return $x;
  }
}

abstract class $InputImage_ImageFormatImpl {
  factory $InputImage_ImageFormatImpl() = _$InputImage_ImageFormatImpl;
}

class _$InputImage_ImageFormatImpl implements $InputImage_ImageFormatImpl {
  _$InputImage_ImageFormatImpl();
}

final class $InputImage_ImageFormatType
    extends jni.JObjType<InputImage_ImageFormat> {
  const $InputImage_ImageFormatType();

  @override
  String get signature =>
      r"Lcom/google/mlkit/vision/common/InputImage$ImageFormat;";

  @override
  InputImage_ImageFormat fromRef(jni.JObjectPtr ref) =>
      InputImage_ImageFormat.fromRef(ref);

  @override
  jni.JObjType get superType => const jni.JObjectType();

  @override
  final superCount = 1;

  @override
  int get hashCode => ($InputImage_ImageFormatType).hashCode;

  @override
  bool operator ==(Object other) {
    return other.runtimeType == ($InputImage_ImageFormatType) &&
        other is $InputImage_ImageFormatType;
  }
}

/// from: com.google.mlkit.vision.common.InputImage
class InputImage extends jni.JObject {
  @override
  late final jni.JObjType<InputImage> $type = type;

  InputImage.fromRef(
    jni.JObjectPtr ref,
  ) : super.fromRef(ref);

  /// The type which includes information such as the signature of this class.
  static const type = $InputImageType();

  /// from: static public final int IMAGE_FORMAT_NV21
  static const IMAGE_FORMAT_NV21 = 17;

  /// from: static public final int IMAGE_FORMAT_YV12
  static const IMAGE_FORMAT_YV12 = 842094169;

  /// from: static public final int IMAGE_FORMAT_BITMAP
  static const IMAGE_FORMAT_BITMAP = -1;

  /// from: static public final int IMAGE_FORMAT_YUV_420_888
  static const IMAGE_FORMAT_YUV_420_888 = 35;

  static final _getFormat = jniLookup<
              ffi
              .NativeFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>>(
          "InputImage__getFormat")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public int getFormat()
  int getFormat() {
    return _getFormat(reference).integer;
  }

  static final _getHeight = jniLookup<
              ffi
              .NativeFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>>(
          "InputImage__getHeight")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public int getHeight()
  int getHeight() {
    return _getHeight(reference).integer;
  }

  static final _getRotationDegrees = jniLookup<
              ffi
              .NativeFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>>(
          "InputImage__getRotationDegrees")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public int getRotationDegrees()
  int getRotationDegrees() {
    return _getRotationDegrees(reference).integer;
  }

  static final _getWidth = jniLookup<
              ffi
              .NativeFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>>(
          "InputImage__getWidth")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public int getWidth()
  int getWidth() {
    return _getWidth(reference).integer;
  }

  static final _getBitmapInternal = jniLookup<
              ffi
              .NativeFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>>(
          "InputImage__getBitmapInternal")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public android.graphics.Bitmap getBitmapInternal()
  /// The returned object must be released after use, by calling the [release] method.
  bitmap_.Bitmap getBitmapInternal() {
    return const bitmap_.$BitmapType()
        .fromRef(_getBitmapInternal(reference).object);
  }

  static final _getCoordinatesMatrix = jniLookup<
              ffi
              .NativeFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>>(
          "InputImage__getCoordinatesMatrix")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public android.graphics.Matrix getCoordinatesMatrix()
  /// The returned object must be released after use, by calling the [release] method.
  jni.JObject getCoordinatesMatrix() {
    return const jni.JObjectType()
        .fromRef(_getCoordinatesMatrix(reference).object);
  }

  static final _getMediaImage = jniLookup<
              ffi
              .NativeFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>>(
          "InputImage__getMediaImage")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public android.media.Image getMediaImage()
  /// The returned object must be released after use, by calling the [release] method.
  jni.JObject getMediaImage() {
    return const jni.JObjectType().fromRef(_getMediaImage(reference).object);
  }

  static final _fromBitmap = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                  ffi.Pointer<ffi.Void>, ffi.Int32)>>("InputImage__fromBitmap")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>, int)>();

  /// from: static public com.google.mlkit.vision.common.InputImage fromBitmap(android.graphics.Bitmap bitmap, int i)
  /// The returned object must be released after use, by calling the [release] method.
  static InputImage fromBitmap(
    bitmap_.Bitmap bitmap,
    int i,
  ) {
    return const $InputImageType()
        .fromRef(_fromBitmap(bitmap.reference, i).object);
  }

  static final _fromByteArray = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                  ffi.Pointer<ffi.Void>,
                  ffi.Int32,
                  ffi.Int32,
                  ffi.Int32,
                  ffi.Int32)>>("InputImage__fromByteArray")
      .asFunction<
          jni.JniResult Function(ffi.Pointer<ffi.Void>, int, int, int, int)>();

  /// from: static public com.google.mlkit.vision.common.InputImage fromByteArray(byte[] bs, int i, int i1, int i2, int i3)
  /// The returned object must be released after use, by calling the [release] method.
  static InputImage fromByteArray(
    jni.JArray<jni.jbyte> bs,
    int i,
    int i1,
    int i2,
    int i3,
  ) {
    return const $InputImageType()
        .fromRef(_fromByteArray(bs.reference, i, i1, i2, i3).object);
  }

  static final _fromByteBuffer = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                  ffi.Pointer<ffi.Void>,
                  ffi.Int32,
                  ffi.Int32,
                  ffi.Int32,
                  ffi.Int32)>>("InputImage__fromByteBuffer")
      .asFunction<
          jni.JniResult Function(ffi.Pointer<ffi.Void>, int, int, int, int)>();

  /// from: static public com.google.mlkit.vision.common.InputImage fromByteBuffer(java.nio.ByteBuffer byteBuffer, int i, int i1, int i2, int i3)
  /// The returned object must be released after use, by calling the [release] method.
  static InputImage fromByteBuffer(
    jni.JByteBuffer byteBuffer,
    int i,
    int i1,
    int i2,
    int i3,
  ) {
    return const $InputImageType()
        .fromRef(_fromByteBuffer(byteBuffer.reference, i, i1, i2, i3).object);
  }

  static final _fromFilePath = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>,
                  ffi.Pointer<ffi.Void>)>>("InputImage__fromFilePath")
      .asFunction<
          jni.JniResult Function(
              ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// from: static public com.google.mlkit.vision.common.InputImage fromFilePath(android.content.Context context, android.net.Uri uri)
  /// The returned object must be released after use, by calling the [release] method.
  static InputImage fromFilePath(
    jni.JObject context,
    uri_.Uri uri,
  ) {
    return const $InputImageType()
        .fromRef(_fromFilePath(context.reference, uri.reference).object);
  }

  static final _fromMediaImage = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>,
                  ffi.Int32)>>("InputImage__fromMediaImage")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>, int)>();

  /// from: static public com.google.mlkit.vision.common.InputImage fromMediaImage(android.media.Image image, int i)
  /// The returned object must be released after use, by calling the [release] method.
  static InputImage fromMediaImage(
    jni.JObject image,
    int i,
  ) {
    return const $InputImageType()
        .fromRef(_fromMediaImage(image.reference, i).object);
  }

  static final _fromMediaImage1 = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>, ffi.Int32,
                  ffi.Pointer<ffi.Void>)>>("InputImage__fromMediaImage1")
      .asFunction<
          jni.JniResult Function(
              ffi.Pointer<ffi.Void>, int, ffi.Pointer<ffi.Void>)>();

  /// from: static public com.google.mlkit.vision.common.InputImage fromMediaImage(android.media.Image image, int i, android.graphics.Matrix matrix)
  /// The returned object must be released after use, by calling the [release] method.
  static InputImage fromMediaImage1(
    jni.JObject image,
    int i,
    jni.JObject matrix,
  ) {
    return const $InputImageType()
        .fromRef(_fromMediaImage1(image.reference, i, matrix.reference).object);
  }

  static final _getByteBuffer = jniLookup<
              ffi
              .NativeFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>>(
          "InputImage__getByteBuffer")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public java.nio.ByteBuffer getByteBuffer()
  /// The returned object must be released after use, by calling the [release] method.
  jni.JByteBuffer getByteBuffer() {
    return const jni.JByteBufferType()
        .fromRef(_getByteBuffer(reference).object);
  }

  static final _getPlanes = jniLookup<
              ffi
              .NativeFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>>(
          "InputImage__getPlanes")
      .asFunction<jni.JniResult Function(ffi.Pointer<ffi.Void>)>();

  /// from: public android.media.Image$Plane[] getPlanes()
  /// The returned object must be released after use, by calling the [release] method.
  jni.JArray<jni.JObject> getPlanes() {
    return const jni.JArrayType(jni.JObjectType())
        .fromRef(_getPlanes(reference).object);
  }
}

final class $InputImageType extends jni.JObjType<InputImage> {
  const $InputImageType();

  @override
  String get signature => r"Lcom/google/mlkit/vision/common/InputImage;";

  @override
  InputImage fromRef(jni.JObjectPtr ref) => InputImage.fromRef(ref);

  @override
  jni.JObjType get superType => const jni.JObjectType();

  @override
  final superCount = 1;

  @override
  int get hashCode => ($InputImageType).hashCode;

  @override
  bool operator ==(Object other) {
    return other.runtimeType == ($InputImageType) && other is $InputImageType;
  }
}