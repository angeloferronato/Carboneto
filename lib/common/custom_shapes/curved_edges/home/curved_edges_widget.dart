import 'package:carboneto/common/custom_shapes/curved_edges/clip_shadow/clip_shadow.dart';
import 'package:flutter/material.dart';

class CurvedEdgesWidget extends StatelessWidget {
  const CurvedEdgesWidget ({super.key, this.child, required this.shadow, required this.clipper});

  final Shadow shadow;
  final CustomClipper<Path> clipper;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ClipShadowPainter(clipper: clipper, shadow: shadow),
      child: ClipPath(clipper: clipper, child: child,),
    );
  }
}