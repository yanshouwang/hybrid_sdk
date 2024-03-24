# hybrid_vision

Apply computer vision algorithms to perform a variety of tasks on input images and video.

## Overview

The Vision framework performs face and face landmark detection, text detection, barcode 
recognition, image registration, and general feature tracking. Vision also allows the use 
of custom Core ML models for tasks like classification or object detection.

*Notice:* This plugin use [`MLKit`][1] on Android, [`Vision`][2] on iOS and macOS.

## Getting Started

Add `hybrid_vision` as a dependency in your pubspec.yaml file.

``` yaml
dependencies:
  hybrid_vision: ^<latest-version>
```

Or, run this command in your project folder.

``` shell
flutter pub add hybrid_vision
```

## Features

|Feature|Android|iOS|macOS|
|:-|:-:|:-:|:-:|
|Face and face landmark detection||||
|Text detection||||
|Barcode detection|🙆|🙆|🙆|
|Image registration||||
|General feature tracking||||
|Custom Core ML models||||

## Topics

### Barcode Detection

The supported barcode formats are listed here, but some formats are only supported 
on higher version iOS and macOS, you should check the [apple's document][3] to ensure the formats 
you want to use is available.

|Format|Android|iOS|macOS|
|-|:-:|:-:|:-:|
|Aztec|🙆|🙆|🙆|
|Codabar|🙆|🙆 15.0+|🙆 12.0+|
|Code 128|🙆|🙆|🙆|
|Code 39|🙆|🙆|🙆|
|Code 93|🙆|🙆|🙆|
|Data Matrix|🙆|🙆|🙆|
|EAN-13|🙆|🙆|🙆|
|EAN-8|🙆|🙆|🙆|
|GS1 DataBar||🙆 15.0+|🙆 12.0+|
|ITF|🙆|🙆|🙆|
|Modified Plessey||🙆 17.0+|🙆 14.0+|
|PDF417|🙆|🙆|🙆|
|QR Code|🙆|🙆|🙆|
|UPC-A|🙆|🙆|🙆|
|UPC-E|🙆|🙆|🙆|

Check the [`example`][4] to see how to use the corresponding API.

[1]: https://developers.google.com/ml-kit
[2]: https://developer.apple.com/documentation/vision
[3]: https://developer.apple.com/documentation/vision/vnbarcodesymbology
[4]: example
