import 'dart:async';

import 'package:hybrid_logging/hybrid_logging.dart';
import 'package:hybrid_media_platform_interface/hybrid_media_platform_interface.dart';

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
          jni.JNI.applicationContext,
          jni.AudioManager.type.jClass,
          T: jni.AudioManager.type,
        ),
        _ringerModeChangedController = StreamController.broadcast(),
        _volumeChangedController = StreamController.broadcast() {
    final callback = jni.BroadcastReceiverImpl_BroadcastCallback.implement(
      jni.$BroadcastReceiverImpl_BroadcastCallbackImpl(
        onReceive: (context, intent) {
          final action = '${intent.getAction()}';
          if (action == '${jni.AudioManager.RINGER_MODE_CHANGED_ACTION}') {
            final mode = intent
                .getIntExtra(jni.AudioManager.EXTRA_RINGER_MODE, -1)
                .ringerModeOrNull;
            if (mode == null) {
              logger.warning(
                  '${jni.AudioManager.RINGER_MODE_CHANGED_ACTION} is ignored: mode $mode.');
              return;
            }
            final eventArgs = RingerModeChangedEventArgs(mode);
            _ringerModeChangedController.add(eventArgs);
          } else if (action == _kVolumeChangedAction) {
            final type = intent
                .getIntExtra(_kExtraVolumeStreamType.jValue, -1)
                .streamTypeOrNull;
            final volume =
                intent.getIntExtra(_kExtraVolumeStreamValue.jValue, -1);
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
    filter.addAction(_kVolumeChangedAction.jValue);
    jni.ContextCompat.registerReceiver(
      jni.JNI.applicationContext,
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
  RingerMode get ringerMode => jValue.getRingerMode().ringerMode;
  @override
  set ringerMode(RingerMode value) {
    jValue.setRingerMode(value.jValue);
  }

  @override
  int getStreamMinVolume(StreamType type) {
    final value = jValue.getStreamMinVolume(type.jValue);
    return value;
  }

  @override
  int getStreamMaxVolume(StreamType type) {
    final value = jValue.getStreamMaxVolume(type.jValue);
    return value;
  }

  @override
  int getStreamVolume(StreamType type) {
    final value = jValue.getStreamVolume(type.jValue);
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
    jValue.setStreamVolume(type.jValue, volume, flags);
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
    jValue.adjustStreamVolume(type.jValue, direction.jValue, flags);
  }
}
