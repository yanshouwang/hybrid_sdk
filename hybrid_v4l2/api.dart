// Run with `dart run pigeon --input api.dart`.

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/api.dart',
    dartOptions: DartOptions(),
    gobjectHeaderOut: 'linux/hybrid_v4l2_api.h',
    gobjectSourceOut: 'linux/hybrid_v4l2_api.cc',
    gobjectOptions: GObjectOptions(),
  ),
)
class TextureArgs {
  final Uint8List bufferArgs;
  final int widthArgs;
  final int heightArgs;

  TextureArgs(this.bufferArgs, this.widthArgs, this.heightArgs);
}

@HostApi()
abstract class ViewHostAPI {
  int registerTexture();
  void markTextureFrameAvailable(int idArgs, TextureArgs textureArgs);
  void unregisterTexture(int idArgs);
}
