import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:hybrid_v4l2/src/api.dart';

import 'api.x.dart';
import 'rgba_buffer.dart';

class V4L2View extends StatefulWidget {
  final V4L2RGBABuffer? buffer;
  final BoxFit fit;
  final bool fpsVisible;
  final TextStyle? fpsStyle;

  const V4L2View({
    super.key,
    required this.buffer,
    this.fit = BoxFit.contain,
    this.fpsVisible = false,
    this.fpsStyle,
  });

  @override
  State<V4L2View> createState() => _V4L2ViewState();
}

class _V4L2ViewState extends State<V4L2View> {
  final V4L2ViewHostAPI _api;
  final ValueNotifier<int?> _id;
  final ValueNotifier<int> _fps;

  late final Timer _timer;

  int _frames;
  bool _updating;

  _V4L2ViewState()
      : _api = V4L2ViewHostAPI(),
        _id = ValueNotifier(null),
        _fps = ValueNotifier(0),
        _frames = 0,
        _updating = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        _fps.value = _frames;
        _frames = 0;
      },
    );
    _initTexture();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ValueListenableBuilder(
        valueListenable: _id,
        builder: (context, id, child) {
          final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
          final buffer = widget.buffer;
          return ValueListenableBuilder(
            valueListenable: _fps,
            builder: (context, fps, child) {
              return Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                foregroundDecoration: _FPSDecoration(
                  fps: widget.fpsVisible ? fps : null,
                  style: widget.fpsStyle,
                ),
                child: child,
              );
            },
            child: buffer == null
                ? null
                : FittedBox(
                    fit: widget.fit,
                    child: SizedBox(
                      width: buffer.width / devicePixelRatio,
                      height: buffer.height / devicePixelRatio,
                      child: id == null
                          ? null
                          : Texture(
                              textureId: id,
                            ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  @override
  void didUpdateWidget(covariant V4L2View oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.buffer != oldWidget.buffer) {
      _updateTexture();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _disposeTexture();
    _id.dispose();
    _fps.dispose();
    super.dispose();
  }

  void _initTexture() async {
    _id.value = await _api.registerTexture();
    _updateTexture();
  }

  void _updateTexture() async {
    final id = _id.value;
    final buffer = widget.buffer;
    if (id == null || buffer == null || _updating) {
      return;
    }
    _updating = true;
    try {
      final textureArgs = TextureArgs(
        bufferArgs: buffer.value,
        widthArgs: buffer.width,
        heightArgs: buffer.height,
      );
      await _api.markTextureFrameAvailable(id, textureArgs);
      _frames++;
    } finally {
      _updating = false;
    }
  }

  void _disposeTexture() async {
    final id = _id.value;
    if (id == null) {
      return;
    }
    await _api.unregisterTexture(id);
  }
}

final class _FPSDecoration extends Decoration {
  final int? fps;
  final TextStyle? style;

  const _FPSDecoration({
    required this.fps,
    this.style,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _FPSPainter(
      fps: fps,
      style: style,
    );
  }
}

final class _FPSPainter extends BoxPainter {
  final int? fps;
  final TextStyle? style;

  _FPSPainter({
    required this.fps,
    this.style,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    if (fps == null) {
      // fpsVisible is false.
      return;
    }
    final size = configuration.size ?? Size.zero;
    final textDirection = configuration.textDirection ?? TextDirection.ltr;
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$fps FPS',
        style: style,
      ),
      textDirection: textDirection,
    );
    textPainter.layout();
    offset = offset.translate(size.width - textPainter.width, 0.0);
    textPainter.paint(canvas, offset);
  }
}

// import 'package:flutter/rendering.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_elinux/widgets.dart';

// class V4L2View extends StatelessWidget {
//   const V4L2View({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const viewType = 'hebei.dev/v4l2_view';
//     return PlatformViewLink(
//       surfaceFactory: (context, controller) {
//         return ELinuxViewSurface(
//           controller: controller as ELinuxViewController,
//           hitTestBehavior: PlatformViewHitTestBehavior.opaque,
//           gestureRecognizers: const {},
//         );
//       },
//       onCreatePlatformView: (params) {
//         return PlatformViewsServiceELinux.initELinuxView(
//           id: params.id,
//           viewType: viewType,
//           layoutDirection: TextDirection.ltr,
//           creationParams: params,
//           creationParamsCodec: const StandardMessageCodec(),
//           onFocus: () => params.onFocusChanged(true),
//         )
//           ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
//           ..create();
//       },
//       viewType: viewType,
//     );
//   }
// }
