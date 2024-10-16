// Run with `dart run pigeon --input api.dart`.

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/v4l2_api.dart',
    dartOptions: DartOptions(),
    gobjectHeaderOut: 'linux/hybrid_v4l2_api.h',
    gobjectSourceOut: 'linux/hybrid_v4l2_api.cc',
    gobjectOptions: GObjectOptions(),
  ),
)
@HostApi()
abstract class V4L2ViewHostAPI {
  int registerTexture();
  void updateTexture(int idArgs, Uint8List bufferArgs);
  void unregisterTexture(int idArgs);
}
