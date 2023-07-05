import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../objects/qrcode_capture.dart';
import '../typedef/typedef.dart';

/// Method responsible for building the widget to be used in a conditional import.
Widget buildWidget({
  required void Function(QRCodeCapture barcodes) onDetect,
  ErrorBuilder? errorBuilder,
  double qrCodeSize = 250,
  Color qrCodeOutsideColor = Colors.transparent,
  double qrCodeOutsideOpacity = 0,
}) =>
    const SizedBox.shrink();
