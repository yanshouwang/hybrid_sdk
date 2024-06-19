import 'package:flutter/material.dart';
import 'package:hybrid_os_platform_interface/hybrid_os_platform_interface.dart';
import 'package:hybrid_os_windows/hybrid_os_windows.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final os = OS();
    if (os is! Windows) {
      throw TypeError();
    }
    final version = 'Windows ${os.version}';
    final isWindows10OrGreater = os.isWindows10OrGreater;
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
              'isWindows10OrGreater',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              '$isWindows10OrGreater',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
