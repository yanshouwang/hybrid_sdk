// Autogenerated by jnigen. DO NOT EDIT!

// ignore_for_file: annotate_overrides
// ignore_for_file: camel_case_extensions
// ignore_for_file: camel_case_types
// ignore_for_file: constant_identifier_names
// ignore_for_file: doc_directive_unknown
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
// ignore_for_file: use_super_parameters

import "dart:isolate" show ReceivePort;
import "dart:ffi" as ffi;
import "package:jni/internal_helpers_for_jnigen.dart";
import "package:jni/jni.dart" as jni;

/// from: android.os.Build$Partition
class Build_Partition extends jni.JObject {
  @override
  late final jni.JObjType<Build_Partition> $type = type;

  Build_Partition.fromReference(
    jni.JReference reference,
  ) : super.fromReference(reference);

  static final _class = jni.JClass.forName(r"android/os/Build$Partition");

  /// The type which includes information such as the signature of this class.
  static const type = $Build_PartitionType();
  static final _id_PARTITION_NAME_SYSTEM = _class.staticFieldId(
    r"PARTITION_NAME_SYSTEM",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String PARTITION_NAME_SYSTEM
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get PARTITION_NAME_SYSTEM =>
      _id_PARTITION_NAME_SYSTEM.get(_class, const jni.JStringType());

  static final _id_getName = _class.instanceMethodId(
    r"getName",
    r"()Ljava/lang/String;",
  );

  static final _getName = ProtectedJniExtensions.lookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                ffi.Pointer<ffi.Void>,
                jni.JMethodIDPtr,
              )>>("globalEnv_CallObjectMethod")
      .asFunction<
          jni.JniResult Function(
            ffi.Pointer<ffi.Void>,
            jni.JMethodIDPtr,
          )>();

  /// from: public java.lang.String getName()
  /// The returned object must be released after use, by calling the [release] method.
  jni.JString getName() {
    return _getName(reference.pointer, _id_getName as jni.JMethodIDPtr)
        .object(const jni.JStringType());
  }

  static final _id_getFingerprint = _class.instanceMethodId(
    r"getFingerprint",
    r"()Ljava/lang/String;",
  );

  static final _getFingerprint = ProtectedJniExtensions.lookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                ffi.Pointer<ffi.Void>,
                jni.JMethodIDPtr,
              )>>("globalEnv_CallObjectMethod")
      .asFunction<
          jni.JniResult Function(
            ffi.Pointer<ffi.Void>,
            jni.JMethodIDPtr,
          )>();

  /// from: public java.lang.String getFingerprint()
  /// The returned object must be released after use, by calling the [release] method.
  jni.JString getFingerprint() {
    return _getFingerprint(
            reference.pointer, _id_getFingerprint as jni.JMethodIDPtr)
        .object(const jni.JStringType());
  }

  static final _id_getBuildTimeMillis = _class.instanceMethodId(
    r"getBuildTimeMillis",
    r"()J",
  );

  static final _getBuildTimeMillis = ProtectedJniExtensions.lookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                ffi.Pointer<ffi.Void>,
                jni.JMethodIDPtr,
              )>>("globalEnv_CallLongMethod")
      .asFunction<
          jni.JniResult Function(
            ffi.Pointer<ffi.Void>,
            jni.JMethodIDPtr,
          )>();

  /// from: public long getBuildTimeMillis()
  int getBuildTimeMillis() {
    return _getBuildTimeMillis(
            reference.pointer, _id_getBuildTimeMillis as jni.JMethodIDPtr)
        .long;
  }

  static final _id_equals = _class.instanceMethodId(
    r"equals",
    r"(Ljava/lang/Object;)Z",
  );

  static final _equals = ProtectedJniExtensions.lookup<
              ffi.NativeFunction<
                  jni.JniResult Function(
                      ffi.Pointer<ffi.Void>,
                      jni.JMethodIDPtr,
                      ffi.VarArgs<(ffi.Pointer<ffi.Void>,)>)>>(
          "globalEnv_CallBooleanMethod")
      .asFunction<
          jni.JniResult Function(ffi.Pointer<ffi.Void>, jni.JMethodIDPtr,
              ffi.Pointer<ffi.Void>)>();

  /// from: public boolean equals(java.lang.Object object)
  bool equals(
    jni.JObject object,
  ) {
    return _equals(reference.pointer, _id_equals as jni.JMethodIDPtr,
            object.reference.pointer)
        .boolean;
  }

  static final _id_hashCode1 = _class.instanceMethodId(
    r"hashCode",
    r"()I",
  );

  static final _hashCode1 = ProtectedJniExtensions.lookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                ffi.Pointer<ffi.Void>,
                jni.JMethodIDPtr,
              )>>("globalEnv_CallIntMethod")
      .asFunction<
          jni.JniResult Function(
            ffi.Pointer<ffi.Void>,
            jni.JMethodIDPtr,
          )>();

  /// from: public int hashCode()
  int hashCode1() {
    return _hashCode1(reference.pointer, _id_hashCode1 as jni.JMethodIDPtr)
        .integer;
  }
}

