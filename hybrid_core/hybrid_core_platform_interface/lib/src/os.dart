import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class OSPlatform extends PlatformInterface implements OS {
  final PipelineOwner _owner;

  /// Constructs a OSPlatform.
  OSPlatform()
      : _owner = PipelineOwner(),
        super(token: _token);

  static final Object _token = Object();

  static OSPlatform? _instance;

  /// The default instance of [OSPlatform] to use.
  static OSPlatform get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError('OS is not implemented on this platform.');
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [OSPlatform] when
  /// they register themselves.
  static set instance(OSPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  @override
  Future<Uint8List> renderWidgetToMemory({
    required BuildContext context,
    required Widget widget,
    Size? size,
    ImageByteFormat format = ImageByteFormat.rawRgba,
  }) async {
    var isDirty = true;
    final view = View.of(context);
    final configuration = ViewConfiguration(
      size: size ?? view.physicalSize / view.devicePixelRatio,
      devicePixelRatio: view.devicePixelRatio,
    );
    final rrb = RenderRepaintBoundary();
    final renderView = RenderView(
      view: view,
      configuration: configuration,
      child: rrb,
    );
    final owner = BuildOwner(
      focusManager: FocusManager.instance,
      onBuildScheduled: () {
        ///
        ///current render is dirty, mark it.
        ///
        isDirty = true;
      },
    );
    _owner.rootNode = renderView;
    renderView.prepareInitialFrame();
    final adapter = RenderObjectToWidgetAdapter(
      container: rrb,
      child: Directionality(
        textDirection: Directionality.of(context),
        child: widget,
      ),
    );
    final element = adapter.attachToRenderTree(owner);
    owner
      ..buildScope(element)
      ..finalizeTree();
    _owner
      ..flushLayout()
      ..flushCompositingBits()
      ..flushPaint();
    while (isDirty || rrb.needsPaint) {
      owner
        ..buildScope(element)
        ..finalizeTree();
      _owner
        ..flushLayout()
        ..flushCompositingBits()
        ..flushPaint();
      isDirty = false;
      const duration = Duration(milliseconds: 100);
      await Future.delayed(duration);
    }
    final image = await rrb.toImage(pixelRatio: view.devicePixelRatio);
    final data = await image.toByteData(format: format);
    if (data == null) {
      throw UnimplementedError();
    }
    return data.buffer.asUint8List();
  }
}

abstract class OS {
  factory OS() => OSPlatform.instance;

  Future<Uint8List> renderWidgetToMemory({
    required BuildContext context,
    required Widget widget,
    Size? size,
    ImageByteFormat format = ImageByteFormat.rawRgba,
  });
}

extension on RenderRepaintBoundary {
  bool get needsPaint {
    return kDebugMode ? debugNeedsPaint : false;
  }
}
