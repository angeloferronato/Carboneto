import 'package:carboneto/features/library/models/history_model.dart';
import 'package:carboneto/features/training/screens/training_finished/widgets/arc_painter.dart';
import 'package:carboneto/features/training/screens/training_finished/widgets/exercise_badge.dart';
import 'package:carboneto/features/training/screens/training_finished/widgets/stat_tile.dart';
import 'package:carboneto/features/training/screens/training_finished/widgets/training_summary_widgets.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class TrainingSummarySheet extends StatefulWidget {
  const TrainingSummarySheet(
      {super.key, required this.training, required this.isDark});
  final TrainingHistoryModel training;
  final bool isDark;

  @override
  State<TrainingSummarySheet> createState() => _TrainingSummarySheetState();
}

class _TrainingSummarySheetState extends State<TrainingSummarySheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _arcCtrl;
  late final Animation<double> _arcProgress;

  double get _completionRate =>
      (widget.training.trainingProgress / 100).clamp(0.0, 1.0);

  String get _elapsedFormatted {
    final s = widget.training.trainingDuration;
    final h = s ~/ 3600;
    final m = ((s % 3600) ~/ 60).toString().padLeft(2, '0');
    final sec = (s % 60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$sec' : '$m:$sec';
  }

  @override
  void initState() {
    super.initState();
    _arcCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _arcProgress = Tween<double>(begin: 0.0, end: _completionRate).animate(
      CurvedAnimation(parent: _arcCtrl, curve: Curves.easeOutCubic),
    );
    Future.delayed(const Duration(milliseconds: 150), () => _arcCtrl.forward());
  }

  @override
  void dispose() {
    _arcCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ThemeColors(widget.isDark);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: colors.bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.subtle.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(colors),
                    const SizedBox(height: 24),
                    _buildArcHero(colors),
                    const SizedBox(height: 24),
                    _buildStatStrip(colors),
                    const SizedBox(height: 20),
                    _buildBreakdown(colors),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeColors colors) {
    final date = widget.training.sessionEndedAt;
    final dateLabel = date != null
        ? '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}'
        : '';

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateLabel,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: CbColors.primary,
                    letterSpacing: 1.2),
              ),
              const SizedBox(height: 4),
              Text(
                widget.training.title,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: colors.onSurface,
                    letterSpacing: -0.6,
                    height: 1.1),
              ),
            ],
          ),
        ),
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: CbColors.primary.withValues(alpha: 0.12),
          ),
          child: Icon(Icons.local_fire_department_rounded,
              color: CbColors.primary, size: 24),
        ),
      ],
    );
  }

  Widget _buildArcHero(ThemeColors colors) {
    return AnimatedBuilder(
      animation: _arcCtrl,
      builder: (_, __) => SizedBox(
        height: 180,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 180,
              height: 180,
              child: CustomPaint(
                painter: ArcPainter(
                  progress: _arcProgress.value,
                  trackColor: colors.arcTrack,
                  progressColor: CbColors.primary,
                  glowColor: CbColors.primary.withValues(alpha: 0.35),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${(_arcProgress.value * 100).round()}%',
                  style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      color: colors.onSurface,
                      letterSpacing: -2,
                      height: 1.0),
                ),
                const SizedBox(height: 4),
                Text('conclusão',
                    style: TextStyle(
                        fontSize: 11,
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

  Widget _buildStatStrip(ThemeColors colors) {
    double trainingPct = 0;
    if (widget.training.trainingType == 'reps') {
      for (final exercise in widget.training.perExercise) {
        if (exercise.type == 'reps') {
          if (exercise.done > 0) {
            trainingPct += exercise.total / exercise.done;
          }
        }
      }
    }
    final items = [
      StatData(
          label: 'Duração',
          value: _elapsedFormatted,
          icon: Icons.timer_rounded),
      StatData(
          label: 'Exercícios',
          value: '${widget.training.perExercise.length}',
          icon: Icons.fitness_center_rounded),
    ];

    if (trainingPct > 0) {
      items.add(StatData(
          label: 'Eficiência',
          value: '${(trainingPct * 100).toStringAsFixed(0)}%',
          icon: Icons.percent_rounded,
          accent: trainingPct >= 0.5 ? CbColors.success : CbColors.warning));
    }

    return Row(
      children: items.asMap().entries.map((e) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: e.key < items.length - 1 ? 10 : 0),
            child: SummaryStatTile(data: e.value, colors: colors),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBreakdown(ThemeColors colors) {
    final exercises = widget.training.perExercise;
    if (exercises.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
              color: colors.cardShadow,
              blurRadius: 24,
              offset: const Offset(0, 6))
        ],
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
                Text('${exercises.length} exercícios',
                    style: TextStyle(
                        fontSize: 12,
                        color: CbColors.primary,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ...exercises.asMap().entries.map((entry) {
            final i = entry.key;
            final ex = entry.value; // ExerciseProgress
            final isLast = i == exercises.length - 1;

            String detail;
            double progress;

            if (ex.type == 'reps') {
              final pct = ex.done > 0 ? (ex.total / ex.done) : 0.0;
              detail =
                  '${ex.done}/${ex.total} | ${(pct * 100).toStringAsFixed(0)}%';
              progress = ex.total > 0 ? (ex.done / ex.total).clamp(0.0, 1.0) : 0.0;
            } else {
              final done = ex.total - ex.remaining;
              final tm = (ex.total ~/ 60).toString().padLeft(2, '0');
              detail = '${_fmt(done)} / ${tm}m';
              progress = ex.total > 0 ? (done / ex.total).clamp(0.0, 1.0) : 0.0;
            }

            final isComplete = ex.isCompleted;
            final rowColor = isComplete ? CbColors.primary : Colors.orange;


            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                  child: Row(
                    children: [
                      ExerciseBadge(
                          index: i, isComplete: isComplete, colors: colors),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ex.name,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: colors.onSurface),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 3,
                                backgroundColor: colors.progressTrack,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(rowColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(detail,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: rowColor)),
                    ],
                  ),
                ),
                if (!isLast)
                  Divider(
                      height: 1,
                      indent: 66,
                      endIndent: 20,
                      color: colors.divider),
              ],
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  String _fmt(int seconds) =>
      '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
}
