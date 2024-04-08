import 'package:flutter/material.dart';
import 'package:hybrid_core/hybrid_core.dart';

class OSView extends StatelessWidget {
  const OSView({super.key});

  @override
  Widget build(BuildContext context) {
    final os = OS.instance;
    final String version;
    final bool atLeastVersion;
    if (os is Android) {
      version = 'Android API ${os.api}';
      atLeastVersion = os.atLeastAPI(33);
    } else if (os is iOS) {
      version = 'iOS ${os.version}';
      final version17_0 = DarwinVersion.number(17.0);
      atLeastVersion = os.atLeastVersion(version17_0);
    } else if (os is macOS) {
      version = 'macOS ${os.version}';
      final version14_0 = DarwinVersion.number(14.0);
      atLeastVersion = os.atLeastVersion(version14_0);
    } else if (os is Windows) {
      version = 'Windows ${os.version}';
      atLeastVersion = os.isWindows10OrGreater;
    } else if (os is Linux) {
      version = 'Linux <UNKNOWN>';
      atLeastVersion = false;
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
              'Version at least\nAndroid API 33+\niOS 17.0+\nmacOS 14.0+\nWindows 10+',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
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
