import 'package:hybrid_os_platform_interface/hybrid_os_platform_interface.dart';

import 'android_impl.dart';
import 'partition.dart';
import 'settings.dart';
import 'window.dart';

/// Android.
abstract interface class Android implements OS {
  static Android? _instance;

  factory Android() {
    var instance = _instance;
    if (instance == null) {
      _instance = instance = AndroidImpl();
    }
    return instance;
  }

  /// The name of the underlying board, like "goldfish".
  ///
  /// Added in API level 1
  String get board;

  /// The system bootloader version number.
  ///
  /// Added in API level 8
  String get bootloader;

  /// The consumer-visible brand with which the product/hardware will be associated,
  /// if any.
  ///
  /// Added in API level 1
  String get brand;

  /// The name of the instruction set (CPU type + ABI convention) of native code.
  ///
  /// This field was deprecated in API level 21.
  ///
  /// Use SUPPORTED_ABIS instead.
  ///
  /// Added in API level 4
  ///
  /// Deprecated in API level 21
  String get cpuABI;

  /// The name of the second instruction set (CPU type + ABI convention) of native code.
  ///
  /// This field was deprecated in API level 21.
  ///
  /// Use SUPPORTED_ABIS instead.
  ///
  /// Added in API level 8
  ///
  /// Deprecated in API level 21
  String get cpuABI2;

  /// The name of the industrial design.
  ///
  /// Added in API level 1
  String get device;

  /// A build ID string meant for displaying to the user
  ///
  /// Added in API level 3
  String get display;

  /// A string that uniquely identifies this build. Do not attempt to parse this value.
  ///
  /// Added in API level 1
  String get fingerprint;

  /// The name of the hardware (from the kernel command line or /proc).
  ///
  /// Added in API level 8
  String get hardware;

  /// Added in API level 1
  String get host;

  /// Either a changelist number, or a label like "M4-rc20".
  ///
  /// Added in API level 1
  String get id;

  /// The manufacturer of the product/hardware.
  ///
  /// Added in API level 4
  String get manufacturer;

  /// The end-user-visible name for the end product.
  ///
  /// Added in API level 1
  String get model;

  /// The SKU of the device as set by the original design manufacturer (ODM).
  ///
  /// This is a runtime-initialized property set during startup to configure device
  /// services. If no value is set, this is reported as UNKNOWN.
  ///
  /// The ODM SKU may have multiple variants for the same system SKU in case a
  /// manufacturer produces variants of the same design. For example, the same
  /// build may be released with variations in physical keyboard and/or display
  /// hardware, each with a different ODM SKU.
  ///
  /// Added in API level 31
  String get odmSKU;

  /// The name of the overall product.
  ///
  /// Added in API level 1
  String get product;

  /// The radio firmware version number.
  ///
  /// This field was deprecated in API level 15.
  ///
  /// The radio firmware version is frequently not available when this class is
  /// initialized, leading to a blank or "unknown" value for this string. Use
  /// getRadioVersion() instead.
  ///
  /// Added in API level 8
  ///
  /// Deprecated in API level 15
  String get radio;

