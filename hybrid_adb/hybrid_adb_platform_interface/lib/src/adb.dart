import 'dart:io';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract base class ADBImpl extends PlatformInterface implements ADB {
  /// Constructs a [ADBImpl].
  ADBImpl() : super(token: _token);

  static final Object _token = Object();

  static ADBImpl? _instance;

  /// The default instance of [ADBImpl] to use.
  static ADBImpl get instance {
    final instance = _instance;
    if (instance == null) {
      throw UnimplementedError('ADB is not implemented on this platform.');
    }
    return instance;
  }

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ADBImpl] when
  /// they register themselves.
  static set instance(ADBImpl instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  String get executable;

  @override
  Future<String> execute(List<String> commandArguments) async {
    final result = await Process.run(executable, commandArguments);
    final exitCode = result.exitCode;
    if (exitCode != 0) {
      throw ADBException(
        code: exitCode,
        message: '${result.stderr}',
      );
    }
    return '${result.stdout}';
  }
}

abstract interface class ADB {
  static ADB get instance => ADBImpl.instance;

  Future<String> execute(List<String> commandArguments);
}

class ADBException {
  final int code;
  final String message;

  ADBException({
    required this.code,
    required this.message,
  });

  @override
  String toString() {
    return 'ADB Exception: $code, $message';
  }
}
