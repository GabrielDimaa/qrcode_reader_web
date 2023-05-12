import 'package:flutter/services.dart';

class QRCodeReaderException extends PlatformException {
  QRCodeReaderException({required super.code, super.details, super.message});

  @override
  String toString() {
    if (message == null) return "QRCodeReaderPermissionDeniedException: Error reading QRCode.";
    return message!;
  }
}

class QRCodeReaderPermissionDeniedException extends QRCodeReaderException {
  QRCodeReaderPermissionDeniedException({required super.message}) : super(code: "QRCodeReaderPermissionDeniedException");

  @override
  String toString() {
   if (message == null) return "QRCodeReaderPermissionDeniedException: Permission denied.";
   return message!;
  }
}
