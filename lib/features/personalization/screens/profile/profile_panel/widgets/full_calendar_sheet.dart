import 'package:carboneto/common/widgets/buttons/cb_primary_btn.dart';
import 'package:carboneto/features/personalization/controllers/profile_panel_controller/athlete_panel_controller.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FullCalendarSheet extends StatefulWidget {
  const FullCalendarSheet({
    super.key,
    required this.initialMonth,
    required this.selectedDay,
    required this.controller,
    required this.isDark,
  });

  final DateTime initialMonth;
  final DateTime selectedDay;
  final AthletePanelController controller;
  final bool isDark;

  @override
  State<FullCalendarSheet> createState() => FullCalendarSheetState();
}

class FullCalendarSheetState extends State<FullCalendarSheet> {
  late DateTime _viewMonth;
  late DateTime _picked;

  @override
  void initState() {
    super.initState();
    _viewMonth = widget.initialMonth;
    _picked = widget.selectedDay;
  }



  void _prevMonth() => setState(
      () => _viewMonth = DateTime(_viewMonth.year, _viewMonth.month - 1));

  void _nextMonth() => setState(
      () => _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + 1));

  List<DateTime?> _buildCells() {
    final firstDay = DateTime(_viewMonth.year, _viewMonth.month, 1);
    final daysInMonth = DateTime(_viewMonth.year, _viewMonth.month + 1, 0).day;
    final leadingBlanks = firstDay.weekday % 7;
    final cells = <DateTime?>[];
    for (int i = 0; i < leadingBlanks; i++) cells.add(null);
    for (int d = 1; d <= daysInMonth; d++) {
      cells.add(DateTime(_viewMonth.year, _viewMonth.month, d));
    }
    while (cells.length % 7 != 0) cells.add(null);
    return cells;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final bg = isDark ? CbColors.dark : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final cells = _buildCells();
    final today = DateTime.now();

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: textColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _prevMonth,
                child: Icon(Icons.chevron_left_rounded,
                    color: textColor.withValues(alpha: 0.5), size: 26),
              ),
              Text(
                '${CbHelperFunctions.monthName(_viewMonth.month)} ${_viewMonth.year}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              GestureDetector(
                onTap: _nextMonth,
                child: Icon(Icons.chevron_right_rounded,
                    color: textColor.withValues(alpha: 0.5), size: 26),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: CbHelperFunctions.kDayLetters
                .map((l) => Expanded(
                      child: Center(
                        child: Text(l,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: textColor.withValues(alpha: 0.4))),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          Obx(() => GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 4,
                crossAxisSpacing: 0,
                childAspectRatio: 0.85,
                children: cells.map((day) {
                  if (day == null) return const SizedBox.shrink();

                  final isSelected = CbHelperFunctions.isSameDay(day, _picked);
                  final isToday = CbHelperFunctions.isSameDay(day, today);
                  final hasDot = widget.controller.hasTrainingOn(day);

                  return GestureDetector(
                    onTap: () => setState(() => _picked = day),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? CbColors.primary
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: isToday && !isSelected
                                  ? Border.all(
                                      color: CbColors.primary, width: 1.5)
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                '${day.day}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected || isToday
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: isSelected
                                      ? Colors.white
                                      : isToday
                                          ? CbColors.primary
                                          : textColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          // Training dot
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: hasDot
                                  ? (isSelected
                                      ? Colors.white.withValues(alpha: 0.7)
                                      : CbColors.primary)
                                  : Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              )),
          const SizedBox(height: 20),
          CbPrimaryBtn(
            label: 'Confirmar',
            onPressed: () => Navigator.pop(context, _picked),
          ),
        ],
      ),
    );
  }
}
