import 'dart:async';
import 'dart:developer';

import 'package:clover/clover.dart';
import 'package:hybrid_os_android/hybrid_os_android.dart';

final class HomeViewModel extends ViewModel {
  final Android _os;

  late final int _sdk;
  late final StreamSubscription _brightnessModeSubscription;
  late final StreamSubscription _brightnessSubscription;

  late bool _canWriteSettings;
  late ScreenBrightnessMode _brightnessMode;
  late double _brightness;

  HomeViewModel() : _os = Android() {
    _sdk = _os.sdk;

    log('''Board: ${_os.board}
Bootloader: ${_os.bootloader}
Brand: ${_os.brand}
CPU ABI: ${_os.cpuABI}
CPU ABI2: ${_os.cpuABI2}
Device: ${_os.device}
Display: ${_os.display}
Fingerprint: ${_os.fingerprint}
Hardware: ${_os.hardware}
Host: ${_os.host}
Id: ${_os.id}
Manufacturer: ${_os.manufacturer}
Model: ${_os.model}
ODM SKU: ${_os.sdk >= VersionCodes.s ? _os.odmSKU : ''}
Product: ${_os.product}
Radio: ${_os.sdk >= VersionCodes.iceCreamSandwichMR1 ? _os.radioVersion : _os.radio}
SKU: ${_os.sdk >= VersionCodes.s ? _os.sku : ''}
SOC Manufacturer: ${_os.sdk >= VersionCodes.s ? _os.socManufacturer : ''}
SOC Model: ${_os.sdk >= VersionCodes.s ? _os.socModel : ''}
Supported 32 Bit ABIs: ${_os.supported32BitABIs}
Supported 64 Bit ABIs: ${_os.supported64BitABIs}
Supported ABIs: ${_os.supportedABIs}
Tags: ${_os.tags}
Time: ${_os.time}
Type: ${_os.type}
User: ${_os.user}
Fingerprinted Partitions: ${_os.sdk >= VersionCodes.q ? _os.fingerprintedPartitions : ''}
Base OS: ${_os.sdk >= VersionCodes.m ? _os.baseOS : ''}
Codename: ${_os.codename}
Incremental: ${_os.incremental}
Media Performance Class: ${_os.sdk >= VersionCodes.s ? _os.mediaPerformanceClass : ''}
Preview SDK: ${_os.sdk >= VersionCodes.m ? _os.previewSDK : ''}
Release: ${_os.release}
Release or Codename: ${_os.sdk >= VersionCodes.r ? _os.releaseOrCodename : ''}
Release or Preview Display: ${_os.sdk >= VersionCodes.tiramisu ? _os.releaseOrPreviewDisplay : ''}
SDK: ${_os.sdk}
Security Patch: ${_os.sdk >= VersionCodes.m ? _os.securityPatch : ''}
''');

    _canWriteSettings = _os.settings.canWrite;
    _brightnessMode = _os.settings.brightnessMode;
    _brightness = _os.settings.brightness / 0xff;

    _brightnessModeSubscription =
        _os.settings.brightnessModeChanged.listen((value) {
      _brightnessMode = value;
      notifyListeners();
    });
    _brightnessSubscription = _os.settings.brightnessChanged.listen((value) {
      _brightness = value / 0xff;
      notifyListeners();
    });
  }

  int get sdk => _sdk;

  bool get upsideDownCakeOrLater => _sdk >= VersionCodes.upsideDownCake;

  bool get canWriteSettings => _canWriteSettings;

  ScreenBrightnessMode get brightnessMode => _brightnessMode;
  set brightnessMode(ScreenBrightnessMode value) =>
      _os.settings.brightnessMode = value;

  double get brightness => _brightness;
  set brightness(double value) =>
      _os.settings.brightness = (value * 0xff).toInt();

  Future<void> startManageWriteSettingsActivity() async {
    await _os.startManageWriteSettingsActivity();
    _canWriteSettings = _os.settings.canWrite;
    notifyListeners();
  }

  @override
  void dispose() {
    _brightnessModeSubscription.cancel();
    _brightnessSubscription.cancel();
    super.dispose();
  }
}
