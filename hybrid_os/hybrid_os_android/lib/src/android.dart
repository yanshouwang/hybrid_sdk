import 'package:hybrid_os_platform_interface/hybrid_os_platform_interface.dart';

/// Android.
abstract interface class Android implements OS {
  /// The base OS build the product is based on.
  ///
  /// Added in API level 23
  String get baseOS;

  /// The current development codename, or the string "REL" if this is a release
  /// build.
  ///
  /// Added in API level 4
  String get codename;

  /// The internal value used by the underlying source control to represent this
  /// build. E.g., a perforce changelist number or a git hash.
  ///
  /// Added in API level 1
  String get incremental;

  /// The media performance class of the device or 0 if none.
  ///
  /// If this value is not 0, the device conforms to the media performance class
  /// definition of the SDK version of this value. This value never changes while
  /// a device is booted, but it may increase when the hardware manufacturer
  /// provides an OTA update.
  ///
  /// Possible non-zero values are defined in [`Build.VERSION_CODES`](https://developer.android.com/reference/android/os/Build.VERSION_CODES?_gl=1*krfoi0*_up*MQ..*_ga*MTA5NzcyNjc3OS4xNzE4NzU5MzQ4*_ga_6HH9YJMN9M*MTcxODc1OTM0OC4xLjAuMTcxODc1OTM0OC4wLjAuMA..)
  /// starting with [`Build.VERSION_CODES#R`](https://developer.android.com/reference/android/os/Build.VERSION_CODES?_gl=1*2bz9va*_up*MQ..*_ga*MTA5NzcyNjc3OS4xNzE4NzU5MzQ4*_ga_6HH9YJMN9M*MTcxODc1OTM0OC4xLjAuMTcxODc1OTM0OC4wLjAuMA..#R).
  ///
  /// Added in API level 31
  int get mediaPerformanceClass;

  /// The developer preview revision of a prerelease SDK. This value will always
  /// be `0` on production platform builds/devices.
  ///
  /// When this value is nonzero, any new API added since the last officially
  /// published [`API level`](https://developer.android.com/reference/android/os/Build.VERSION#SDK_INT)
  /// is only guaranteed to be present on that specific preview revision. For
  /// example, an API `Activity.fooBar()` might be present in preview revision 1
  /// but renamed or removed entirely in preview revision 2, which may cause an
  /// app attempting to call it to crash at runtime.
  ///
  /// Experimental apps targeting preview APIs should check this value for equality
  /// (`==`) with the preview SDK revision they were built for before using any
  /// prerelease platform APIs. Apps that detect a preview SDK revision other than
  /// the specific one they expect should fall back to using APIs from the previously
  /// published API level only to avoid unwanted runtime exceptions.
  ///
  /// Added in API level 23
  int get previewSDK;

  /// The user-visible version string. E.g., "1.0" or "3.4b5" or "bananas". This
  /// field is an opaque string. Do not assume that its value has any particular
  /// structure or that values of RELEASE from different releases can be somehow
  /// ordered.
  ///
  /// Added in API level 1
  String get release;

  /// The version string. May be [`RELEASE`](https://developer.android.com/reference/android/os/Build.VERSION#RELEASE)
  /// or [`CODENAME`](https://developer.android.com/reference/android/os/Build.VERSION#CODENAME)
  /// if not a final release build.
  ///
  /// Added in API level 30
  String get releaseOrCodename;

  /// The version string we show to the user; may be [`RELEASE`](https://developer.android.com/reference/android/os/Build.VERSION#RELEASE)
  /// or a descriptive string if not a final release build.
  ///
  /// Added in API level 33
  String get releaseOrPreviewDisplay;

  /// The SDK version of the software currently running on this hardware device.
  /// This value never changes while a device is booted, but it may increase when
  /// the hardware manufacturer provides an OTA update.
  ///
  /// Possible values are defined in [`Build.VERSION_CODES`](https://developer.android.com/reference/android/os/Build.VERSION_CODES?_gl=1*76gc9s*_up*MQ..*_ga*MTA5NzcyNjc3OS4xNzE4NzU5MzQ4*_ga_6HH9YJMN9M*MTcxODc1OTM0OC4xLjAuMTcxODc1OTM0OC4wLjAuMA..).
  ///
  /// Added in API level 4
  int get sdk;

  /// The user-visible security patch level. This value represents the date when
  /// the device most recently applied a security patch.
  ///
  /// Added in API level 23
  String get securityPatch;
}
