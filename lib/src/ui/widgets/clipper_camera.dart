import 'package:flutter/material.dart';

class ClipperCamera extends CustomClipper<Path> {
  final double sizeRect;

  ClipperCamera({required this.sizeRect});

  @override
  Path getClip(Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);

    final double left = center.dx - (sizeRect / 2);
    final double top = center.dy - (sizeRect / 2);

    final Rect rect = Rect.fromLTRB(left, top, left + sizeRect, top + sizeRect);

    final Path path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(rect)
      ..fillType = PathFillType.evenOdd;

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
