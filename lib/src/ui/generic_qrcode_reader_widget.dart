import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../objects/qrcode_capture.dart';
import '../typedef/typedef.dart';
import 'generic_default_widget.dart' if (dart.library.html) 'generic_web_widget.dart';

/// Widget responsible for displaying the camera videos and reading the QR Code.
/// It will only build if it's for web; for other platforms, it will return a SizedBox.
class GenericQRCodeReaderWidget extends StatelessWidget {
  final void Function(QRCodeCapture barcodes) onDetect;
  final ErrorBuilder? errorBuilder;
  final double qrCodeSize;
  final Color qrCodeOutsideColor;
  final double qrCodeOutsideOpacity;

  /// Widget responsible for displaying the camera and reading the QR Code.
  /// [onDetect] - Function called when the QR Code is detected.
  /// [errorBuilder] - Widget to be displayed when an error occurs.
  /// [qrCodeSize] - Size of the QR Code.
  /// [qrCodeOutsideColor] - Color outside the QR Code.
  /// [qrCodeOutsideOpacity] - Opacity outside the QR Code.
  const GenericQRCodeReaderWidget({
    super.key,
    required this.onDetect,
    this.errorBuilder,
    this.qrCodeSize = 250,
    this.qrCodeOutsideColor = Colors.transparent,
    this.qrCodeOutsideOpacity = 0,
  });

  @override
  Widget build(BuildContext context) {
    return buildWidget(
      onDetect: onDetect,
      errorBuilder: errorBuilder,
      qrCodeSize: qrCodeSize,
      qrCodeOutsideColor: qrCodeOutsideColor,
      qrCodeOutsideOpacity: qrCodeOutsideOpacity,
    );
  }
}
