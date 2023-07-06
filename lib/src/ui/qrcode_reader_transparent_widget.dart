import 'package:flutter/material.dart';

import '../objects/qrcode_capture.dart';
import '../typedef/typedef.dart';
import 'qrcode_reader_transparent_default_widget.dart' if (dart.library.html) 'qrcode_reader_transparent_web_widget.dart';

/// Widget responsible for displaying the camera videos and reading the QR Code.
/// It will only build if it's for web; for other platforms, it will return a SizedBox.
class QRCodeReaderTransparentWidget extends StatelessWidget {
  final void Function(QRCodeCapture barcodes) onDetect;
  final ErrorBuilder? errorBuilder;
  final double targetSize;
  final Color? outsideColor;

  /// Widget responsible for displaying the camera and reading the QR Code.
  /// [onDetect] - Function called when the QR Code is detected.
  /// [errorBuilder] - Widget to be displayed when an error occurs.
  /// [targetSize] - Size of the QR Code.
  /// [qrCodeOutsideColor] - Color outside the QR Code.
  /// [qrCodeOutsideOpacity] - Opacity outside the QR Code.
  const QRCodeReaderTransparentWidget({
    super.key,
    required this.onDetect,
    this.errorBuilder,
    this.targetSize = 250,
    this.outsideColor
  });

  @override
  Widget build(BuildContext context) {
    return buildWidget(
      onDetect: onDetect,
      errorBuilder: errorBuilder,
      targetSize: targetSize,
      outsideColor: outsideColor,
    );
  }
}
