import 'dart:async';

import 'package:hybrid_logging/hybrid_logging.dart';
import 'package:hybrid_media_platform_interface/hybrid_media_platform_interface.dart';
import 'package:jni/jni.dart' as jni;

import 'jni.dart' as jni;

const _kVolumeChangedAction = 'android.media.VOLUME_CHANGED_ACTION';
const _kExtraVolumeStreamType = 'android.media.EXTRA_VOLUME_STREAM_TYPE';
const _kExtraVolumeStreamValue = 'android.media.EXTRA_VOLUME_STREAM_VALUE';

final class AudioManagerImpl with TypeLogger implements AudioManager {
  final jni.AudioManager jValue;

  final StreamController<RingerModeChangedEventArgs>
      _ringerModeChangedController;
  final StreamController<VolumeChangedEventArgs> _volumeChangedController;

  AudioManagerImpl()
      : jValue = jni.ContextCompat.getSystemService(
          jni.context,
          jni.AudioManager.type.jClass,
          T: jni.AudioManager.type,
        ),
        _ringerModeChangedController = StreamController.broadcast(),
        _volumeChangedController = StreamController.broadcast() {
    final callback = jni.BroadcastReceiverImpl_BroadcastCallback.implement(
      jni.$BroadcastReceiverImpl_BroadcastCallback(
        onReceive: (context, intent) {
          final action = '${intent.getAction()}';
          if (action == '${jni.AudioManager.RINGER_MODE_CHANGED_ACTION}') {
            final mode = intent
                .getIntExtra(jni.AudioManager.EXTRA_RINGER_MODE, -1)
                .toRingerModeOrNull();
            if (mode == null) {
              logger.warning(
                  '${jni.AudioManager.RINGER_MODE_CHANGED_ACTION} is ignored: mode $mode.');
              return;
            }
            final eventArgs = RingerModeChangedEventArgs(mode);
            _ringerModeChangedController.add(eventArgs);
          } else if (action == _kVolumeChangedAction) {
            final type = intent
                .getIntExtra(_kExtraVolumeStreamType.toJString(), -1)
                .toStreamTypeOrNull();
            final volume =
                intent.getIntExtra(_kExtraVolumeStreamValue.toJString(), -1);
            if (type == null || volume == -1) {
              logger.warning(
                  '$_kVolumeChangedAction is ignored: type $type, value $volume.');
              return;
            }
            final eventArgs = VolumeChangedEventArgs(
              type: type,
              volume: volume,
            );
            _volumeChangedController.add(eventArgs);
          } else {
            logger.warning('Unexpected action: $action');
          }
        },
      ),
    );
    final receiver = jni.BroadcastReceiverImpl(callback);
    final filter = jni.IntentFilter();
    filter.addAction(jni.AudioManager.RINGER_MODE_CHANGED_ACTION);
    filter.addAction(_kVolumeChangedAction.toJString());
    jni.ContextCompat.registerReceiver(
      jni.context,
      receiver,
      filter,
      jni.ContextCompat.RECEIVER_NOT_EXPORTED,
    );
  }

  @override
  Stream<RingerModeChangedEventArgs> get ringerModeChanged =>
      _ringerModeChangedController.stream;

  @override
  Stream<VolumeChangedEventArgs> get volumeChanged =>
      _volumeChangedController.stream;

  @override
  bool get isVolumeFixed => jValue.isVolumeFixed();

  @override
  RingerMode get ringerMode => jValue.getRingerMode().toRingerMode();
  @override
  set ringerMode(RingerMode value) {
    jValue.setRingerMode(value.toJRingerMode());
  }

  @override
  int getStreamMinVolume(StreamType type) {
    final value = jValue.getStreamMinVolume(type.toJStreamType());
    return value;
  }

  @override
  int getStreamMaxVolume(StreamType type) {
    final value = jValue.getStreamMaxVolume(type.toJStreamType());
    return value;
  }

  @override
  int getStreamVolume(StreamType type) {
    final value = jValue.getStreamVolume(type.toJStreamType());
    return value;
  }

  @override
  void setStreamVolume(
    StreamType type, {
    required int volume,
    bool? showUI,
    bool? allowRingerModes,
    bool? playSound,
    bool? removeSoundAndVibrate,
    bool? vibrate,
  }) {
    var flags = 0;
    if (showUI == true) {
      flags |= jni.AudioManager.FLAG_SHOW_UI;
    }
    if (allowRingerModes == true) {
      flags |= jni.AudioManager.FLAG_ALLOW_RINGER_MODES;
    }
    if (playSound == true) {
      flags |= jni.AudioManager.FLAG_PLAY_SOUND;
    }
    if (removeSoundAndVibrate == true) {
      flags |= jni.AudioManager.FLAG_REMOVE_SOUND_AND_VIBRATE;
    }
    if (vibrate == true) {
      flags |= jni.AudioManager.FLAG_VIBRATE;
    }
    jValue.setStreamVolume(type.toJStreamType(), volume, flags);
  }

