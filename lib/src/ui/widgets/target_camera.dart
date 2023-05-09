import 'package:flutter/material.dart';
import 'dart:math';

class TargetCamera extends StatelessWidget {
  final Color? color;

  const TargetCamera({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: _shape(),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Transform.rotate(
            angle: pi / 2,
            child: _shape(),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Transform.rotate(
            angle: -pi / 2,
            child: _shape(),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Transform.rotate(
            angle: -pi / 1,
            child: _shape(),
          ),
        ),
      ],
    );
  }

  Widget _shape() {
    return SizedBox(
      width: 40,
      height: 40,
      child: CustomPaint(
        painter: LShapePainter(color),
      ),
    );
  }
}

class LShapePainter extends CustomPainter {
  final Color? color;

  LShapePainter(this.color);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color ?? Colors.white
      ..strokeWidth = 2;

    canvas.drawLine(const Offset(0, -1), Offset(0, size.height), paint);
    canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), paint);
  }
}
