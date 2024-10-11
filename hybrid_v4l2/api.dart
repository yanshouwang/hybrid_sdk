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
class TextureArgs {
  final Uint8List bufferArgs;
  final int widthArgs;
  final int heightArgs;

  TextureArgs(
    this.bufferArgs,
    this.widthArgs,
    this.heightArgs,
  );
}

@HostApi()
abstract class ViewHostAPI {
  int registerTexture();
  void updateTexture(
      int idArgs, Uint8List bufferArgs, int widthArgs, int heightArgs);
  void unregisterTexture(int idArgs);
}
