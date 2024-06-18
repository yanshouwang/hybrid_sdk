import 'package:hybrid_os_platform_interface/hybrid_os_platform_interface.dart';

import 'jni.g.dart';

/// Android Platform.
final class AndroidPlatform extends OSPlatform implements Android {
  @override
  String get baseOS => Build_VERSION.BASE_OS.toDartString();

  @override
  String get codename => Build_VERSION.CODENAME.toDartString();

  @override
  String get incremental => Build_VERSION.INCREMENTAL.toDartString();

  @override
  int get mediaPerformanceClass => Build_VERSION.MEDIA_PERFORMANCE_CLASS;

  @override
  int get previewSDKVersion => Build_VERSION.PREVIEW_SDK_INT;

  @override
  String get release => Build_VERSION.RELEASE.toDartString();

  @override
  String get releaseOrCodename =>
      Build_VERSION.RELEASE_OR_CODENAME.toDartString();

  @override
  String get releaseOrPreviewDisplay =>
      Build_VERSION.RELEASE_OR_PREVIEW_DISPLAY.toDartString();

  @override
  int get sdkVersion => Build_VERSION.SDK_INT;

  @override
  String get securityPatch => Build_VERSION.SECURITY_PATCH.toDartString();
}

/// Android OS.
abstract class Android implements OS {
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
  /// Possible non-zero values are defined in Build.VERSION_CODES starting with
  /// Build.VERSION_CODES#R.
  ///
  /// Added in API level 31
  int get mediaPerformanceClass;

  /// The developer preview revision of a prerelease SDK. This value will always
  /// be 0 on production platform builds/devices.
  ///
  /// When this value is nonzero, any new API added since the last officially
  /// published API level is only guaranteed to be present on that specific preview
  /// revision. For example, an API Activity.fooBar() might be present in preview
  /// revision 1 but renamed or removed entirely in preview revision 2, which may
  /// cause an app attempting to call it to crash at runtime.
  ///
  /// Experimental apps targeting preview APIs should check this value for equality
  /// (==) with the preview SDK revision they were built for before using any
  /// prerelease platform APIs. Apps that detect a preview SDK revision other than
  /// the specific one they expect should fall back to using APIs from the previously
  /// published API level only to avoid unwanted runtime exceptions.
  ///
  /// Added in API level 23
  int get previewSDKVersion;

  /// The user-visible version string. E.g., "1.0" or "3.4b5" or "bananas". This
  /// field is an opaque string. Do not assume that its value has any particular
  /// structure or that values of RELEASE from different releases can be somehow
  /// ordered.
  ///
  /// Added in API level 1
  String get release;

  /// The version string. May be RELEASE or CODENAME if not a final release build.
  ///
  /// Added in API level 30
  String get releaseOrCodename;

  /// The version string we show to the user; may be RELEASE or a descriptive
  /// string if not a final release build.
  ///
  /// Added in API level 33
  String get releaseOrPreviewDisplay;

  /// The SDK version of the software currently running on this hardware device.
  /// This value never changes while a device is booted, but it may increase when
  /// the hardware manufacturer provides an OTA update.
  ///
  /// Possible values are defined in Build.VERSION_CODES.
  ///
  /// Added in API level 4
  int get sdkVersion;

  /// The user-visible security patch level. This value represents the date when
  /// the device most recently applied a security patch.
  ///
  /// Added in API level 23
  String get securityPatch;
}

/// Enumeration of the currently known SDK version codes. These are the values
/// that can be found in VERSION#SDK. Version numbers increment monotonically
/// with each official platform release.
abstract class VersionCodes {
  /// The original, first, version of Android. Yay!
  ///
  /// Released publicly as Android 1.0 in September 2008.
  ///
  /// Constant Value: 1 (0x00000001)
  ///
  /// Added in API level 4
  static int get base => Build_VERSION_CODES.BASE;

  /// First Android update.
  ///
  /// Released publicly as Android 1.1 in February 2009.
  ///
  /// Constant Value: 2 (0x00000002)
  ///
  /// Added in API level 4
  static int get base1_1 => Build_VERSION_CODES.BASE_1_1;

  /// C.
  ///
  /// Released publicly as Android 1.5 in April 2009.
  ///
  /// Constant Value: 3 (0x00000003)
  ///
  /// Added in API level 4
  static int get cupcake => Build_VERSION_CODES.CUPCAKE;

  /// Magic version number for a current development build, which has not yet
  /// turned into an official release.
  ///
  /// Constant Value: 10000 (0x00002710)
  ///
  /// Added in API level 4
  static int get curDevelopment => Build_VERSION_CODES.CUR_DEVELOPMENT;

  /// Released publicly as Android 1.6 in September 2009.
  ///
  /// Applications targeting this or a later release will get these new changes
  /// in behavior:
  ///
  /// * They must explicitly request the [`Manifest.permission.WRITE_EXTERNAL_STORAGE`](https://developer.android.com/reference/android/Manifest.permission?_gl=1*7mn3rd*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#WRITE_EXTERNAL_STORAGE)
  /// permission to be able to modify the contents of the SD card. (Apps targeting
  /// earlier versions will always request the permission.)
  ///
  /// * They must explicitly request the [`Manifest.permission.READ_PHONE_STATE`](https://developer.android.com/reference/android/Manifest.permission?_gl=1*5g85c2*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#READ_PHONE_STATE)
  /// permission to be able to be able to retrieve phone state info. (Apps targeting
  /// earlier versions will always request the permission.)
  ///
  /// * They are assumed to support different screen densities and sizes. (Apps
  /// targeting earlier versions are assumed to only support medium density normal
  /// size screens unless otherwise indicated). They can still explicitly specify
  /// screen support either way with the supports-screens manifest tag.
  ///
  /// * [`TabHost`](https://developer.android.com/reference/android/widget/TabHost?_gl=1*5g85c2*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// will use the new dark tab background design.
  ///
  /// Constant Value: 4 (0x00000004)
  ///
  /// Added in API level 4
  static int get donut => Build_VERSION_CODES.DONUT;

  /// Released publicly as Android 2.0 in October 2009.
  ///
  /// Applications targeting this or a later release will get these new changes
  /// in behavior:
  ///
  /// * The [`Service.onStartCommand`](https://developer.android.com/reference/android/app/Service?_gl=1*5g85c2*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#onStartCommand(android.content.Intent,%20int,%20int))
  /// function will return the new [`Service.START_STICKY`](https://developer.android.com/reference/android/app/Service?_gl=1*uxgbaj*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#START_STICKY)
  /// behavior instead of the old compatibility [`Service.START_STICKY_COMPATIBILITY`](https://developer.android.com/reference/android/app/Service?_gl=1*sr7ie8*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#START_STICKY_COMPATIBILITY).
  ///
  /// * The [`Activity`](https://developer.android.com/reference/android/app/Activity?_gl=1*sr7ie8*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// class will now execute back key presses on the key up instead of key down,
  /// to be able to detect canceled presses from virtual keys.
  ///
  /// The [`TabWidget`](https://developer.android.com/reference/android/widget/TabWidget?_gl=1*sr7ie8*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// class will use a new color scheme for tabs. In the new scheme, the foreground
  /// tab has a medium gray background the background tabs have a dark gray
  /// background.
  ///
  /// Constant Value: 5 (0x00000005)
  ///
  /// Added in API level 5
  static int get eclair => Build_VERSION_CODES.ECLAIR;

