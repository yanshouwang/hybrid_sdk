class USBError extends Error {
  final Object? message;

  USBError([this.message]);

  @override
  String toString() {
    if (message != null) {
      return "USBError: ${Error.safeToString(message)}";
    }
    return "USBError";
  }
}
