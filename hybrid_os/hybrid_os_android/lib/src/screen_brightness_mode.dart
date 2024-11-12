import 'jni.dart';

/// Screen brightness mode.
enum ScreenBrightnessMode {
  /// SCREEN_BRIGHTNESS_MODE value for manual mode.
  manual(Settings_System.SCREEN_BRIGHTNESS_MODE_MANUAL),

  /// SCREEN_BRIGHTNESS_MODE value for automatic mode.
  automatic(Settings_System.SCREEN_BRIGHTNESS_MODE_AUTOMATIC);

  final int value;

  const ScreenBrightnessMode(this.value);

  factory ScreenBrightnessMode.fromValue(int value) {
    switch (value) {
      case Settings_System.SCREEN_BRIGHTNESS_MODE_MANUAL:
        return ScreenBrightnessMode.manual;
      case Settings_System.SCREEN_BRIGHTNESS_MODE_AUTOMATIC:
        return ScreenBrightnessMode.automatic;
      default:
        throw ArgumentError.value(value);
    }
  }
}
