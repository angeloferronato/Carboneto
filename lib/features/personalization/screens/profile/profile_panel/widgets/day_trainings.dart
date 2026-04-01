import 'package:carboneto/features/library/models/history_model.dart';
import 'package:carboneto/features/library/screens/history_screen/widgets/history_result.dart';
import 'package:carboneto/features/personalization/screens/profile/profile_panel/widgets/training_summary_sheet.dart';
import 'package:carboneto/features/training/screens/training_finished/widgets/training_summary_widgets.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DayTrainingsScreen extends StatefulWidget {
  const DayTrainingsScreen({
    super.key,
    required this.day,
    required this.trainings,
    required this.isDark,
  });

  final DateTime day;
  final List<TrainingHistoryModel> trainings;
  final bool isDark;

  @override
  State<DayTrainingsScreen> createState() => _DayTrainingsScreenState();
}

class _DayTrainingsScreenState extends State<DayTrainingsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<double>(begin: 32, end: 0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Map<String, List<TrainingHistoryModel>> get _groupedByHour {
  final Map<String, List<TrainingHistoryModel>> groups = {};
  for (final t in widget.trainings) {
    final d = t.sessionEndedAt;
    if (d == null) continue;
    
    final key = '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    groups.putIfAbsent(key, () => []).add(t);
  }
  final sorted = Map.fromEntries(
    groups.entries.toList()..sort((a, b) => b.key.compareTo(a.key)),
  );
  return sorted;
}

  List<Object> get _flatItems {
    final List<Object> items = [];
    _groupedByHour.forEach((hour, trainings) {
      items.add(hour); // header
      items.addAll(trainings);
    });
    return items;
  }

  String get _dateLabel {
    const weekdays = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    const months = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];
    final d = widget.day;
    return '${weekdays[d.weekday - 1]}, ${d.day} de ${months[d.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = ThemeColors(widget.isDark);
    final textColor = widget.isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: widget.isDark ? CbColors.dark : CbColors.light,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(colors, textColor),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final items = _flatItems;
                  final entry = items[i];
                  final delay = i * 0.06;

                  return AnimatedBuilder(
                    animation: _ctrl,
                    builder: (_, child) {
                      final progress = ((_ctrl.value - delay) / (1.0 - delay))
                          .clamp(0.0, 1.0);
                      final curve = Curves.easeOutCubic.transform(progress);
                      return Opacity(
                        opacity: curve,
                        child: Transform.translate(
                          offset: Offset(0, 24 * (1 - curve)),
                          child: child,
                        ),
                      );
                    },
                    child: entry is String
                        ? _HourHeader(hour: entry, isDark: widget.isDark)
                        : Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: HistoryResult(
                              historyTraining: entry as TrainingHistoryModel,
                              hideOptions: true,
                              onTap: () => showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                showDragHandle: false,
                                builder: (_) => TrainingSummarySheet(
                                    training: entry, isDark: widget.isDark),
                              ),
                            ),
                          ),
                  );
                },
                childCount: _flatItems.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(ThemeColors colors, Color textColor) {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      backgroundColor: widget.isDark ? CbColors.dark : CbColors.light,
      surfaceTintColor: Colors.transparent,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child:
            Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: textColor),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: AnimatedBuilder(
          animation: _fade,
          builder: (_, __) => Opacity(
            opacity: _fade.value,
            child: Transform.translate(
              offset: Offset(0, _slide.value),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 80, 22, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _dateLabel.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: CbColors.primary,
                        letterSpacing: 1.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Treinos Realizados',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: textColor,
                            letterSpacing: -0.8,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: CbColors.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${widget.trainings.length}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: CbColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HourHeader extends StatelessWidget {
  const _HourHeader({required this.hour, required this.isDark});
  final String hour;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : Colors.black;
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: Row(
        children: [
          Text(
            hour,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: CbColors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Divider(
              color: textColor.withValues(alpha: 0.08),
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
