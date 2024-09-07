import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';

import 'package:clover/clover.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hybrid_uvc/hybrid_uvc.dart';
import 'package:hybrid_uvc_example/view_models.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<HomeViewModel>(context);
    final streaming = viewModel.streaming;
    final frame = viewModel.frame;
    // final zoomAbsolute = viewModel.zoomAbsolute;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox.expand(
              child: frame == null
                  ? null
                  : UVCView(
                      frame: frame,
                      fit: BoxFit.contain,
                      fpsVisible: true,
                      fpsStyle:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                    ),
            ),
            // if (zoomAbsolute != null)
            //   Container(
            //     margin: const EdgeInsets.only(
            //       left: 40.0,
            //       right: 100.0,
            //     ),
            //     height: 80.0,
            //     child: Slider(
            //       min: zoomAbsolute.minimum.toDouble(),
            //       max: zoomAbsolute.maximum.toDouble(),
            //       divisions: (zoomAbsolute.maximum - zoomAbsolute.minimum) ~/
            //           zoomAbsolute.resolution,
            //       value: zoomAbsolute.current.toDouble(),
            //       onChanged: (value) {
            //         final focalLength = value.toInt();
            //         viewModel.setZoomAbsolute(focalLength);
            //       },
            //     ),
            //   ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (streaming) {
            viewModel.stopStreaming();
          } else {
            viewModel.startStreaming();
          }
        },
        child: Icon(
          streaming ? Icons.stop : Icons.play_arrow,
        ),
      ),
    );
  }
}