  /// E incremental update.
  ///
  /// Released publicly as Android 2.0.1 in December 2009.
  ///
  /// Constant Value: 6 (0x00000006)
  ///
  /// Added in API level 6
  static int get eclair0_1 => Build_VERSION_CODES.ECLAIR_0_1;

  /// E MR1.
  ///
  /// Released publicly as Android 2.1 in January 2010.
  ///
  /// Constant Value: 7 (0x00000007)
  ///
  /// Added in API level 7
  static int get eclairMR1 => Build_VERSION_CODES.ECLAIR_MR1;

  /// F.
  ///
  /// Released publicly as Android 2.2 in May 2010.
  ///
  /// Constant Value: 8 (0x00000008)
  ///
  /// Added in API level 8
  static int get froyo => Build_VERSION_CODES.FROYO;

  /// G.
  ///
  /// Released publicly as Android 2.3 in December 2010.
  ///
  /// Applications targeting this or a later release will get these new changes
  /// in behavior:
  ///
  /// * The application's notification icons will be shown on the new dark status
  /// bar background, so must be visible in this situation.
  ///
  /// Constant Value: 9 (0x00000009)
  ///
  /// Added in API level 9
  static int get gingerbread => Build_VERSION_CODES.GINGERBREAD;

  /// G MR1.
  ///
  /// Released publicly as Android 2.3.3 in February 2011.
  ///
  /// Constant Value: 10 (0x0000000a)
  ///
  /// Added in API level 10
  static int get gingerbreadMR1 => Build_VERSION_CODES.GINGERBREAD_MR1;

  /// H.
  ///
  /// Released publicly as Android 3.0 in February 2011.
  ///
  /// Applications targeting this or a later release will get these new changes
  /// in behavior:
  ///
  /// * The default theme for applications is now dark holographic: [`R.style.Theme_Holo`](https://developer.android.com/reference/android/R.style?_gl=1*aak1we*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#Theme_Holo).
  ///
  /// * On large screen devices that do not have a physical menu button,
  /// the soft (compatibility) menu is disabled.
  ///
  /// * The activity lifecycle has changed slightly as per [`Activity`](https://developer.android.com/reference/android/app/Activity?_gl=1*aak1we*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..).
  ///
  /// * An application will crash if it does not call through to the super
  /// implementation of its [`Activity.onPause()`](https://developer.android.com/reference/android/app/Activity?_gl=1*aak1we*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#onPause())
  /// method.
  ///
  /// * When an application requires a permission to access one of its components
  /// (activity, receiver, service, provider), this permission is no longer
  /// enforced when the application wants to access its own component. This means
  /// it can require a permission on a component that it does not itself hold and
  /// still access that component.
  ///
  /// * [`Context.getSharedPreferences()`](https://developer.android.com/reference/android/content/Context?_gl=1*cp3vx1*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#getSharedPreferences(java.lang.String,%20int))
  /// will not automatically reload the preferences if they have changed on storage,
  /// unless [`Context.MODE_MULTI_PROCESS`](https://developer.android.com/reference/android/content/Context?_gl=1*cp3vx1*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#MODE_MULTI_PROCESS)
  /// is used.
  ///
  /// * [`ViewGroup.setMotionEventSplittingEnabled(boolean)`](https://developer.android.com/reference/android/view/ViewGroup?_gl=1*cp3vx1*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#setMotionEventSplittingEnabled(boolean))
  /// will default to true.
  ///
  /// * [`WindowManager.LayoutParams.FLAG_SPLIT_TOUCH`](https://developer.android.com/reference/android/view/WindowManager.LayoutParams?_gl=1*em95oo*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#FLAG_SPLIT_TOUCH)
  /// is enabled by default on windows.
  ///
  /// * [`PopupWindow.isSplitTouchEnabled()`](https://developer.android.com/reference/android/widget/PopupWindow?_gl=1*em95oo*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#isSplitTouchEnabled())
  /// will return true by default.
  ///
  /// * [`GridView`](https://developer.android.com/reference/android/widget/GridView?_gl=1*em95oo*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// and [`ListView`](https://developer.android.com/reference/android/widget/ListView?_gl=1*grvbgj*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// will use [`View.setActivated`](https://developer.android.com/reference/android/view/View?_gl=1*grvbgj*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#setActivated(boolean))
  /// for selected items if they do not implement [`Checkable`](https://developer.android.com/reference/android/widget/Checkable?_gl=1*grvbgj*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..).
  ///
  /// * [`Scroller`](https://developer.android.com/reference/android/widget/Scroller?_gl=1*grvbgj*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// will be constructed with "flywheel" behavior enabled by default.
  ///
  /// Constant Value: 11 (0x0000000b)
  ///
  /// Added in API level 11
  static int get honeycomb => Build_VERSION_CODES.HONEYCOMB;

  /// H MR1.
  ///
  /// Released publicly as Android 3.1 in May 2011.
  ///
  /// Constant Value: 12 (0x0000000c)
  ///
  /// Added in API level 12
  static int get honeycombMR1 => Build_VERSION_CODES.HONEYCOMB_MR1;

