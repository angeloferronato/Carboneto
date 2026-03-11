import 'package:carboneto/common/widgets/buttons/cb_primary_btn.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/create_form.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/features/training/screens/training_finished/widgets/arc_painter.dart';
import 'package:carboneto/features/training/screens/training_finished/widgets/exercise_badge.dart';
import 'package:carboneto/features/training/screens/training_finished/widgets/ring.dart';
import 'package:carboneto/features/training/screens/training_finished/widgets/stat_tile.dart';
import 'package:carboneto/home_menu.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrainingFinishedScreen extends StatefulWidget {
  const TrainingFinishedScreen({
    super.key,
    required this.training,
    required this.stats,
    required this.elapsedSeconds,
  });

  final TrainingModel training;
  final Map<String, dynamic> stats;
  final int elapsedSeconds;

  @override
  State<TrainingFinishedScreen> createState() => _TrainingFinishedScreenState();
}

class _TrainingFinishedScreenState extends State<TrainingFinishedScreen>
    with TickerProviderStateMixin {

  late final AnimationController _entranceCtrl;
  late final AnimationController _arcCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _staggerCtrl;

  late final Animation<double> _fadeIn;
  late final Animation<double> _slideUp;
  late final Animation<double> _pulse;
  late final Animation<double> _arcProgress;

  int _selectedRating = 0;
  final TextEditingController _noteCtrl = TextEditingController();

  Map<String, dynamic> get _perExercise =>
      (widget.stats['PerExercise'] as Map<String, dynamic>?) ?? {};

  String get _trainingType =>
      (widget.stats['TrainingType'] as String?) ?? '';

  String get _elapsedFormatted {
    final h = widget.elapsedSeconds ~/ 3600;
    final m = ((widget.elapsedSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (widget.elapsedSeconds % 60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  int get _totalExercises => widget.training.exercises.length;

  bool get _hasRepsExercises =>
      _trainingType == 'reps' || _trainingType == 'mixed';

  double get _completionRate {
    if (_perExercise.isEmpty) return 1.0;
    double sum = 0;
    for (final v in _perExercise.values) {
      if (v['Type'] == 'reps') {
        final done  = (v['Done']  as int?) ?? 0;
        final total = (v['Total'] as int?) ?? 1;
        sum += total > 0 ? (done / total).clamp(0.0, 1.0) : 1.0;
      } else {
        final total     = (v['Total']     as int?) ?? 0;
        final remaining = (v['Remaining'] as int?) ?? 0;
        sum += total > 0 ? ((total - remaining) / total).clamp(0.0, 1.0) : 1.0;
      }
    }
    return (sum / _perExercise.length).clamp(0.0, 1.0);
  }

  double get _repsEfficiency {
    final repsEx = _perExercise.values.where((v) => v['Type'] == 'reps').toList();
    if (repsEx.isEmpty) return 0;
    double sum = 0;
    for (final v in repsEx) {
      final done     = (v['Done']  as int?) ?? 0;
      final required = (v['Total'] as int?) ?? 1;
      sum += done > 0 ? (required / done).clamp(0.0, 1.0) : 0.0;
    }
    return sum / repsEx.length;
  }

  int get _efficiencyPct {
    final rate = _hasRepsExercises ? _repsEfficiency : _completionRate;
    return (rate * 100).round().clamp(0, 100);
  }

  Color get _efficiencyColor {
    if (_efficiencyPct >= 55) return CbColors.success;
    if (_efficiencyPct >= 40) return CbColors.secondary;
    return CbColors.error;
  }

  @override
  void initState() {
    super.initState();

    _entranceCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _arcCtrl      = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _pulseCtrl    = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200))
      ..repeat(reverse: true);
    _staggerCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));

    _fadeIn = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _slideUp = Tween<double>(begin: 48, end: 0).animate(
      CurvedAnimation(parent: _entranceCtrl, curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic)),
    );
    _pulse = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _arcProgress = Tween<double>(begin: 0.0, end: _completionRate).animate(
      CurvedAnimation(parent: _arcCtrl, curve: Curves.easeOutCubic),
    );

    _entranceCtrl.forward();
    Future.delayed(const Duration(milliseconds: 300), () { if (mounted) _arcCtrl.forward(); });
    Future.delayed(const Duration(milliseconds: 500), () { if (mounted) _staggerCtrl.forward(); });
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _arcCtrl.dispose();
    _pulseCtrl.dispose();
    _staggerCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = ThemeColors(isDark);

    return Scaffold(
      backgroundColor: colors.bg,
      body: Stack(
        children: [
          _buildDecorativeRings(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildHeader(colors),
                    const SizedBox(height: 32),
                    _buildArcHero(colors),
                    const SizedBox(height: 28),
                    _buildStatStrip(colors),
                    const SizedBox(height: 22),
                    _buildBreakdown(colors),
                    const SizedBox(height: 22),
                    _buildFeedback(colors),
                    const SizedBox(height: 28),
                    _buildCTA(),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeRings() => Stack(children: [
    Positioned(top: -80, right: -80, child: Ring(size: 300, color: CbColors.primary, opacity: 0.06)),
    Positioned(top: 60,  right: -40, child: Ring(size: 140, color: CbColors.primary, opacity: 0.09)),
  ]);

  Widget _buildHeader(ThemeColors colors) {
    return AnimatedBuilder(
      animation: _entranceCtrl,
      builder: (_, __) => Opacity(
        opacity: _fadeIn.value,
        child: Transform.translate(
          offset: Offset(0, _slideUp.value),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Treino concluído',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: CbColors.primary, letterSpacing: 1.4),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.training.title,
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: colors.onSurface, letterSpacing: -0.8, height: 1.1),
                    ),
                  ],
                ),
              ),
              AnimatedBuilder(
                animation: _pulseCtrl,
                builder: (_, child) => Transform.scale(scale: _pulse.value, child: child),
                child: Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CbColors.primary,
                    boxShadow: [BoxShadow(color: CbColors.primary.withValues(alpha: 0.45), blurRadius: 18, spreadRadius: 2)],
                  ),
                  child: const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 28),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArcHero(ThemeColors colors) {
    return AnimatedBuilder(
      animation: Listenable.merge([_arcCtrl, _entranceCtrl]),
      builder: (_, __) => Opacity(
        opacity: _fadeIn.value,
        child: SizedBox(
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 200, height: 200,
                child: CustomPaint(
                  painter: ArcPainter(
                    progress: _arcProgress.value,
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
                    '${(_arcProgress.value * 100).round()}%',
                    style: TextStyle(fontSize: 52, fontWeight: FontWeight.w900, color: colors.onSurface, letterSpacing: -2, height: 1.0),
                  ),
                  const SizedBox(height: 4),
                  Text('conclusão', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.subtle, letterSpacing: 0.8)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatStrip(ThemeColors colors) {
    final items = [
      StatData(label: 'Duração',    value: _elapsedFormatted,  icon: Icons.timer_rounded),
      StatData(label: 'Exercícios', value: '$_totalExercises', icon: Icons.fitness_center_rounded),
      if (_hasRepsExercises)
        StatData(label: 'Eficiência', value: '$_efficiencyPct%', icon: Icons.percent_rounded, accent: _efficiencyColor),
    ];

    return AnimatedBuilder(
      animation: _staggerCtrl,
      builder: (_, __) => Row(
        children: items.asMap().entries.map((e) {
          final delay = e.key * 0.15;
          final t     = ((_staggerCtrl.value - delay) / (1.0 - delay)).clamp(0.0, 1.0);
          final curve = Curves.easeOutBack.transform(t);
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: e.key < items.length - 1 ? 10 : 0),
              child: Opacity(
                opacity: t,
                child: Transform.translate(
                  offset: Offset(0, 30 * (1 - curve)),
                  child: StatTile(data: e.value, colors: colors),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBreakdown(ThemeColors colors) {
    return AnimatedBuilder(
      animation: _staggerCtrl,
      builder: (_, child) => Opacity(
        opacity: Curves.easeOut.transform(_staggerCtrl.value.clamp(0.0, 1.0)),
        child: Transform.translate(offset: Offset(0, 20 * (1 - _staggerCtrl.value)), child: child),
      ),
      child: Container(
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
                  Text('Exercícios', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: colors.onSurface, letterSpacing: -0.3)),
                  const Spacer(),
                  Text('$_totalExercises concluídos', style: TextStyle(fontSize: 12, color: CbColors.primary, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ...widget.training.exercises.asMap().entries.map((entry) {
              final i      = entry.key;
              final ex     = entry.value;
              final data   = _perExercise[i.toString()] as Map<String, dynamic>?;
              final isLast = i == widget.training.exercises.length - 1;

              String detail   = '—';
              double progress = 1.0;

              if (data != null) {
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
              }

              final isComplete = progress >= 1.0;
              final rowColor   = isComplete ? CbColors.primary : Colors.orange;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                    child: Row(
                      children: [
                        ExerciseBadge(index: i, isComplete: isComplete, colors: colors),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ex.title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: colors.onSurface), maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 3,
                                  backgroundColor: colors.progressTrack,
                                  valueColor: AlwaysStoppedAnimation<Color>(rowColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(detail, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: rowColor)),
                      ],
                    ),
                  ),
                  if (!isLast) Divider(height: 1, indent: 66, endIndent: 20, color: colors.divider),
                ],
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedback(ThemeColors colors) {
    final labels       = ['Muito fácil', 'Fácil', 'Ok', 'Difícil', 'Exaustivo'];
    final icons        = [CbImages.veryEasyIcon, CbImages.easyIcon, CbImages.okIcon, CbImages.hardIcon, CbImages.veryHardIcon];
    final ratingColors = [Colors.blue, Colors.green, CbColors.primary, Colors.orange, Colors.red];

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: colors.cardShadow, blurRadius: 24, offset: const Offset(0, 6))],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Como foi?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: colors.onSurface, letterSpacing: -0.3)),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (i) {
              final isSelected = _selectedRating == i + 1;
              final color      = ratingColors[i];
              return GestureDetector(
                onTap: () => setState(() => _selectedRating = i + 1),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: isSelected ? 50 : 58, end: isSelected ? 58 : 50),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  builder: (_, size, __) => Container(
                    width: size, height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? color.withValues(alpha: 0.15) : colors.chipBg,
                      border: Border.all(color: isSelected ? color : Colors.transparent, width: 2),
                    ),
                    child: isSelected
                        ? DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 12, spreadRadius: 1)],
                            ),
                            child: Padding(padding: const EdgeInsets.all(10), child: Image.asset(icons[i], fit: BoxFit.contain)),
                          )
                        : Padding(padding: const EdgeInsets.all(10), child: Image.asset(icons[i], fit: BoxFit.contain)),
                  ),
                ),
              );
            }),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: _selectedRating > 0
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: Text(
                          labels[_selectedRating - 1],
                          key: ValueKey(_selectedRating),
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: ratingColors[_selectedRating - 1], letterSpacing: 0.2),
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),
          CreateForm(
            label: 'Comentário',
            hintText: 'Comente algo sobre esse treino...',
            controller: _noteCtrl,
            validateEmpty: '',
            maxLength: 200,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildCTA() {
    return Center(
      child: CbPrimaryBtn(
        label: 'Finalizar',
        onPressed: () {
          FocusScope.of(context).unfocus();
          //TODO: persist _selectedRating + _noteCtrl.text to Firestore
          Get.put(UserController(), permanent: true);
          Get.offAll(() => const HomeMenu());
        },
        fontSize: 18,
        paddingV: 12,
        paddingH: 40,
      ),
    );
  }

  String _fmt(int seconds) =>
      '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
}

class StatData {
  const StatData({required this.label, required this.value, required this.icon, this.accent});
  final String   label;
  final String   value;
  final IconData icon;
  final Color?   accent;
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







