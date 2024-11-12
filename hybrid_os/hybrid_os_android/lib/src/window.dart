import 'window_attributes.dart';

/// Abstract base class for a top-level window look and behavior policy. An instance
/// of this class should be used as the top-level view added to the window manager.
/// It provides standard UI policies such as a background, title area, default
/// key processing, etc.
///
/// The framework will instantiate an implementation of this class on behalf of
/// the application.
abstract interface class Window {
  /// Retrieve the current window attributes associated with this panel.
  WindowAttributes get attrs;

  set attrs(WindowAttributes value);

  /// This is called whenever the current window attributes change.
  Stream<WindowAttributes> get attrsChanged;
}
