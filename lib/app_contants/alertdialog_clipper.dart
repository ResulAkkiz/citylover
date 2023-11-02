import 'package:flutter/material.dart';

class AlertDialogClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double radius = 20;
    path.moveTo(50, 50);
    path.lineTo(size.width - 50, 50);
    path.lineTo(size.width - 50, size.height / 2);
    path.lineTo(50, size.height / 2);
    path.lineTo(50, 50);

    path.moveTo(size.width / 2 - radius, 50);
    path.arcToPoint(
      Offset(size.width / 2 + radius, 50),
      radius: Radius.circular(radius),
    );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
