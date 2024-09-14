import 'package:flutter/material.dart';
import 'package:hybrid_os_android/hybrid_os_android.dart';
import 'package:hybrid_os_platform_interface/hybrid_os_platform_interface.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final os = OS();
    if (os is! Android) {
      throw TypeError();
    }
    final version = 'Android ${os.sdk}';
    final upsideDownCakeOrLater = os.sdk >= VersionCodes.upsideDownCake;
    return MaterialApp(
      home: Scaffold(
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
                'Android 34+',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              Text(
                '$upsideDownCakeOrLater',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
