import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:hybrid_uvc/hybrid_uvc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final UVC uvc;
  late final ValueNotifier<ui.Image?> image;

  @override
  void initState() {
    super.initState();
    uvc = UVC();
    image = ValueNotifier(null);
    uvc.initialize(handleUVCFrame);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: ValueListenableBuilder(
          valueListenable: image,
          builder: (context, image, child) {
            return RawImage(
              image: image,
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
  }

  bool _handling = false;

  void handleUVCFrame(UVCFrame frame) async {
    if (_handling) {
      return;
    }
    _handling = true;
    try {
      final buffer = await ui.ImmutableBuffer.fromUint8List(frame.value);
      final descriptor = ui.ImageDescriptor.raw(
        buffer,
        width: frame.width,
        height: frame.height,
        pixelFormat: ui.PixelFormat.rgba8888,
      );
      final codec = await descriptor.instantiateCodec();
      final info = await codec.getNextFrame();
      image.value = info.image;
    } finally {
      _handling = false;
    }
  }
}