  /// H MR2.
  ///
  /// Released publicly as Android 3.2 in July 2011.
  ///
  /// Update to Honeycomb MR1 to support 7 inch tablets, improve screen compatibility
  /// mode, etc.
  ///
  /// As of this version, applications that don't say whether they support XLARGE
  /// screens will be assumed to do so only if they target [`HONEYCOMB`](https://developer.android.com/reference/android/os/Build.VERSION_CODES?_gl=1*42kl89*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#HONEYCOMB)
  /// or later; it had been [`GINGERBREAD`](https://developer.android.com/reference/android/os/Build.VERSION_CODES?_gl=1*42kl89*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#GINGERBREAD)
  /// or later. Applications that don't support a screen size at least as large
  /// as the current screen will provide the user with a UI to switch them in to
  /// screen size compatibility mode.
  ///
  /// This version introduces new screen size resource qualifiers based on the
  /// screen size in dp: see [`Configuration.screenWidthDp`](https://developer.android.com/reference/android/content/res/Configuration?_gl=1*6l8dno*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#screenWidthDp),
  /// [`Configuration.screenHeightDp`](https://developer.android.com/reference/android/content/res/Configuration?_gl=1*6l8dno*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#screenHeightDp),
  /// and [`Configuration.smallestScreenWidthDp`](https://developer.android.com/reference/android/content/res/Configuration?_gl=1*6l8dno*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#smallestScreenWidthDp).
  /// Supplying these in <supports-screens> as per [`ApplicationInfo.requiresSmallestWidthDp`](https://developer.android.com/reference/android/content/pm/ApplicationInfo?_gl=1*8mqhnz*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#requiresSmallestWidthDp),
  /// [`ApplicationInfo.compatibleWidthLimitDp`](https://developer.android.com/reference/android/content/pm/ApplicationInfo?_gl=1*8mqhnz*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#compatibleWidthLimitDp),
  /// and [`ApplicationInfo.largestWidthLimitDp`](https://developer.android.com/reference/android/content/pm/ApplicationInfo?_gl=1*8mqhnz*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#largestWidthLimitDp)
  /// is preferred over the older screen size buckets and for older devices the
  /// appropriate buckets will be inferred from them.
  ///
  /// Applications targeting this or a later release will get these new changes
  /// in behavior:
  ///
  /// * New [`PackageManager.FEATURE_SCREEN_PORTRAIT`](https://developer.android.com/reference/android/content/pm/PackageManager?_gl=1*romeh2*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#FEATURE_SCREEN_PORTRAIT)
  /// and [`PackageManager.FEATURE_SCREEN_LANDSCAPE`](https://developer.android.com/reference/android/content/pm/PackageManager?_gl=1*romeh2*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#FEATURE_SCREEN_LANDSCAPE)
  /// features were introduced in this release. Applications that target previous
  /// platform versions are assumed to require both portrait and landscape support
  /// in the device; when targeting Honeycomb MR1 or greater the application is
  /// responsible for specifying any specific orientation it requires.
  ///
  /// * [`AsyncTask`](https://developer.android.com/reference/android/os/AsyncTask?_gl=1*romeh2*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// will use the serial executor by default when calling [`AsyncTask.execute(Params)`](https://developer.android.com/reference/android/os/AsyncTask?_gl=1*romeh2*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#execute(Params[])).
  ///
  /// * [`ActivityInfo.configChanges`](https://developer.android.com/reference/android/content/pm/ActivityInfo?_gl=1*tpy0b1*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#configChanges)
  /// will have the [`ActivityInfo.CONFIG_SCREEN_SIZE`](https://developer.android.com/reference/android/content/pm/ActivityInfo?_gl=1*tpy0b1*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#CONFIG_SCREEN_SIZE)
  /// and [`ActivityInfo.CONFIG_SMALLEST_SCREEN_SIZE`](https://developer.android.com/reference/android/content/pm/ActivityInfo?_gl=1*tpy0b1*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#CONFIG_SMALLEST_SCREEN_SIZE)
  /// bits set; these need to be cleared for older applications because some
  /// developers have done absolute comparisons against this value instead of
  /// correctly masking the bits they are interested in.
  ///
  /// Constant Value: 13 (0x0000000d)
  ///
  /// Added in API level 13
  static int get honeycombMR2 => Build_VERSION_CODES.HONEYCOMB_MR2;

  /// I.
  ///
  /// Released publicly as Android 4.0 in October 2011.
  ///
  /// Applications targeting this or a later release will get these new changes
  /// in behavior:
  ///
  /// * For devices without a dedicated menu key, the software compatibility menu
  /// key will not be shown even on phones. By targeting Ice Cream Sandwich or
  /// later, your UI must always have its own menu UI affordance if needed, on
  /// both tablets and phones. The ActionBar will take care of this for you.
  ///
  /// * 2d drawing hardware acceleration is now turned on by default. You can use
  /// [`android:hardwareAccelerated`](https://developer.android.com/reference/android/R.attr?_gl=1*31p4gm*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#hardwareAccelerated)
  /// to turn it off if needed, although this is strongly discouraged since it
  /// will result in poor performance on larger screen devices.
  ///
  /// * The default theme for applications is now the "device default" theme:
  /// [`R.style.Theme_DeviceDefault`](https://developer.android.com/reference/android/R.style?_gl=1*5fohhn*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#Theme_DeviceDefault).
  /// This may be the holo dark theme or a different dark theme defined by the
  /// specific device. The [`R.style.Theme_Holo`](https://developer.android.com/reference/android/R.style?_gl=1*7kov9c*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#Theme_Holo)
  /// family must not be modified for a device to be considered compatible.
  /// Applications that explicitly request a theme from the Holo family will be
  /// guaranteed that these themes will not change character within the same
  /// platform version. Applications that wish to blend in with the device should
  /// use a theme from the [`R.style.Theme_DeviceDefault`](https://developer.android.com/reference/android/R.style?_gl=1*7kov9c*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#Theme_DeviceDefault)
  /// family.
  ///
  /// * Managed cursors can now throw an exception if you directly close the cursor
  /// yourself without stopping the management of it; previously failures would
  /// be silently ignored.
  ///
  /// * The fadingEdge attribute on views will be ignored (fading edges is no
  /// longer a standard part of the UI). A new requiresFadingEdge attribute allows
  /// applications to still force fading edges on for special cases.
  ///
  /// * [`Context.bindService()`](https://developer.android.com/reference/android/content/Context?_gl=1*7kov9c*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#bindService(android.content.Intent,%20android.content.Context.BindServiceFlags,%20java.util.concurrent.Executor,%20android.content.ServiceConnection))
  /// will not automatically add in [`Context.BIND_WAIVE_PRIORITY`](https://developer.android.com/reference/android/content/Context?_gl=1*98qvch*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#BIND_WAIVE_PRIORITY).
  ///
  /// * App Widgets will have standard padding automatically added around them,
  /// rather than relying on the padding being baked into the widget itself.
  ///
  /// * An exception will be thrown if you try to change the type of a window
  /// after it has been added to the window manager. Previously this would result
  /// in random incorrect behavior.
  ///
  /// * [`AnimationSet`](https://developer.android.com/reference/android/view/animation/AnimationSet?_gl=1*98qvch*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// will parse out the duration, fillBefore, fillAfter, repeatMode, and startOffset
  /// XML attributes that are defined.
  ///
  /// * [`ActionBar.setHomeButtonEnabled()`](https://developer.android.com/reference/android/app/ActionBar?_gl=1*98qvch*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#setHomeButtonEnabled(boolean))
  /// is false by default.
  ///
  /// Constant Value: 14 (0x0000000e)
  ///
  /// Added in API level 14
  static int get iceCreamSandwich => Build_VERSION_CODES.ICE_CREAM_SANDWICH;

  /// I MR1.
  ///
  /// Released publicly as Android 4.03 in December 2011.
  ///
  /// Constant Value: 15 (0x0000000f)
  ///
  /// Added in API level 15
  static int get iceCreamSandwichMR1 =>
      Build_VERSION_CODES.ICE_CREAM_SANDWICH_MR1;

