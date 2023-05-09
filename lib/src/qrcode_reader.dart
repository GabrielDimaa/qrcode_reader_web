import 'dart:html' as html;

import 'objects/qrcode_capture.dart';

abstract class QRCodeReader {
  /// Timer used to capture frames to be analyzed
  Duration get frameInterval;

  html.DivElement get videoContainer;

  bool get isStarted;

  int get videoWidth;

  int get videoHeight;

  Future<void> start();

  Stream<QRCodeCapture?> detectQrCode();

  Future<void> stop();
}