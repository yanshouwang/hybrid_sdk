/// Build information for a particular device partition.
///
/// Added in API level 29
abstract interface class Partition {
  /// The time (ms since epoch), at which this partition was built, see Build#TIME.
  ///
  /// Added in API level 29
  int get buildTimeMills;

  /// The build fingerprint of this partition, see Build#FINGERPRINT.
  ///
  /// Added in API level 29
  String get fingerprint;

  /// The name of this partition, e.g. "system", or "vendor"
  ///
  /// Added in API level 29
  String get name;
}
