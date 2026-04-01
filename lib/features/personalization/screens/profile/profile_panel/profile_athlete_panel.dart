import 'package:carboneto/features/personalization/controllers/profile_base_controller.dart/profile_base_controller.dart';
import 'package:carboneto/features/personalization/controllers/profile_panel_controller/athlete_panel_controller.dart';
import 'package:carboneto/features/personalization/screens/profile/profile_panel/widgets/calendar_card.dart';
import 'package:carboneto/features/personalization/screens/profile/profile_panel/widgets/empty_chart.dart';
import 'package:carboneto/features/personalization/screens/profile/profile_panel/widgets/line_chart_card.dart';
import 'package:carboneto/features/personalization/screens/profile/profile_panel/widgets/metric_chips.dart';
import 'package:carboneto/features/personalization/screens/profile/profile_panel/widgets/range_selector.dart';
import 'package:carboneto/features/personalization/screens/profile/profile_panel/widgets/stats_row.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/private_account_state.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileAthletePanel extends StatefulWidget {
  const ProfileAthletePanel({super.key, required this.userId});

  final String userId;

  @override
  State<ProfileAthletePanel> createState() => _ProfileAthletePanelState();
}

class _ProfileAthletePanelState extends State<ProfileAthletePanel> {
  late final AthletePanelController _ctrl;
  late final ProfileBaseController _baseCtrl;

  ChartRange _selectedRange = ChartRange.month;
  ChartMetric _selectedMetric = ChartMetric.acerto;

  late DateTime _currentWeekStart;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();

    _baseCtrl = Get.find<ProfileBaseController>(tag: widget.userId);

    _ctrl = Get.put(
      AthletePanelController(userId: widget.userId),
      tag: widget.userId,
    );

    final now = DateTime.now();
    _currentWeekStart = now.subtract(Duration(days: now.weekday % 7));
    _selectedDay = now;

    _ctrl.updateChartSelection(
      _toControllerMetric(_selectedMetric),
      _toControllerRange(_selectedRange),
    );
  }

  void _onMetricChanged(ChartMetric m) {
    setState(() => _selectedMetric = m);
    _ctrl.updateChartSelection(
      _toControllerMetric(m),
      _toControllerRange(_selectedRange),
    );
  }

  void _onRangeChanged(ChartRange r) {
    setState(() => _selectedRange = r);
    _ctrl.updateChartSelection(
      _toControllerMetric(_selectedMetric),
      _toControllerRange(r),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final isAuthUser = _baseCtrl.isAuthUser;
      final isPrivate =
          _baseCtrl.user.value.isPrivate && !isAuthUser;

      // Show private state — same pattern as ProfileTrainingsList
      if (isPrivate) {
        return PrivateAccountState();
      }

      if (_ctrl.isLoading.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 60),
          child: Center(
            child: CircularProgressIndicator(color: CbColors.primary),
          ),
        );
      }

      final stats = _ctrl.stats.value;
      final points = _ctrl.chartPoints;
      final chartData = points.map((p) => p.value).toList();
      final chartLabels = points.map((p) => p.label).toList();

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatsRow(stats: stats, isDark: isDark),
            const SizedBox(height: 30),
            CalendarCard(
              weekStart: _currentWeekStart,
              selectedDay: _selectedDay,
              controller: _ctrl,
              onDaySelected: (day) => setState(() => _selectedDay = day),
              onWeekChanged: (start) =>
                  setState(() => _currentWeekStart = start),
              isDark: isDark,
            ),
            const SizedBox(height: 35),
            MetricChips(
              selected: _selectedMetric,
              onChanged: _onMetricChanged,
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            if (chartData.length < 2)
              EmptyChart(isDark: isDark)
            else
              ChartCard(
                data: chartData,
                labels: chartLabels,
                metric: _selectedMetric,
                isDark: isDark,
              ),
            const SizedBox(height: 12),
            RangeSelector(
              selected: _selectedRange,
              onChanged: _onRangeChanged,
              isDark: isDark,
            ),
          ],
        ),
      );
    });
  }

  AthletePanelMetric _toControllerMetric(ChartMetric m) {
    switch (m) {
      case ChartMetric.acerto:
        return AthletePanelMetric.acerto;
      case ChartMetric.duracao:
        return AthletePanelMetric.duracao;
      case ChartMetric.frequencia:
        return AthletePanelMetric.frequencia;
    }
  }

  AthletePanelRange _toControllerRange(ChartRange r) {
    switch (r) {
      case ChartRange.week:
        return AthletePanelRange.week;
      case ChartRange.month:
        return AthletePanelRange.month;
      case ChartRange.threeMonths:
        return AthletePanelRange.threeMonths;
      case ChartRange.oneYear:
        return AthletePanelRange.oneYear;
      case ChartRange.allTime:
        return AthletePanelRange.allTime;
    }
  }
}

