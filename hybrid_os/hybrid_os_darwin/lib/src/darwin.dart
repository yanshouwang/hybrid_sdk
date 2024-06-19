import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:hybrid_os_platform_interface/hybrid_os_platform_interface.dart';

import 'ffi.g.dart';

/// DarwinPlatform.
abstract base class DarwinPlatform extends OSPlatform implements Darwin {
  final NSProcessInfo info;

  DarwinPlatform() : info = NSProcessInfo.alloc().init();

  @override
  DarwinVersion get version {
    return using((arena) {
      final nsVersionPtr = arena<NSOperatingSystemVersion>();
      info.getOperatingSystemVersion(nsVersionPtr);
      final nsVersion = nsVersionPtr.ref;
      return DarwinVersion(
        majorVersion: nsVersion.majorVersion,
        minorVersion: nsVersion.minorVersion,
        patchVersion: nsVersion.patchVersion,
      );
    });
  }

  @override
  bool isAtLeastVersion(DarwinVersion version) {
    return using((arena) {
      final nsVersionPtr = arena<NSOperatingSystemVersion>();
      final nsVersion = nsVersionPtr.ref;
      nsVersion.majorVersion = version.majorVersion;
      nsVersion.minorVersion = version.minorVersion;
      nsVersion.patchVersion = version.patchVersion;
      return info.isOperatingSystemAtLeastVersion_(nsVersion);
    });
  }
}

/// Darwin.
abstract interface class Darwin implements OS {
  /// The version of the operating system on which the process is executing.
  DarwinVersion get version;

  /// Returns a Boolean value indicating whether the version of the operating
  /// system on which the process is executing is the same or later than the given
  /// version.
  ///
  /// [version] The operating system version to test against.
  bool isAtLeastVersion(DarwinVersion version);
}

/// A structure that contains version information about the currently executing
/// operating system, including major, minor, and patch version numbers.
final class DarwinVersion {
  /// The major release number, such as 10 in version 10.9.3.
  final int majorVersion;

  /// The minor release number, such as 9 in version 10.9.3.
  final int minorVersion;

  /// The update release number, such as 3 in version 10.9.3.
  final int patchVersion;

  /// Constructs a [DarwinVersion].
  DarwinVersion({
    this.majorVersion = 0,
    this.minorVersion = 0,
    this.patchVersion = 0,
  });

  /// Constructs a [DarwinVersion] from [String].
  factory DarwinVersion.fromString(String text) {
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

  /// Constructs a [DarwinVersion] from [num].
  factory DarwinVersion.fromNumber(num number) =>
      DarwinVersion.fromString('$number');

  /// Copies a [DarwinVersion].
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
