import 'package:flutter/widgets.dart';

import '../objects/qrcode_capture.dart';
import '../typedef/typedef.dart';
import 'default_widget.dart' if (dart.library.html) 'web_widget.dart';

/// Widget responsible for displaying the camera videos and reading the QR Code.
/// It will only build if it's for web; for other platforms, it will return a SizedBox.
class QRCodeReaderWidget extends StatelessWidget {
  final void Function(QRCodeCapture barcodes) onDetect;
  final double size;
  final BorderRadius? borderRadius;
  final Color? targetColor;
  final ErrorBuilder? errorBuilder;
  final Widget? placeholder;

  const QRCodeReaderWidget({
    super.key,
    required this.onDetect,
    required this.size,
    this.borderRadius,
    this.targetColor,
    this.errorBuilder,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return buildWidget(
      onDetect: onDetect,
      size: size,
      borderRadius: borderRadius,
      targetColor: targetColor,
      errorBuilder: errorBuilder,
      placeholder: placeholder,
    );
  }
}
