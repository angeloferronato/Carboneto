import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ChartPainter extends CustomPainter {
  ChartPainter({
    required this.data,
    required this.labels,
    required this.metric,
    required this.isDark,
    required this.benchmarkValue,
    this.selectedIndex,
  });

  final List<double> data;
  final List<String> labels;
  final ChartMetric metric;
  final bool isDark;
  final int? selectedIndex;
  final double benchmarkValue;

  static const double _pLeft = 12;
  static const double _pRight = 52;
  static const double _pTop = 20;
  static const double _pBottom = 44;

  static const Color _lineColor = CbColors.primary;
  static const Color _fillTop = Color(0x554477FF);
  static const Color _fillBottom = Color(0x004477FF);
  static const Color _barColor = CbColors.primary;
  static const Color _benchmarkColor = Color(0xFFFF9500);

  @override
  void paint(Canvas canvas, Size size) {
    final len = data.length;
    if (len < 2) return;

    final chartW = size.width - _pLeft - _pRight;
    final chartH = size.height - _pTop - _pBottom;
    final chartBottom = _pTop + chartH;

    final labelColor = (isDark ? Colors.white : Colors.black)
        .withValues(alpha: 0.40);

    final labelStyle =
        TextStyle(fontSize: 11, color: labelColor, height: 1);

    double minRaw = data.first;
    double maxRaw = data.first;

    for (int i = 1; i < len; i++) {
      final v = data[i];
      if (v < minRaw) minRaw = v;
      if (v > maxRaw) maxRaw = v;
    }

    double minVal, maxVal;
    if (metric == ChartMetric.acerto) {
      minVal = 0;
      maxVal = 100;
    } else {
      final pad = (maxRaw - minRaw) * 0.20;
      minVal = (minRaw - pad).clamp(0.0, double.infinity);
      maxVal = maxRaw + pad;
      if (maxVal == minVal) maxVal = minVal + 1;
    }

    final range = maxVal - minVal;
    final invRange = 1 / range;

    double toY(double v) =>
        _pTop + chartH * (1 - ((v - minVal) * invRange).clamp(0.0, 1.0));

    double toX(int i) => _pLeft + (i / (len - 1)) * chartW;

    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black)
          .withValues(alpha: 0.07)
      ..strokeWidth = 1;

    const gridLines = 4;
    for (int t = 0; t <= gridLines; t++) {
      final v = minVal + range * (t / gridLines);
      final y = toY(v);

      canvas.drawLine(
        Offset(_pLeft, y),
        Offset(_pLeft + chartW, y),
        gridPaint,
      );

      _drawText(
        canvas,
        _formatYLabel(v),
        Offset(_pLeft + chartW + 6, y - 7),
        labelStyle,
        width: 48,
      );
    }

    canvas.drawLine(
      Offset(_pLeft, chartBottom),
      Offset(_pLeft + chartW, chartBottom),
      Paint()
        ..color = (isDark ? Colors.white : Colors.black)
            .withValues(alpha: 0.10)
        ..strokeWidth = 1,
    );

    if (metric.isBar) {
      _drawBars(canvas, chartW, chartBottom, toY, labelStyle);
    } else {
      _drawLine(canvas, chartW, chartH, chartBottom, toX, toY);
    }

    final maxXLabels = len.clamp(1, 7);
    final step = (len - 1) / (maxXLabels - 1);

    for (int i = 0; i < maxXLabels; i++) {
      final di = (i * step).round();
      if (di >= labels.length) continue;

      final x = metric.isBar
          ? _pLeft + (chartW / len) * di + (chartW / len) / 2
          : toX(di);

      _drawText(
        canvas,
        labels[di],
        Offset(x, chartBottom + 10),
        labelStyle,
        align: TextAlign.center,
        width: 36,
      );
    }

    // if (metric == ChartMetric.acerto) {
    //   final y = toY(benchmarkValue);

    //   _drawDashedLine(
    //     canvas,
    //     Offset(_pLeft, y),
    //     Offset(_pLeft + chartW, y),
    //     Paint()
    //       ..color = _benchmarkColor.withValues(alpha: 0.75)
    //       ..strokeWidth = 1.5,
    //   );

    //   _drawText(
    //     canvas,
    //     'GLOBAL%',
    //     Offset(_pLeft + chartW - 50, y - 14),
    //     TextStyle(
    //       fontSize: 10,
    //       color: _benchmarkColor.withValues(alpha: 0.85),
    //       fontWeight: FontWeight.w600,
    //       height: 1,
    //     ),
    //     width: 100,
    //   );
    // }

    if (!metric.isBar &&
        selectedIndex != null &&
        selectedIndex! < len) {
      final x = toX(selectedIndex!);
      final y = toY(data[selectedIndex!]);

      canvas.drawCircle(Offset(x, y), 5, Paint()..color = _lineColor);
      canvas.drawCircle(Offset(x, y), 3, Paint()..color = Colors.white);
    }
  }

  void _drawBars(Canvas canvas, double chartW, double chartBottom,
      double Function(double) toY, TextStyle labelStyle) {
    final len = data.length;
    if (len == 0) return;

    final barW = chartW / len;
    const pad = 4.0;

    for (int i = 0; i < len; i++) {
      final x = _pLeft + i * barW + pad / 2;
      final top = toY(data[i]);
      final selected = selectedIndex == i;

      final rect = RRect.fromRectAndCorners(
        Rect.fromLTRB(x, top, x + barW - pad, chartBottom),
        topLeft: const Radius.circular(4),
        topRight: const Radius.circular(4),
      );

      canvas.drawRRect(
        rect,
        Paint()
          ..shader = ui.Gradient.linear(
            Offset(x, top),
            Offset(x, chartBottom),
            [
              _barColor.withValues(alpha: selected ? 1 : 0.85),
              _barColor.withValues(alpha: 0.40),
            ],
          ),
      );

      _drawText(
        canvas,
        _formatYLabel(data[i]),
        Offset(x + (barW - pad) / 2, top - 16),
        TextStyle(
          fontSize: 10,
          color: selected
              ? _barColor
              : (isDark
                  ? Colors.white.withValues(alpha: 0.55)
                  : Colors.black.withValues(alpha: 0.55)),
          fontWeight:
              selected ? FontWeight.w700 : FontWeight.w500,
          height: 1,
        ),
        align: TextAlign.center,
        width: barW,
      );
    }
  }

  void _drawLine(
      Canvas canvas,
      double chartW,
      double chartH,
      double chartBottom,
      double Function(int) toX,
      double Function(double) toY) {
    final len = data.length;

    final path = Path();
    final fill = Path();

    final firstX = toX(0);
    final firstY = toY(data[0]);

    path.moveTo(firstX, firstY);
    fill.moveTo(firstX, chartBottom);
    fill.lineTo(firstX, firstY);

    for (int i = 1; i < len; i++) {
      final x = toX(i);
      final y = toY(data[i]);
      path.lineTo(x, y);
      fill.lineTo(x, y);
    }

    fill.lineTo(toX(len - 1), chartBottom);
    fill.close();

    canvas.drawPath(
      fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [_fillTop, _fillBottom],
        ).createShader(
          Rect.fromLTWH(_pLeft, _pTop, chartW, chartH),
        ),
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = _lineColor
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );

    for (int i = 0; i < len; i++) {
      if (i == selectedIndex) continue;
      canvas.drawCircle(
        Offset(toX(i), toY(data[i])),
        3,
        Paint()..color = _lineColor.withValues(alpha: 0.7),
      );
    }
  }

  String _formatYLabel(double v) => switch (metric) {
        ChartMetric.acerto => '${v.toStringAsFixed(0)}%',
        ChartMetric.duracao => '${v.toStringAsFixed(0)}m',
        ChartMetric.frequencia => v.toStringAsFixed(0),
      };

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint,
      {double dash = 6, double gap = 4}) {
    final dist = (end - start).distance;
    if (dist == 0) return;

    final dx = (end.dx - start.dx) / dist;
    final dy = (end.dy - start.dy) / dist;

    double traveled = 0;
    while (traveled < dist) {
      final next = (traveled + dash).clamp(0, dist);
      canvas.drawLine(
        Offset(start.dx + dx * traveled, start.dy + dy * traveled),
        Offset(start.dx + dx * next, start.dy + dy * next),
        paint,
      );
      traveled += dash + gap;
    }
  }

  void _drawText(Canvas canvas, String text, Offset offset, TextStyle style,
      {TextAlign align = TextAlign.left, double width = 60}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textAlign: align,
    )..layout(maxWidth: width);

    final dx = align == TextAlign.center
        ? offset.dx - tp.width / 2
        : offset.dx;

    tp.paint(canvas, Offset(dx, offset.dy));
  }

  @override
  bool shouldRepaint(covariant ChartPainter old) =>
      old.data != data ||
      old.metric != metric ||
      old.isDark != isDark ||
      old.selectedIndex != selectedIndex ||
      old.benchmarkValue != benchmarkValue;
}