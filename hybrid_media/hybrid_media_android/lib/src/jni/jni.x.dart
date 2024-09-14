import 'package:hybrid_media_platform_interface/hybrid_media_platform_interface.dart';
import 'package:jni/jni.dart' as jni;

import 'android/app/_package.dart' as jni;
import 'android/content/_package.dart' as jni;
import 'android/media/_package.dart' as jni;

abstract final class JNI {
  static jni.Context get applicationContext {
    final reference = jni.Jni.getCachedApplicationContext();
    return jni.Context.fromReference(reference);
  }

  static jni.Activity get currentActivity {
    final reference = jni.Jni.getCurrentActivity();
    return jni.Activity.fromReference(reference);
  }
}

// ignore: camel_case_extensions
extension intX on int {
  RingerMode get ringerMode {
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

  RingerMode? get ringerModeOrNull {
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

  StreamType? get streamTypeOrNull {
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

extension StringX on String {
  jni.JString get jValue => toJString();
}

extension RingerModeX on RingerMode {
  int get jValue {
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

extension StreamTypeX on StreamType {
  int get jValue {
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
  int get jValue {
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
