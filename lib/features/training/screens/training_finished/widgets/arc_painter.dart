import 'dart:math';

import 'package:flutter/material.dart';

class ArcPainter extends CustomPainter {
  const ArcPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.glowColor,
  });

  final double progress;
  final Color  trackColor;
  final Color  progressColor;
  final Color  glowColor;

  static const double _startAngle = pi * 0.75;
  static const double _sweepAngle = pi * 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 14;
    final rect   = Rect.fromCircle(center: center, radius: radius);

    canvas.drawArc(rect, _startAngle, _sweepAngle, false, Paint()
      ..color       = trackColor
      ..style       = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap   = StrokeCap.round);

    if (progress <= 0.001) return;

    final sweep = _sweepAngle * progress;

    canvas.drawArc(rect, _startAngle, sweep, false, Paint()
      ..color       = glowColor
      ..style       = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap   = StrokeCap.round
      ..maskFilter  = const MaskFilter.blur(BlurStyle.normal, 8));

    canvas.drawArc(rect, _startAngle, sweep, false, Paint()
      ..color       = progressColor
      ..style       = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap   = StrokeCap.round);

    final tipAngle = _startAngle + sweep;
    canvas.drawCircle(
      Offset(center.dx + radius * cos(tipAngle), center.dy + radius * sin(tipAngle)),
      5,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(ArcPainter old) => old.progress != progress;
}