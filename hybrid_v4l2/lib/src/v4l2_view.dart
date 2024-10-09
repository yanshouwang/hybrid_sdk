import 'package:flutter/widgets.dart';

import 'v4l2_api.x.dart';
import 'v4l2_mapped_buffer.dart';

class V4L2View extends StatefulWidget {
  final V4L2MappedBuffer? mappedBuf;

  const V4L2View({
    super.key,
    this.mappedBuf,
  });

  @override
  State<V4L2View> createState() => _V4L2ViewState();
}

class _V4L2ViewState extends State<V4L2View> {
  final V4L2ViewHostAPI _api;
  final ValueNotifier<int?> _textureId;
  final ValueNotifier<int> _fps;
  final Stopwatch _watch;

  int _frames;
  bool _updating;

  _V4L2ViewState()
      : _api = V4L2ViewHostAPI(),
        _textureId = ValueNotifier(null),
        _fps = ValueNotifier(0),
        _watch = Stopwatch(),
        _frames = 0,
        _updating = false;

  @override
  void initState() {
    super.initState();
    _registerTexture();
    _watch.start();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _textureId,
      builder: (context, textureId, child) {
        return SizedBox.expand(
          child: textureId == null
              ? null
              : Texture(
                  textureId: textureId,
                ),
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant V4L2View oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mappedBuf != oldWidget.mappedBuf) {
      _updateTexture();
    }
  }

  @override
  void dispose() {
    _watch.stop();
    _unregisterTexture();
    _textureId.dispose();
    _fps.dispose();
    super.dispose();
  }

  void _registerTexture() async {
    _textureId.value = await _api.registerTexture();
    _updateTexture();
  }

  void _updateTexture() async {
    final id = _textureId.value;
    final mappedBuf = widget.mappedBuf;
    if (id == null || mappedBuf == null || _updating) {
      return;
    }
    _updating = true;
    try {
      await _api.updateTexture(id, mappedBuf.value);
      if (_watch.elapsed.inSeconds < 1) {
        _frames++;
      } else {
        _fps.value = _frames;
        _frames = 0;
        _watch.reset();
      }
      debugPrint('Frames: $_frames');
    } finally {
      _updating = false;
    }
  }

  void _unregisterTexture() async {
    final id = _textureId.value;
    if (id == null) {
      return;
    }
    await _api.unregisterTexture(id);
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
