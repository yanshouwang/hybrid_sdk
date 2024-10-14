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
class V4L2TextureArgs {
  final Uint8List bufferArgs;
  final int widthArgs;
  final int heightArgs;

  V4L2TextureArgs(
    this.bufferArgs,
    this.widthArgs,
    this.heightArgs,
  );
}

@HostApi()
abstract class V4L2ViewHostAPI {
  int registerTexture();
  void updateTexture(int idArgs, V4L2TextureArgs textureArgs);
  void unregisterTexture(int idArgs);
}
