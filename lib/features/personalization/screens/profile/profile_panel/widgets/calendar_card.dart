import 'package:carboneto/common/widgets/buttons/see_all_btn.dart';
import 'package:carboneto/features/library/models/history_model.dart';
import 'package:carboneto/features/personalization/controllers/profile_panel_controller/athlete_panel_controller.dart';
import 'package:carboneto/features/personalization/screens/profile/profile_panel/widgets/day_chip.dart';
import 'package:carboneto/features/personalization/screens/profile/profile_panel/widgets/day_trainings.dart';
import 'package:carboneto/features/personalization/screens/profile/profile_panel/widgets/full_calendar_sheet.dart';
import 'package:carboneto/features/personalization/screens/profile/profile_panel/widgets/training_summary_sheet.dart';
import 'package:carboneto/features/personalization/screens/profile/profile_panel/widgets/training_tile.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalendarCard extends StatefulWidget {
  const CalendarCard({
    super.key,
    required this.weekStart,
    required this.selectedDay,
    required this.controller,
    required this.onDaySelected,
    required this.onWeekChanged,
    required this.isDark,
  });

  final DateTime weekStart;
  final DateTime selectedDay;
  final AthletePanelController controller;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<DateTime> onWeekChanged;
  final bool isDark;

  @override
  State<CalendarCard> createState() => CalendarCardState();
}

class CalendarCardState extends State<CalendarCard> {
  static const int _initialPage = 10000;
  late final PageController _pageController;

  DateTime _weekStartForPage(int page) =>
      widget.weekStart.add(Duration(days: (page - _initialPage) * 7));

  int _pageForWeekStart(DateTime ws) {
    final diff = ws.difference(widget.weekStart).inDays;
    return _initialPage + diff ~/ 7;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  void didUpdateWidget(CalendarCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weekStart != widget.weekStart) {
      final target = _pageForWeekStart(widget.weekStart);
      if (_pageController.hasClients &&
          _pageController.page?.round() != target) {
        _pageController.animateToPage(target,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  double _getTrainingPct(TrainingHistoryModel t) {
    double trainingPct = 0;
    double exercisesCounter = 0;

    if (['reps', 'mixed'].contains(t.trainingType)) {
      for (final exercise in t.perExercise) {
        if (exercise.type == 'reps') {
          if (exercise.done > 0) {
            trainingPct += exercise.total / exercise.done;
            exercisesCounter += 1;
          }
        }
      }
      trainingPct = trainingPct / exercisesCounter;
    }
    return trainingPct;
  }

  void _openTrainingSummary(BuildContext context, TrainingHistoryModel t) {
    showModalBottomSheet(
      context: context,
      showDragHandle: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TrainingSummarySheet(
          training: t, trainingPct: _getTrainingPct(t), isDark: widget.isDark),
    );
  }

  Future<void> _openFullCalendar(BuildContext context) async {
    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      backgroundColor: Colors.transparent,
      builder: (_) => FullCalendarSheet(
        initialMonth:
            DateTime(widget.selectedDay.year, widget.selectedDay.month),
        selectedDay: widget.selectedDay,
        controller: widget.controller,
        isDark: widget.isDark,
      ),
    );
    if (picked != null) {
      final weekday = picked.weekday % 7;
      widget.onWeekChanged(picked.subtract(Duration(days: weekday)));
      widget.onDaySelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDark ? Colors.white : Colors.black;
    final midDay = widget.weekStart.add(const Duration(days: 3));
    final monthLabel =
        '${CbHelperFunctions.monthName(midDay.month)} ${midDay.year}';

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut),
              child: Icon(Icons.chevron_left_rounded,
                  color: textColor.withValues(alpha: 0.5), size: 22),
            ),
            Text(
              monthLabel,
              style: TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 18, color: textColor),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () => _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut),
                  child: Icon(Icons.chevron_right_rounded,
                      color: textColor.withValues(alpha: 0.5), size: 22),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => _openFullCalendar(context),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: CbColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.calendar_today_rounded,
                        size: 17, color: CbColors.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 78,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (page) =>
                widget.onWeekChanged(_weekStartForPage(page)),
            itemBuilder: (context, page) {
              final weekStart = _weekStartForPage(page);
              final days =
                  List.generate(7, (i) => weekStart.add(Duration(days: i)));
              return Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (i) {
                      final day = days[i];
                      return GestureDetector(
                        onTap: () => widget.onDaySelected(day),
                        child: DayChip(
                          letter: CbHelperFunctions.kDayLetters[i],
                          number: day.day,
                          isSelected: CbHelperFunctions.isSameDay(
                              day, widget.selectedDay),
                          isToday:
                              CbHelperFunctions.isSameDay(day, DateTime.now()),
                          hasDot: widget.controller.hasTrainingOn(day),
                          isDark: widget.isDark,
                        ),
                      );
                    }),
                  ));
            },
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Treinos realizados'),
            SeeAllBtn(
              onPressed: () => Get.to(() => DayTrainingsScreen(
                    day: widget.selectedDay,
                    trainings:
                        widget.controller.trainingsOn(widget.selectedDay),
                    isDark: widget.isDark,
                  )),
              buttonTitle: 'Ver todos',
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Obx(() {
          final trainings = widget.controller.trainingsOn(widget.selectedDay);
          if (trainings.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Text(
                'Nenhum treino neste dia',
                style: TextStyle(
                    color: textColor.withValues(alpha: 0.4), fontSize: 13),
              ),
            );
          }

          final hasMore = trainings.length > 2;
          final visible = hasMore ? trainings.sublist(0, 2) : trainings;

          return Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: visible.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () => _openTrainingSummary(context, visible[i]),
                  child: TrainingTile(
                    training: visible[i],
                    isDark: widget.isDark,
                    trainingPct: _getTrainingPct(visible[i]),
                  ),
                ),
              ),
              if (hasMore)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    '+ ${trainings.length - 2} mais',
                    style: TextStyle(
                        color: textColor.withValues(alpha: 0.4), fontSize: 13),
                  ),
                ),
            ],
          );
        }),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
