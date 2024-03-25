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

abstract class Android implements OS {
  int get api;

  bool atLeastAPI(int api);
}

abstract class Darwin implements OS {
  DarwinVersion get version;

  bool atLeastVersion(DarwinVersion version);
}

// ignore: camel_case_types
abstract class iOS implements Darwin {}

// ignore: camel_case_types
abstract class macOS implements Darwin {}

class DarwinVersion {
  final int majorVersion;
  final int minorVersion;
  final int patchVersion;

  DarwinVersion({
    this.majorVersion = 0,
    this.minorVersion = 0,
    this.patchVersion = 0,
  });

  factory DarwinVersion.text(String text) {
    final texts = text.split('.');
    final majorText = texts.elementAtOrNull(0);
    final minorText = texts.elementAtOrNull(1);
    final patchText = texts.elementAtOrNull(2);
    final majorVersion = majorText == null ? 0 : int.parse(majorText);
    final minorVersion = minorText == null ? 0 : int.parse(minorText);
    final patchVersion = patchText == null ? 0 : int.parse(patchText);
    return DarwinVersion(
      majorVersion: majorVersion,
      minorVersion: minorVersion,
      patchVersion: patchVersion,
    );
  }

  factory DarwinVersion.number(num number) => DarwinVersion.text('$number');

  DarwinVersion copyWith({
    int? majorVersion,
    int? minorVersion,
    int? patchVersion,
  }) {
    return DarwinVersion(
      majorVersion: majorVersion ?? this.majorVersion,
      minorVersion: minorVersion ?? this.minorVersion,
      patchVersion: patchVersion ?? this.patchVersion,
    );
  }

  @override
  operator ==(Object other) {
    return other is DarwinVersion &&
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
