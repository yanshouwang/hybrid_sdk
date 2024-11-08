import 'package:hybrid_os_android/src/screen_brightness_mode.dart';

import 'android.dart';
import 'jni.dart' as jni;

final class AndroidImpl implements Android {
  static AndroidImpl? _instance;

  factory AndroidImpl() {
    var instance = _instance;
    if (instance == null) {
      _instance = instance = AndroidImpl._();
    }
    return instance;
  }

  AndroidImpl._();

  @override
  String get baseOS => jni.Build_VERSION.BASE_OS.toDartString();

  @override
  String get codename => jni.Build_VERSION.CODENAME.toDartString();

  @override
  String get incremental => jni.Build_VERSION.INCREMENTAL.toDartString();

  @override
  int get mediaPerformanceClass => jni.Build_VERSION.MEDIA_PERFORMANCE_CLASS;

  @override
  int get previewSDK => jni.Build_VERSION.PREVIEW_SDK_INT;

  @override
  String get release => jni.Build_VERSION.RELEASE.toDartString();

  @override
  String get releaseOrCodename =>
      jni.Build_VERSION.RELEASE_OR_CODENAME.toDartString();

  @override
  String get releaseOrPreviewDisplay =>
      jni.Build_VERSION.RELEASE_OR_PREVIEW_DISPLAY.toDartString();

  @override
  int get sdk => jni.Build_VERSION.SDK_INT;

  @override
  String get securityPatch => jni.Build_VERSION.SECURITY_PATCH.toDartString();

  @override
  int get screenBrightness {
    final contentResolver = jni.Env.context.getContentResolver();
    return jni.Settings_System.getInt1(
        contentResolver, jni.Settings_System.SCREEN_BRIGHTNESS);
  }

  @override
  set screenBrightness(int value) {
    final contentResolver = jni.Env.context.getContentResolver();
    jni.Settings_System.putInt(
        contentResolver, jni.Settings_System.SCREEN_BRIGHTNESS, value);
  }

  @override
  ScreenBrightnessMode get screenBrightnessMode {
    final contentResolver = jni.Env.context.getContentResolver();
    final value = jni.Settings_System.getInt1(
        contentResolver, jni.Settings_System.SCREEN_BRIGHTNESS_MODE);
    return ScreenBrightnessMode.fromValue(value);
  }

  @override
  set screenBrightnessMode(ScreenBrightnessMode value) {
    final contentResolver = jni.Env.context.getContentResolver();
    jni.Settings_System.putInt(contentResolver,
        jni.Settings_System.SCREEN_BRIGHTNESS_MODE, value.value);
  }
}
