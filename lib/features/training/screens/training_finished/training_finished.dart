import 'package:carboneto/common/widgets/buttons/cb_primary_btn.dart';
import 'package:carboneto/features/create/screens/create_training/widgets/create_form.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/training/models/training/training_model.dart';
import 'package:carboneto/features/training/screens/training_finished/widgets/ring.dart';
import 'package:carboneto/features/training/screens/training_finished/widgets/training_summary_widgets.dart';
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

  List<ExerciseRowData> get _exerciseRows =>
      widget.training.exercises.asMap().entries.map((e) {
        final data = _perExercise[e.key.toString()] as Map<String, dynamic>? ?? {};
        return ExerciseRowData.fromStatsMap(e.value.title, data);
      }).toList();

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
                    TrainingSummaryArc(
                      colors: colors,
                      arcProgress: _arcProgress,
                      size: 200,
                      fontSize: 52,
                    ),
                    const SizedBox(height: 28),
                    TrainingSummaryStatStrip(
                      colors: colors,
                      staggerAnimation: _staggerCtrl,
                      items: [
                        StatData(label: 'Duração',    value: _elapsedFormatted,  icon: Icons.timer_rounded),
                        StatData(label: 'Exercícios', value: '$_totalExercises', icon: Icons.fitness_center_rounded),
                        if (_hasRepsExercises)
                          StatData(label: 'Eficiência', value: '$_efficiencyPct%', icon: Icons.percent_rounded, accent: _efficiencyColor),
                      ],
                    ),
                    const SizedBox(height: 22),
                    TrainingSummaryBreakdown(
                      colors: colors,
                      exercises: _exerciseRows,
                      slideAnimation: _staggerCtrl,
                      headerTrailing: Text(
                        '$_totalExercises concluídos',
                        style: TextStyle(fontSize: 12, color: CbColors.primary, fontWeight: FontWeight.w600),
                      ),
                    ),
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
}