  /// J.
  ///
  /// Released publicly as Android 4.1 in July 2012.
  ///
  /// Applications targeting this or a later release will get these new changes
  /// in behavior:
  ///
  /// * You must explicitly request the [`Manifest.permission.READ_CALL_LOG`](https://developer.android.com/reference/android/Manifest.permission?_gl=1*bjbjzu*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#READ_CALL_LOG)
  /// and/or [`Manifest.permission.WRITE_CALL_LOG`](https://developer.android.com/reference/android/Manifest.permission?_gl=1*bjbjzu*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#WRITE_CALL_LOG)
  /// permissions; access to the call log is no longer implicitly provided through
  /// [`Manifest.permission.READ_CONTACTS`](https://developer.android.com/reference/android/Manifest.permission?_gl=1*bjbjzu*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#READ_CONTACTS)
  /// and [`Manifest.permission.WRITE_CONTACTS`](https://developer.android.com/reference/android/Manifest.permission?_gl=1*bjbjzu*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#WRITE_CONTACTS).
  ///
  /// * [`RemoteViews`](https://developer.android.com/reference/android/widget/RemoteViews?_gl=1*dl595z*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// will throw an exception if setting an onClick handler for views being
  /// generated by a [`RemoteViewsService`](https://developer.android.com/reference/android/widget/RemoteViewsService?_gl=1*dl595z*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// for a collection container; previously this just resulted in a warning log
  /// message.
  ///
  /// * New [`ActionBar`](https://developer.android.com/reference/android/app/ActionBar?_gl=1*fkr8fg*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// policy for embedded tabs: embedded tabs are now always stacked in the action
  /// bar when in portrait mode, regardless of the size of the screen.
  ///
  /// * [`WebSettings.setAllowFileAccessFromFileURLs`](https://developer.android.com/reference/android/webkit/WebSettings?_gl=1*fkr8fg*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#setAllowFileAccessFromFileURLs(boolean))
  /// and [`WebSettings.setAllowUniversalAccessFromFileURLs`](https://developer.android.com/reference/android/webkit/WebSettings?_gl=1*fkr8fg*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#setAllowUniversalAccessFromFileURLs(boolean))
  /// default to false.
  ///
  /// * Calls to [`PackageManager.setComponentEnabledSetting`](https://developer.android.com/reference/android/content/pm/PackageManager?_gl=1*fkr8fg*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#setComponentEnabledSetting(android.content.ComponentName,%20int,%20int))
  /// will now throw an IllegalArgumentException if the given component class name
  /// does not exist in the application's manifest.
  ///
  /// * `NfcAdapter.setNdefPushMessage`, `NfcAdapter.setNdefPushMessageCallback`
  /// and `NfcAdapter.setOnNdefPushCompleteCallback` will throw IllegalStateException
  /// if called after the Activity has been destroyed.
  ///
  /// * Accessibility services must require the new [`Manifest.permission.BIND_ACCESSIBILITY_SERVICE`](https://developer.android.com/reference/android/Manifest.permission?_gl=1*j55a9x*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#BIND_ACCESSIBILITY_SERVICE)
  /// permission or they will not be available for use.
  ///
  /// * [`AccessibilityServiceInfo.FLAG_INCLUDE_NOT_IMPORTANT_VIEWS`](https://developer.android.com/reference/android/accessibilityservice/AccessibilityServiceInfo?_gl=1*j55a9x*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#FLAG_INCLUDE_NOT_IMPORTANT_VIEWS)
  /// must be set for unimportant views to be included in queries.
  ///
  /// Constant Value: 16 (0x00000010)
  ///
  /// Added in API level 16
  static int get jellyBean => Build_VERSION_CODES.JELLY_BEAN;

  /// J MR1.
  ///
  /// Released publicly as Android 4.2 in November 2012.
  ///
  /// Applications targeting this or a later release will get these new changes
  /// in behavior:
  ///
  /// * Content Providers: The default value of `android:exported` is now `false`.
  /// See [the android:exported section](https://developer.android.com/guide/topics/manifest/provider-element?_gl=1*1tc2aut*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#exported)
  /// in the provider documentation for more details.
  ///
  /// * [`View.getLayoutDirection()`](https://developer.android.com/reference/android/view/View?_gl=1*l4m6by*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#getLayoutDirection())
  /// can return different values than [`View.LAYOUT_DIRECTION_LTR`](https://developer.android.com/reference/android/view/View?_gl=1*l4m6by*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#LAYOUT_DIRECTION_LTR)
  /// based on the locale etc.
  ///
  /// * [`WebView.addJavascriptInterface`](https://developer.android.com/reference/android/webkit/WebView?_gl=1*l4m6by*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#addJavascriptInterface(java.lang.Object,%20java.lang.String))
  /// requires explicit annotations on methods for them to be accessible from
  /// Javascript.
  ///
  /// Constant Value: 17 (0x00000011)
  ///
  /// Added in API level 17
  static int get jellyBeanMR1 => Build_VERSION_CODES.JELLY_BEAN_MR1;

  /// J MR2.
  ///
  /// Released publicly as Android 4.3 in July 2013.
  ///
  /// Constant Value: 18 (0x00000012)
  ///
  /// Added in API level 18
  static int get jellyBeanMR2 => Build_VERSION_CODES.JELLY_BEAN_MR2;

  /// K.
  ///
  /// Released publicly as Android 4.4 in October 2013.
  ///
  /// Applications targeting this or a later release will get these new changes
  /// in behavior. For more information about this release, see the [Android KitKat
  /// overview](https://developer.android.com/about/versions/kitkat?_gl=1*1v62s6g*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..).
  ///
  /// * The default result of [`PreferenceActivity.isValueFragment`](https://developer.android.com/reference/android/preference/PreferenceActivity?_gl=1*1qng3f*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#isValidFragment(java.lang.String))
  /// becomes false instead of true.
  ///
  /// * In [`WebView`](https://developer.android.com/reference/android/webkit/WebView?_gl=1*1qng3f*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..),
  /// apps targeting earlier versions will have JS URLs evaluated directly and
  /// any result of the evaluation will not replace the current page content. Apps
  /// targetting KITKAT or later that load a JS URL will have the result of that
  /// URL replace the content of the current page
  ///
  /// * [`AlarmManager.set`](https://developer.android.com/reference/android/app/AlarmManager?_gl=1*8na5ie*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#set(int,%20long,%20android.app.PendingIntent))
  /// becomes interpreted as an inexact value, to give the system more flexibility
  /// in scheduling alarms.
  ///
  /// * [`Context.getSharedPreferences`](https://developer.android.com/reference/android/content/Context?_gl=1*8na5ie*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#getSharedPreferences(java.lang.String,%20int))
  /// no longer allows a null name.
  ///
  /// * [`RelativeLayout`](https://developer.android.com/reference/android/widget/RelativeLayout?_gl=1*8na5ie*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// changes to compute wrapped content margins correctly.
  ///
  /// * [`ActionBar`](https://developer.android.com/reference/android/app/ActionBar?_gl=1*6n6m5p*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)'s
  /// window content overlay is allowed to be drawn.
  ///
  /// * The [`Manifest.permission.READ_EXTERNAL_STORAGE`](https://developer.android.com/reference/android/Manifest.permission?_gl=1*cqwi58*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#READ_EXTERNAL_STORAGE)
  /// permission is now always enforced.
  ///
  /// * Access to package-specific external storage directories belonging to the
  /// calling app no longer requires the [`Manifest.permission.READ_EXTERNAL_STORAGE`](https://developer.android.com/reference/android/Manifest.permission?_gl=1*cqwi58*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#READ_EXTERNAL_STORAGE)
  /// or [`Manifest.permission.WRITE_EXTERNAL_STORAGE`](https://developer.android.com/reference/android/Manifest.permission?_gl=1*ab9c0n*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#WRITE_EXTERNAL_STORAGE)
  /// permissions.
  ///
  /// Constant Value: 19 (0x00000013)
  ///
  /// Added in API level 19
  static int get kitkat => Build_VERSION_CODES.KITKAT;

