import 'dart:developer';

import 'package:clover/clover.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

import 'view_models.dart';
import 'views.dart';

void main() {
  Logger.root.onRecord.listen(onLogRecord);
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
  ]);
  runApp(const MyApp());
}

void onLogRecord(LogRecord record) {
  log(
    record.message,
    time: record.time,
    sequenceNumber: record.sequenceNumber,
    level: record.level.value,
    name: record.loggerName,
    zone: record.zone,
    error: record.error,
    stackTrace: record.stackTrace,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ViewModelBinding(
        viewBuilder: (context) => const HomeView(),
        viewModelBuilder: (context) => HomeViewModel(),
      ),
      // showPerformanceOverlay: true,
    );
  }
}
