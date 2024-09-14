import 'adjust_direction.dart';
import 'hybrid_media_plugin.dart';
import 'ringer_mode.dart';
import 'ringer_mode_changed_event_args.dart';
import 'stream_type.dart';
import 'volume_changed_event_args.dart';

abstract interface class AudioManager {
  static AudioManager? _instance;

  factory AudioManager() {
    var instance = _instance;
    if (instance == null) {
      _instance = instance = HybridMediaPlugin.instance.createAudioManager();
    }
    return instance;
  }

  /// Sticky broadcast intent action indicating that the ringer mode has changed.
  ///
  /// Includes the new ringer mode.
  Stream<RingerModeChangedEventArgs> get ringerModeChanged;

  /// Broadcast intent when the volume for a particular stream type changes.
  ///
  /// Includes the stream, the new volume and previous volumes
  Stream<VolumeChangedEventArgs> get volumeChanged;

  /// Indicates if the device implements a fixed volume policy.
  ///
  /// Some devices may not have volume control and may operate at a fixed volume,
  /// and may not enable muting or changing the volume of audio streams. This
  /// method will return true on such devices.
  ///
  /// The following APIs have no effect when volume is fixed:
  /// * adjustVolume(int,int)
  /// * adjustSuggestedStreamVolume(int,int,int)
  /// * adjustStreamVolume(int,int,int)
  /// * setStreamVolume(int,int,int)
  /// * setRingerMode(int)
  /// * setStreamSolo(int,boolean)
  /// * setStreamMute(int,boolean)
  bool get isVolumeFixed;

  /// Returns the current ringtone mode.
  RingerMode get ringerMode;

  /// Sets the ringer mode.
  ///
  /// Silent mode will mute the volume and will not vibrate. Vibrate mode will
  /// mute the volume and vibrate. Normal mode will be audible and may vibrate
  /// according to user settings.
  ///
  /// This method has no effect if the device implements a fixed volume policy as
  /// indicated by isVolumeFixed(). *
  ///
  /// From N onward, ringer mode adjustments that would toggle Do Not Disturb are
  /// not allowed unless the app has been granted Do Not Disturb Access. See
  /// NotificationManager#isNotificationPolicyAccessGranted().
  set ringerMode(RingerMode value);

  /// Returns the minimum volume index for a particular stream.
  ///
  /// [type] The stream type whose minimum volume index is returned.
  int getStreamMinVolume(StreamType type);

  /// Returns the maximum volume index for a particular stream.
  ///
  /// [type] The stream type whose maximum volume index is returned.
  int getStreamMaxVolume(StreamType type);

  /// Returns the current volume index for a particular stream.
  ///
  /// [type] The stream type whose volume index is returned.
  int getStreamVolume(StreamType type);

  /// Sets the volume index for a particular stream.
  ///
  /// This method has no effect if the device implements a fixed volume policy as
  /// indicated by isVolumeFixed()
  ///
  /// From N onward, volume adjustments that would toggle Do Not Disturb are not
  /// allowed unless the app has been granted Do Not Disturb Access. See
  /// NotificationManager#isNotificationPolicyAccessGranted().
  ///
  /// [type] The stream whose volume index should be set.
  ///
  /// [volume] The volume index to set. See getStreamMaxVolume(int) for the largest
  /// valid value.
  ///
  /// [showUI] Show a toast containing the current volume.
  ///
  /// [allowRingerModes] Whether to include ringer modes as possible options when
  /// changing volume. For example, if true and volume level is 0 and the volume
  /// is adjusted with ADJUST_LOWER, then the ringer mode may switch the silent
  /// or vibrate mode.
  ///
  /// By default this is on for the ring stream. If this flag is included, this
  /// behavior will be present regardless of the stream type being affected by
  /// the ringer mode.
  ///
  /// [playSound] Whether to play a sound when changing the volume.
  ///
  /// If this is given to adjustVolume(int,int) or adjustSuggestedStreamVolume(int,int,int),
  /// it may be ignored in some cases (for example, the decided stream type is
  /// not AudioManager#STREAM_RING, or the volume is being adjusted downward).
  ///
  /// [removeSoundAndVibrate] Removes any sounds/vibrate that may be in the queue,
  /// or are playing (related to changing volume).
  ///
  /// [vibrate] Whether to vibrate if going into the vibrate ringer mode.
  void setStreamVolume(
    StreamType type, {
    required int volume,
    bool? showUI,
    bool? allowRingerModes,
    bool? playSound,
    bool? removeSoundAndVibrate,
    bool? vibrate,
  });

  /// Adjusts the volume of a particular stream by one step in a direction.
  ///
  /// This method should only be used by applications that replace the platform-wide
  /// management of audio settings or the main telephony application.
  ///
  /// This method has no effect if the device implements a fixed volume policy as
  /// indicated by isVolumeFixed().
  ///
  /// From N onward, ringer mode adjustments that would toggle Do Not Disturb are
  /// not allowed unless the app has been granted Do Not Disturb Access. See
  /// NotificationManager#isNotificationPolicyAccessGranted().
  ///
  /// [type] The stream whose volume index should be set.
  ///
  /// [direction] The direction to adjust the volume.
  ///
  /// [showUI] Show a toast containing the current volume.
  ///
  /// [allowRingerModes] Whether to include ringer modes as possible options when
  /// changing volume. For example, if true and volume level is 0 and the volume
  /// is adjusted with ADJUST_LOWER, then the ringer mode may switch the silent
  /// or vibrate mode.
  ///
  /// By default this is on for the ring stream. If this flag is included, this
  /// behavior will be present regardless of the stream type being affected by
  /// the ringer mode.
  ///
  /// [playSound] Whether to play a sound when changing the volume.
  ///
  /// If this is given to adjustVolume(int,int) or adjustSuggestedStreamVolume(int,int,int),
  /// it may be ignored in some cases (for example, the decided stream type is
  /// not AudioManager#STREAM_RING, or the volume is being adjusted downward).
  ///
  /// [removeSoundAndVibrate] Removes any sounds/vibrate that may be in the queue,
  /// or are playing (related to changing volume).
  ///
  /// [vibrate] Whether to vibrate if going into the vibrate ringer mode.
  void adjustStreamVolume(
    StreamType type, {
    required AdjustDirection direction,
    bool? showUI,
    bool? allowRingerModes,
    bool? playSound,
    bool? removeSoundAndVibrate,
    bool? vibrate,
  });
}
