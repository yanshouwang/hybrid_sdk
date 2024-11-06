import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';

import 'api.x.dart';

class V4L2TextureArgs {
  final Uint8List buffer;
  final int width;
  final int height;

  V4L2TextureArgs({
    required this.buffer,
    required this.width,
    required this.height,
  });
}

class V4L2TextureView extends StatefulWidget {
  final V4L2TextureArgs? args;
  final BoxFit fit;
  final bool fpsVisible;
  final TextStyle? fpsStyle;

  const V4L2TextureView({
    super.key,
    required this.args,
    this.fit = BoxFit.contain,
    this.fpsVisible = false,
    this.fpsStyle,
  });

  @override
  State<V4L2TextureView> createState() => _V4L2TextureViewState();
}

class _V4L2TextureViewState extends State<V4L2TextureView> {
  final V4L2ViewHostAPI _api;
  final ValueNotifier<int?> _id;
  final ValueNotifier<int> _fps;

  late final Timer _timer;

  int _frames;
  bool _updating;

  _V4L2TextureViewState()
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
          final args = widget.args;
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
            child: args == null
                ? null
                : FittedBox(
                    fit: widget.fit,
                    child: SizedBox(
                      width: args.width / devicePixelRatio,
                      height: args.height / devicePixelRatio,
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
  void didUpdateWidget(covariant V4L2TextureView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.args != oldWidget.args) {
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
    final args = widget.args;
    if (id == null || args == null || _updating) {
      return;
    }
    _updating = true;
    try {
      await _api.updateTexture(id, args.buffer, args.width, args.height);
      _frames++;
    } catch (e) {
      debugPrint('updateTexture failed, $e.');
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
