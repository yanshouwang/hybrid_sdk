# hybrid_core

The core library of the Hybrid SDK.

## Getting Started

Add `hybrid_core` as a dependency in your pubspec.yaml file.

``` YAML
dependencies:
  hybrid_core: ^<latest-version>
```

Or, run this command in your project folder.

``` shell
flutter pub add hybrid_core
```

## Topics

### OS

1. Get the `OS` instance.
``` Dart
final os = OS();
```
2. Check the OS type.
``` Dart
if (os is Android) {
  ...
} else if (os is iOS) {
  ...
} else if (os is macOS) {
  ...
} else if (os is Windows) {
  ...
} else if (os is Linux) {
  ...
} else {
  throw TypeError();
}
```
3.Get the version.
``` Dart
// Android
final api = os.api;
// iOS and macOS
final version = os.version;
// Windows
final version = os.version;
```
4.Check version.
``` Dart
// Android
final atLeastAPI = os.atLeastAPI(33);
// iOS and macOS
final version = DarwinOSVersion.number(17.0);
final atLeastVersion = os.atLeastVersion(version);
// Windows
final isWindowsXPOrGreater = os.isWindowsXPOrGreater;
final isWindowsXPSP1OrGreater = os.isWindowsXPSP1OrGreater;
final isWindowsXPSP2OrGreater = os.isWindowsXPSP2OrGreater;
final isWindowsXPSP3OrGreater = os.isWindowsXPSP3OrGreater;
final isWindowsVistaOrGreater = os.isWindowsVistaOrGreater;
final isWindowsVistaSP1OrGreater = os.isWindowsVistaSP1OrGreater;
final isWindowsVistaSP2OrGreater = os.isWindowsVistaSP2OrGreater;
final isWindows7OrGreater = os.isWindows7OrGreater;
final isWindows7SP1OrGreater = os.isWindows7SP1OrGreater;
final isWindows8OrGreater = os.isWindows8OrGreater;
final isWindows8Point1OrGreater = os.isWindows8Point1OrGreater;
final isWindows10OrGreater = os.isWindows10OrGreater;
final isWindowsServer = os.isWindowsServer;
final isWindowsVersionOrGreater = os.isWindowsVersionOrGreater(
  majorVersion: 10,
  minorVersion: 0,
  servicePackMajor: 0,
);
```
5. Render a widget to memory.
``` Dart
final memory = await os.renderWidgetToMemory(
  context: context,
  widget: widget,
  size: size,
  format: format,
);
```

Check the [`example`][1] to see how to use the corresponding API.

[1]: example