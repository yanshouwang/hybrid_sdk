import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hybrid_v4l2/hybrid_v4l2.dart';
import 'package:texture_rgba_renderer/texture_rgba_renderer_platform_interface.dart';

class TextureView extends StatefulWidget {
  final V4L2RGBABuffer? frame;

  const TextureView({
    super.key,
    this.frame,
  });

  @override
  State<TextureView> createState() => _TextureViewState();
}

class _TextureViewState extends State<TextureView> {
  late final ValueNotifier<int?> id;
  late final ValueNotifier<int> fps;
  late final Timer timer;

  int frames = 0;
  bool updating = false;

  @override
  void initState() {
    super.initState();
    id = ValueNotifier(null);
    fps = ValueNotifier(0);
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        fps.value = frames;
        frames = 0;
        debugPrint('FPS ${fps.value}');
      },
    );
    _registerTexture();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: id,
      builder: (context, id, child) {
        return SizedBox.expand(
          child: id == null
              ? null
              : Texture(
                  textureId: id,
                ),
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant TextureView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.frame != oldWidget.frame) {
      _updateTexture();
    }
  }

  @override
  void dispose() {
    timer.cancel();
    _unregisterTexture();
    id.dispose();
    super.dispose();
  }

  /// Create a texture with unique identifier [key].
  ///
  /// @return a texture id which can be used with
  /// ```dart
  /// Texture(textureId: textureId)
  /// ```
  Future<int> createTexture(int key) {
    return TextureRgbaRendererPlatform.instance.createTexture(key);
  }

  /// Close a texture with unique identifier [key].
  ///
  /// @return a boolean to indicate whether the operation is sucessfully executed.
  Future<bool> closeTexture(int key) {
    return TextureRgbaRendererPlatform.instance.closeTexture(key);
  }

  /// Provide the rgba data to the texture.
  Future<bool> onRgba(int key, Uint8List data, int height, int width) {
    return TextureRgbaRendererPlatform.instance
        .onRgba(key, data, height, width, 1);
  }

  void _registerTexture() async {
    id.value = await createTexture(hashCode);
  }

  void _updateTexture() async {
    final frame = widget.frame;
    if (frame == null || updating) {
      return;
    }
    updating = true;
    try {
      await onRgba(hashCode, frame.value, frame.height, frame.width);
      frames++;
    } finally {
      updating = false;
    }
  }

  void _unregisterTexture() async {
    await closeTexture(hashCode);
  }
}
