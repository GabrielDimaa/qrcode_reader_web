import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../qrcode_reader_web.dart';
import '../objects/start_arguments.dart';
import '../typedef/typedef.dart';
import 'qrcode_reader_controller.dart';
import 'widgets/clipper_camera.dart';
import 'widgets/target_camera.dart';

/// Method responsible for building the widget to be used in a conditional import.
Widget buildWidget({
  required void Function(QRCodeCapture barcodes) onDetect,
  required double size,
  BorderRadius? borderRadius,
  Color? targetColor,
  ErrorBuilder? errorBuilder,
  Widget? placeholder,
}) =>
    WebWidget(
      onDetect: onDetect,
      size: size,
      borderRadius: borderRadius,
      targetColor: targetColor,
      errorBuilder: errorBuilder,
      placeholder: placeholder,
    );

/// Widget responsible for displaying the camera videos and reading the QR Code.
class WebWidget extends StatefulWidget {
  final void Function(QRCodeCapture barcodes) onDetect;
  final double size;
  final BorderRadius? borderRadius;
  final Color? targetColor;
  final ErrorBuilder? errorBuilder;
  final Widget? placeholder;

  const WebWidget({
    super.key,
    required this.onDetect,
    required this.size,
    this.borderRadius,
    this.targetColor,
    this.errorBuilder,
    this.placeholder,
  });

  @override
  State<WebWidget> createState() => _WebWidgetState();
}

class _WebWidgetState extends State<WebWidget> {
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
        double sizeRenderer = widget.size;

        if (exception != null) return errorWidget(context: context, exception: exception!);

        if (value != null) {
          final double minSizeImage = min(value.size.width, value.size.height);
          if (widget.size > minSizeImage) {
            sizeRenderer = minSizeImage;
          }
        }

        return Stack(
          children: [
            Visibility(
              visible: value != null,
              replacement: Center(
                child: widget.placeholder ??
                    Container(
                      width: sizeRenderer,
                      height: sizeRenderer,
                      decoration: BoxDecoration(
                        borderRadius: widget.borderRadius,
                        color: Colors.grey.shade400,
                      ),
                    ),
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: widget.borderRadius ?? BorderRadius.circular(0),
                  child: SizedBox(
                    height: sizeRenderer,
                    width: sizeRenderer,
                    child: FittedBox(
                      fit: BoxFit.none,
                      child: SizedBox(
                        width: value?.size.width,
                        height: value?.size.height,
                        child: HtmlElementView(viewType: value?.webId ?? ""),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                width: sizeRenderer,
                height: sizeRenderer,
                padding: const EdgeInsets.all(16),
                child: TargetCamera(color: widget.targetColor),
              ),
            ),
            Center(
              child: ClipPath(
                //This [ValueKey] is necessary, in case the [sizeRenderer] changes, build the widget again.
                key: ValueKey(sizeRenderer),
                clipper: ClipperCamera(sizeRect: sizeRenderer),
                child: Container(color: Colors.white),
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
