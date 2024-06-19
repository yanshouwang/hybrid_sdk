import 'package:flutter/material.dart';
import 'package:hybrid_os_darwin/hybrid_os_darwin.dart';
import 'package:hybrid_os_platform_interface/hybrid_os_platform_interface.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final os = OS();
    final String version;
    final bool isAtLeastVersion;
    if (os is iOS) {
      version = 'iOS ${os.version}';
      final version17_0 = DarwinVersion.fromNumber(17.0);
      isAtLeastVersion = os.isAtLeastVersion(version17_0);
    } else if (os is macOS) {
      version = 'macOS ${os.version}';
      final version14_0 = DarwinVersion.fromNumber(14.0);
      isAtLeastVersion = os.isAtLeastVersion(version14_0);
    } else {
      throw TypeError();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('OS'),
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        alignment: Alignment.center,
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
              'At least version\niOS 17.0+\nmacOS 14.0+',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              '$isAtLeastVersion',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