  /// A hardware serial number, if available. Alphanumeric only, case-insensitive.
  /// This field is always set to Build.UNKNOWN.
  ///
  /// This field was deprecated in API level 26.
  ///
  /// Use getSerial() instead.
  ///
  /// Added in API level 9
  ///
  /// Deprecated in API level 26
  ///
  /// Note: Root access may allow you to modify device identifiers, such as the
  /// hardware serial number. If you change these identifiers, you can not use
  /// key attestation to obtain proof of the device's original identifiers. KeyMint
  /// will reject an ID attestation request if the identifiers provided by the
  /// frameworks do not match the identifiers it was provisioned with.
  ///
  /// Starting with API level 29, persistent device identifiers are guarded behind
  /// additional restrictions, and apps are recommended to use resettable identifiers
  /// (see Best practices for unique identifiers). This method can be invoked if
  /// one of the following requirements is met:
  ///
  /// - If the calling app has been granted the READ_PRIVILEGED_PHONE_STATE
  /// permission; this is a privileged permission that can only be granted to apps
  /// preloaded on the device.
  ///
  /// - If the calling app has carrier privileges (see TelephonyManager.hasCarrierPrivileges())
  /// on any active subscription.
  ///
  /// - If the calling app is the default SMS role holder (see RoleManager.isRoleHeld(String)).
  ///
  /// - If the calling app is the device owner of a fully-managed device, a profile
  /// owner of an organization-owned device, or their delegates (see
  /// DevicePolicyManager.getEnrollmentSpecificId()).
  ///
  /// If the calling app does not meet one of these requirements then this method
  /// will behave as follows:
  ///
  /// - If the calling app's target SDK is API level 28 or lower and the app has
  /// the READ_PHONE_STATE permission then Build.UNKNOWN is returned.
  ///
  /// - If the calling app's target SDK is API level 28 or lower and the app does
  /// not have the READ_PHONE_STATE permission, or if the calling app is targeting
  /// API level 29 or higher, then a SecurityException is thrown.
  ///
  /// Requires android.Manifest.permission.READ_PRIVILEGED_PHONE_STATE
  String get serial;

  /// The SKU of the hardware (from the kernel command line).
  ///
  /// The SKU is reported by the bootloader to configure system software features.
  /// If no value is supplied by the bootloader, this is reported as UNKNOWN.
  ///
  /// Added in API level 31
  String get sku;

  /// The manufacturer of the device's primary system-on-chip.
  ///
  /// Added in API level 31
  String get socManufacturer;

  /// The model name of the device's primary system-on-chip.
  ///
  /// Added in API level 31
  String get socModel;

  /// An ordered list of 32 bit ABIs supported by this device. The most preferred
  /// ABI is the first element in the list. See SUPPORTED_ABIS and SUPPORTED_64_BIT_ABIS.
  ///
  /// Added in API level 21
  List<String> get supported32BitABIs;

  /// An ordered list of 64 bit ABIs supported by this device. The most preferred
  /// ABI is the first element in the list. See SUPPORTED_ABIS and SUPPORTED_32_BIT_ABIS.
  ///
  /// Added in API level 21
  List<String> get supported64BitABIs;

  /// An ordered list of ABIs supported by this device. The most preferred ABI is
  /// the first element in the list. See SUPPORTED_32_BIT_ABIS and SUPPORTED_64_BIT_ABIS.
  ///
  /// Added in API level 21
  List<String> get supportedABIs;

  /// Comma-separated tags describing the build, like "unsigned,debug".
  ///
  /// Added in API level 1
  String get tags;

  /// The time at which the build was produced, given in milliseconds since the
  /// UNIX epoch.
  ///
  /// Added in API level 1
  int get time;

  /// The type of build, like "user" or "eng".
  ///
  /// Added in API level 1
  String get type;

  /// Added in API level 1
  String get user;

  /// Get build information about partitions that have a separate fingerprint
  /// defined. The list includes partitions that are suitable candidates for
  /// over-the-air updates. This is not an exhaustive list of partitions on the
  /// device.
  ///
  /// Added in API level 29
  List<Partition> get fingerprintedPartitions;

  /// Returns the version string for the radio firmware. May return null (if, for
  /// instance, the radio is not currently on).
  ///
  /// Added in API level 14
  String? get radioVersion;

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

  /// System settings, containing miscellaneous system preferences. This table
  /// holds simple name/value pairs. There are convenience functions for accessing
  /// individual settings entries.
  Settings get settings;

  /// Retrieve the current Window for the activity. This can be used to directly
  /// access parts of the Window API that are not available through Activity/Screen.
  Window get window;

  Future<void> startManageWriteSettingsActivity();
}
