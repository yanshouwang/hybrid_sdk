enum RingerMode {
  /// Ringer mode that will be silent and will not vibrate. (This overrides the
  /// vibrate setting.)
  silent,

  /// Ringer mode that will be silent and will vibrate. (This will cause the phone
  /// ringer to always vibrate, but the notification vibrate to only vibrate if
  /// set.)
  vibrate,

  /// Ringer mode that may be audible and may vibrate. It will be audible if the
  /// volume before changing out of this mode was audible. It will vibrate if the
  /// vibrate setting is on.
  normal,
}
