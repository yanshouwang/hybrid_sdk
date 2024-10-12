import 'dart:async';

import 'package:flutter/widgets.dart';

import 'v4l2_api.x.dart';
import 'v4l2_rgbx_buffer.dart';

class V4L2View extends StatefulWidget {
  final V4L2RGBXBuffer? frame;
  final BoxFit fit;
  final bool fpsVisible;
  final TextStyle? fpsStyle;

  const V4L2View({
    super.key,
    required this.frame,
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
    _registerTexture();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ValueListenableBuilder(
        valueListenable: _id,
        builder: (context, id, child) {
          final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
          final frame = widget.frame;
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
            child: frame == null
                ? null
                : FittedBox(
                    fit: widget.fit,
                    child: SizedBox(
                      width: frame.width / devicePixelRatio,
                      height: frame.height / devicePixelRatio,
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
    if (widget.frame != oldWidget.frame) {
      _updateTexture();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _unregisterTexture();
    _id.dispose();
    _fps.dispose();
    super.dispose();
  }

  void _registerTexture() async {
    _id.value = await _api.registerTexture();
    _updateTexture();
  }

  void _updateTexture() async {
    final id = _id.value;
    final frame = widget.frame;
    if (id == null || frame == null || _updating) {
      return;
    }
    _updating = true;
    try {
      await _api.updateTexture(id, frame.value, frame.width, frame.height);
      _frames++;
    } finally {
      _updating = false;
    }
  }

  void _unregisterTexture() async {
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
