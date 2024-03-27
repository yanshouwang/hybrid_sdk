import 'package:flutter/material.dart';
import 'package:hybrid_core/hybrid_core.dart';

class OSView extends StatelessWidget {
  final OS os;

  OSView({super.key}) : os = OS();

  @override
  Widget build(BuildContext context) {
    final os = this.os;
    final String version;
    final bool atLeastVersion;
    if (os is Android) {
      version = '${os.api}';
      atLeastVersion = os.atLeastAPI(33);
    } else if (os is iOS) {
      version = '${os.version}';
      final version17_0 = DarwinVersion.number(17.0);
      atLeastVersion = os.atLeastVersion(version17_0);
    } else if (os is macOS) {
      version = '${os.version}';
      final version14_0 = DarwinVersion.number(14.0);
      atLeastVersion = os.atLeastVersion(version14_0);
    } else if (os is Windows) {
      version = '${os.version}';
      atLeastVersion = os.isWindows10OrGreater;
    } else {
      throw TypeError();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('OS'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Version',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              version,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              'At least API 33+ or iOS 17.0+ or macOS 14.0+ or Windows 10+',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              '$atLeastVersion',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
