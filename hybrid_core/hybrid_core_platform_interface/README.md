# hybrid_core_platform_interface

A common platform interface for the [`hybrid_core`][1] plugin.

This interface allows platform-specific implementations of the `hybrid_core`
plugin, as well as the plugin itself, to ensure they are supporting the
same interface.

# Usage

To implement a new platform-specific implementation of `hybrid_core`, extend 
[`NativeOS`][2] with an implementation that performs the
platform-specific behavior, and when you register your plugin, set the 
default `NativeOS` by calling `NativeOS.instance = NativeOSImpl()`.

# Note on breaking changes

Strongly prefer non-breaking changes (such as adding a method to the interface)
over breaking changes for this package.

See https://flutter.dev/go/platform-interface-breaking-changes for a discussion
on why a less-clean interface is preferable to a breaking change.

[1]: https://pub.dev/packages/hybrid_core
[2]: lib/src/os.dart
