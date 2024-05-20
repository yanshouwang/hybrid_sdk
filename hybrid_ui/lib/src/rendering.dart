import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

final _owner = PipelineOwner();

@override
Future<Uint8List> renderWidgetToMemory({
  required BuildContext context,
  required Widget widget,
  Size? size,
  ImageByteFormat format = ImageByteFormat.rawRgba,
}) async {
  var isDirty = true;
  final view = View.of(context);
  final configuration = _getViewConfiguration(
    view: view,
    size: size,
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

ViewConfiguration _getViewConfiguration({
  required FlutterView view,
  Size? size,
}) {
  if (size == null) {
    return ViewConfiguration.fromView(view);
  } else {
    final logicalConstraints = BoxConstraints.tight(size);
    final devicePixelRatio = view.devicePixelRatio;
    final physicalConstraints = logicalConstraints * devicePixelRatio;
    return ViewConfiguration(
      physicalConstraints: physicalConstraints,
      logicalConstraints: logicalConstraints,
      devicePixelRatio: devicePixelRatio,
    );
  }
}

extension on RenderRepaintBoundary {
  bool get needsPaint {
    return kDebugMode ? debugNeedsPaint : false;
  }
}
