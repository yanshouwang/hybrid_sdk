import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hybrid_vision/hybrid_vision.dart';
import 'package:image_picker/image_picker.dart';

typedef SizeListener = void Function(int width, int height);

class BarcodeView extends StatefulWidget {
  const BarcodeView({super.key});

  @override
  State<BarcodeView> createState() => _BarcodeViewState();
}

class _BarcodeViewState extends State<BarcodeView> {
  late final ImagePicker imagePicker;
  late final BarcodeDetector detector;
  late final ValueNotifier<bool> detecting;
  late final ValueNotifier<Uri?> uri;
  late final ValueNotifier<List<Barcode>> barcodes;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
    detector = BarcodeDetector(
        // formats: [
        //   BarcodeFormat.qrCode,
        // ],
        );
    detecting = ValueNotifier(false);
    uri = ValueNotifier(null);
    barcodes = ValueNotifier([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: uri,
                  builder: (context, uri, child) {
                    return ValueListenableBuilder(
                      valueListenable: barcodes,
                      builder: (context, barcodes, child) {
                        if (uri == null) {
                          return const Placeholder();
                        }
                        return ImageView(
                          uri: uri,
                          fit: BoxFit.contain,
                          sizeListener: (width, height) {},
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              ValueListenableBuilder(
                valueListenable: detecting,
                builder: (context, detecting, child) {
                  return ElevatedButton(
                    onPressed: detecting
                        ? null
                        : () async {
                            this.detecting.value = true;
                            try {
                              final file = await imagePicker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (file == null) {
                                return;
                              }
                              final uri = Uri.file(file.path);
                              // final uri = Uri.parse(
                              //     'https://www.barcodestalk.com/sites/default/files/styles/banner/public/2021-04/3-types-of-barcodes.jpg');
                              this.uri.value = uri;
                              final image = VisionImage.uri(uri);
                              final barcodes = await detector.detect(image);
                              if (!context.mounted) {
                                return;
                              }
                              this.barcodes.value = barcodes;
                            } finally {
                              this.detecting.value = false;
                            }
                          },
                    child: detecting
                        ? const SizedBox.square(
                            dimension: 16.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                            ),
                          )
                        : const Text('DETECT'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    detecting.dispose();
  }
}

class ImageView extends StatelessWidget {
  final Uint8List? memory;
  final Uri? uri;
  final BoxFit? fit;
  final SizeListener? sizeListener;

  const ImageView({
    super.key,
    this.memory,
    this.uri,
    this.fit,
    this.sizeListener,
  }) : assert(memory != null || uri != null);

  @override
  Widget build(BuildContext context) {
    final memory = this.memory;
    const configuratioin = ImageConfiguration.empty;
    final imageListener = ImageStreamListener((image, synchronousCall) {
      final width = image.image.width;
      final height = image.image.height;
      sizeListener?.call(width, height);
    });
    if (memory == null) {
      final uri = ArgumentError.checkNotNull(this.uri);
      final isFile = uri.isScheme('file');
      if (isFile) {
        final file = File.fromUri(uri);
        return Image.file(
          file,
          fit: fit,
        )..image.resolve(configuratioin).addListener(imageListener);
      } else {
        final src = uri.toString();
        return Image.network(
          src,
          fit: fit,
        )..image.resolve(configuratioin).addListener(imageListener);
      }
    } else {
      return Image.memory(
        memory,
        fit: fit,
      )..image.resolve(configuratioin).addListener(imageListener);
    }
  }
}