  /// K for watches.
  ///
  /// Released publicly as Android 4.4W in June 2014.
  ///
  /// Applications targeting this or a later release will get these new changes
  /// in behavior:
  ///
  /// * [`AlertDialog`](https://developer.android.com/reference/android/app/AlertDialog?_gl=1*ab9c0n*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// might not have a default background if the theme does not specify one.
  ///
  /// Constant Value: 20 (0x00000014)
  ///
  /// Added in API level 20
  static int get kitkatWatch => Build_VERSION_CODES.KITKAT_WATCH;

  /// L.
  ///
  /// Released publicly as Android 5.0 in November 2014.
  ///
  /// Applications targeting this or a later release will get these new changes
  /// in behavior. For more information about this release, see the [Android
  /// Lollipop overview](https://developer.android.com/about/versions/lollipop?_gl=1*1yn2z4c*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..).
  ///
  /// * [`Context.bindService`](https://developer.android.com/reference/android/content/Context?_gl=1*gq2p8q*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#bindService(android.content.Intent,%20android.content.Context.BindServiceFlags,%20java.util.concurrent.Executor,%20android.content.ServiceConnection))
  /// now requires an explicit Intent, and will throw an exception if given an
  /// implicit Intent.
  ///
  /// * [`Notification.Builder`](https://developer.android.com/reference/android/app/Notification.Builder?_gl=1*gq2p8q*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// will not have the colors of their various notification elements adjusted to
  /// better match the new material design look.
  ///
  /// * [`Message`](https://developer.android.com/reference/android/os/Message?_gl=1*gq2p8q*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// will validate that a message is not currently in use when it is recycled.
  ///
  /// * Hardware accelerated drawing in windows will be enabled automatically in
  /// most places.
  ///
  /// * [`Spinner`](https://developer.android.com/reference/android/widget/Spinner?_gl=1*eljvk1*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// throws an exception if attaching an adapter with more than one item type.
  ///
  /// * If the app is a launcher, the launcher will be available to the user even
  /// when they are using corporate profiles (which requires that the app use
  /// [`LauncherApps`](https://developer.android.com/reference/android/content/pm/LauncherApps?_gl=1*eljvk1*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// to correctly populate its apps UI).
  ///
  /// * Calling [`Service.stopForeground`](https://developer.android.com/reference/android/app/Service?_gl=1*eljvk1*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#stopForeground(boolean))
  /// with removeNotification false will modify the still posted notification so
  /// that it is no longer forced to be ongoing.
  ///
  /// * A [`DreamService`](https://developer.android.com/reference/android/service/dreams/DreamService?_gl=1*k1ptwo*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// must require the [`Manifest.permission.BIND_DREAM_SERVICE`](https://developer.android.com/reference/android/Manifest.permission?_gl=1*k1ptwo*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#BIND_DREAM_SERVICE)
  /// permission to be usable.
  ///
  /// Constant Value: 21 (0x00000015)
  ///
  /// Added in API level 21
  static int get lollipop => Build_VERSION_CODES.LOLLIPOP;

  /// L MR1.
  ///
  /// Released publicly as Android 5.1 in March 2015.
  ///
  /// For more information about this release, see the [Android 5.1 APIs](https://developer.android.com/about/versions/android-5.1?_gl=1*k1ptwo*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..).
  ///
  /// Constant Value: 22 (0x00000016)
  ///
  /// Added in API level 22
  static int get lollipopMR1 => Build_VERSION_CODES.LOLLIPOP_MR1;

  /// M.
  ///
  /// Released publicly as Android 6.0 in October 2015.
  ///
  /// Applications targeting this or a later release will get these new changes
  /// in behavior. For more information about this release, see the [Android 6.0
  /// Marshmallow overview](https://developer.android.com/about/versions/marshmallow?_gl=1*1ijuiil*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..).
  ///
  /// * Runtime permissions. Dangerous permissions are no longer granted at install
  /// time, but must be requested by the application at runtime through
  /// [`Activity.requestPermissions(String, int)`](https://developer.android.com/reference/android/app/Activity?_gl=1*k1ptwo*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#requestPermissions(java.lang.String[],%20int)).
  ///
  /// * Bluetooth and Wi-Fi scanning now requires holding the location permission.
  ///
  /// * [`AlarmManager.setTimeZone`](https://developer.android.com/reference/android/app/AlarmManager?_gl=1*hxbqsj*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#setTimeZone(java.lang.String))
  /// will fail if the given timezone is non-Olson.
  ///
  /// * Activity transitions will only return shared elements mapped in the returned
  /// view hierarchy back to the calling activity.
  ///
  /// * [`View`](https://developer.android.com/reference/android/view/View?_gl=1*hxbqsj*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// allows a number of behaviors that may break existing apps: Canvas throws an
  /// exception if restore() is called too many times, widgets may return a hint
  /// size when returning UNSPECIFIED measure specs, and it will respect the
  /// attributes [`R.attr.foreground`](https://developer.android.com/reference/android/R.attr?_gl=1*hxbqsj*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#foreground),
  /// [`R.attr.foregroundGravity`](https://developer.android.com/reference/android/R.attr?_gl=1*7lbzyf*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#foregroundGravity),
  /// [`R.attr.foregroundTint`](https://developer.android.com/reference/android/R.attr?_gl=1*7lbzyf*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#foregroundTint),
  /// and [`R.attr.foregroundTintMode`](https://developer.android.com/reference/android/R.attr?_gl=1*7lbzyf*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#foregroundTintMode).
  ///
  /// * [`MotionEvent.getButtonState`](https://developer.android.com/reference/android/view/MotionEvent?_gl=1*7lbzyf*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#getButtonState())
  /// will no longer report [`MotionEvent.BUTTON_PRIMARY`](https://developer.android.com/reference/android/view/MotionEvent?_gl=1*5f1te4*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#BUTTON_PRIMARY)
  /// and [`MotionEvent.BUTTON_SECONDARY`](https://developer.android.com/reference/android/view/MotionEvent?_gl=1*5f1te4*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#BUTTON_SECONDARY)
  /// as synonyms for [`MotionEvent.BUTTON_STYLUS_PRIMARY`](https://developer.android.com/reference/android/view/MotionEvent?_gl=1*5f1te4*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#BUTTON_STYLUS_PRIMARY)
  /// and [`MotionEvent.BUTTON_STYLUS_SECONDARY`](https://developer.android.com/reference/android/view/MotionEvent?_gl=1*5f1te4*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#BUTTON_STYLUS_SECONDARY).
  ///
  /// * [`ScrollView`](https://developer.android.com/reference/android/widget/ScrollView?_gl=1*5f1te4*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// now respects the layout param margins when measuring.
  ///
  /// Constant Value: 23 (0x00000017)
  ///
  /// Added in API level 23
  static int get m => Build_VERSION_CODES.M;

