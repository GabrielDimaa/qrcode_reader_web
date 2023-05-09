import 'dart:typed_data';

class QRCodeCapture {
  final String raw;
  final Uint8List? image;

  QRCodeCapture({
    required this.raw,
    this.image,
  });
}
