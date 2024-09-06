class JPEGError extends Error {
  final Object? message;

  JPEGError([this.message]);

  @override
  String toString() {
    if (message != null) {
      return "JPEGError: ${Error.safeToString(message)}";
    }
    return "JPEGError";
  }
}
