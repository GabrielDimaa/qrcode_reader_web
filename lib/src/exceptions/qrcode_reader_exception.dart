import 'package:flutter/services.dart';

class QRCodeReaderException extends PlatformException {
  QRCodeReaderException({required super.code, super.details, super.message});
}

class QRCodeReaderPermissionDeniedException implements Exception {
  final String? message;

  QRCodeReaderPermissionDeniedException(this.message);

  @override
  String toString() {
   if (message == null) return "QRCodeReaderPermissionDeniedException: Permission denied.";
   return message!;
  }
}
