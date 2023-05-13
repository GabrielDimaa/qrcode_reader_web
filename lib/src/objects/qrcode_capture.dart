import 'dart:typed_data';

/// QR Code that will be captured in the [detectQrCode] event.
class QRCodeCapture {
  /// Content QRCode.
  final String raw;

  /// QR Code in image.
  final Uint8List? image;

  QRCodeCapture({
    required this.raw,
    this.image,
  });
}
