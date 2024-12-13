// import 'dart:async';

// import 'package:clover/clover.dart';
// import 'package:hybrid_os_android/hybrid_os_android.dart';

// final class HomeViewModel extends ViewModel {
//   final Android _os;

//   late final int _sdk;
//   late final StreamSubscription _brightnessModeSubscription;
//   late final StreamSubscription _brightnessSubscription;

//   late bool _canWriteSettings;
//   late ScreenBrightnessMode _brightnessMode;
//   late double _brightness;

//   HomeViewModel() : _os = Android() {
//     _sdk = _os.sdk;
//     _canWriteSettings = _os.settings.canWrite;
//     _brightnessMode = _os.settings.brightnessMode;
//     _brightness = _os.settings.brightness / 0xff;

//     _brightnessModeSubscription =
//         _os.settings.brightnessModeChanged.listen((value) {
//       _brightnessMode = value;
//       notifyListeners();
//     });
//     _brightnessSubscription = _os.settings.brightnessChanged.listen((value) {
//       _brightness = value / 0xff;
//       notifyListeners();
//     });
//   }

//   int get sdk => _sdk;

//   bool get upsideDownCakeOrLater => _sdk >= VersionCodes.upsideDownCake;

//   bool get canWriteSettings => _canWriteSettings;

//   ScreenBrightnessMode get brightnessMode => _brightnessMode;
//   set brightnessMode(ScreenBrightnessMode value) =>
//       _os.settings.brightnessMode = value;

//   double get brightness => _brightness;
//   set brightness(double value) =>
//       _os.settings.brightness = (value * 0xff).toInt();

//   Future<void> startManageWriteSettingsActivity() async {
//     await _os.startManageWriteSettingsActivity();
//     _canWriteSettings = _os.settings.canWrite;
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     _brightnessModeSubscription.cancel();
//     _brightnessSubscription.cancel();
//     super.dispose();
//   }
// }
