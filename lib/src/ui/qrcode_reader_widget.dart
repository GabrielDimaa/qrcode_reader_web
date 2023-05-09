import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../exceptions/qrcode_reader_exception.dart';
import '../objects/qrcode_capture.dart';
import '../objects/start_arguments.dart';
import 'qrcode_reader_controller.dart';
import 'widgets/clipper_camera.dart';
import 'widgets/target_camera.dart';

/// The function signature for the error builder.
typedef MobileScannerErrorBuilder = Widget Function(
  BuildContext,
  QRCodeReaderException,
  Widget?,
);

class QRCodeReaderWidget extends StatefulWidget {
  final void Function(QRCodeCapture barcodes) onDetect;
  final double size;
  final Color? targetColor;
  final MobileScannerErrorBuilder? errorBuilder;
  final Widget Function(BuildContext, Widget?)? placeholderBuilder;

  const QRCodeReaderWidget({
    super.key,
    required this.onDetect,
    required this.size,
    this.targetColor,
    this.errorBuilder,
    this.placeholderBuilder,
  });

  @override
  State<QRCodeReaderWidget> createState() => _QRCodeReaderWidgetState();
}

class _QRCodeReaderWidgetState extends State<QRCodeReaderWidget> {
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

  Widget _buildPlaceholderOrError(BuildContext context, Widget? child) {
    final QRCodeReaderException? error = exception;

    if (error != null) {
      return widget.errorBuilder?.call(context, error, child) ?? const ColoredBox(color: Colors.black, child: Center(child: Icon(Icons.error, color: Colors.white)));
    }

    return widget.placeholderBuilder?.call(context, child) ?? const ColoredBox(color: Colors.black);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<StartArguments?>(
      valueListenable: controller.startArguments,
      builder: (context, value, child) {
        double sizeRenderer = widget.size;

        if (value != null) {
          final double minSizeImage = min(value.size.width, value.size.height);
          if (widget.size > minSizeImage) {
            sizeRenderer = minSizeImage;
          }
        }

        // if (value == null) return Container();

        // return ClipRect(
        //   child: SizedBox(
        //     height: 300,
        //     width: 300,
        //     child: FittedBox(
        //       fit: BoxFit.none,
        //       child: value != null ? SizedBox(
        //         width: value.size.width,
        //         height: value.size.height,
        //         child: HtmlElementView(viewType: value.webId),
        //       ) : Container(color: Colors.grey.shade300),
        //     ),
        //   ),
        // );

        return Stack(
          children: [
            Visibility(
              visible: value != null,
              replacement: Center(
                child: Container(
                  color: Colors.grey.shade400,
                  width: sizeRenderer,
                  height: sizeRenderer,
                ),
              ),
              child: Center(
                child: ClipRect(
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

    // return ValueListenableBuilder<StartArguments?>(
    //   valueListenable: controller.startArguments,
    //   builder: (context, value, child) {
    //     double sizeRenderer = widget.size;
    //
    //     if (value != null) {
    //       final double minSizeImage = min(value.size.width, value.size.height);
    //       if (widget.size > minSizeImage) {
    //         sizeRenderer = minSizeImage;
    //       }
    //     }
    //
    //     return Stack(
    //       children: [
    //         Center(
    //           child: value != null
    //               ? FittedBox(
    //                   fit: BoxFit.cover,
    //                   child: Center(
    //                     child: SizedBox(
    //                       height: value.size.height,
    //                       width: value.size.width,
    //                       child: HtmlElementView(viewType: value.webId),
    //                     ),
    //                   ),
    //                 )
    //               : Container(color: Colors.grey.shade300),
    //         ),
    //         Center(
    //           child: Container(
    //             width: sizeRenderer,
    //             height: sizeRenderer,
    //             padding: const EdgeInsets.all(16),
    //             child: TargetCamera(color: widget.targetColor),
    //           ),
    //         ),
    //         Center(
    //           child: ClipPath(
    //             //This [ValueKey] is necessary, in case the [sizeRenderer] changes, build the widget again.
    //             key: ValueKey(sizeRenderer),
    //             clipper: ClipperCamera(sizeRect: sizeRenderer),
    //             child: Container(color: Colors.white),
    //           ),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  @override
  void dispose() {
    qrCodeSubscription?.cancel();
    controller.dispose();
    super.dispose();
  }
}
