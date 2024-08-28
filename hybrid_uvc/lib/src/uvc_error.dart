class UVCError extends Error {
  final Object? message;

  UVCError([this.message]);

  @override
  String toString() {
    if (message != null) {
      return "UVCError: ${Error.safeToString(message)}";
    }
    return "UVCError";
  }
}
