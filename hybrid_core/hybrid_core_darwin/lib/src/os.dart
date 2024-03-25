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

class DarwinOSImpl implements DarwinOS {
  final ffi.NSProcessInfo info;

  DarwinOSImpl() : info = ffi.NSProcessInfo.alloc(foundation).init();

  @override
  DarwinOSVersion get version {
    return ffi.using((arena) {
      final nsVersionPtr = arena<ffi.NSOperatingSystemVersion>();
      info.getOperatingSystemVersion(nsVersionPtr);
      final nsVersion = nsVersionPtr.ref;
      return DarwinOSVersion(
        majorVersion: nsVersion.majorVersion,
        minorVersion: nsVersion.minorVersion,
        patchVersion: nsVersion.patchVersion,
      );
    });
  }

  @override
  bool atLeastVersion(DarwinOSVersion version) {
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
class iOSImpl extends DarwinOSImpl implements iOS {}

// ignore: camel_case_types
class macOSImpl extends DarwinOSImpl implements macOS {}
