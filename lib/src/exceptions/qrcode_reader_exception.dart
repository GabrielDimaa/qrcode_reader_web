import 'package:flutter/services.dart';

/// Exception class for errors encountered during QR code reading.
class QRCodeReaderException extends PlatformException {
  QRCodeReaderException({required super.code, super.details, super.message});

  @override
  String toString() {
    if (message == null) return "QRCodeReaderPermissionDeniedException: Error reading QRCode.";
    return message!;
  }
}

/// Exception thrown when the user denies permission to access the camera for QR code reading.
class QRCodeReaderPermissionDeniedException extends QRCodeReaderException {
  QRCodeReaderPermissionDeniedException({required super.message}) : super(code: "QRCodeReaderPermissionDeniedException");

  @override
  String toString() {
   if (message == null) return "QRCodeReaderPermissionDeniedException: Permission denied.";
   return message!;
  }
}
