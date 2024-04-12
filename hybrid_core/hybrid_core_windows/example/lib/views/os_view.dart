import 'package:flutter/material.dart';
import 'package:hybrid_core_platform_interface/hybrid_core_platform_interface.dart';
import 'package:hybrid_core_windows/hybrid_core_windows.dart';

class OSView extends StatelessWidget {
  const OSView({super.key});

  @override
  Widget build(BuildContext context) {
    final os = OS.instance;
    if (os is! Windows) {
      throw TypeError();
    }
    final version = 'Windows ${os.version}';
    final atLeastVersion = os.isWindows10OrGreater;
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
              'Version at least\nWindows 10+',
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
