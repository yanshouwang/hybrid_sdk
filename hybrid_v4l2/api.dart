// Run with `dart run pigeon --input api.dart`.

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/api.dart',
    dartOptions: DartOptions(),
    gobjectHeaderOut: 'linux/hybrid_v4l2_api.h',
    gobjectSourceOut: 'linux/hybrid_v4l2_api.cc',
    gobjectOptions: GObjectOptions(),
    cppHeaderOut: 'elinux/hybrid_v4l2_api.h',
    cppSourceOut: 'elinux/hybrid_v4l2_api.cc',
    cppOptions: CppOptions(),
  ),
)
@HostApi()
abstract class ViewHostAPI {
  int registerTexture();
  void updateTexture(
      int idArgs, Uint8List bufferArgs, int widthArgs, int heightArgs);
  void unregisterTexture(int idArgs);
}
