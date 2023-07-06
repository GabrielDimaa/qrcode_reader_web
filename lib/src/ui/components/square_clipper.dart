import 'package:flutter/rendering.dart';

class SquareClipper extends CustomClipper<Path> {
  final double squareSize;

  SquareClipper(this.squareSize);

  @override
  Path getClip(Size size) {
    final Path path = Path();
    final double offsetX = (size.width - squareSize) / 2;
    final double offsetY = (size.height - squareSize) / 2;

    final cropRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(offsetX, offsetY, squareSize, squareSize),
      const Radius.circular(16),
    );

    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    path.addRRect(cropRect);
    path.fillType = PathFillType.evenOdd;

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
