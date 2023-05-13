import 'dart:html' as html;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'objects/qrcode_capture.dart';

/// Interface for implementing QR Code reading.
abstract class QRCodeReader {
  static void registerWith(Registrar registrar) {}

  /// Timer used to capture frames to be analyzed.
  Duration get frameInterval;

  /// The html responsible for the video.
  html.DivElement get videoContainer;

  /// Returns true if the reader is started, false otherwise.
  bool get isStarted;

  /// The width of the video in pixels.
  int get videoWidth;

  /// The height of the video in pixels.
  int get videoHeight;

  /// Starts the QR code reader.
  Future<void> start();

  /// Returns a stream of QRCodeCapture objects representing QR codes detected in the video feed.
  Stream<QRCodeCapture?> detectQrCode();

  /// Stops the QR code reader.
  Future<void> stop();
}