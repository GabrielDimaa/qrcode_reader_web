import 'package:flutter/widgets.dart';

import '../exceptions/qrcode_reader_exception.dart';

typedef ErrorBuilder = Widget Function({required BuildContext context, required QRCodeReaderException exception});