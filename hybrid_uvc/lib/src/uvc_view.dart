import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hybrid_logging/hybrid_logging.dart';
import 'package:logging/logging.dart';

import 'uvc_jni.dart' as jni;
import 'uvc_frame.dart';

class UVCView extends StatefulWidget with TypeLogger {
  final UVCFrame frame;
  final BoxFit fit;
  final bool fpsVisible;
  final TextStyle? fpsStyle;
  final Level? logLevel;

  const UVCView({
    super.key,
    required this.frame,
    this.fit = BoxFit.contain,
    this.fpsVisible = false,
    this.fpsStyle,
    this.logLevel,
  });

  @override
  State<UVCView> createState() => _UVCViewState();
}

class _UVCViewState extends State<UVCView> {
  int? _id;
  late int _frames;
  late final ValueNotifier<int> _fps;
  late final Timer _fpsTimer;

  Logger get logger => widget.logger;

  @override
  void initState() {
    super.initState();
    _frames = 0;
    _fps = ValueNotifier(0);
    _fpsTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        _fps.value = _frames;
        _frames = 0;
      },
    );
    final logLevel = widget.logLevel;
    if (logLevel != null) {
      _updateLogLevel(logLevel);
    }
  }

  @override
  Widget build(BuildContext context) {
    final frame = widget.frame;
    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    return ValueListenableBuilder(
      valueListenable: _fps,
      builder: (context, fps, child) {
        return DecoratedBox(
          decoration: _FPSDecoration(
            fps: widget.fpsVisible ? fps : null,
            style: widget.fpsStyle,
          ),
          child: child,
        );
      },
      child: FittedBox(
        fit: widget.fit,
        child: SizedBox(
          width: frame.width / devicePixelRatio,
          height: frame.height / devicePixelRatio,
          child: PlatformViewLink(
            viewType: 'hebei.dev/UVCView',
            surfaceFactory: (context, controller) {
              return AndroidViewSurface(
                controller: controller as AndroidViewController,
                hitTestBehavior: PlatformViewHitTestBehavior.opaque,
                gestureRecognizers: const {},
              );
            },
            onCreatePlatformView: (params) {
              return _initHybridAndroidView(
                params,
                hybridComposition: true,
                creationParams: {},
                creationParamsCodec: const StandardMessageCodec(),
              )..addOnPlatformViewCreatedListener((id) {
                  params.onPlatformViewCreated(id);
                  _id = id;
                  _updateNativeMemory(id, widget.frame);
                });
            },
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant UVCView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final id = _id;
    final frame = widget.frame;
    if (id != null && frame != oldWidget.frame) {
      _updateNativeMemory(id, frame);
    }
    final logLevel = widget.logLevel;
    if (logLevel != oldWidget.logLevel) {
      _updateLogLevel(logLevel);
    }
  }

  void _updateLogLevel(Level? logLevel) {
    logger.level = logLevel;
  }

  void _updateNativeMemory(int id, UVCFrame frame) async {
    final stopwatch = Stopwatch()..start();
    final view = jni.UVCViewFactory.INSTANCE.retrieve(id);
    var memory = view.getMemory();
    if (!memory.isNull) {
      logger.warning('UVC frame dropped.');
      return;
    }
    final memroy = frame.data.toJArray();
    view.setMemory(memroy);
    _frames++;
    stopwatch.stop();
  }

  @override
  void dispose() {
    _fpsTimer.cancel();
    _fps.dispose();
    super.dispose();
  }
}

AndroidViewController _initHybridAndroidView(
  PlatformViewCreationParams params, {
  required bool hybridComposition,
  TextDirection layoutDirection = TextDirection.ltr,
  dynamic creationParams,
  MessageCodec<dynamic>? creationParamsCodec,
}) {
  if (hybridComposition) {
    return PlatformViewsService.initExpensiveAndroidView(
      id: params.id,
      viewType: params.viewType,
      layoutDirection: layoutDirection,
      creationParams: creationParams,
      creationParamsCodec: creationParamsCodec,
    );
  } else {
    return PlatformViewsService.initSurfaceAndroidView(
      id: params.id,
      viewType: params.viewType,
      layoutDirection: layoutDirection,
      creationParams: creationParams,
      creationParamsCodec: creationParamsCodec,
    );
  }
}

final class _FPSDecoration extends Decoration {
  final int? fps;
  final TextStyle? style;

  _FPSDecoration({
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
