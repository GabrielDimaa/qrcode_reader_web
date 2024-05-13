import 'dart:async';
import 'dart:html';
import 'dart:ui';
import 'dart:ui_web' as ui;

import 'package:flutter/foundation.dart';

import '../exceptions/qrcode_reader_exception.dart';
import '../libraries/jsqr_library.dart';
import '../objects/qrcode_capture.dart';
import '../objects/start_arguments.dart';
import '../qrcode_reader.dart';

/// Class responsible for the screen controls of [QRCodeReaderWidget].
class QRCodeReaderController {
  /// Instance of the QRCodeReader implementation.
  late QRCodeReader qrCodeReader;

  QRCodeReaderController() {
    qrCodeReader = JsQRLibrary(_vidDiv);
  }

  /// Indicates whether the QR code reader is currently starting.
  bool _starting = false;

  /// The html responsible for the video.
  final DivElement _vidDiv = DivElement();

  /// The unique identifier for the view of the QR code reader.
  final String _viewID = 'WebScanner-${DateTime.now().millisecondsSinceEpoch}';

  /// Notifier for the arguments passed to the start method.
  final ValueNotifier<StartArguments?> startArguments = ValueNotifier(null);

  /// Stream controller for QRCodeCapture.
  final StreamController<QRCodeCapture> _streamController = StreamController();

  /// Subscription to the stream of QRCodeCapture.
  StreamSubscription? _subscription;

  /// Gets the QR Code stream.
  Stream<QRCodeCapture> get qrCodeStream => _streamController.stream;

  /// Starts the QR code reader.
  ///
  /// This method tries to start the QR code reader and registers the video element
  /// to the platform view registry. When the QR code reader starts to detect
  /// a QR code, it sends the captured frames to the stream controller.
  Future<void> start() async {
    try {
      _starting = true;

      if (qrCodeReader.isStarted) {
        startArguments.value = StartArguments(
          webId: _viewID,
          size: Size(qrCodeReader.videoWidth.toDouble(), qrCodeReader.videoHeight.toDouble()),
        );

        return;
      }

      _registerVideo();

      await qrCodeReader.start();
      _subscription = qrCodeReader.detectQrCode().listen((event) {
        if (event != null && !_streamController.isClosed) _streamController.add(event);
      });

      startArguments.value = StartArguments(
        webId: _viewID,
        size: Size(qrCodeReader.videoWidth.toDouble(), qrCodeReader.videoHeight.toDouble()),
      );
    } on QRCodeReaderException catch (_) {
      rethrow;
    } catch (e) {
      throw QRCodeReaderException(
        code: "QRCodeReaderException",
        message: e.toString(),
      );
    } finally {
      _starting = false;
    }
  }

  /// Registers the video element to the platform view registry.
  void _registerVideo() {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
        _viewID,
        (_) => _vidDiv
          ..style.width = '100%'
          ..style.height = '100%');
  }

  /// Disposes the controller.
  ///
  /// This method cancels the subscription to the stream and closes the stream controller.
  /// If the QR code reader is still starting, it waits for half a second before stopping it.
  Future<void> dispose() async {
    _subscription?.cancel();
    _streamController.close();

    bool repeat = _starting;
    do {
      repeat = _starting;
      if (!repeat) {
        await qrCodeReader.stop();
      } else {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } while (repeat);
  }
}
