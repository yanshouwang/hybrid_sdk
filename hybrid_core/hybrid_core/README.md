# hybrid_core

The core library of the Hybrid SDK.

## Getting Started

Add `hybrid_core` as a dependency in your pubspec.yaml file.

``` yaml
dependencies:
  hybrid_core: ^<latest-version>
```

Or, run this command in your project folder.

``` shell
flutter pub add hybrid_core
```

## Features

|Feature|Android|iOS|macOS|
|:-|:-:|:-:|:-:|
|OS|🙆|🙆|🙆|

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
} else {
  throw TypeError();
}
```
3.Get the version.
``` Dart
// Android
final api = os.api;
// iOS and macOS
final version = os.versioin;
```
4.Check version.
``` Dart
// Android
final atLeastAPI = os.atLeastAPI(33);
// iOS and macOS
final version = DarwinOSVersion.number(17.0);
final atLeastVersion = os.atLeastVersion(version);
```

Check the [`example`][1] to see how to use the corresponding API.

[1]: example