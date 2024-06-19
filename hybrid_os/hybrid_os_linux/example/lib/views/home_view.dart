import 'package:flutter/material.dart';
import 'package:hybrid_os_linux/hybrid_os_linux.dart';
import 'package:hybrid_os_platform_interface/hybrid_os_platform_interface.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final os = OS();
    if (os is! Linux) {
      throw TypeError();
    }
    const version = 'Linux <UNKNOWN>';
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
          ],
        ),
      ),
    );
  }
}
