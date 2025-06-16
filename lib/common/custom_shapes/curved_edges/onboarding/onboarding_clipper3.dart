import 'package:flutter/material.dart';

class OnboardingClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 170);

    final firstCurve = Offset((size.width - 30) / 2, 190);
    final lastCurve = Offset(size.width, 60);
    path.quadraticBezierTo(firstCurve.dx, firstCurve.dy, lastCurve.dx, lastCurve.dy);

    path.lineTo(size.width, size.height / 2  + 140);

    final secondFirstCurve = Offset(size.width / 2, size.height / 2 + 40);
    final secondLastCurve = Offset(0, size.height / 2 + 70);
    path.quadraticBezierTo(secondFirstCurve.dx, secondFirstCurve.dy, secondLastCurve.dx, secondLastCurve.dy);

    path.lineTo(0, 300);
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}