  /// N.
  ///
  /// Released publicly as Android 7.0 in August 2016.
  ///
  /// Applications targeting this or a later release will get these new changes
  /// in behavior. For more information about this release, see the [Android Nougat
  /// overview](https://developer.android.com/about/versions/nougat?_gl=1*18punux*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..).
  ///
  /// * [`DownloadManager.Request.setAllowedNetworkTypes`](https://developer.android.com/reference/android/app/DownloadManager.Request?_gl=1*311f81*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#setAllowedNetworkTypes(int))
  /// will disable "allow over metered" when specifying only [`DownloadManager.Request.NETWORK_WIFI`](https://developer.android.com/reference/android/app/DownloadManager.Request?_gl=1*311f81*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#NETWORK_WIFI).
  ///
  /// * [`DownloadManager`](https://developer.android.com/reference/android/app/DownloadManager?_gl=1*lweca*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// no longer allows access to raw file paths.
  ///
  /// * [`Notification.Builder.setShowWhen`](https://developer.android.com/reference/android/app/Notification.Builder?_gl=1*lweca*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#setShowWhen(boolean))
  /// must be called explicitly to have the time shown, and various other changes
  /// in [`Notification.Builder`](https://developer.android.com/reference/android/app/Notification.Builder?_gl=1*lweca*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// to how notifications are shown.
  ///
  /// * [`Context.MODE_WORLD_READABLE`](https://developer.android.com/reference/android/content/Context?_gl=1*lweca*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#MODE_WORLD_READABLE)
  /// and [`Context.MODE_WORLD_WRITEABLE`](https://developer.android.com/reference/android/content/Context?_gl=1*flc3cb*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#MODE_WORLD_WRITEABLE)
  /// are no longer supported.
  ///
  /// * [`FileUriExposedException`](https://developer.android.com/reference/android/os/FileUriExposedException?_gl=1*flc3cb*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// will be thrown to applications.
  ///
  /// * Applications will see global drag and drops as per [`View.DRAG_FLAG_GLOBAL`](https://developer.android.com/reference/android/view/View?_gl=1*flc3cb*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#DRAG_FLAG_GLOBAL).
  ///
  /// * [`WebView.evaluateJavascript`](https://developer.android.com/reference/android/webkit/WebView?_gl=1*flc3cb*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#evaluateJavascript(java.lang.String,%20android.webkit.ValueCallback%3Cjava.lang.String%3E))
  /// will not persist state from an empty WebView.
  ///
  /// * [`AnimatorSet`](https://developer.android.com/reference/android/animation/AnimatorSet?_gl=1*flc3cb*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// will not ignore calls to end() before start().
  ///
  /// * [`AlarmManager.cancel`](https://developer.android.com/reference/android/app/AlarmManager?_gl=1*dkkt9c*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#cancel(android.app.PendingIntent))
  /// will throw a NullPointerException if given a null operation.
  ///
  /// * [`FragmentManager`](https://developer.android.com/reference/android/app/FragmentManager?_gl=1*dkkt9c*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// will ensure fragments have been created before being placed on the back
  /// stack.
  ///
  /// * [`FragmentManager`](https://developer.android.com/reference/android/app/FragmentManager?_gl=1*dkkt9c*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// restores fragments in [`Fragment.onCreate`](https://developer.android.com/reference/android/app/Fragment?_gl=1*bir9ml*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#onCreate(android.os.Bundle))
  /// rather than after the method returns.
  ///
  /// * [`R.attr.resizeableActivity`](https://developer.android.com/reference/android/R.attr?_gl=1*bir9ml*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#resizeableActivity)
  /// defaults to true.
  ///
  /// * [`AnimatedVectorDrawable`](https://developer.android.com/reference/android/graphics/drawable/AnimatedVectorDrawable?_gl=1*bir9ml*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// throws exceptions when opening invalid VectorDrawable animations.
  ///
  /// * [`ViewGroup.MarginLayoutParams`](https://developer.android.com/reference/android/view/ViewGroup.MarginLayoutParams?_gl=1*bir9ml*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// will no longer be dropped when converting between some types of layout params
  /// (such as [`LinearLayout.LayoutParams`](https://developer.android.com/reference/android/widget/LinearLayout.LayoutParams?_gl=1*99aqpi*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// to [`RelativeLayout.LayoutParams`](https://developer.android.com/reference/android/widget/RelativeLayout.LayoutParams?_gl=1*99aqpi*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)).
  ///
  /// * Your application processes will not be killed when the device density
  /// changes.
  ///
  /// * Drag and drop. After a view receives the [`DragEvent.ACTION_DRAG_ENTERED`](https://developer.android.com/reference/android/view/DragEvent?_gl=1*99aqpi*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#ACTION_DRAG_ENTERED)
  /// event, when the drag shadow moves into a descendant view that can accept
  /// the data, the view receives the [`DragEvent.ACTION_DRAG_EXITED`](https://developer.android.com/reference/android/view/DragEvent?_gl=1*99aqpi*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#ACTION_DRAG_EXITED)
  /// event and won\u2019t receive [`DragEvent.ACTION_DRAG_LOCATION`](https://developer.android.com/reference/android/view/DragEvent?_gl=1*py32jj*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#ACTION_DRAG_LOCATION)
  /// and [`DragEvent.ACTION_DROP`](https://developer.android.com/reference/android/view/DragEvent?_gl=1*py32jj*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#ACTION_DROP)
  /// events while the drag shadow is within that descendant view, even if the
  /// descendant view returns false from its handler for these events.
  ///
  /// Constant Value: 24 (0x00000018)
  ///
  /// Added in API level 24
  static int get n => Build_VERSION_CODES.N;

  /// N MR1.
  ///
  /// Released publicly as Android 7.1 in October 2016.
  ///
  /// For more information about this release, see [Android 7.1 for Developers](https://developer.android.com/about/versions/nougat/android-7.1?_gl=1*1m2j1xp*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..).
  ///
  /// Constant Value: 25 (0x00000019)
  ///
  /// Added in API level 25
  static int get nMR1 => Build_VERSION_CODES.N_MR1;

