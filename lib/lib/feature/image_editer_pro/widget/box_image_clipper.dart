import 'package:flutter/material.dart';

class BoxImageClipper extends CustomClipper<Path> {
  final Size sizeOfBoxImage;
  final Offset offsetOfBoxImage;
  final double statusBarValue;

  BoxImageClipper(this.sizeOfBoxImage, this.offsetOfBoxImage, this.statusBarValue);

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(offsetOfBoxImage.dx, offsetOfBoxImage.dy-statusBarValue);
    path.lineTo(offsetOfBoxImage.dx, offsetOfBoxImage.dy+sizeOfBoxImage.height-statusBarValue);
    path.lineTo(offsetOfBoxImage.dx+sizeOfBoxImage.width, offsetOfBoxImage.dy+sizeOfBoxImage.height-statusBarValue);
    path.lineTo(offsetOfBoxImage.dx+sizeOfBoxImage.width, offsetOfBoxImage.dy-statusBarValue);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(BoxImageClipper oldClipper) => false;
}