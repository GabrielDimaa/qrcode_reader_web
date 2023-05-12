@JS()
library jsqr;

import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:js/js.dart';

import '../objects/qrcode_capture.dart';
import '../qrcode_reader.dart';
import '../exceptions/qrcode_reader_exception.dart';
import 'js_library.dart';
import 'media_devices_library.dart';

@JS('jsQR')
external Code? jsQR(dynamic data, int? width, int? height);

@JS()
class Code {
  external String get data;

  external Uint8ClampedList get binaryData;
}

class JsQRLibrary implements QRCodeReader {
  @override
  final html.DivElement videoContainer;

  final html.VideoElement video = html.VideoElement();
  html.MediaStream? localMediaStream;

  JsQRLibrary(this.videoContainer);

  @override
  Duration get frameInterval => const Duration(milliseconds: 200);

  @override
  int get videoHeight => video.videoHeight;

  @override
  int get videoWidth => video.videoWidth;

  @override
  bool get isStarted => localMediaStream != null;

  @override
  Stream<QRCodeCapture?> detectQrCode() async* {
    yield* Stream.periodic(frameInterval, (_) => _captureCode(video)).asyncMap((Code? code) async {
      if (code == null) return null;

      return QRCodeCapture(
        raw: code.data,
        image: Uint8List.fromList(code.binaryData),
      );
    });
  }

  @override
  Future<void> start() async {
    try {
      await JsLibrary.injectLibraries([const JsLibrary(contextName: 'jsQR', url: 'https://cdn.jsdelivr.net/npm/jsqr@1.4.0/dist/jsQR.min.js')]);

      videoContainer.children = [video];

      final stream = await _initMediaStream();

      //tell Safari we don't want fullscreen.
      video.setAttribute('playsinline', 'true');

      if (stream != null) {
        localMediaStream = stream;
        video.srcObject = stream;
        await video.play();
      }
    } on QRCodeReaderPermissionDeniedException catch (_) {
      rethrow;
    } catch (e) {
      throw PlatformException(code: 'QRCodeReaderError', message: e.toString());
    }
  }

  @override
  Future<void> stop() async {
    try {
      localMediaStream?.getTracks().where((track) => track.readyState == 'live').forEach((track) => track.stop());
    } catch (_) {}

    video.srcObject = null;
    localMediaStream = null;
    videoContainer.children = [];
  }

  ///Captures a frame and analyzes it for QR codes.
  Code? _captureCode(html.VideoElement video) {
    if (localMediaStream == null) return null;

    final canvas = html.CanvasElement(width: video.videoWidth, height: video.videoHeight);
    final ctx = canvas.context2D;
    ctx.drawImage(video, 0, 0);
    final imgData = ctx.getImageData(0, 0, canvas.width!, canvas.height!);
    final code = jsQR(imgData.data, canvas.width, canvas.height);

    return code;
  }

  Future<html.MediaStream?> _initMediaStream() async {
    try {
      final Map<dynamic, dynamic>? capabilities = html.window.navigator.mediaDevices?.getSupportedConstraints();
      late final Map<String, dynamic> constraints;

      if (capabilities != null && capabilities['facingMode'] == true) {
        constraints = {'video': VideoOptions(facingMode: 'environment')};
      } else {
        constraints = {'video': true};
      }

      return await html.window.navigator.mediaDevices?.getUserMedia(constraints);
    } on html.DomException catch (e) {
      throw QRCodeReaderPermissionDeniedException(message: e.message);
    }
  }
}
