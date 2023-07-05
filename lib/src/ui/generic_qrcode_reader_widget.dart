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

  /// Widget reponsável por mostrar a câmera e ler o QR Code.
  /// [onDetect] - Função chamada quando o QR Code é detectado.
  /// [errorBuilder] - Widget que será mostrado quando ocorrer um erro.
  /// [qrCodeSize] - Tamanho do QR Code.
  /// [qrCodeOutsideColor] - Cor de fora do QR Code.
  /// [qrCodeOutsideOpacity] - Opacidade de fora do QR Code.
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
