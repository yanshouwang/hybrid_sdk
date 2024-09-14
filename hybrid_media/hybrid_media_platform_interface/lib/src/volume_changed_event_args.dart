import 'stream_type.dart';

final class VolumeChangedEventArgs {
  final StreamType type;
  final int volume;

  VolumeChangedEventArgs({
    required this.type,
    required this.volume,
  });
}
