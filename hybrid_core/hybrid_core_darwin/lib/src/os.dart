import 'dart:io';

import 'package:hybrid_core_platform_interface/hybrid_core_platform_interface.dart';

import 'ffi.dart' as ffi;

const _foundationPath =
    '/System/Library/Frameworks/Foundation.framework/Foundation';
final _foundationLib = ffi.DynamicLibrary.open(_foundationPath);
final foundation = ffi.HybridCore(_foundationLib);

class OSPlatformImpl extends OSPlatform {
  @override
  final OS os;

  OSPlatformImpl() : os = Platform.isIOS ? iOSImpl() : macOSImpl();
}

class DarwinImpl implements Darwin {
  final ffi.NSProcessInfo info;

  DarwinImpl() : info = ffi.NSProcessInfo.alloc(foundation).init();

  @override
  DarwinVersion get version {
    return ffi.using((arena) {
      final nsVersionPtr = arena<ffi.NSOperatingSystemVersion>();
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
    return ffi.using((arena) {
      final nsVersionPtr = arena<ffi.NSOperatingSystemVersion>();
      final nsVersion = nsVersionPtr.ref;
      nsVersion.majorVersion = version.majorVersion;
      nsVersion.minorVersion = version.minorVersion;
      nsVersion.patchVersion = version.patchVersion;
      return info.isOperatingSystemAtLeastVersion_(nsVersion);
    });
  }
}

// ignore: camel_case_types
class iOSImpl extends DarwinImpl implements iOS {}

// ignore: camel_case_types
class macOSImpl extends DarwinImpl implements macOS {}
