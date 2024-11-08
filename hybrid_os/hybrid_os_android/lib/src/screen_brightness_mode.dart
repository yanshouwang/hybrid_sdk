import 'jni.dart';

enum ScreenBrightnessMode {
  manual(Settings_System.SCREEN_BRIGHTNESS_MODE_MANUAL),
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
