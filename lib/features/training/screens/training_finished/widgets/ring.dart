import 'package:flutter/material.dart';

class Ring extends StatelessWidget {
  const Ring({required this.size, required this.color, required this.opacity});
  final double size;
  final Color  color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: opacity), width: 1.5),
      ),
    );
  }
}