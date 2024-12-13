import 'dart:async';
import 'dart:ui';

import 'package:jni/jni.dart' as jni;

import 'android.dart';
import 'jni.dart' as jni;
import 'screen_brightness_mode.dart';
import 'settings.dart';
import 'window.dart';
import 'window_attributes.dart';

final class AndroidImpl implements Android {
  Settings? _settings;
  Window? _window;

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
  Settings get settings {
    var settings = _settings;
    if (settings == null) {
      _settings = settings = SettingsImpl();
    }
    return settings;
  }

  @override
  Window get window {
    var window = _window;
    if (window == null) {
      final jWindow = jni.activity.getWindow();
      _window = window = WindowImpl(jWindow);
    }
    return window;
  }

  @override
  Future<void> startManageWriteSettingsActivity() {
    final packageName = jni.context.getPackageName().toDartString(
          releaseOriginal: true,
        );
    final uriString = jni.JString.fromString("package:$packageName");
    final uri = jni.Uri.parse(uriString);
    final intent = jni.Intent.new$2(jni.Settings.ACTION_MANAGE_WRITE_SETTINGS)
        .setData(uri);
    final completer = Completer<void>();
    final callback = jni.AndroidImpl_StartActivityCallback.implement(
      jni.$AndroidImpl_StartActivityCallback(
        onActivityResult: () => completer.complete(),
      ),
    );
    jni.AndroidImpl.INSTANCE.startActivity(intent, callback);
    return completer.future;
  }
}

final class SettingsImpl implements Settings {
  final jni.ContentResolver contentResolver;

  late final StreamController<ScreenBrightnessMode>
      brightnessModeChangedController;
  late final StreamController<int> brightnessChangedController;

  jni.ContentObserver? brightnessModeObserver;
  jni.ContentObserver? brightnessObserver;

  SettingsImpl() : contentResolver = jni.context.getContentResolver() {
    brightnessModeChangedController = StreamController.broadcast(
      onListen: onListenBrightnessModeChanged,
      onCancel: onCancelBrightnessModeChanged,
    );
    brightnessChangedController = StreamController.broadcast(
      onListen: onListenBrightnessChanged,
      onCancel: onCancelBrightnessChanged,
    );
  }

  @override
  bool get canWrite => jni.Settings_System.canWrite(jni.context);

  @override
  ScreenBrightnessMode get brightnessMode {
    final contentResolver = jni.context.getContentResolver();
    final value = jni.Settings_System.getInt$1(
        contentResolver, jni.Settings_System.SCREEN_BRIGHTNESS_MODE);
    return ScreenBrightnessMode.fromValue(value);
  }

  @override
  set brightnessMode(ScreenBrightnessMode value) {
    final contentResolver = jni.context.getContentResolver();
    jni.Settings_System.putInt(contentResolver,
        jni.Settings_System.SCREEN_BRIGHTNESS_MODE, value.value);
  }

  @override
  int get brightness {
    final contentResolver = jni.context.getContentResolver();
    return jni.Settings_System.getInt$1(
        contentResolver, jni.Settings_System.SCREEN_BRIGHTNESS);
  }

  @override
  set brightness(int value) {
    final contentResolver = jni.context.getContentResolver();
    jni.Settings_System.putInt(
        contentResolver, jni.Settings_System.SCREEN_BRIGHTNESS, value);
  }

  @override
  Stream<ScreenBrightnessMode> get brightnessModeChanged =>
      brightnessModeChangedController.stream;
  @override
  Stream<int> get brightnessChanged => brightnessChangedController.stream;

  void onListenBrightnessModeChanged() {
    final uri = jni.Settings_System.getUriFor$1(
        jni.Settings_System.SCREEN_BRIGHTNESS_MODE);
    final looper = jni.Looper.getMainLooper();
    final handler = jni.Handler.new$2(looper);
    final callback = jni.ContentObserverImpl_ChangeCallback.implement(
      jni.$ContentObserverImpl_ChangeCallback(
        onChange: () => brightnessModeChangedController.add(brightnessMode),
      ),
    );
    final observer = jni.ContentObserverImpl(handler, callback);
    contentResolver.registerContentObserver(uri, false, observer);
    brightnessModeObserver = observer;
  }

