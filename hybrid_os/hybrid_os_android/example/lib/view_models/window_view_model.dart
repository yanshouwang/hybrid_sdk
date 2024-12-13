// import 'package:clover/clover.dart';
// import 'package:hybrid_os_android/hybrid_os_android.dart';

// final class WindowViewModel extends ViewModel {
//   final Android _os;

//   late final Window _window;

//   late WindowAttributes _attrs;

//   WindowViewModel() : _os = Android() {
//     _window = _os.window;
//     _attrs = _window.attrs;
//   }

//   double? get screenBrightness => _attrs.brightness;
//   set screenBrightness(double? value) {
//     _attrs.brightness = value;
//     _window.attrs = _attrs;
//     notifyListeners();
//   }
// }
