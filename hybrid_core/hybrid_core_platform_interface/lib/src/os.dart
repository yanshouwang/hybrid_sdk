import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class OSPlatform extends PlatformInterface {
  /// Constructs a OSPlatform.
  OSPlatform() : super(token: _token);

  static final Object _token = Object();

  static OSPlatform? _instance;

  /// The default instance of [OSPlatform] to use.
  static OSPlatform get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError('OS is not implemented on this platform.');
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [OSPlatform] when
  /// they register themselves.
  static set instance(OSPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  OS get os;
}

abstract class OS {
  factory OS() => OSPlatform.instance.os;
}

abstract class AndroidOS implements OS {
  int get api;

  bool atLeastAPI(int api);
}

abstract class DarwinOS implements OS {
  DarwinOSVersion get version;

  bool atLeastVersion(DarwinOSVersion version);
}

// ignore: camel_case_types
abstract class iOS implements DarwinOS {}

// ignore: camel_case_types
abstract class macOS implements DarwinOS {}

class DarwinOSVersion {
  final int majorVersion;
  final int minorVersion;
  final int patchVersion;

  DarwinOSVersion({
    this.majorVersion = 0,
    this.minorVersion = 0,
    this.patchVersion = 0,
  });

  factory DarwinOSVersion.text(String text) {
    final texts = text.split('.');
    final majorText = texts.elementAtOrNull(0);
    final minorText = texts.elementAtOrNull(1);
    final patchText = texts.elementAtOrNull(2);
    final majorVersion = majorText == null ? 0 : int.parse(majorText);
    final minorVersion = minorText == null ? 0 : int.parse(minorText);
    final patchVersion = patchText == null ? 0 : int.parse(patchText);
    return DarwinOSVersion(
      majorVersion: majorVersion,
      minorVersion: minorVersion,
      patchVersion: patchVersion,
    );
  }

  factory DarwinOSVersion.number(num number) => DarwinOSVersion.text('$number');

  DarwinOSVersion copyWith({
    int? majorVersion,
    int? minorVersion,
    int? patchVersion,
  }) {
    return DarwinOSVersion(
      majorVersion: majorVersion ?? this.majorVersion,
      minorVersion: minorVersion ?? this.minorVersion,
      patchVersion: patchVersion ?? this.patchVersion,
    );
  }

  @override
  operator ==(Object other) {
    return other is DarwinOSVersion &&
        other.majorVersion == majorVersion &&
        other.minorVersion == minorVersion &&
        other.patchVersion == patchVersion;
  }

  @override
  int get hashCode => Object.hash(
        majorVersion,
        minorVersion,
        patchVersion,
      );

  @override
  String toString() {
    return '$majorVersion.$minorVersion.$patchVersion';
  }
}
