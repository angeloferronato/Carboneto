import 'package:carboneto/features/personalization/screens/profile/profile_panel/widgets/chart_painter.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:flutter/material.dart';

class ChartCard extends StatefulWidget {
  const ChartCard({
    super.key,
    required this.data,
    required this.labels,
    required this.metric,
    required this.isDark,
  });

  final List<double> data;
  final List<String> labels;
  final ChartMetric metric;
  final bool isDark;

  @override
  State<ChartCard> createState() => _ChartCardState();
}

class _ChartCardState extends State<ChartCard> {
  int? _selectedIndex;
  Offset? _tooltipOffset;

  static const double _pLeft = 12;
  static const double _pRight = 52;
  static const double _pTop = 20;
  static const double _pBottom = 44;

  int? _indexFromOffset(Offset local, Size size) {
    if (widget.data.isEmpty) return null;
    final chartW = size.width - _pLeft - _pRight;
    final chartH = size.height - _pTop - _pBottom;

    if (local.dx < _pLeft || local.dx > _pLeft + chartW) return null;
    if (local.dy < _pTop || local.dy > _pTop + chartH + _pBottom) return null;

    if (widget.metric.isBar) {
      final barW = chartW / widget.data.length;
      final idx = ((local.dx - _pLeft) / barW).floor();
      return idx.clamp(0, widget.data.length - 1);
    } else {
      // Snap to nearest point on line
      int nearest = 0;
      double minDist = double.infinity;
      for (int i = 0; i < widget.data.length; i++) {
        final x = _pLeft + (i / (widget.data.length - 1)) * chartW;
        final dist = (local.dx - x).abs();
        if (dist < minDist) {
          minDist = dist;
          nearest = i;
        }
      }
      return nearest;
    }
  }

  @override
  void didUpdateWidget(ChartCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the metric changes or the data length changes, clear the tooltip!
    if (oldWidget.metric != widget.metric || oldWidget.data.length != widget.data.length) {
      _selectedIndex = null;
      _tooltipOffset = null;
    }
  }

  void _onTapDown(TapDownDetails d, Size size) {
    final idx = _indexFromOffset(d.localPosition, size);
    if (idx == null) return;
    setState(() {
      if (_selectedIndex == idx) {
        _selectedIndex = null;
        _tooltipOffset = null;
      } else {
        _selectedIndex = idx;
        _tooltipOffset = d.localPosition;
      }
    });
  }

  String _tooltipText(int index) {
    final v = widget.data[index];
    final label = index < widget.labels.length ? widget.labels[index] : '';
    final formatted = switch (widget.metric) {
      ChartMetric.acerto => '${v.toStringAsFixed(1)}%',
      ChartMetric.duracao => '${v.toStringAsFixed(0)} min',
      ChartMetric.frequencia => '${v.toStringAsFixed(0)} treinos',
    };
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const height = 220.0;
        final size = Size(constraints.maxWidth, height);

        return GestureDetector(
          onTapDown: (d) => _onTapDown(d, size),
          onTapCancel: () => setState(() {
            _selectedIndex = null;
            _tooltipOffset = null;
          }),
          child: SizedBox(
            height: height,
            child: Stack(
              children: [
                CustomPaint(
                  painter: ChartPainter(
                    benchmarkValue: 48.0,
                    data: widget.data,
                    labels: widget.labels,
                    metric: widget.metric,
                    isDark: widget.isDark,
                    selectedIndex: _selectedIndex,
                  ),
                  child: const SizedBox.expand(),
                ),
                if (_selectedIndex != null && _tooltipOffset != null)
                  _Tooltip(
                    text: _tooltipText(_selectedIndex!),
                    position: _tooltipOffset!,
                    isDark: widget.isDark,
                    chartWidth: constraints.maxWidth,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}


class _Tooltip extends StatelessWidget {
  const _Tooltip({
    required this.text,
    required this.position,
    required this.isDark,
    required this.chartWidth,
  });

  final String text;
  final Offset position;
  final bool isDark;
  final double chartWidth;

  @override
  Widget build(BuildContext context) {
    const tooltipW = 80.0;
    const tooltipH = 32.0;
    const vOffset = 14.0;

    double left = position.dx - tooltipW / 2;
    left = left.clamp(4.0, chartWidth - tooltipW - 4);
    final top = (position.dy - tooltipH - vOffset).clamp(2.0, double.infinity);

    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: tooltipW,
        height: tooltipH,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color.fromARGB(87, 70, 123, 184), Color.fromARGB(143, 21, 46, 66)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xFF223142),
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white, 
          ),
        ),
      ),
    );
  }
}