final class $Build_PartitionType extends jni.JObjType<Build_Partition> {
  const $Build_PartitionType();

  @override
  String get signature => r"Landroid/os/Build$Partition;";

  @override
  Build_Partition fromReference(jni.JReference reference) =>
      Build_Partition.fromReference(reference);

  @override
  jni.JObjType get superType => const jni.JObjectType();

  @override
  final superCount = 1;

  @override
  int get hashCode => ($Build_PartitionType).hashCode;

  @override
  bool operator ==(Object other) {
    return other.runtimeType == ($Build_PartitionType) &&
        other is $Build_PartitionType;
  }
}

/// from: android.os.Build$VERSION
class Build_VERSION extends jni.JObject {
  @override
  late final jni.JObjType<Build_VERSION> $type = type;

  Build_VERSION.fromReference(
    jni.JReference reference,
  ) : super.fromReference(reference);

  static final _class = jni.JClass.forName(r"android/os/Build$VERSION");

  /// The type which includes information such as the signature of this class.
  static const type = $Build_VERSIONType();
  static final _id_BASE_OS = _class.staticFieldId(
    r"BASE_OS",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String BASE_OS
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get BASE_OS =>
      _id_BASE_OS.get(_class, const jni.JStringType());

  static final _id_CODENAME = _class.staticFieldId(
    r"CODENAME",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String CODENAME
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get CODENAME =>
      _id_CODENAME.get(_class, const jni.JStringType());

  static final _id_INCREMENTAL = _class.staticFieldId(
    r"INCREMENTAL",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String INCREMENTAL
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get INCREMENTAL =>
      _id_INCREMENTAL.get(_class, const jni.JStringType());

  static final _id_MEDIA_PERFORMANCE_CLASS = _class.staticFieldId(
    r"MEDIA_PERFORMANCE_CLASS",
    r"I",
  );

  /// from: static public final int MEDIA_PERFORMANCE_CLASS
  static int get MEDIA_PERFORMANCE_CLASS =>
      _id_MEDIA_PERFORMANCE_CLASS.get(_class, const jni.jintType());

  static final _id_PREVIEW_SDK_INT = _class.staticFieldId(
    r"PREVIEW_SDK_INT",
    r"I",
  );

  /// from: static public final int PREVIEW_SDK_INT
  static int get PREVIEW_SDK_INT =>
      _id_PREVIEW_SDK_INT.get(_class, const jni.jintType());

  static final _id_RELEASE = _class.staticFieldId(
    r"RELEASE",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String RELEASE
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get RELEASE =>
      _id_RELEASE.get(_class, const jni.JStringType());

  static final _id_RELEASE_OR_CODENAME = _class.staticFieldId(
    r"RELEASE_OR_CODENAME",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String RELEASE_OR_CODENAME
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get RELEASE_OR_CODENAME =>
      _id_RELEASE_OR_CODENAME.get(_class, const jni.JStringType());

  static final _id_RELEASE_OR_PREVIEW_DISPLAY = _class.staticFieldId(
    r"RELEASE_OR_PREVIEW_DISPLAY",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String RELEASE_OR_PREVIEW_DISPLAY
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get RELEASE_OR_PREVIEW_DISPLAY =>
      _id_RELEASE_OR_PREVIEW_DISPLAY.get(_class, const jni.JStringType());

  static final _id_SDK = _class.staticFieldId(
    r"SDK",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String SDK
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get SDK => _id_SDK.get(_class, const jni.JStringType());

  static final _id_SDK_INT = _class.staticFieldId(
    r"SDK_INT",
    r"I",
  );

  /// from: static public final int SDK_INT
  static int get SDK_INT => _id_SDK_INT.get(_class, const jni.jintType());

  static final _id_SECURITY_PATCH = _class.staticFieldId(
    r"SECURITY_PATCH",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String SECURITY_PATCH
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get SECURITY_PATCH =>
      _id_SECURITY_PATCH.get(_class, const jni.JStringType());

  static final _id_new0 = _class.constructorId(
    r"()V",
  );

  static final _new0 = ProtectedJniExtensions.lookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                ffi.Pointer<ffi.Void>,
                jni.JMethodIDPtr,
              )>>("globalEnv_NewObject")
      .asFunction<
          jni.JniResult Function(
            ffi.Pointer<ffi.Void>,
            jni.JMethodIDPtr,
          )>();

  /// from: public void <init>()
  /// The returned object must be released after use, by calling the [release] method.
  factory Build_VERSION() {
    return Build_VERSION.fromReference(
        _new0(_class.reference.pointer, _id_new0 as jni.JMethodIDPtr)
            .reference);
  }
}

final class $Build_VERSIONType extends jni.JObjType<Build_VERSION> {
  const $Build_VERSIONType();

  @override
  String get signature => r"Landroid/os/Build$VERSION;";

  @override
  Build_VERSION fromReference(jni.JReference reference) =>
      Build_VERSION.fromReference(reference);

  @override
  jni.JObjType get superType => const jni.JObjectType();

  @override
  final superCount = 1;

  @override
  int get hashCode => ($Build_VERSIONType).hashCode;

  @override
  bool operator ==(Object other) {
    return other.runtimeType == ($Build_VERSIONType) &&
        other is $Build_VERSIONType;
  }
}

/// from: android.os.Build$VERSION_CODES
class Build_VERSION_CODES extends jni.JObject {
  @override
  late final jni.JObjType<Build_VERSION_CODES> $type = type;

  Build_VERSION_CODES.fromReference(
    jni.JReference reference,
  ) : super.fromReference(reference);

  static final _class = jni.JClass.forName(r"android/os/Build$VERSION_CODES");

  /// The type which includes information such as the signature of this class.
  static const type = $Build_VERSION_CODESType();

  /// from: static public final int BASE
  static const BASE = 1;

  /// from: static public final int BASE_1_1
  static const BASE_1_1 = 2;

  /// from: static public final int CUPCAKE
  static const CUPCAKE = 3;

  /// from: static public final int CUR_DEVELOPMENT
  static const CUR_DEVELOPMENT = 10000;

  /// from: static public final int DONUT
  static const DONUT = 4;

  /// from: static public final int ECLAIR
  static const ECLAIR = 5;

  /// from: static public final int ECLAIR_0_1
  static const ECLAIR_0_1 = 6;

  /// from: static public final int ECLAIR_MR1
  static const ECLAIR_MR1 = 7;

  /// from: static public final int FROYO
  static const FROYO = 8;

  /// from: static public final int GINGERBREAD
  static const GINGERBREAD = 9;

  /// from: static public final int GINGERBREAD_MR1
  static const GINGERBREAD_MR1 = 10;

  /// from: static public final int HONEYCOMB
  static const HONEYCOMB = 11;

  /// from: static public final int HONEYCOMB_MR1
  static const HONEYCOMB_MR1 = 12;

  /// from: static public final int HONEYCOMB_MR2
  static const HONEYCOMB_MR2 = 13;

  /// from: static public final int ICE_CREAM_SANDWICH
  static const ICE_CREAM_SANDWICH = 14;

  /// from: static public final int ICE_CREAM_SANDWICH_MR1
  static const ICE_CREAM_SANDWICH_MR1 = 15;

  /// from: static public final int JELLY_BEAN
  static const JELLY_BEAN = 16;

  /// from: static public final int JELLY_BEAN_MR1
  static const JELLY_BEAN_MR1 = 17;

  /// from: static public final int JELLY_BEAN_MR2
  static const JELLY_BEAN_MR2 = 18;

  /// from: static public final int KITKAT
  static const KITKAT = 19;

  /// from: static public final int KITKAT_WATCH
  static const KITKAT_WATCH = 20;

  /// from: static public final int LOLLIPOP
  static const LOLLIPOP = 21;

  /// from: static public final int LOLLIPOP_MR1
  static const LOLLIPOP_MR1 = 22;

  /// from: static public final int M
  static const M = 23;

  /// from: static public final int N
  static const N = 24;

  /// from: static public final int N_MR1
  static const N_MR1 = 25;

  /// from: static public final int O
  static const O = 26;

  /// from: static public final int O_MR1
  static const O_MR1 = 27;

  /// from: static public final int P
  static const P = 28;

  /// from: static public final int Q
  static const Q = 29;

  /// from: static public final int R
  static const R = 30;

  /// from: static public final int S
  static const S = 31;

  /// from: static public final int S_V2
  static const S_V2 = 32;

  /// from: static public final int TIRAMISU
  static const TIRAMISU = 33;

  /// from: static public final int UPSIDE_DOWN_CAKE
  static const UPSIDE_DOWN_CAKE = 34;
  static final _id_new0 = _class.constructorId(
    r"()V",
  );

  static final _new0 = ProtectedJniExtensions.lookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                ffi.Pointer<ffi.Void>,
                jni.JMethodIDPtr,
              )>>("globalEnv_NewObject")
      .asFunction<
          jni.JniResult Function(
            ffi.Pointer<ffi.Void>,
            jni.JMethodIDPtr,
          )>();

  /// from: public void <init>()
  /// The returned object must be released after use, by calling the [release] method.
  factory Build_VERSION_CODES() {
    return Build_VERSION_CODES.fromReference(
        _new0(_class.reference.pointer, _id_new0 as jni.JMethodIDPtr)
            .reference);
  }
}

final class $Build_VERSION_CODESType extends jni.JObjType<Build_VERSION_CODES> {
  const $Build_VERSION_CODESType();

  @override
  String get signature => r"Landroid/os/Build$VERSION_CODES;";

  @override
  Build_VERSION_CODES fromReference(jni.JReference reference) =>
      Build_VERSION_CODES.fromReference(reference);

  @override
  jni.JObjType get superType => const jni.JObjectType();

  @override
  final superCount = 1;

  @override
  int get hashCode => ($Build_VERSION_CODESType).hashCode;

  @override
  bool operator ==(Object other) {
    return other.runtimeType == ($Build_VERSION_CODESType) &&
        other is $Build_VERSION_CODESType;
  }
}

/// from: android.os.Build
class Build extends jni.JObject {
  @override
  late final jni.JObjType<Build> $type = type;

  Build.fromReference(
    jni.JReference reference,
  ) : super.fromReference(reference);

  static final _class = jni.JClass.forName(r"android/os/Build");

  /// The type which includes information such as the signature of this class.
  static const type = $BuildType();
  static final _id_BOARD = _class.staticFieldId(
    r"BOARD",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String BOARD
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get BOARD =>
      _id_BOARD.get(_class, const jni.JStringType());

  static final _id_BOOTLOADER = _class.staticFieldId(
    r"BOOTLOADER",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String BOOTLOADER
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get BOOTLOADER =>
      _id_BOOTLOADER.get(_class, const jni.JStringType());

  static final _id_BRAND = _class.staticFieldId(
    r"BRAND",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String BRAND
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get BRAND =>
      _id_BRAND.get(_class, const jni.JStringType());

  static final _id_CPU_ABI = _class.staticFieldId(
    r"CPU_ABI",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String CPU_ABI
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get CPU_ABI =>
      _id_CPU_ABI.get(_class, const jni.JStringType());

  static final _id_CPU_ABI2 = _class.staticFieldId(
    r"CPU_ABI2",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String CPU_ABI2
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get CPU_ABI2 =>
      _id_CPU_ABI2.get(_class, const jni.JStringType());

  static final _id_DEVICE = _class.staticFieldId(
    r"DEVICE",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String DEVICE
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get DEVICE =>
      _id_DEVICE.get(_class, const jni.JStringType());

  static final _id_DISPLAY = _class.staticFieldId(
    r"DISPLAY",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String DISPLAY
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get DISPLAY =>
      _id_DISPLAY.get(_class, const jni.JStringType());

  static final _id_FINGERPRINT = _class.staticFieldId(
    r"FINGERPRINT",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String FINGERPRINT
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get FINGERPRINT =>
      _id_FINGERPRINT.get(_class, const jni.JStringType());

  static final _id_HARDWARE = _class.staticFieldId(
    r"HARDWARE",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String HARDWARE
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get HARDWARE =>
      _id_HARDWARE.get(_class, const jni.JStringType());

  static final _id_HOST = _class.staticFieldId(
    r"HOST",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String HOST
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get HOST => _id_HOST.get(_class, const jni.JStringType());

  static final _id_ID = _class.staticFieldId(
    r"ID",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String ID
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get ID => _id_ID.get(_class, const jni.JStringType());

  static final _id_MANUFACTURER = _class.staticFieldId(
    r"MANUFACTURER",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String MANUFACTURER
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get MANUFACTURER =>
      _id_MANUFACTURER.get(_class, const jni.JStringType());

  static final _id_MODEL = _class.staticFieldId(
    r"MODEL",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String MODEL
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get MODEL =>
      _id_MODEL.get(_class, const jni.JStringType());

  static final _id_ODM_SKU = _class.staticFieldId(
    r"ODM_SKU",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String ODM_SKU
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get ODM_SKU =>
      _id_ODM_SKU.get(_class, const jni.JStringType());

  static final _id_PRODUCT = _class.staticFieldId(
    r"PRODUCT",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String PRODUCT
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get PRODUCT =>
      _id_PRODUCT.get(_class, const jni.JStringType());

  static final _id_RADIO = _class.staticFieldId(
    r"RADIO",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String RADIO
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get RADIO =>
      _id_RADIO.get(_class, const jni.JStringType());

  static final _id_SERIAL = _class.staticFieldId(
    r"SERIAL",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String SERIAL
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get SERIAL =>
      _id_SERIAL.get(_class, const jni.JStringType());

  static final _id_SKU = _class.staticFieldId(
    r"SKU",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String SKU
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get SKU => _id_SKU.get(_class, const jni.JStringType());

  static final _id_SOC_MANUFACTURER = _class.staticFieldId(
    r"SOC_MANUFACTURER",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String SOC_MANUFACTURER
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get SOC_MANUFACTURER =>
      _id_SOC_MANUFACTURER.get(_class, const jni.JStringType());

  static final _id_SOC_MODEL = _class.staticFieldId(
    r"SOC_MODEL",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String SOC_MODEL
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get SOC_MODEL =>
      _id_SOC_MODEL.get(_class, const jni.JStringType());

  static final _id_SUPPORTED_32_BIT_ABIS = _class.staticFieldId(
    r"SUPPORTED_32_BIT_ABIS",
    r"[Ljava/lang/String;",
  );

  /// from: static public final java.lang.String[] SUPPORTED_32_BIT_ABIS
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JArray<jni.JString> get SUPPORTED_32_BIT_ABIS =>
      _id_SUPPORTED_32_BIT_ABIS.get(
          _class, const jni.JArrayType(jni.JStringType()));

  static final _id_SUPPORTED_64_BIT_ABIS = _class.staticFieldId(
    r"SUPPORTED_64_BIT_ABIS",
    r"[Ljava/lang/String;",
  );

  /// from: static public final java.lang.String[] SUPPORTED_64_BIT_ABIS
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JArray<jni.JString> get SUPPORTED_64_BIT_ABIS =>
      _id_SUPPORTED_64_BIT_ABIS.get(
          _class, const jni.JArrayType(jni.JStringType()));

  static final _id_SUPPORTED_ABIS = _class.staticFieldId(
    r"SUPPORTED_ABIS",
    r"[Ljava/lang/String;",
  );

  /// from: static public final java.lang.String[] SUPPORTED_ABIS
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JArray<jni.JString> get SUPPORTED_ABIS =>
      _id_SUPPORTED_ABIS.get(_class, const jni.JArrayType(jni.JStringType()));

  static final _id_TAGS = _class.staticFieldId(
    r"TAGS",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String TAGS
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get TAGS => _id_TAGS.get(_class, const jni.JStringType());

  static final _id_TIME = _class.staticFieldId(
    r"TIME",
    r"J",
  );

  /// from: static public final long TIME
  static int get TIME => _id_TIME.get(_class, const jni.jlongType());

  static final _id_TYPE = _class.staticFieldId(
    r"TYPE",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String TYPE
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get TYPE => _id_TYPE.get(_class, const jni.JStringType());

  static final _id_UNKNOWN = _class.staticFieldId(
    r"UNKNOWN",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String UNKNOWN
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get UNKNOWN =>
      _id_UNKNOWN.get(_class, const jni.JStringType());

  static final _id_USER = _class.staticFieldId(
    r"USER",
    r"Ljava/lang/String;",
  );

  /// from: static public final java.lang.String USER
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString get USER => _id_USER.get(_class, const jni.JStringType());

  static final _id_new0 = _class.constructorId(
    r"()V",
  );

  static final _new0 = ProtectedJniExtensions.lookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                ffi.Pointer<ffi.Void>,
                jni.JMethodIDPtr,
              )>>("globalEnv_NewObject")
      .asFunction<
          jni.JniResult Function(
            ffi.Pointer<ffi.Void>,
            jni.JMethodIDPtr,
          )>();

  /// from: public void <init>()
  /// The returned object must be released after use, by calling the [release] method.
  factory Build() {
    return Build.fromReference(
        _new0(_class.reference.pointer, _id_new0 as jni.JMethodIDPtr)
            .reference);
  }

  static final _id_getSerial = _class.staticMethodId(
    r"getSerial",
    r"()Ljava/lang/String;",
  );

  static final _getSerial = ProtectedJniExtensions.lookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                ffi.Pointer<ffi.Void>,
                jni.JMethodIDPtr,
              )>>("globalEnv_CallStaticObjectMethod")
      .asFunction<
          jni.JniResult Function(
            ffi.Pointer<ffi.Void>,
            jni.JMethodIDPtr,
          )>();

  /// from: static public java.lang.String getSerial()
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString getSerial() {
    return _getSerial(
            _class.reference.pointer, _id_getSerial as jni.JMethodIDPtr)
        .object(const jni.JStringType());
  }

  static final _id_getFingerprintedPartitions = _class.staticMethodId(
    r"getFingerprintedPartitions",
    r"()Ljava/util/List;",
  );

  static final _getFingerprintedPartitions = ProtectedJniExtensions.lookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                ffi.Pointer<ffi.Void>,
                jni.JMethodIDPtr,
              )>>("globalEnv_CallStaticObjectMethod")
      .asFunction<
          jni.JniResult Function(
            ffi.Pointer<ffi.Void>,
            jni.JMethodIDPtr,
          )>();

  /// from: static public java.util.List getFingerprintedPartitions()
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JList<Build_Partition> getFingerprintedPartitions() {
    return _getFingerprintedPartitions(_class.reference.pointer,
            _id_getFingerprintedPartitions as jni.JMethodIDPtr)
        .object(const jni.JListType($Build_PartitionType()));
  }

  static final _id_getRadioVersion = _class.staticMethodId(
    r"getRadioVersion",
    r"()Ljava/lang/String;",
  );

  static final _getRadioVersion = ProtectedJniExtensions.lookup<
          ffi.NativeFunction<
              jni.JniResult Function(
                ffi.Pointer<ffi.Void>,
                jni.JMethodIDPtr,
              )>>("globalEnv_CallStaticObjectMethod")
      .asFunction<
          jni.JniResult Function(
            ffi.Pointer<ffi.Void>,
            jni.JMethodIDPtr,
          )>();

  /// from: static public java.lang.String getRadioVersion()
  /// The returned object must be released after use, by calling the [release] method.
  static jni.JString getRadioVersion() {
    return _getRadioVersion(
            _class.reference.pointer, _id_getRadioVersion as jni.JMethodIDPtr)
        .object(const jni.JStringType());
  }
}

final class $BuildType extends jni.JObjType<Build> {
  const $BuildType();

  @override
  String get signature => r"Landroid/os/Build;";

  @override
  Build fromReference(jni.JReference reference) =>
      Build.fromReference(reference);

  @override
  jni.JObjType get superType => const jni.JObjectType();

  @override
  final superCount = 1;

  @override
  int get hashCode => ($BuildType).hashCode;

  @override
  bool operator ==(Object other) {
    return other.runtimeType == ($BuildType) && other is $BuildType;
  }
}