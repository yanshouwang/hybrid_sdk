final class V4L2Error extends Error {
  final Object? message;

  V4L2Error([this.message]);

  @override
  String toString() {
    if (message != null) {
      return "V4L2Error: ${Error.safeToString(message)}";
    }
    return "V4L2Error";
  }
}
