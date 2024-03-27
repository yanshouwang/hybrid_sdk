import 'dart:ffi';

import 'package:hybrid_core_platform_interface/hybrid_core_platform_interface.dart';

import 'ffi.dart' as ffi;

class WindowsPlatform extends OSPlatform implements Windows {
  WindowsPlatform();

  @override
  WindowsVersion get version => ffi.using((arena) {
        final osvi = arena<ffi.OSVERSIONINFOEXW>();
        osvi.ref.dwOSVersionInfoSize = ffi.sizeOf<ffi.OSVERSIONINFOEXW>();
        ffi.kernel32.GetVersionExW(osvi.cast());
        return osvi.ref.toWindowsVersion();
      });

  @override
  bool get isWindows10OrGreater => isWindowsVersionOrGreater(
        majorVersion: ffi.HIBYTE(ffi.WIN32_WINNT_WINTHRESHOLD),
        minorVersion: ffi.LOBYTE(ffi.WIN32_WINNT_WINTHRESHOLD),
        servicePackMajor: 0,
      );

  @override
  bool get isWindows7OrGreater => isWindowsVersionOrGreater(
        majorVersion: ffi.HIBYTE(ffi.WIN32_WINNT_WIN7),
        minorVersion: ffi.LOBYTE(ffi.WIN32_WINNT_WIN7),
        servicePackMajor: 0,
      );

  @override
  bool get isWindows7SP1OrGreater => isWindowsVersionOrGreater(
        majorVersion: ffi.HIBYTE(ffi.WIN32_WINNT_WIN7),
        minorVersion: ffi.LOBYTE(ffi.WIN32_WINNT_WIN7),
        servicePackMajor: 1,
      );

  @override
  bool get isWindows8OrGreater => isWindowsVersionOrGreater(
        majorVersion: ffi.HIBYTE(ffi.WIN32_WINNT_WIN8),
        minorVersion: ffi.LOBYTE(ffi.WIN32_WINNT_WIN8),
        servicePackMajor: 0,
      );

  @override
  bool get isWindows8Point1OrGreater => isWindowsVersionOrGreater(
        majorVersion: ffi.HIBYTE(ffi.WIN32_WINNT_WINBLUE),
        minorVersion: ffi.LOBYTE(ffi.WIN32_WINNT_WINBLUE),
        servicePackMajor: 0,
      );

  @override
  bool get isWindowsServer => ffi.using((arena) {
        final osvi = arena<ffi.OSVERSIONINFOEXW>();
        osvi.ref.wProductType = ffi.VER_NT_WORKSTATION;
        final dwlConditionMask = ffi.kernel32.VerSetConditionMask(
          0,
          ffi.VER_PRODUCT_TYPE,
          ffi.VER_EQUAL,
        );
        return ffi.kernel32.VerifyVersionInfoW(
              osvi,
              ffi.VER_PRODUCT_TYPE,
              dwlConditionMask,
            ) ==
            ffi.FALSE;
      });

  @override
  bool get isWindowsVistaOrGreater => isWindowsVersionOrGreater(
        majorVersion: ffi.HIBYTE(ffi.WIN32_WINNT_VISTA),
        minorVersion: ffi.LOBYTE(ffi.WIN32_WINNT_VISTA),
        servicePackMajor: 0,
      );

  @override
  bool get isWindowsVistaSP1OrGreater => isWindowsVersionOrGreater(
        majorVersion: ffi.HIBYTE(ffi.WIN32_WINNT_VISTA),
        minorVersion: ffi.LOBYTE(ffi.WIN32_WINNT_VISTA),
        servicePackMajor: 1,
      );

  @override
  bool get isWindowsVistaSP2OrGreater => isWindowsVersionOrGreater(
        majorVersion: ffi.HIBYTE(ffi.WIN32_WINNT_VISTA),
        minorVersion: ffi.LOBYTE(ffi.WIN32_WINNT_VISTA),
        servicePackMajor: 2,
      );

  @override
  bool get isWindowsXPOrGreater => isWindowsVersionOrGreater(
        majorVersion: ffi.HIBYTE(ffi.WIN32_WINNT_WINXP),
        minorVersion: ffi.LOBYTE(ffi.WIN32_WINNT_WINXP),
        servicePackMajor: 0,
      );

  @override
  bool get isWindowsXPSP1OrGreater => isWindowsVersionOrGreater(
        majorVersion: ffi.HIBYTE(ffi.WIN32_WINNT_WINXP),
        minorVersion: ffi.LOBYTE(ffi.WIN32_WINNT_WINXP),
        servicePackMajor: 1,
      );

