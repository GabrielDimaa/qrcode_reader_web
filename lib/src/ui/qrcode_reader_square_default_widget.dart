import 'package:flutter/widgets.dart';

import '../objects/qrcode_capture.dart';
import '../typedef/typedef.dart';

/// Method responsible for building the widget to be used in a conditional import.
Widget buildWidget({
  required void Function(QRCodeCapture barcodes) onDetect,
  required double size,
  BorderRadius? borderRadius,
  Color? targetColor,
  ErrorBuilder? errorBuilder,
  Widget? placeholder,
}) =>
    const SizedBox.shrink();
