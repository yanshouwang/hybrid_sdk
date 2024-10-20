import 'package:clover/clover.dart';
import 'package:flutter/material.dart';
import 'package:hybrid_v4l2/hybrid_v4l2.dart';
import 'package:hybrid_v4l2_example/view_models.dart';

import 'texture_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<HomeViewModel>(context);
    final formats = viewModel.formats;
    final sizes = viewModel.sizes;
    final format = viewModel.format;
    final size = viewModel.size;
    final streaming = viewModel.streaming;
    final frame = viewModel.frame;
    return Scaffold(
      extendBody: true,
      body: V4L2View(
        frame: frame,
        fit: BoxFit.cover,
        fpsVisible: true,
      ),
      // body: TextureView(
      //   frame: buffer,
      // ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          children: [
            DropdownMenu(
              onSelected: (format) {
                if (format == null) {
                  return;
                }
                viewModel.setFormat(format);
              },
              label: const Text('FORMAT'),
              dropdownMenuEntries: formats
                  .map((format) => DropdownMenuEntry(
                        value: format,
                        label: '$format'
                            .replaceFirst('V4L2PixFmt.', '')
                            .toUpperCase(),
                      ))
                  .toList(),
              initialSelection: format,
              enabled: !streaming,
            ),
            const SizedBox(width: 20),
            DropdownMenu(
              onSelected: (size) {
                if (size == null) {
                  return;
                }
                viewModel.setSize(size);
              },
              label: const Text('SIZE'),
              dropdownMenuEntries: sizes
                  .map((size) => DropdownMenuEntry(
                        value: size,
                        label: '${size.width}x${size.height}',
                      ))
                  .toList(),
              initialSelection: size,
              enabled: !streaming,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          if (streaming) {
            viewModel.stopStreaming();
          } else {
            viewModel.beginStreaming();
          }
        },
        shape: const CircleBorder(),
        child: Icon(streaming ? Icons.stop : Icons.play_arrow),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
