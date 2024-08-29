import 'package:clover/clover.dart';
import 'package:flutter/material.dart';
import 'package:hybrid_uvc_example/view_models.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<HomeViewModel>(context);
    final streaming = viewModel.streaming;
    final image = viewModel.image;
    return Scaffold(
      body: SizedBox.expand(
        child: RawImage(
          image: image,
          fit: BoxFit.cover,
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
