import 'dart:async';

import 'package:flutter/material.dart';

import '../../qrcode_reader_web.dart';
import '../objects/start_arguments.dart';
import '../typedef/typedef.dart';
import 'qrcode_reader_controller.dart';

/// Method responsible for building the widget to be used in a conditional import.
Widget buildWidget({
  required void Function(QRCodeCapture barcodes) onDetect,
  ErrorBuilder? errorBuilder,
  double qrCodeSize = 250,
  Color qrCodeOutsideColor = Colors.transparent,
  double qrCodeOutsideOpacity = 0,
}) =>
    GenericWebWidget(
      onDetect: onDetect,
      errorBuilder: errorBuilder,
      qrCodeSize: qrCodeSize,
      qrCodeOutsideColor: qrCodeOutsideColor,
      qrCodeOutsideOpacity: qrCodeOutsideOpacity,
    );

/// Widget responsible for displaying the camera videos and reading the QR Code.
class GenericWebWidget extends StatefulWidget {
  final void Function(QRCodeCapture barcodes) onDetect;
  final ErrorBuilder? errorBuilder;
  final double qrCodeSize;
  final Color qrCodeOutsideColor;
  final double qrCodeOutsideOpacity;

  const GenericWebWidget({
    super.key,
    required this.onDetect,
    this.errorBuilder,
    this.qrCodeSize = 250,
    this.qrCodeOutsideColor = Colors.transparent,
    this.qrCodeOutsideOpacity = 0,
  });

  @override
  State<GenericWebWidget> createState() => _GenericWebWidgetState();
}

class _GenericWebWidgetState extends State<GenericWebWidget> {
  final QRCodeReaderController controller = QRCodeReaderController();

  late StreamSubscription<QRCodeCapture>? qrCodeSubscription;
  QRCodeReaderException? exception;

  @override
  void initState() {
    super.initState();

    qrCodeSubscription = controller.qrCodeStream.listen((capture) {
      widget.onDetect(capture);
    });

    start();
  }

  Future<void> start() async {
    try {
      await controller.start();
    } catch (e) {
      setState(() => exception = e as QRCodeReaderException);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<StartArguments?>(
      valueListenable: controller.startArguments,
      builder: (context, value, child) {
        final totalWidth = MediaQuery.of(context).size.width;
        final totalHeight = MediaQuery.of(context).size.height;
        final borderWidth = (totalWidth / 2) - (widget.qrCodeSize / 2);
        final borderHeight = (totalHeight / 2) - (widget.qrCodeSize / 2);
        final colorAndOpacity = widget.qrCodeOutsideColor.withOpacity(widget.qrCodeOutsideOpacity);

        if (exception != null) {
          return errorWidget(context: context, exception: exception!);
        }

        return Stack(
          children: [
            Visibility(
              visible: value != null,
              replacement: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              child: Center(
                child: SizedBox(
                  width: totalWidth,
                  height: totalHeight,
                  child: Stack(
                    children: [
                      HtmlElementView(viewType: value?.webId ?? ""),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: colorAndOpacity, width: borderHeight),
                              left: BorderSide(color: colorAndOpacity, width: borderWidth),
                              right: BorderSide(color: colorAndOpacity, width: borderWidth),
                              bottom: BorderSide(color: colorAndOpacity, width: borderHeight),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget errorWidget({required BuildContext context, required QRCodeReaderException exception}) {
    if (widget.errorBuilder == null) {
      return Center(
        child: Text(exception.toString()),
      );
    }

    return widget.errorBuilder!.call(
      context: context,
      exception: exception,
    );
  }

  @override
  void dispose() {
    qrCodeSubscription?.cancel();
    controller.dispose();
    super.dispose();
  }
}
