/// struct v4l2_rect
abstract interface class V4L2Rect {
  /// Horizontal offset of the top, left corner of the rectangle, in pixels.
  int get left;
  set left(int value);

  /// Vertical offset of the top, left corner of the rectangle, in pixels.
  int get top;
  set top(int value);

  /// Width of the rectangle, in pixels.
  int get width;
  set width(int value);

  /// Height of the rectangle, in pixels.
  int get height;
  set height(int value);
}
