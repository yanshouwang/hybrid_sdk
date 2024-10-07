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