  void onCancelBrightnessModeChanged() {
    final observer = ArgumentError.checkNotNull(brightnessModeObserver);
    contentResolver.unregisterContentObserver(observer);
  }

  void onListenBrightnessChanged() {
    final uri =
        jni.Settings_System.getUriFor$1(jni.Settings_System.SCREEN_BRIGHTNESS);
    final looper = jni.Looper.getMainLooper();
    final handler = jni.Handler.new$2(looper);
    final callback = jni.ContentObserverImpl_ChangeCallback.implement(
      jni.$ContentObserverImpl_ChangeCallback(
        onChange: () => brightnessChangedController.add(brightness),
      ),
    );
    final observer = jni.ContentObserverImpl(handler, callback);
    contentResolver.registerContentObserver(uri, false, observer);
    brightnessObserver = observer;
  }

  void onCancelBrightnessChanged() {
    final observer = ArgumentError.checkNotNull(brightnessObserver);
    contentResolver.unregisterContentObserver(observer);
  }
}

final class WindowImpl implements Window {
  final jni.Window jWindow;

  late final StreamController<WindowAttributes> attrsChangedController;

  WindowImpl(this.jWindow) {
    attrsChangedController = StreamController.broadcast(
      onListen: onListenAttrsChanged,
      onCancel: onCancelAttrsChanged,
    );
  }

  @override
  WindowAttributes get attrs {
    final jAttributes = jWindow.getAttributes();
    return WindowAttributesImpl(jAttributes);
  }

  @override
  set attrs(WindowAttributes value) {
    if (value is! WindowAttributesImpl) {
      throw TypeError();
    }
    runOnPlatformThread(() {
      jWindow.setAttributes(value.jParams);
    });
  }

  @override
  Stream<WindowAttributes> get attrsChanged => attrsChangedController.stream;

  void onListenAttrsChanged() {
    final callback1 = jni.Window_Callback.implement(
      jni.$Window_Callback(
        dispatchKeyEvent: (event) => false,
        dispatchKeyShortcutEvent: (event) => false,
        dispatchTouchEvent: (event) => false,
        dispatchTrackballEvent: (event) => false,
        dispatchGenericMotionEvent: (event) => false,
        dispatchPopulateAccessibilityEvent: (event) => false,
        onCreatePanelView: (id) =>
            jni.JObject.fromReference(jni.jNullReference),
        onCreatePanelMenu: (id, menu) => false,
        onPreparePanel: (id, view, menu) => false,
        onMenuOpened: (id, menu) => false,
        onMenuItemSelected: (id, item) => false,
        onWindowAttributesChanged: (jAttrs) {
          final attrs = WindowAttributesImpl(jAttrs);
          attrsChangedController.add(attrs);
        },
        onContentChanged: () {},
        onWindowFocusChanged: (hasFocus) {},
        onAttachedToWindow: () {},
        onDetachedFromWindow: () {},
        onPanelClosed: (id, menu) {},
        onSearchRequested: () => false,
        onSearchRequested$1: (event) => false,
        onWindowStartingActionMode: (callback) =>
            jni.JObject.fromReference(jni.jNullReference),
        onWindowStartingActionMode$1: (callback, type) =>
            jni.JObject.fromReference(jni.jNullReference),
        onActionModeStarted: (actionMode) {},
        onActionModeFinished: (actionMode) {},
        onProvideKeyboardShortcuts: (data, menu, id) {},
        onPointerCaptureChanged: (hasCapture) {},
      ),
    );
    jWindow.setCallback(callback1);
  }

  void onCancelAttrsChanged() {
    final callback = jni.Window_Callback.fromReference(jni.jNullReference);
    jWindow.setCallback(callback);
  }
}

final class WindowAttributesImpl implements WindowAttributes {
  final jni.WindowManager_LayoutParams jParams;

  WindowAttributesImpl(this.jParams);

  @override
  double? get brightness {
    final brightness = jParams.screenBrightness;
    if (brightness == jni.WindowManager_LayoutParams.BRIGHTNESS_OVERRIDE_NONE) {
      return null;
    }
    return brightness;
  }

  @override
  set brightness(double? value) {
    jParams.screenBrightness =
        value ?? jni.WindowManager_LayoutParams.BRIGHTNESS_OVERRIDE_NONE;
  }
}
