import 'hybrid_os_plugin.dart';

abstract interface class OS {
  factory OS() => OSPlugin.instance.createOS();
}
