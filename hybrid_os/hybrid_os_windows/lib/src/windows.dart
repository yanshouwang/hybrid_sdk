import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:hybrid_os_platform_interface/hybrid_os_platform_interface.dart';

import 'ffi.dart';
import 'ffi.g.dart';

/// WindowsPlatform.
final class WindowsPlatform extends OSPlatform implements Windows {
  @override
  WindowsVersion get version => using((arena) {
        final osviex = arena<OSVERSIONINFOEXW>();
        osviex.ref.dwOSVersionInfoSize = sizeOf<OSVERSIONINFOEXW>();
        final osvi = osviex.cast<OSVERSIONINFOW>();
        kernel32Lib.GetVersionExW(osvi);
        return WindowsVersion.fromOSVERSIONINFOEXW(osviex.ref);
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
        final dwlConditionMask = kernel32Lib.VerSetConditionMask(
          0,
          VER_PRODUCT_TYPE,
          VER_EQUAL,
        );
        return kernel32Lib.VerifyVersionInfoW(
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
      final dwlConditionMask = kernel32Lib.VerSetConditionMask(
        kernel32Lib.VerSetConditionMask(
          kernel32Lib.VerSetConditionMask(
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
      return kernel32Lib.VerifyVersionInfoW(
            osvi,
            VER_MAJORVERSION | VER_MINORVERSION | VER_SERVICEPACKMAJOR,
            dwlConditionMask,
          ) !=
          FALSE;
    });
  }
}

/// Windows.
abstract interface class Windows implements OS {
  /// [`GetVersionEx` may be altered or unavailable for releases after Windows 8.1.
  /// Instead, use the [Version Helper functions](https://learn.microsoft.com/en-us/windows/desktop/SysInfo/version-helper-apis)]
  ///
  /// With the release of Windows 8.1, the behavior of the GetVersionEx API has
  /// changed in the value it will return for the operating system version. The
  /// value returned by the GetVersionEx function now depends on how the application
  /// is manifested.
  ///
  /// Applications not manifested for Windows 8.1 or Windows 10 will return the
  /// Windows 8 OS version value (6.2). Once an application is manifested for a
  /// given operating system version, GetVersionEx will always return the version
  /// that the application is manifested for in future releases. To manifest your
  /// applications for Windows 8.1 or Windows 10, refer to [Targeting your
  /// application for Windows](https://learn.microsoft.com/en-us/windows/desktop/SysInfo/targeting-your-application-at-windows-8-1).
  WindowsVersion get version;

  /// Indicates if the current OS version matches, or is greater than, the Windows
  /// XP version.
  bool get isWindowsXPOrGreater;

  /// Indicates if the current OS version matches, or is greater than, the Windows
  /// XP with Service Pack 1 (SP1) version.
  bool get isWindowsXPSP1OrGreater;

  /// Indicates if the current OS version matches, or is greater than, the Windows
  /// XP with Service Pack 2 (SP2) version.
  bool get isWindowsXPSP2OrGreater;

  /// Indicates if the current OS version matches, or is greater than, the Windows
  /// XP with Service Pack 3 (SP3) version.
  bool get isWindowsXPSP3OrGreater;

  /// Indicates if the current OS version matches, or is greater than, the Windows
  /// Vista version.
  bool get isWindowsVistaOrGreater;

  /// Indicates if the current OS version matches, or is greater than, the Windows
  /// Vista with Service Pack 1 (SP1) version.
  bool get isWindowsVistaSP1OrGreater;

  /// Indicates if the current OS version matches, or is greater than, the Windows
  /// Vista with Service Pack 2 (SP2) version.
  bool get isWindowsVistaSP2OrGreater;

  /// Indicates if the current OS version matches, or is greater than, the Windows
  /// 7 version.
  bool get isWindows7OrGreater;

  /// Indicates if the current OS version matches, or is greater than, the Windows
  /// 7 with Service Pack 1 (SP1) version.
  bool get isWindows7SP1OrGreater;

  /// Indicates if the current OS version matches, or is greater than, the Windows
  /// 8 version.
  bool get isWindows8OrGreater;

  /// Indicates if the current OS version matches, or is greater than, the Windows
  /// 8.1 version.
  bool get isWindows8Point1OrGreater;

  /// Indicates if the current OS version matches, or is greater than, the Windows
  /// 10 version.
  bool get isWindows10OrGreater;

  /// Indicates if the current OS is a Windows Server release. Applications that
  /// need to distinguish between server and client versions of Windows should
  /// call this function.
  bool get isWindowsServer;

  /// Indicates if the current OS version matches, or is greater than, the provided
  /// version information. This function is useful in confirming a version of
  /// Windows Server that doesn't share a version number with a client release.
  ///
  /// **Important** You should only use this function if the other provided [Version
  /// Helper functions](https://learn.microsoft.com/en-us/windows/desktop/SysInfo/version-helper-apis)
  /// do not fit within your scenarios.
  ///
  /// [majorVersion] The major OS version number.
  ///
  /// [minorVersion] The minor OS version number.
  ///
  /// [servicePackMajor] The major Service Pack version number.
  ///
  /// TRUE if the specified version matches, or is greater than, the version of
  /// the current Windows OS; otherwise, FALSE.
  bool isWindowsVersionOrGreater({
    int majorVersion = 0,
    int minorVersion = 0,
    int servicePackMajor = 0,
  });
}

/// Contains operating system version information. The information includes major
/// and minor version numbers, a build number, a platform identifier, and information
/// about product suites and the latest Service Pack installed on the system. This
/// structure is used with the [GetVersionEx](https://learn.microsoft.com/en-us/windows/desktop/api/sysinfoapi/nf-sysinfoapi-getversionexa)
/// and [VerifyVersionInfo](https://learn.microsoft.com/en-us/windows/desktop/api/winbase/nf-winbase-verifyversioninfoa)
/// functions.
final class WindowsVersion {
  /// The major version number of the operating system.
  final int majorVersion;

  /// The minor version number of the operating system.
  final int minorVersion;

  /// The build number of the operating system.
  final int buildNumber;

  /// A null-terminated string, such as "Service Pack 3", that indicates the latest
  /// Service Pack installed on the system. If no Service Pack has been installed,
  /// the string is empty.
  final String csdVersion;

  /// The major version number of the latest Service Pack installed on the system.
  /// For example, for Service Pack 3, the major version number is 3. If no Service
  /// Pack has been installed, the value is zero.
  final int servicePackMajor;

  /// The minor version number of the latest Service Pack installed on the system.
  /// For example, for Service Pack 3, the minor version number is 0.
  final int servicePackMinor;

  /// Any additional information about the system. This member can be one of the
  /// following values.
  ///
  /// |Value|Meaning|
  /// |:-|:-|
  /// |VER_NT_DOMAIN_CONTROLLER<br>0x0000002|The system is a domain controller and the operating system is Windows Server 2012 , Windows Server 2008 R2, Windows Server 2008, Windows Server 2003, or Windows 2000 Server.|
  /// |VER_NT_SERVER<br>0x0000003|The operating system is Windows Server 2012, Windows Server 2008 R2, Windows Server 2008, Windows Server 2003, or Windows 2000 Server.<br>Note that a server that is also a domain controller is reported as `VER_NT_DOMAIN_CONTROLLER`, not `VER_NT_SERVER`.|
  /// |VER_NT_WORKSTATION<br>0x0000001|The operating system is Windows 8, Windows 7, Windows Vista, Windows XP Professional, Windows XP Home Edition, or Windows 2000 Professional.|
  final WindowsType type;

  /// Constructs a [WindowsVersion].
  WindowsVersion({
    this.majorVersion = 0,
    this.minorVersion = 0,
    this.buildNumber = 0,
    this.csdVersion = '',
    this.servicePackMajor = 0,
    this.servicePackMinor = 0,
    this.type = WindowsType.unknown,
  });

  /// Constructs a [WindowsVersion] from [OSVERSIONINFOEXW].
  factory WindowsVersion.fromOSVERSIONINFOEXW(OSVERSIONINFOEXW info) {
    final csdVersionCharCodes = <int>[];
    for (var i = 0; i < 128; i++) {
      final charCode = info.szCSDVersion[i];
      if (charCode == 0x00) {
        break;
      }
      csdVersionCharCodes.add(charCode);
    }
    final csdVersion = String.fromCharCodes(csdVersionCharCodes);
    return WindowsVersion(
      majorVersion: info.dwMajorVersion,
      minorVersion: info.dwMinorVersion,
      buildNumber: info.dwBuildNumber,
      csdVersion: csdVersion,
      servicePackMajor: info.wServicePackMajor,
      servicePackMinor: info.wServicePackMinor,
      type: info.wProductType.toWindowsType(),
    );
  }

  @override
  String toString() {
    final mainVersion = '$majorVersion.$minorVersion.$buildNumber';
    return csdVersion.isEmpty ? mainVersion : '$mainVersion $csdVersion';
  }
}

/// WindowsType.
enum WindowsType {
  /// The operating system is unknown.
  unknown,

  /// The operating system is Windows 8, Windows 7, Windows Vista, Windows XP
  /// Professional, Windows XP Home Edition, or Windows 2000 Professional.
  workstation,

  /// The system is a domain controller and the operating system is Windows
  /// Server 2012 , Windows Server 2008 R2, Windows Server 2008, Windows Server
  /// 2003, or Windows 2000 Server.
  domainController,

  /// The operating system is Windows Server 2012, Windows Server 2008 R2, Windows
  /// Server 2008, Windows Server 2003, or Windows 2000 Server.
  ///
  /// Note that a server that is also a domain controller is reported as
  /// `VER_NT_DOMAIN_CONTROLLER`, not `VER_NT_SERVER`.
  server,
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