  /// O.
  ///
  /// Released publicly as Android 8.0 in August 2017.
  ///
  /// Applications targeting this or a later release will get these new changes
  /// in behavior. For more information about this release, see the [Android Oreo
  /// overview](https://developer.android.com/about/versions/oreo?_gl=1*1od98au*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..).
  ///
  /// * Background execution limits are applied to the application.
  ///
  /// * The behavior of [`AccountManager's AccountManager.getAccountsByType(String)`](https://developer.android.com/reference/android/accounts/AccountManager?_gl=1*py32jj*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#getAccountsByType(java.lang.String)),
  /// [`AccountManager.getAccountsByTypeAndFeatures(String, String, AccountManagerCallback, Handler)`](https://developer.android.com/reference/android/accounts/AccountManager?_gl=1*nohg7o*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#getAccountsByTypeAndFeatures(java.lang.String,%20java.lang.String[],%20android.accounts.AccountManagerCallback%3Candroid.accounts.Account[]%3E,%20android.os.Handler)),
  /// and [`AccountManager.hasFeatures(Account, String, AccountManagerCallback, Handler)`](https://developer.android.com/reference/android/accounts/AccountManager?_gl=1*nohg7o*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#hasFeatures(android.accounts.Account,%20java.lang.String[],%20android.accounts.AccountManagerCallback%3Cjava.lang.Boolean%3E,%20android.os.Handler))
  /// has changed as documented there.
  ///
  /// * [`ActivityManager.RunningAppProcessInfo.IMPORTANCE_PERCEPTIBLE_PRE_26`](https://developer.android.com/reference/android/app/ActivityManager.RunningAppProcessInfo?_gl=1*nohg7o*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#IMPORTANCE_PERCEPTIBLE_PRE_26)
  /// is now returned as [`ActivityManager.RunningAppProcessInfo.IMPORTANCE_PERCEPTIBLE`](https://developer.android.com/reference/android/app/ActivityManager.RunningAppProcessInfo?_gl=1*nohg7o*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#IMPORTANCE_PERCEPTIBLE).
  ///
  /// * The [`NotificationManager`](https://developer.android.com/reference/android/app/NotificationManager?_gl=1*nohg7o*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// now requires the use of notification channels.
  ///
  /// * Changes to the strict mode that are set in [`Application.onCreate`](https://developer.android.com/reference/android/app/Application?_gl=1*6mmwbu*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#onCreate())
  /// will no longer be clobbered after that function returns.
  ///
  /// * A shared library apk with native code will have that native code included
  /// in the library path of its clients.
  ///
  /// * [`Context.getSharedPreferences`](https://developer.android.com/reference/android/content/Context?_gl=1*6mmwbu*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#getSharedPreferences(java.lang.String,%20int))
  /// in credential encrypted storage will throw an exception before the user is
  /// unlocked.
  ///
  /// * Attempting to retrieve a [`Context#FINGERPRINT_SERVICE`](https://developer.android.com/reference/android/content/Context?_gl=1*6mmwbu*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#FINGERPRINT_SERVICE)
  /// on a device that does not support that feature will now throw a runtime
  /// exception.
  ///
  /// * [`Fragment`](https://developer.android.com/reference/android/app/Fragment?_gl=1*8nubxd*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// will stop any active view animations when the fragment is stopped.
  ///
  /// * Some compatibility code in Resources that attempts to use the default
  /// Theme the app may be using will be turned off, requiring the app to explicitly
  /// request resources with the right theme.
  ///
  /// * [`ContentResolver.notifyChange`](https://developer.android.com/reference/android/content/ContentResolver?_gl=1*8nubxd*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#notifyChange(android.net.Uri,%20android.database.ContentObserver))
  /// and [`ContentResolver.registerContentObserver`](https://developer.android.com/reference/android/content/ContentResolver?_gl=1*8nubxd*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#registerContentObserver(android.net.Uri,%20boolean,%20android.database.ContentObserver))
  /// will throw a SecurityException if the caller does not have permission to
  /// access the provider (or the provider doesn't exit); otherwise the call will
  /// be silently ignored.
  ///
  /// * [`CameraDevice.createCaptureRequest`](https://developer.android.com/reference/android/hardware/camera2/CameraDevice?_gl=1*8nubxd*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#createCaptureRequest(int))
  /// will enable [`CaptureRequest.CONTROL_ENABLE_ZSL`](https://developer.android.com/reference/android/hardware/camera2/CaptureRequest?_gl=1*1r7zy4*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#CONTROL_ENABLE_ZSL)
  /// by default for still image capture.
  ///
  /// * WallpaperManager's [`WallpaperManager.getWallpaperFile(int)`](https://developer.android.com/reference/android/app/WallpaperManager?_gl=1*1r7zy4*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#getWallpaperFile(int)),
  /// [`WallpaperManager.getDrawable()`](https://developer.android.com/reference/android/app/WallpaperManager?_gl=1*1r7zy4*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#getDrawable()),
  /// [`WallpaperManager.getFastDrawable()`](https://developer.android.com/reference/android/app/WallpaperManager?_gl=1*1r7zy4*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#getFastDrawable()),
  /// [`WallpaperManager.peekDrawable()`](https://developer.android.com/reference/android/app/WallpaperManager?_gl=1*41fwxj*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#peekDrawable()),
  /// and [`WallpaperManager.peekFastDrawable()`](https://developer.android.com/reference/android/app/WallpaperManager?_gl=1*41fwxj*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#peekFastDrawable())
  /// will throw an exception if you can not access the wallpaper.
  ///
  /// * The behavior of [`UsbDeviceConnection.requestWait`](https://developer.android.com/reference/android/hardware/usb/UsbDeviceConnection?_gl=1*41fwxj*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#requestWait())
  /// is modified as per the documentation there.
  ///
  /// * [`StrictMode.VmPolicy.Builder.detectAll`](https://developer.android.com/reference/android/os/StrictMode.VmPolicy.Builder?_gl=1*41fwxj*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#detectAll())
  /// will also enable [`StrictMode.VmPolicy.Builder#detectContentUriWithoutPermission`](https://developer.android.com/reference/android/os/StrictMode.VmPolicy.Builder?_gl=1*ekwhdy*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#detectContentUriWithoutPermission())
  /// and [`StrictMode.VmPolicy.Builder#detectUntaggedSockets`](https://developer.android.com/reference/android/os/StrictMode.VmPolicy.Builder?_gl=1*ekwhdy*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#detectUntaggedSockets()).
  ///
  /// * [`StrictMode.ThreadPolicy.Builder.detectAll`](https://developer.android.com/reference/android/os/StrictMode.ThreadPolicy.Builder?_gl=1*ekwhdy*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#detectAll())
  /// will also enable [`StrictMode.ThreadPolicy.Builder#detectUnbufferedIo`](https://developer.android.com/reference/android/os/StrictMode.ThreadPolicy.Builder?_gl=1*ekwhdy*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#detectUnbufferedIo()).
  ///
  /// * [`DocumentsContract`](https://developer.android.com/reference/android/provider/DocumentsContract?_gl=1*gqqifh*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)'s
  /// various methods will throw failure exceptions back to the caller instead of
  /// returning null.
  ///
  /// * [`View.hasFocusable`](https://developer.android.com/reference/android/view/View?_gl=1*gqqifh*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#hasFocusable())
  /// now includes auto-focusable views.
  ///
  /// * [`SurfaceView`](https://developer.android.com/reference/android/view/SurfaceView?_gl=1*gqqifh*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// will no longer always change the underlying Surface object
  /// when something about it changes; apps need to look at the current state of
  /// the object to determine which things they are interested in have changed.
  ///
  /// * [`WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY`](https://developer.android.com/reference/android/view/WindowManager.LayoutParams?_gl=1*abvw5s*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#TYPE_APPLICATION_OVERLAY)
  /// must be used for overlay windows, other system overlay window types are not
  /// allowed.
  ///
  /// * [`ViewTreeObserver.addOnDrawListener`](https://developer.android.com/reference/android/view/ViewTreeObserver?_gl=1*abvw5s*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#addOnDrawListener(android.view.ViewTreeObserver.OnDrawListener))
  /// will throw an exception if called from within onDraw.
  ///
  /// * [`Canvas.setBitmap`](https://developer.android.com/reference/android/graphics/Canvas?_gl=1*abvw5s*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#setBitmap(android.graphics.Bitmap))
  /// will no longer preserve the current matrix and clip stack of the canvas.
  ///
  /// * [`ListPopupWindow.setHeight`](https://developer.android.com/reference/android/widget/ListPopupWindow?_gl=1*abvw5s*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#setHeight(int))
  /// will throw an exception if a negative height is supplied.
  ///
  /// * [`TextView`](https://developer.android.com/reference/android/widget/TextView?_gl=1*cq9izf*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// will use internationalized input for numbers, dates, and times.
  ///
  /// * [`Toast`](https://developer.android.com/reference/android/widget/Toast?_gl=1*cq9izf*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// must be used for showing toast windows; the toast window type can not be
  /// directly used.
  ///
  /// * [`WifiManager.getConnectionInfo`](https://developer.android.com/reference/android/net/wifi/WifiManager?_gl=1*cq9izf*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#getConnectionInfo())
  /// requires that the caller hold the location permission to return BSSID/SSID
  ///
  /// * [`WifiP2pManager.requestPeers`](https://developer.android.com/reference/android/net/wifi/p2p/WifiP2pManager?_gl=1*mjh9iq*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#requestPeers(android.net.wifi.p2p.WifiP2pManager.Channel,%20android.net.wifi.p2p.WifiP2pManager.PeerListListener))
  /// requires the caller hold the location permission.
  ///
  /// * [`R.attr.maxAspectRatio`](https://developer.android.com/reference/android/R.attr?_gl=1*mjh9iq*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#maxAspectRatio)
  /// defaults to 0, meaning there is no restriction on the app's maximum aspect
  /// ratio (so it can be stretched to fill larger screens).
  ///
  /// * [`R.attr.focusable`](https://developer.android.com/reference/android/R.attr?_gl=1*mjh9iq*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#focusable)
  /// defaults to a new state (auto) where it will inherit the value of
  /// [`R.attr.clickable`](https://developer.android.com/reference/android/R.attr?_gl=1*oxzn3t*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#clickable)
  /// unless explicitly overridden.
  ///
  /// * A default theme-appropriate focus-state highlight will be supplied to all
  /// Views which don't provide a focus-state drawable themselves. This can be
  /// disabled by setting [`R.attr.defaultFocusHighlightEnabled`](https://developer.android.com/reference/android/R.attr?_gl=1*oxzn3t*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#defaultFocusHighlightEnabled)
  /// to false.
  ///
  /// Constant Value: 26 (0x0000001a)
  ///
  /// Added in API level 26
  static int get o => Build_VERSION_CODES.O;

