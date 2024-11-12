/// Window attributes.
abstract interface class WindowAttributes {
  /// This can be used to override the user's preferred brightness of the screen.
  /// A value of less than 0, the default, means to use the preferred screen
  /// brightness. 0 to 1 adjusts the brightness from dark to full bright.
  double? get brightness;
  set brightness(double? value);
}
