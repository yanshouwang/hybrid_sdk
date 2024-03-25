import 'dart:typed_data';

abstract class VisionImage {
  final int rotationDegrees;

  VisionImage({
    required this.rotationDegrees,
  });

  factory VisionImage.uri(
    Uri uri, {
    int rotationDegrees = 0,
  }) =>
      UriVisionImage(
        uri: uri,
        rotationDegrees: rotationDegrees,
      );

  factory VisionImage.memory(
    Uint8List memory, {
    int rotationDegrees = 0,
  }) =>
      MemoryVisionImage(
        memory: memory,
        rotationDegrees: rotationDegrees,
      );
}

class UriVisionImage extends VisionImage {
  final Uri uri;

  UriVisionImage({
    required this.uri,
    required super.rotationDegrees,
  });
}

class MemoryVisionImage extends VisionImage {
  final Uint8List memory;

  MemoryVisionImage({
    required this.memory,
    required super.rotationDegrees,
  });
}
