import 'screen_brightness_mode.dart';

abstract interface class Settings {
  /// Checks if the specified app can modify system settings. As of API level 23,
  /// an app cannot modify system settings unless it declares the
  /// Manifest.permission.WRITE_SETTINGS permission in its manifest, and the user
  /// specifically grants the app this capability. To prompt the user to grant
  /// this approval, the app must send an intent with the action
  /// Settings.ACTION_MANAGE_WRITE_SETTINGS, which causes the system to display
  /// a permission management screen.
  bool get canWrite;

  /// Control whether to enable automatic brightness mode.
  ScreenBrightnessMode get brightnessMode;
  set brightnessMode(ScreenBrightnessMode value);

  /// The screen backlight brightness between 0 and 255.
  int get brightness;
  set brightness(int value);

  Stream<ScreenBrightnessMode> get brightnessModeChanged;
  Stream<int> get brightnessChanged;
}
