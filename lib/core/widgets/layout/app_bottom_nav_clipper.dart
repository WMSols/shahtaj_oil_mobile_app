import 'package:flutter/material.dart';

class AppBottomNavClipper extends CustomClipper<Path> {
  AppBottomNavClipper({
    required this.cornerRadius,
    required this.notchWidth,
    required this.notchDepth,
  });

  final double cornerRadius;
  final double notchWidth;
  final double notchDepth;

  @override
  Path getClip(Size size) {
    final path = Path();
    final centerX = size.width / 2;
    final notchStart = centerX - notchWidth / 2;
    final notchEnd = centerX + notchWidth / 2;

    path.moveTo(0, size.height);
    path.lineTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);
    path.lineTo(notchStart, 0);
    path.quadraticBezierTo(centerX, notchDepth, notchEnd, 0);
    path.lineTo(size.width - cornerRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);
    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant AppBottomNavClipper oldClipper) {
    return oldClipper.cornerRadius != cornerRadius ||
        oldClipper.notchWidth != notchWidth ||
        oldClipper.notchDepth != notchDepth;
  }
}
