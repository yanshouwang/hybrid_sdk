import 'dart:async';

import 'package:clover/clover.dart';
import 'package:hybrid_logging/hybrid_logging.dart';
import 'package:hybrid_media_platform_interface/hybrid_media_platform_interface.dart';

final class HomeViewModel extends ViewModel with TypeLogger {
  final AudioManager _audioManager;

  late RingerMode _ringerMode;
  late final int musicMinVolume;
  late final int musicMaxVolume;
  late int _musicVolume;
  late final int ringMinVolume;
  late final int ringMaxVolume;
  late int _ringVolume;
  late final int notificationMinVolume;
  late final int notificationMaxVolume;
  late int _notificationVolume;
  late final int alarmMinVolume;
  late final int alarmMaxVolume;
  late int _alarmVolume;
  late final StreamSubscription _ringerModeChangedSubscription;
  late final StreamSubscription _volumeChangedSubscription;

  HomeViewModel() : _audioManager = AudioManager() {
    // Ringer mode
    _ringerMode = _audioManager.ringerMode;
    // Music
    musicMinVolume = _audioManager.getStreamMinVolume(StreamType.music);
    musicMaxVolume = _audioManager.getStreamMaxVolume(StreamType.music);
    _musicVolume = _audioManager.getStreamVolume(StreamType.music);
    // Ring
    ringMinVolume = _audioManager.getStreamMinVolume(StreamType.ring);
    ringMaxVolume = _audioManager.getStreamMaxVolume(StreamType.ring);
    _ringVolume = _audioManager.getStreamVolume(StreamType.ring);
    // Notification
    notificationMinVolume =
        _audioManager.getStreamMinVolume(StreamType.notification);
    notificationMaxVolume =
        _audioManager.getStreamMaxVolume(StreamType.notification);
    _notificationVolume =
        _audioManager.getStreamVolume(StreamType.notification);
    // Alarm
    alarmMinVolume = _audioManager.getStreamMinVolume(StreamType.alarm);
    alarmMaxVolume = _audioManager.getStreamMaxVolume(StreamType.alarm);
    _alarmVolume = _audioManager.getStreamVolume(StreamType.alarm);
    notifyListeners();
    // Ringer mode changed
    _ringerModeChangedSubscription = _audioManager.ringerModeChanged.listen(
      (eventArgs) {
        logger.info('ringer mode changed: ${eventArgs.mode}');
        _ringerMode = eventArgs.mode;
        notifyListeners();
      },
    );
    // Volume changed
    _volumeChangedSubscription = _audioManager.volumeChanged.listen(
      (eventArgs) {
        logger.info('volume changed: ${eventArgs.type}: ${eventArgs.volume}');
        switch (eventArgs.type) {
          case StreamType.music:
            _musicVolume = eventArgs.volume;
            break;
          case StreamType.ring:
            _ringVolume = eventArgs.volume;
            break;
          case StreamType.notification:
            _notificationVolume = eventArgs.volume;
            break;
          case StreamType.alarm:
            _alarmVolume = eventArgs.volume;
            break;
          default:
            break;
        }
        notifyListeners();
      },
    );
  }

  RingerMode get ringerMode => _ringerMode;
  set ringerMode(RingerMode value) => _audioManager.ringerMode = value;

  int get musicVolume => _musicVolume;
  set musicVolume(int value) => _audioManager.setStreamVolume(
        StreamType.music,
        volume: value,
      );

  int get ringVolume => _ringVolume;
  set ringVolume(int value) => _audioManager.setStreamVolume(
        StreamType.ring,
        volume: value,
      );

  int get notificationVolume => _notificationVolume;
  set notificationVolume(int value) => _audioManager.setStreamVolume(
        StreamType.notification,
        volume: value,
      );

  int get alarmVolume => _alarmVolume;
  set alarmVolume(int value) => _audioManager.setStreamVolume(
        StreamType.alarm,
        volume: value,
      );

  void toggleRingerMode() {
    switch (ringerMode) {
      case RingerMode.silent:
        ringerMode = RingerMode.vibrate;
        break;
      case RingerMode.vibrate:
        ringerMode = RingerMode.normal;
        break;
      case RingerMode.normal:
        ringerMode = RingerMode.silent;
        break;
    }
  }

  void toggleMusicMute() {
    _audioManager.adjustStreamVolume(
      StreamType.music,
      direction: AdjustDirection.toggleMute,
    );
  }

  void toggleRingMute() {
    _audioManager.adjustStreamVolume(
      StreamType.ring,
      direction: AdjustDirection.toggleMute,
    );
  }

  void toggleNotificationMute() {
    _audioManager.adjustStreamVolume(
      StreamType.notification,
      direction: AdjustDirection.toggleMute,
    );
  }

  void toggleAlarmMute() {
    _audioManager.adjustStreamVolume(
      StreamType.alarm,
      direction: AdjustDirection.toggleMute,
    );
  }

  @override
  void dispose() {
    _ringerModeChangedSubscription.cancel();
    _volumeChangedSubscription.cancel();
    super.dispose();
  }
}
