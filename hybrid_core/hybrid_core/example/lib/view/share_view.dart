import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hybrid_core/hybrid_core.dart';
import 'package:share_plus/share_plus.dart';

class ShareView extends StatelessWidget {
  final OS os;

  ShareView({super.key}) : os = OS();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share'),
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Click the button to render a widget to memory and share the image to others.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20.0),
            Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  final box = context.findRenderObject() as RenderBox;
                  final widget = Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.grey,
                    ),
                    child: const Icon(
                      Icons.apple,
                      size: 80.0,
                    ),
                  );
                  final memory = await os.renderWidgetToMemory(
                    context: context,
                    widget: widget,
                    size: const Size.square(200.0),
                    format: ImageByteFormat.png,
                  );
                  final file = XFile.fromData(
                    memory,
                    mimeType: 'image/png',
                  );
                  await Share.shareXFiles(
                    [file],
                    sharePositionOrigin:
                        box.localToGlobal(Offset.zero) & box.size,
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200.0, 40.0),
                ),
                child: const Text('Share'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
