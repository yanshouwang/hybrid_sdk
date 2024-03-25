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

import "../../../../../_init.dart";

/// from: com.google.android.gms.tasks.OnSuccessListener
class OnSuccessListener<$TResult extends jni.JObject> extends jni.JObject {
  @override
  late final jni.JObjType<OnSuccessListener<$TResult>> $type = type(TResult);

  final jni.JObjType<$TResult> TResult;

  OnSuccessListener.fromRef(
    this.TResult,
    jni.JObjectPtr ref,
  ) : super.fromRef(ref);

  /// The type which includes information such as the signature of this class.
  static $OnSuccessListenerType<$TResult> type<$TResult extends jni.JObject>(
    jni.JObjType<$TResult> TResult,
  ) {
    return $OnSuccessListenerType(
      TResult,
    );
  }

  static final _onSuccess = jniLookup<
          ffi.NativeFunction<
              jni.JniResult Function(ffi.Pointer<ffi.Void>,
                  ffi.Pointer<ffi.Void>)>>("OnSuccessListener__onSuccess")
      .asFunction<
          jni.JniResult Function(
              ffi.Pointer<ffi.Void>, ffi.Pointer<ffi.Void>)>();

  /// from: public abstract void onSuccess(TResult object)
  void onSuccess(
    $TResult object,
  ) {
    return _onSuccess(reference, object.reference).check();
  }

  /// Maps a specific port to the implemented interface.
  static final Map<int, $OnSuccessListenerImpl> _$impls = {};
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
      if ($d == r"onSuccess(Ljava/lang/Object;)V") {
        _$impls[$p]!.onSuccess(
          $a[0].castTo(_$impls[$p]!.TResult, releaseOriginal: true),
        );
        return jni.nullptr;
      }
    } catch (e) {
      return ProtectedJniExtensions.newDartException(e.toString());
    }
    return jni.nullptr;
  }

  factory OnSuccessListener.implement(
    $OnSuccessListenerImpl<$TResult> $impl,
  ) {
    final $p = ReceivePort();
    final $x = OnSuccessListener.fromRef(
      $impl.TResult,
      ProtectedJniExtensions.newPortProxy(
        r"com.google.android.gms.tasks.OnSuccessListener",
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

abstract class $OnSuccessListenerImpl<$TResult extends jni.JObject> {
  factory $OnSuccessListenerImpl({
    required jni.JObjType<$TResult> TResult,
    required void Function($TResult object) onSuccess,
  }) = _$OnSuccessListenerImpl;

  jni.JObjType<$TResult> get TResult;

  void onSuccess($TResult object);
}

class _$OnSuccessListenerImpl<$TResult extends jni.JObject>
    implements $OnSuccessListenerImpl<$TResult> {
  _$OnSuccessListenerImpl({
    required this.TResult,
    required void Function($TResult object) onSuccess,
  }) : _onSuccess = onSuccess;

  @override
  final jni.JObjType<$TResult> TResult;

  final void Function($TResult object) _onSuccess;

  void onSuccess($TResult object) {
    return _onSuccess(object);
  }
}

final class $OnSuccessListenerType<$TResult extends jni.JObject>
    extends jni.JObjType<OnSuccessListener<$TResult>> {
  final jni.JObjType<$TResult> TResult;

  const $OnSuccessListenerType(
    this.TResult,
  );

  @override
  String get signature => r"Lcom/google/android/gms/tasks/OnSuccessListener;";

  @override
  OnSuccessListener<$TResult> fromRef(jni.JObjectPtr ref) =>
      OnSuccessListener.fromRef(TResult, ref);

  @override
  jni.JObjType get superType => const jni.JObjectType();

  @override
  final superCount = 1;

  @override
  int get hashCode => Object.hash($OnSuccessListenerType, TResult);

  @override
  bool operator ==(Object other) {
    return other.runtimeType == ($OnSuccessListenerType<$TResult>) &&
        other is $OnSuccessListenerType<$TResult> &&
        TResult == other.TResult;
  }
}