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