  @override
  void adjustStreamVolume(
    StreamType type, {
    required AdjustDirection direction,
    bool? showUI,
    bool? allowRingerModes,
    bool? playSound,
    bool? removeSoundAndVibrate,
    bool? vibrate,
  }) {
    var flags = 0;
    if (showUI == true) {
      flags |= jni.AudioManager.FLAG_SHOW_UI;
    }
    if (allowRingerModes == true) {
      flags |= jni.AudioManager.FLAG_ALLOW_RINGER_MODES;
    }
    if (playSound == true) {
      flags |= jni.AudioManager.FLAG_PLAY_SOUND;
    }
    if (removeSoundAndVibrate == true) {
      flags |= jni.AudioManager.FLAG_REMOVE_SOUND_AND_VIBRATE;
    }
    if (vibrate == true) {
      flags |= jni.AudioManager.FLAG_VIBRATE;
    }
    // TODO: mute, unmute and toggleMute are only available after API level 23.
    jValue.adjustStreamVolume(
        type.toJStreamType(), direction.toJAdjust(), flags);
  }
}

extension on int {
  RingerMode toRingerMode() {
    switch (this) {
      case jni.AudioManager.RINGER_MODE_SILENT:
        return RingerMode.silent;
      case jni.AudioManager.RINGER_MODE_VIBRATE:
        return RingerMode.vibrate;
      case jni.AudioManager.RINGER_MODE_NORMAL:
        return RingerMode.normal;
      default:
        throw ArgumentError.value(this);
    }
  }

  RingerMode? toRingerModeOrNull() {
    switch (this) {
      case jni.AudioManager.RINGER_MODE_SILENT:
        return RingerMode.silent;
      case jni.AudioManager.RINGER_MODE_VIBRATE:
        return RingerMode.vibrate;
      case jni.AudioManager.RINGER_MODE_NORMAL:
        return RingerMode.normal;
      default:
        return null;
    }
  }

  StreamType? toStreamTypeOrNull() {
    switch (this) {
      case jni.AudioManager.STREAM_VOICE_CALL:
        return StreamType.voiceCall;
      case jni.AudioManager.STREAM_SYSTEM:
        return StreamType.system;
      case jni.AudioManager.STREAM_RING:
        return StreamType.ring;
      case jni.AudioManager.STREAM_MUSIC:
        return StreamType.music;
      case jni.AudioManager.STREAM_ALARM:
        return StreamType.alarm;
      case jni.AudioManager.STREAM_NOTIFICATION:
        return StreamType.notification;
      case jni.AudioManager.STREAM_DTMF:
        return StreamType.dtmf;
      case jni.AudioManager.STREAM_ACCESSIBILITY:
        return StreamType.accessibility;
      default:
        return null;
    }
  }
}

extension on RingerMode {
  int toJRingerMode() {
    switch (this) {
      case RingerMode.silent:
        return jni.AudioManager.RINGER_MODE_SILENT;
      case RingerMode.vibrate:
        return jni.AudioManager.RINGER_MODE_VIBRATE;
      case RingerMode.normal:
        return jni.AudioManager.RINGER_MODE_NORMAL;
    }
  }
}

extension on StreamType {
  int toJStreamType() {
    switch (this) {
      case StreamType.voiceCall:
        return jni.AudioManager.STREAM_VOICE_CALL;
      case StreamType.system:
        return jni.AudioManager.STREAM_SYSTEM;
      case StreamType.ring:
        return jni.AudioManager.STREAM_RING;
      case StreamType.music:
        return jni.AudioManager.STREAM_MUSIC;
      case StreamType.alarm:
        return jni.AudioManager.STREAM_ALARM;
      case StreamType.notification:
        return jni.AudioManager.STREAM_NOTIFICATION;
      case StreamType.dtmf:
        return jni.AudioManager.STREAM_DTMF;
      case StreamType.accessibility:
        return jni.AudioManager.STREAM_ACCESSIBILITY;
    }
  }
}

extension AdjustDirectionX on AdjustDirection {
  int toJAdjust() {
    switch (this) {
      case AdjustDirection.lower:
        return jni.AudioManager.ADJUST_LOWER;
      case AdjustDirection.same:
        return jni.AudioManager.ADJUST_SAME;
      case AdjustDirection.raise:
        return jni.AudioManager.ADJUST_RAISE;
      case AdjustDirection.mute:
        return jni.AudioManager.ADJUST_MUTE;
      case AdjustDirection.unmute:
        return jni.AudioManager.ADJUST_UNMUTE;
      case AdjustDirection.toggleMute:
        return jni.AudioManager.ADJUST_TOGGLE_MUTE;
    }
  }
}
