import 'dart:async';
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';

import '../exceptions/qrcode_reader_exception.dart';
import '../libraries/jsqr_library.dart';
import '../objects/qrcode_capture.dart';
import '../objects/start_arguments.dart';
import '../qrcode_reader.dart';

class QRCodeReaderController {
  late QRCodeReader qrCodeReader;

  QRCodeReaderController() {
    qrCodeReader = JsQRLibrary(vidDiv);
  }

  bool starting = false;

  final DivElement vidDiv = DivElement();
  final String viewID = 'WebScanner-${DateTime.now().millisecondsSinceEpoch}';

  final ValueNotifier<StartArguments?> startArguments = ValueNotifier(null);

  final StreamController<QRCodeCapture> streamController = StreamController();
  StreamSubscription? subscription;

  Stream<QRCodeCapture> get qrCodeStream => streamController.stream;

  Future<void> start() async {
    try {
      starting = true;

      if (qrCodeReader.isStarted) {
        startArguments.value = StartArguments(
          webId: viewID,
          size: ui.Size(qrCodeReader.videoWidth.toDouble(), qrCodeReader.videoHeight.toDouble()),
        );

        return;
      }

      _registerVideo();

      await qrCodeReader.start();
      subscription = qrCodeReader.detectQrCode().listen((event) {
        if (event != null && !streamController.isClosed) streamController.add(event);
      });

      startArguments.value = StartArguments(
        webId: viewID,
        size: ui.Size(qrCodeReader.videoWidth.toDouble(), qrCodeReader.videoHeight.toDouble()),
      );
    } on QRCodeReaderException catch (_) {
      rethrow;
    } catch (e) {
      throw QRCodeReaderException(
        code: "QRCodeReaderException",
        message: e.toString(),
      );
    } finally {
      starting = false;
    }
  }

  void _registerVideo() {
    ui.platformViewRegistry.registerViewFactory(
        viewID,
        (_) => vidDiv
          ..style.width = '100%'
          ..style.height = '100%');
  }

  Future<void> dispose() async {
    subscription?.cancel();
    streamController.close();

    bool repeat = starting;
    do {
      repeat = starting;
      if (!repeat) {
        await qrCodeReader.stop();
      } else {
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } while (repeat);
  }
}
