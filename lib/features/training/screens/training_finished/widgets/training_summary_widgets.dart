// features/training/widgets/training_summary_widgets.dart

import 'package:carboneto/features/library/models/history_model.dart';
import 'package:carboneto/features/training/screens/training_finished/widgets/arc_painter.dart';
import 'package:carboneto/features/training/screens/training_finished/widgets/exercise_badge.dart';
import 'package:carboneto/features/training/screens/training_finished/widgets/ring.dart';
import 'package:carboneto/features/training/screens/training_finished/widgets/stat_tile.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

// ── Shared data classes ────────────────────────────────────────────────────

class StatData {
  const StatData({required this.label, required this.value, required this.icon, this.accent});
  final String label;
  final String value;
  final IconData icon;
  final Color? accent;
}

class ThemeColors {
  const ThemeColors(this.isDark);
  final bool isDark;

  Color get bg            => isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF0F0F3);
  Color get surface       => isDark ? const Color(0xFF161616) : Colors.white;
  Color get onSurface     => isDark ? Colors.white            : const Color(0xFF0D0D0D);
  Color get subtle        => isDark ? Colors.white38          : Colors.black38;
  Color get chipBg        => isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.05);
  Color get arcTrack      => isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.07);
  Color get progressTrack => isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.07);
  Color get divider       => isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.05);
  Color get cardShadow    => Colors.black.withValues(alpha: isDark ? 0.35 : 0.06);
}

// ── Decorative rings ───────────────────────────────────────────────────────

class TrainingSummaryRings extends StatelessWidget {
  const TrainingSummaryRings({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Positioned(top: -80, right: -80, child: Ring(size: 300, color: CbColors.primary, opacity: 0.06)),
      Positioned(top: 60,  right: -40, child: Ring(size: 140, color: CbColors.primary, opacity: 0.09)),
    ]);
  }
}

// ── Arc hero ───────────────────────────────────────────────────────────────

class TrainingSummaryArc extends StatelessWidget {
  const TrainingSummaryArc({
    super.key,
    required this.colors,
    required this.arcProgress,
    required this.size,
    required this.fontSize,
  });

  final ThemeColors colors;
  final Animation<double> arcProgress;
  final double size;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: arcProgress,
      builder: (_, __) => SizedBox(
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: size, height: size,
              child: CustomPaint(
                painter: ArcPainter(
                  progress: arcProgress.value,
                  trackColor: colors.arcTrack,
                  progressColor: CbColors.primary,
                  glowColor: CbColors.primary.withValues(alpha: 0.4),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(arcProgress.value * 100).round()}%',
                  style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w900,
                      color: colors.onSurface,
                      letterSpacing: -2,
                      height: 1.0),
                ),
                const SizedBox(height: 4),
                Text('conclusão',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colors.subtle,
                        letterSpacing: 0.8)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stat strip ─────────────────────────────────────────────────────────────

class TrainingSummaryStatStrip extends StatelessWidget {
  const TrainingSummaryStatStrip({
    super.key,
    required this.colors,
    required this.items,
    this.staggerAnimation,
  });

  final ThemeColors colors;
  final List<StatData> items;
  final Animation<double>? staggerAnimation;

  @override
  Widget build(BuildContext context) {
    if (staggerAnimation != null) {
      return AnimatedBuilder(
        animation: staggerAnimation!,
        builder: (_, __) => _buildRow(),
      );
    }
    return _buildRow();
  }

