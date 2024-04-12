import 'package:flutter/material.dart';
import 'package:hybrid_core_linux/hybrid_core_linux.dart';
import 'package:hybrid_core_platform_interface/hybrid_core_platform_interface.dart';

class OSView extends StatelessWidget {
  const OSView({super.key});

  @override
  Widget build(BuildContext context) {
    final os = OS.instance;
    if (os is! Linux) {
      throw TypeError();
    }
    const version = 'Linux <UNKNOWN>';
    const atLeastVersion = false;
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
              'Version at least\nLinux',
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
