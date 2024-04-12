import 'package:flutter/material.dart';
import 'package:hybrid_core_android/hybrid_core_android.dart';
import 'package:hybrid_core_platform_interface/hybrid_core_platform_interface.dart';

class OSView extends StatelessWidget {
  const OSView({super.key});

  @override
  Widget build(BuildContext context) {
    final os = OS.instance;
    if (os is! Android) {
      throw TypeError();
    }
    final version = 'Android API ${os.api}';
    final atLeastVersion = os.atLeastAPI(33);
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
