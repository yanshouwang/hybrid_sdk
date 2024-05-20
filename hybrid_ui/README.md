# hybrid_ui

The core library of the Hybrid SDK.

## Getting Started

Add `hybrid_ui` as a dependency in your pubspec.yaml file.

``` YAML
dependencies:
  hybrid_ui: ^<latest-version>
```

Or, run this command in your project folder.

``` shell
flutter pub add hybrid_ui
```

## Topics

1. Render a widget to memory.
``` Dart
final memory = await renderWidgetToMemory(
  context: context,
  widget: widget,
  size: size,
  format: format,
);
```

Check the [`example`][1] to see how to use the corresponding API.

[1]: example