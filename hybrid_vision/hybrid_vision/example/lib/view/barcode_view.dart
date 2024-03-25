import 'dart:io';
import 'dart:ui' as ui;

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
  late final ValueNotifier<Size?> size;
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
    size = ValueNotifier(null);
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
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    buildImageView(),
                    buildBarcodesView(),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              buildDetectView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImageView() {
    return ValueListenableBuilder(
      valueListenable: uri,
      builder: (context, uri, child) {
        if (uri == null) {
          return const Offstage();
        }
        const fit = BoxFit.contain;
        final isFile = uri.isScheme('file');
        if (isFile) {
          return Image.file(
            File.fromUri(uri),
            fit: fit,
          );
        } else {
          return Image.network(
            '$uri',
            fit: fit,
          );
        }
      },
    );
  }

  Widget buildBarcodesView() {
    final mediaQuery = MediaQuery.of(context);
    return ValueListenableBuilder(
      valueListenable: uri,
      builder: (context, uri, child) {
        if (uri == null) {
          return const Offstage();
        }
        return FutureBuilder(
          future: Future(
            () async {
              final path = uri.toFilePath();
              final buffer = await ui.ImmutableBuffer.fromFilePath(path);
              final descriptor = await ui.ImageDescriptor.encoded(buffer);
              final ratio = mediaQuery.devicePixelRatio;
              final width = descriptor.width / ratio;
              final height = descriptor.height / ratio;
              return Size(width, height);
            },
          ),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? LayoutBuilder(
                    builder: (context, constraints) {
                      final size = snapshot.requireData;
                      final width =
                          constraints.biggest.aspectRatio < size.aspectRatio
                              ? constraints.maxWidth
                              : constraints.maxHeight * size.aspectRatio;
                      final height = width / size.width * size.height;
                      return FittedBox(
                        fit: BoxFit.contain,
                        child: ValueListenableBuilder(
                          valueListenable: barcodes,
                          builder: (context, barcodes, child) {
                            return CustomPaint(
                              painter: BarcodesPainter(
                                barcodes: barcodes,
                                color: Theme.of(context).colorScheme.error,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                              ),
                              size: Size(width, height),
                            );
                          },
                        ),
                      );
                    },
                  )
                : const Offstage();
          },
        );
      },
    );
  }

  Widget buildDetectView() {
    return ValueListenableBuilder(
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
    );
  }

  @override
  void dispose() {
    super.dispose();
    detecting.dispose();
    uri.dispose();
    size.dispose();
    barcodes.dispose();
  }
}

class BarcodesPainter extends CustomPainter {
  final List<Barcode> barcodes;
  final Color? color;
  final TextStyle? style;

  BarcodesPainter({
    required this.barcodes,
    this.color,
    this.style,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = color ?? Colors.amber;
    for (var barcode in barcodes) {
      final left = barcode.boundingBox.left * width;
      final top = barcode.boundingBox.top * height;
      final right = barcode.boundingBox.right * width;
      final bottom = barcode.boundingBox.bottom * height;
      final rect = Rect.fromLTRB(left, top, right, bottom);
      canvas.drawRect(rect, paint);

      final formatPainter = TextPainter(
        text: TextSpan(
          text: barcode.format.name,
          style: style,
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      formatPainter.layout(
        maxWidth: rect.width,
      );
      final formatSize = formatPainter.size;
      final formatOffset =
          rect.topCenter.translate(-formatSize.width / 2, -formatSize.height);
      formatPainter.paint(canvas, formatOffset);

      final valuePainter = TextPainter(
        text: TextSpan(
          text: barcode.value,
          style: style,
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      valuePainter.layout(
        maxWidth: rect.width,
      );
      final valueSize = valuePainter.size;
      final valueOffset =
          rect.bottomCenter.translate(-valueSize.width / 2, 0.0);
      valuePainter.paint(canvas, valueOffset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

extension on BarcodeFormat {
  String get name {
    switch (this) {
      case BarcodeFormat.aztec:
        return 'Aztec';
      case BarcodeFormat.code128:
        return 'Code 128';
      case BarcodeFormat.code39:
        return 'Code 39';
      case BarcodeFormat.code93:
        return 'Code 93';
      case BarcodeFormat.codabar:
        return 'Codabar';
      case BarcodeFormat.dataMatrix:
        return 'Data Matrix';
      case BarcodeFormat.ean13:
        return 'EAN-13';
      case BarcodeFormat.ean8:
        return 'EAN-8';
      case BarcodeFormat.gs1DataBar:
        return 'GS1 DataBar';
      case BarcodeFormat.itf:
        return 'ITF';
      case BarcodeFormat.msiPlessey:
        return 'Modified Plessey';
      case BarcodeFormat.pdf417:
        return 'PDF-417';
      case BarcodeFormat.qrCode:
        return 'QR CODE';
      case BarcodeFormat.upcA:
        return 'UPC-A';
      case BarcodeFormat.upcE:
        return 'UPC-E';
      default:
        return '未知';
    }
  }
}