  /// O MR1.
  ///
  /// Released publicly as Android 8.1 in December 2017.
  ///
  /// Applications targeting this or a later release will get these new changes
  /// in behavior. For more information about this release, see [Android 8.1
  /// features and APIs](https://developer.android.com/about/versions/oreo/android-8.1?_gl=1*1kovjw1*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..).
  ///
  /// * Apps exporting and linking to apk shared libraries must explicitly enumerate
  /// all signing certificates in a consistent order.
  ///
  /// * [`R.attr.screenOrientation`](https://developer.android.com/reference/android/R.attr?_gl=1*oxzn3t*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#screenOrientation)
  /// can not be used to request a fixed orientation if the associated activity
  /// is not fullscreen and opaque.
  ///
  /// Constant Value: 27 (0x0000001b)
  ///
  /// Added in API level 27
  static int get oMR1 => Build_VERSION_CODES.O_MR1;

  /// P.
  ///
  /// Released publicly as Android 9 in August 2018.
  ///
  /// Applications targeting this or a later release will get these new changes
  /// in behavior. For more information about this release, see the [Android 9
  /// Pie overview](https://developer.android.com/about/versions/pie?_gl=1*1czigyg*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..).
  ///
  /// * [`Service.startForeground`](https://developer.android.com/reference/android/app/Service?_gl=1*nmtqrl*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#startForeground(int,%20android.app.Notification))
  /// requires that apps hold the permission [`Manifest.permission.FOREGROUND_SERVICE`](https://developer.android.com/reference/android/Manifest.permission?_gl=1*nmtqrl*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..#FOREGROUND_SERVICE).
  ///
  /// * [`LinearLayout`](https://developer.android.com/reference/android/widget/LinearLayout?_gl=1*nmtqrl*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  /// will always remeasure weighted children, even if there is no excess space.
  ///
  /// Constant Value: 28 (0x0000001c)
  ///
  /// Added in API level 28
  static int get p => Build_VERSION_CODES.P;

  /// Q.
  ///
  /// Released publicly as Android 10 in September 2019.
  ///
  /// Applications targeting this or a later release will get these new changes
  /// in behavior. For more information about this release, see the [Android 10
  /// overview](https://developer.android.com/about/versions/10?_gl=1*1xmeqjx*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..).
  ///
  /// * [Behavior changes: all apps](https://developer.android.com/about/versions/10/behavior-changes-all?_gl=1*y1ybdo*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  ///
  /// * [Behavior changes: apps targeting API 29+](https://developer.android.com/about/versions/10/behavior-changes-10?_gl=1*y1ybdo*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  ///
  /// Constant Value: 29 (0x0000001d)
  ///
  /// Added in API level 29
  static int get q => Build_VERSION_CODES.Q;

  /// R.
  ///
  /// Released publicly as Android 11 in September 2020.
  ///
  /// Applications targeting this or a later release will get these new changes
  /// in behavior. For more information about this release, see the [Android 11
  /// overview](https://developer.android.com/about/versions/11?_gl=1*vqgkpj*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..).
  ///
  /// * [Behavior changes: all apps](https://developer.android.com/about/versions/11/behavior-changes-all?_gl=1*bk0u43*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  ///
  /// * [Behavior changes: Apps targeting Android 11](https://developer.android.com/about/versions/11/behavior-changes-11?_gl=1*bk0u43*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  ///
  /// * [Updates to non-SDK interface restrictions in Android 11](https://developer.android.com/about/versions/11/non-sdk-11?_gl=1*bk0u43*_up*MQ..*_ga*MTU4NjA1ODYyNC4xNzE4Njc3MjE1*_ga_6HH9YJMN9M*MTcxODY5MzExMC4yLjAuMTcxODY5MzExMC4wLjAuMA..)
  ///
  /// Constant Value: 30 (0x0000001e)
  ///
  /// Added in API level 30
  static int get r => Build_VERSION_CODES.R;

  /// S.
  ///
  /// Constant Value: 31 (0x0000001f)
  ///
  /// Added in API level 31
  static int get s => Build_VERSION_CODES.S;

  /// S V2. Once more unto the breach, dear friends, once more.
  ///
  /// Constant Value: 32 (0x00000020)
  ///
  /// Added in API level 32
  static int get sV2 => Build_VERSION_CODES.S_V2;

  /// Tiramisu.
  ///
  /// Constant Value: 33 (0x00000021)
  ///
  /// Added in API level 33
  static int get tiramisu => Build_VERSION_CODES.TIRAMISU;

  /// Upside Down Cake.
  ///
  /// Constant Value: 34 (0x00000022)
  ///
  /// Added in API level 34
  static int get upsideDownCake => Build_VERSION_CODES.UPSIDE_DOWN_CAKE;
}