  Widget _buildRow() {
    return Row(
      children: items.asMap().entries.map((e) {
        double opacity = 1.0;
        double slideY  = 0.0;

        if (staggerAnimation != null) {
          final delay = e.key * 0.15;
          final t     = ((staggerAnimation!.value - delay) / (1.0 - delay)).clamp(0.0, 1.0);
          final curve = Curves.easeOutBack.transform(t);
          opacity = t;
          slideY  = 30 * (1 - curve);
        }

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: e.key < items.length - 1 ? 10 : 0),
            child: Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(0, slideY),
                child: SummaryStatTile(data: e.value, colors: colors),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Exercise breakdown ─────────────────────────────────────────────────────

class TrainingSummaryBreakdown extends StatelessWidget {
  const TrainingSummaryBreakdown({
    super.key,
    required this.colors,
    required this.exercises,
    this.headerTrailing,
    this.slideAnimation,
  });

  final ThemeColors colors;

  /// Each entry: { 'name', 'type', 'progress' (0-1), 'detail' }
  final List<ExerciseRowData> exercises;
  final Widget? headerTrailing;
  final Animation<double>? slideAnimation;

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: colors.cardShadow, blurRadius: 24, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
            child: Row(
              children: [
                Text('Exercícios',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: colors.onSurface,
                        letterSpacing: -0.3)),
                const Spacer(),
                if (headerTrailing != null) headerTrailing!,
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...exercises.asMap().entries.map((entry) {
            final i  = entry.key;
            final ex = entry.value;
            final isLast = i == exercises.length - 1;
            final rowColor = ex.isComplete ? CbColors.primary : Colors.orange;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                  child: Row(
                    children: [
                      ExerciseBadge(index: i, isComplete: ex.isComplete, colors: colors),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ex.name,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: colors.onSurface),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: ex.progress,
                                minHeight: 3,
                                backgroundColor: colors.progressTrack,
                                valueColor: AlwaysStoppedAnimation<Color>(rowColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(ex.detail,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: rowColor)),
                    ],
                  ),
                ),
                if (!isLast)
                  Divider(height: 1, indent: 66, endIndent: 20, color: colors.divider),
              ],
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );

    if (slideAnimation != null) {
      return AnimatedBuilder(
        animation: slideAnimation!,
        builder: (_, c) => Opacity(
          opacity: Curves.easeOut.transform(slideAnimation!.value.clamp(0.0, 1.0)),
          child: Transform.translate(
              offset: Offset(0, 20 * (1 - slideAnimation!.value)), child: c),
        ),
        child: child,
      );
    }

    return child;
  }
}

// ── Row data model ─────────────────────────────────────────────────────────

class ExerciseRowData {
  const ExerciseRowData({
    required this.name,
    required this.progress,
    required this.detail,
    required this.isComplete,
  });

  final String name;
  final double progress;
  final String detail;
  final bool isComplete;

  /// Build from TrainingFinishedScreen's perExercise map entry
  static ExerciseRowData fromStatsMap(String name, Map<String, dynamic> data) {
    String detail   = '—';
    double progress = 1.0;

    switch (data['Type']) {
      case 'reps':
        final done  = (data['Done']  as int?) ?? 0;
        final total = (data['Total'] as int?) ?? 1;
        detail   = '$done/$total reps';
        progress = total > 0 ? (done / total).clamp(0.0, 1.0) : 1.0;
      case 'time':
        final total     = (data['Total']     as int?) ?? 0;
        final remaining = (data['Remaining'] as int?) ?? 0;
        final done      = total - remaining;
        final tm        = (total ~/ 60).toString().padLeft(2, '0');
        detail   = '${_fmt(done)} / ${tm}m';
        progress = total > 0 ? (done / total).clamp(0.0, 1.0) : 1.0;
      default:
        detail = 'Livre';
    }

    return ExerciseRowData(
      name: name,
      progress: progress,
      detail: detail,
      isComplete: progress >= 1.0,
    );
  }

  /// Build from ExerciseProgress (history sheet)
  static ExerciseRowData fromExerciseProgress(ExerciseProgress ex) {
    String detail;
    double progress;

    if (ex.type == 'reps') {
      detail   = '${ex.done}/${ex.total} reps';
      progress = ex.total > 0 ? (ex.done / ex.total).clamp(0.0, 1.0) : 0.0;
    } else {
      final done = ex.total - ex.remaining;
      final tm   = (ex.total ~/ 60).toString().padLeft(2, '0');
      detail   = '${_fmt(done)} / ${tm}m';
      progress = ex.total > 0 ? (done / ex.total).clamp(0.0, 1.0) : 0.0;
    }

    return ExerciseRowData(
      name: ex.name,
      progress: progress,
      detail: detail,
      isComplete: ex.isCompleted,
    );
  }

  static String _fmt(int seconds) =>
      '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
}