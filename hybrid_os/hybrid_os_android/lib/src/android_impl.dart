import 'dart:async';
import 'dart:ui';

import 'package:jni/jni.dart' as jni;

import 'android.dart';
import 'jni.dart' as jni;
import 'partition.dart';
import 'screen_brightness_mode.dart';
import 'settings.dart';
import 'version_codes.dart';
import 'window.dart';
import 'window_attributes.dart';

final class AndroidImpl implements Android {
  Settings? _settings;
  Window? _window;

  @override
  String get baseOS => jni.Build_VERSION.BASE_OS.toDartString(
        releaseOriginal: true,
      );

  @override
  String get codename => jni.Build_VERSION.CODENAME.toDartString(
        releaseOriginal: true,
      );

  @override
  String get incremental => jni.Build_VERSION.INCREMENTAL.toDartString(
        releaseOriginal: true,
      );

  @override
  int get mediaPerformanceClass => jni.Build_VERSION.MEDIA_PERFORMANCE_CLASS;

  @override
  int get previewSDK => jni.Build_VERSION.PREVIEW_SDK_INT;

  @override
  String get release => jni.Build_VERSION.RELEASE.toDartString(
        releaseOriginal: true,
      );

  @override
  String get releaseOrCodename =>
      jni.Build_VERSION.RELEASE_OR_CODENAME.toDartString(
        releaseOriginal: true,
      );

  @override
  String get releaseOrPreviewDisplay =>
      jni.Build_VERSION.RELEASE_OR_PREVIEW_DISPLAY.toDartString(
        releaseOriginal: true,
      );

  @override
  int get sdk => jni.Build_VERSION.SDK_INT;

  @override
  String get securityPatch => jni.Build_VERSION.SECURITY_PATCH.toDartString(
        releaseOriginal: true,
      );

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

  @override
  String get board => jni.Build.BOARD.toDartString(
        releaseOriginal: true,
      );

  @override
  String get bootloader => jni.Build.BOOTLOADER.toDartString(
        releaseOriginal: true,
      );

  @override
  String get brand => jni.Build.BRAND.toDartString(
        releaseOriginal: true,
      );

  @override
  String get cpuABI => jni.Build.CPU_ABI.toDartString(
        releaseOriginal: true,
      );

  @override
  String get cpuABI2 => jni.Build.CPU_ABI2.toDartString(
        releaseOriginal: true,
      );

  @override
  String get device => jni.Build.DEVICE.toDartString(
        releaseOriginal: true,
      );

  @override
  String get display => jni.Build.DISPLAY.toDartString(
        releaseOriginal: true,
      );

  @override
  String get fingerprint => jni.Build.FINGERPRINT.toDartString(
        releaseOriginal: true,
      );

  @override
  List<Partition> get fingerprintedPartitions =>
      jni.Build.getFingerprintedPartitions()
          .map((jPartition) => PartitionImpl(jPartition))
          .toList();

  @override
  String get hardware => jni.Build.HARDWARE.toDartString(
        releaseOriginal: true,
      );

  @override
  String get host => jni.Build.HOST.toDartString(
        releaseOriginal: true,
      );

  @override
  String get id => jni.Build.ID.toDartString(
        releaseOriginal: true,
      );

  @override
  String get manufacturer => jni.Build.MANUFACTURER.toDartString(
        releaseOriginal: true,
      );

  @override
  String get model => jni.Build.MODEL.toDartString(
        releaseOriginal: true,
      );

  @override
  String get odmSKU => jni.Build.ODM_SKU.toDartString(
        releaseOriginal: true,
      );

  @override
  String get product => jni.Build.PRODUCT.toDartString(
        releaseOriginal: true,
      );

  @override
  String get radio => jni.Build.RADIO.toDartString(
        releaseOriginal: true,
      );

  @override
  String? get radioVersion {
    final jRadioVersion = jni.Build.getRadioVersion();
    return jRadioVersion.isNull
        ? null
        : jRadioVersion.toDartString(
            releaseOriginal: true,
          );
  }

  @override
  String get serial => sdk >= VersionCodes.o
      ? jni.Build.getSerial().toDartString(
          releaseOriginal: true,
        )
      : jni.Build.SERIAL.toDartString(
          releaseOriginal: true,
        );

  @override
  String get sku => jni.Build.SKU.toDartString(
        releaseOriginal: true,
      );

  @override
  String get socManufacturer => jni.Build.SOC_MANUFACTURER.toDartString(
        releaseOriginal: true,
      );

  @override
  String get socModel => jni.Build.SOC_MODEL.toDartString(
        releaseOriginal: true,
      );

  @override
  List<String> get supported32BitABIs =>
      jni.Build.SUPPORTED_32_BIT_ABIS.toList();

  @override
  List<String> get supported64BitABIs =>
      jni.Build.SUPPORTED_64_BIT_ABIS.toList();

  @override
  List<String> get supportedABIs => jni.Build.SUPPORTED_ABIS.toList();

  @override
  String get tags => jni.Build.TAGS.toDartString(
        releaseOriginal: true,
      );

  @override
  int get time => jni.Build.TIME;

  @override
  String get type => jni.Build.TYPE.toDartString(
        releaseOriginal: true,
      );

  @override
  String get user => jni.Build.USER.toDartString(
        releaseOriginal: true,
      );
}

final class PartitionImpl implements Partition {
  final jni.Build_Partition _jPartition;

  PartitionImpl(this._jPartition);

  @override
  int get buildTimeMills => _jPartition.getBuildTimeMillis();

  @override
  String get fingerprint => _jPartition.getFingerprint().toDartString(
        releaseOriginal: true,
      );

  @override
  String get name => _jPartition.getName().toDartString(
        releaseOriginal: true,
      );
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

extension on jni.JArray<jni.JString> {
  List<String> toList() {
    final items = <String>[];
    for (var i = 0; i < length; i++) {
      final item = this[i].toDartString(
        releaseOriginal: true,
      );
      items.add(item);
    }
    return items;
  }
}
