// ignore_for_file: camel_case_types

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:hybrid_core_platform_interface/hybrid_core_platform_interface.dart';

import 'ffi.dart';
import 'ffi.g.dart';

base class DarwinImpl extends OSImpl implements Darwin {
  final NSProcessInfo info;

  DarwinImpl() : info = NSProcessInfo.alloc(foundationLib).init();

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
  bool atLeastVersion(DarwinVersion version) {
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

base class iOSImpl extends DarwinImpl implements iOS {}

base class macOSImpl extends DarwinImpl implements macOS {}

abstract class Darwin implements OS {
  DarwinVersion get version;

  bool atLeastVersion(DarwinVersion version);
}

abstract class iOS implements Darwin {}

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
