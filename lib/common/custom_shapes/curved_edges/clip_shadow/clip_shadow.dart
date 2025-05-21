import 'package:flutter/material.dart';

class ClipShadowPainter extends CustomPainter { 
  final Shadow shadow;
  final CustomClipper<Path> clipper;

  ClipShadowPainter({required this.clipper, required this.shadow});
  
  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();

    var clipPath = clipper.getClip(size).shift(shadow.offset);
    canvas.drawPath(clipPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}