  @override
  bool get isWindowsXPSP2OrGreater => isWindowsVersionOrGreater(
        majorVersion: ffi.HIBYTE(ffi.WIN32_WINNT_WINXP),
        minorVersion: ffi.LOBYTE(ffi.WIN32_WINNT_WINXP),
        servicePackMajor: 2,
      );

  @override
  bool get isWindowsXPSP3OrGreater => isWindowsVersionOrGreater(
        majorVersion: ffi.HIBYTE(ffi.WIN32_WINNT_WINXP),
        minorVersion: ffi.LOBYTE(ffi.WIN32_WINNT_WINXP),
        servicePackMajor: 3,
      );

  @override
  bool isWindowsVersionOrGreater({
    int majorVersion = 0,
    int minorVersion = 0,
    int servicePackMajor = 0,
  }) {
    return ffi.using((arena) {
      final osvi = arena<ffi.OSVERSIONINFOEXW>();
      final dwlConditionMask = ffi.kernel32.VerSetConditionMask(
        ffi.kernel32.VerSetConditionMask(
          ffi.kernel32.VerSetConditionMask(
            0,
            ffi.VER_MAJORVERSION,
            ffi.VER_GREATER_EQUAL,
          ),
          ffi.VER_MINORVERSION,
          ffi.VER_GREATER_EQUAL,
        ),
        ffi.VER_SERVICEPACKMAJOR,
        ffi.VER_GREATER_EQUAL,
      );
      osvi.ref.dwMajorVersion = majorVersion;
      osvi.ref.dwMinorVersion = minorVersion;
      osvi.ref.wServicePackMajor = servicePackMajor;
      return ffi.kernel32.VerifyVersionInfoW(
            osvi,
            ffi.VER_MAJORVERSION |
                ffi.VER_MINORVERSION |
                ffi.VER_SERVICEPACKMAJOR,
            dwlConditionMask,
          ) !=
          ffi.FALSE;
    });
  }
}

abstract class Windows implements OS {
  WindowsVersion get version;
  bool get isWindowsXPOrGreater;
  bool get isWindowsXPSP1OrGreater;
  bool get isWindowsXPSP2OrGreater;
  bool get isWindowsXPSP3OrGreater;
  bool get isWindowsVistaOrGreater;
  bool get isWindowsVistaSP1OrGreater;
  bool get isWindowsVistaSP2OrGreater;
  bool get isWindows7OrGreater;
  bool get isWindows7SP1OrGreater;
  bool get isWindows8OrGreater;
  bool get isWindows8Point1OrGreater;
  bool get isWindows10OrGreater;
  bool get isWindowsServer;

  bool isWindowsVersionOrGreater({
    int majorVersion = 0,
    int minorVersion = 0,
    int servicePackMajor = 0,
  });
}

class WindowsVersion {
  final int majorVersion;
  final int minorVersion;
  final int buildNumber;
  final String servicePack;
  final int servicePackMajor;
  final int servicePackMinor;
  final WindowsType type;

  WindowsVersion({
    this.majorVersion = 0,
    this.minorVersion = 0,
    this.buildNumber = 0,
    this.servicePack = '',
    this.servicePackMajor = 0,
    this.servicePackMinor = 0,
    this.type = WindowsType.unknown,
  });

  @override
  String toString() {
    final mainVersion = '$majorVersion.$minorVersion.$buildNumber';
    return servicePack.isEmpty ? mainVersion : '$mainVersion $servicePack';
  }
}

enum WindowsType {
  unknown,
  workstation,
  domainController,
  server,
}

extension on ffi.OSVERSIONINFOEXW {
  WindowsVersion toWindowsVersion() {
    final charCodes = <int>[];
    for (var i = 0; i < 128; i++) {
      final charCode = szCSDVersion[i];
      if (charCode == 0x00) {
        break;
      }
      charCodes.add(charCode);
    }
    final csdVersion = String.fromCharCodes(charCodes);
    return WindowsVersion(
      majorVersion: dwMajorVersion,
      minorVersion: dwMinorVersion,
      buildNumber: dwBuildNumber,
      servicePack: csdVersion,
      servicePackMajor: wServicePackMajor,
      servicePackMinor: wServicePackMinor,
      type: wProductType.toWindowsType(),
    );
  }
}

extension on int {
  WindowsType toWindowsType() {
    switch (this) {
      case ffi.VER_NT_WORKSTATION:
        return WindowsType.workstation;
      case ffi.VER_NT_DOMAIN_CONTROLLER:
        return WindowsType.domainController;
      case ffi.VER_NT_SERVER:
        return WindowsType.server;
      default:
        return WindowsType.unknown;
    }
  }
}
