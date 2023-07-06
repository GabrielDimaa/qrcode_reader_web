import 'dart:async';

import 'package:flutter/material.dart';

import '../../qrcode_reader_web.dart';
import '../objects/start_arguments.dart';
import '../typedef/typedef.dart';
import 'components/square_clipper.dart';
import 'qrcode_reader_controller.dart';

/// Method responsible for building the widget to be used in a conditional import.
Widget buildWidget({
  required void Function(QRCodeCapture barcodes) onDetect,
  ErrorBuilder? errorBuilder,
  double targetSize = 250,
  Color? outsideColor,
}) =>
    QRCodeReaderTransparentWebWidget(
      onDetect: onDetect,
      errorBuilder: errorBuilder,
      targetSize: targetSize,
      outsideColor: outsideColor,
    );

/// Widget responsible for displaying the camera videos and reading the QR Code.
class QRCodeReaderTransparentWebWidget extends StatefulWidget {
  final void Function(QRCodeCapture barcodes) onDetect;
  final ErrorBuilder? errorBuilder;
  final double targetSize;
  final Color? outsideColor;

  const QRCodeReaderTransparentWebWidget({
    super.key,
    required this.onDetect,
    this.errorBuilder,
    this.targetSize = 250,
    this.outsideColor,
  });

  @override
  State<QRCodeReaderTransparentWebWidget> createState() => _QRCodeReaderTransparentWebWidgetState();
}

class _QRCodeReaderTransparentWebWidgetState extends State<QRCodeReaderTransparentWebWidget> {
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
                  width: value?.size.width ?? 0,
                  height: value?.size.height ?? 0,
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.black,
                        child: HtmlElementView(viewType: value?.webId ?? ""),
                      ),
                      Center(
                        child: IgnorePointer(
                          child: ClipPath(
                            clipper: SquareClipper(widget.targetSize),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: widget.outsideColor ?? Colors.black.withOpacity(0.5),
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
