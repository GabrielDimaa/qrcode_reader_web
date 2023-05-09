import 'dart:async';
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

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
          size: Size(qrCodeReader.videoWidth.toDouble(), qrCodeReader.videoHeight.toDouble()),
        );

        return;
      }

      registerVideo();

      await qrCodeReader.start();
      subscription = qrCodeReader.detectQrCode().listen((event) {
        // if (event != null && !streamController.isClosed) streamController.add(event);
        if (event != null) streamController.add(event);
      });

      startArguments.value = StartArguments(
        webId: viewID,
        size: Size(qrCodeReader.videoWidth.toDouble(), qrCodeReader.videoHeight.toDouble()),
      );
    } on PlatformException catch (e) {
      throw QRCodeReaderException(
        code: e.code,
        message: e.message,
        details: e.details,
      );
    } finally {
      starting = false;
    }
  }

  void registerVideo() {
    ui.platformViewRegistry.registerViewFactory(
        viewID,
        (_) => vidDiv
          ..style.width = '100%'
          ..style.height = '100%');
  }

  void dispose() {
    subscription?.cancel();
    streamController.close();
    qrCodeReader.stop();
  }
}
