import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:hybrid_core_platform_interface/hybrid_core_platform_interface.dart';

import 'ffi.dart';
import 'ffi.g.dart';

class WindowsPlatform extends OSPlatform implements Windows {
  WindowsPlatform();

  @override
  WindowsVersion get version => using((arena) {
        final osvi = arena<OSVERSIONINFOEXW>();
        osvi.ref.dwOSVersionInfoSize = sizeOf<OSVERSIONINFOEXW>();
        kernel32.GetVersionExW(osvi.cast());
        return osvi.ref.toWindowsVersion();
      });

  @override
  bool get isWindows10OrGreater => isWindowsVersionOrGreater(
        majorVersion: HIBYTE(WIN32_WINNT_WINTHRESHOLD),
        minorVersion: LOBYTE(WIN32_WINNT_WINTHRESHOLD),
        servicePackMajor: 0,
      );

  @override
  bool get isWindows7OrGreater => isWindowsVersionOrGreater(
        majorVersion: HIBYTE(WIN32_WINNT_WIN7),
        minorVersion: LOBYTE(WIN32_WINNT_WIN7),
        servicePackMajor: 0,
      );

  @override
  bool get isWindows7SP1OrGreater => isWindowsVersionOrGreater(
        majorVersion: HIBYTE(WIN32_WINNT_WIN7),
        minorVersion: LOBYTE(WIN32_WINNT_WIN7),
        servicePackMajor: 1,
      );

  @override
  bool get isWindows8OrGreater => isWindowsVersionOrGreater(
        majorVersion: HIBYTE(WIN32_WINNT_WIN8),
        minorVersion: LOBYTE(WIN32_WINNT_WIN8),
        servicePackMajor: 0,
      );

  @override
  bool get isWindows8Point1OrGreater => isWindowsVersionOrGreater(
        majorVersion: HIBYTE(WIN32_WINNT_WINBLUE),
        minorVersion: LOBYTE(WIN32_WINNT_WINBLUE),
        servicePackMajor: 0,
      );

  @override
  bool get isWindowsServer => using((arena) {
        final osvi = arena<OSVERSIONINFOEXW>();
        osvi.ref.wProductType = VER_NT_WORKSTATION;
        final dwlConditionMask = kernel32.VerSetConditionMask(
          0,
          VER_PRODUCT_TYPE,
          VER_EQUAL,
        );
        return kernel32.VerifyVersionInfoW(
              osvi,
              VER_PRODUCT_TYPE,
              dwlConditionMask,
            ) ==
            FALSE;
      });

  @override
  bool get isWindowsVistaOrGreater => isWindowsVersionOrGreater(
        majorVersion: HIBYTE(WIN32_WINNT_VISTA),
        minorVersion: LOBYTE(WIN32_WINNT_VISTA),
        servicePackMajor: 0,
      );

  @override
  bool get isWindowsVistaSP1OrGreater => isWindowsVersionOrGreater(
        majorVersion: HIBYTE(WIN32_WINNT_VISTA),
        minorVersion: LOBYTE(WIN32_WINNT_VISTA),
        servicePackMajor: 1,
      );

  @override
  bool get isWindowsVistaSP2OrGreater => isWindowsVersionOrGreater(
        majorVersion: HIBYTE(WIN32_WINNT_VISTA),
        minorVersion: LOBYTE(WIN32_WINNT_VISTA),
        servicePackMajor: 2,
      );

  @override
  bool get isWindowsXPOrGreater => isWindowsVersionOrGreater(
        majorVersion: HIBYTE(WIN32_WINNT_WINXP),
        minorVersion: LOBYTE(WIN32_WINNT_WINXP),
        servicePackMajor: 0,
      );

  @override
  bool get isWindowsXPSP1OrGreater => isWindowsVersionOrGreater(
        majorVersion: HIBYTE(WIN32_WINNT_WINXP),
        minorVersion: LOBYTE(WIN32_WINNT_WINXP),
        servicePackMajor: 1,
      );

  @override
  bool get isWindowsXPSP2OrGreater => isWindowsVersionOrGreater(
        majorVersion: HIBYTE(WIN32_WINNT_WINXP),
        minorVersion: LOBYTE(WIN32_WINNT_WINXP),
        servicePackMajor: 2,
      );

  @override
  bool get isWindowsXPSP3OrGreater => isWindowsVersionOrGreater(
        majorVersion: HIBYTE(WIN32_WINNT_WINXP),
        minorVersion: LOBYTE(WIN32_WINNT_WINXP),
        servicePackMajor: 3,
      );

  @override
  bool isWindowsVersionOrGreater({
    int majorVersion = 0,
    int minorVersion = 0,
    int servicePackMajor = 0,
  }) {
    return using((arena) {
      final osvi = arena<OSVERSIONINFOEXW>();
      final dwlConditionMask = kernel32.VerSetConditionMask(
        kernel32.VerSetConditionMask(
          kernel32.VerSetConditionMask(
            0,
            VER_MAJORVERSION,
            VER_GREATER_EQUAL,
          ),
          VER_MINORVERSION,
          VER_GREATER_EQUAL,
        ),
        VER_SERVICEPACKMAJOR,
        VER_GREATER_EQUAL,
      );
      osvi.ref.dwMajorVersion = majorVersion;
      osvi.ref.dwMinorVersion = minorVersion;
      osvi.ref.wServicePackMajor = servicePackMajor;
      return kernel32.VerifyVersionInfoW(
            osvi,
            VER_MAJORVERSION | VER_MINORVERSION | VER_SERVICEPACKMAJOR,
            dwlConditionMask,
          ) !=
          FALSE;
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

extension on OSVERSIONINFOEXW {
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
      case VER_NT_WORKSTATION:
        return WindowsType.workstation;
      case VER_NT_DOMAIN_CONTROLLER:
        return WindowsType.domainController;
      case VER_NT_SERVER:
        return WindowsType.server;
      default:
        return WindowsType.unknown;
    }
  }
}
