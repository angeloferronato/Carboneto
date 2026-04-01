import 'package:carboneto/features/library/models/history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AthletePanelStats {
  final double aproveitamentoPct;
  final double aproveitamentoChange;
  final int treinosConcluidos;

  const AthletePanelStats({
    required this.aproveitamentoPct,
    required this.aproveitamentoChange,
    required this.treinosConcluidos,
  });

  static const empty = AthletePanelStats(
    aproveitamentoPct: 0,
    aproveitamentoChange: 0,
    treinosConcluidos: 0,
  );
}

class ChartPoint {
  final String label;
  final double value;
  const ChartPoint(this.label, this.value);
}

class AthletePanelController extends GetxController {
  AthletePanelController({required this.userId});

  final String userId;
  final _db = FirebaseFirestore.instance;

  final RxList<TrainingHistoryModel> _allHistory = <TrainingHistoryModel>[].obs;

  final stats = AthletePanelStats.empty.obs;
  final trainingDates = <String>{}.obs;
  final chartPoints = <ChartPoint>[].obs;
  final isLoading = true.obs;

  var selectedMetric = AthletePanelMetric.acerto;
  var selectedRange = AthletePanelRange.oneYear;

  CollectionReference get _historyRef =>
      _db.collection('users').doc(userId).collection('trainingHistory');

  @override
  void onInit() {
    super.onInit();
    _streamHistory();
  }

  void _streamHistory() {
    _historyRef
        .orderBy('SessionEndedAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      _allHistory.value =
          snapshot.docs.map(TrainingHistoryModel.fromDoc).toList();

      _recompute();
      isLoading.value = false;
    }, onError: (e) {
      debugPrint('[AthletePanelController] $e');
      isLoading.value = false;
    });
  }

  void _recompute() {
    _computeStats();
    _computeTrainingDates();
    _computeChart();
  }

  List<TrainingHistoryModel> trainingsOn(DateTime day) {
    final key = _dateKey(day);
    return _allHistory.where((h) {
      final d = h.sessionEndedAt;
      return d != null && _dateKey(d) == key;
    }).toList();
  }

  void _computeStats() {
    final history = _allHistory;

    int concluded = 0;
    for (final h in history) {
      if (h.status == 'completed' || h.trainingProgress >= 100) {
        concluded++;
      }
    }

    final aprovPct = _fg(history);
    const benchmark = 0.48;

    stats.value = AthletePanelStats(
      aproveitamentoPct: aprovPct,
      aproveitamentoChange: aprovPct - benchmark,
      treinosConcluidos: concluded,
    );
  }

  void _computeTrainingDates() {
    final set = <String>{};

    for (final h in _allHistory) {
      final d = h.sessionEndedAt;
      if (d != null) set.add(_dateKey(d));
    }

    trainingDates.assignAll(set);
  }

  bool hasTrainingOn(DateTime day) =>
      trainingDates.contains(_dateKey(day));

  void updateChartSelection(
      AthletePanelMetric metric, AthletePanelRange range) {
    selectedMetric = metric;
    selectedRange = range;
    _computeChart();
  }

  void _computeChart() {
    final now = DateTime.now();
    final cutoff = _cutoffDate(now, selectedRange);

    final filtered = <TrainingHistoryModel>[];

    for (final h in _allHistory) {
      final d = h.sessionEndedAt;
      if (d == null || !d.isAfter(cutoff)) continue;

      if (selectedMetric == AthletePanelMetric.acerto) {
        bool hasReps = false;
        for (final ex in h.perExercise) {
          if (ex.type == 'reps') {
            hasReps = true;
            break;
          }
        }
        if (!hasReps) continue;
      }

      filtered.add(h);
    }

    final grouped = switch (selectedRange) {
      AthletePanelRange.week ||
      AthletePanelRange.month =>
        _groupByDay(filtered),
      AthletePanelRange.threeMonths =>
        _groupByWeek(filtered),
      AthletePanelRange.oneYear ||
      AthletePanelRange.allTime =>
        _groupByMonth(filtered),
    };

    final keys = grouped.keys.toList()..sort();

    final result = <ChartPoint>[];

    for (final key in keys) {
      final sessions = grouped[key]!;

      double value;
      switch (selectedMetric) {
        case AthletePanelMetric.acerto:
          value = _fg(sessions) * 100;
          break;

        case AthletePanelMetric.duracao:
          if (sessions.isEmpty) {
            value = 0;
          } else {
            double sum = 0;
            for (final h in sessions) {
              sum += h.trainingDuration;
            }
            value = (sum / sessions.length) / 60;
          }
          break;

        case AthletePanelMetric.frequencia:
          value = sessions.length.toDouble();
          break;
      }

      result.add(ChartPoint(_labelForKey(key, selectedRange), value));
    }

    chartPoints.value = result;
  }

  Map<String, List<TrainingHistoryModel>> _groupByDay(
      List<TrainingHistoryModel> sessions) {
    final map = <String, List<TrainingHistoryModel>>{};

    for (final h in sessions) {
      final key = _dateKey(h.sessionEndedAt!);
      (map[key] ??= []).add(h);
    }

    return map;
  }

  Map<String, List<TrainingHistoryModel>> _groupByWeek(
      List<TrainingHistoryModel> sessions) {
    final map = <String, List<TrainingHistoryModel>>{};

    for (final h in sessions) {
      final key = _weekKey(h.sessionEndedAt!);
      (map[key] ??= []).add(h);
    }

    return map;
  }

  Map<String, List<TrainingHistoryModel>> _groupByMonth(
      List<TrainingHistoryModel> sessions) {
    final map = <String, List<TrainingHistoryModel>>{};

    for (final h in sessions) {
      final key = _monthKey(h.sessionEndedAt!);
      (map[key] ??= []).add(h);
    }

    return map;
  }

  String _weekKey(DateTime d) {
    final monday = d.subtract(Duration(days: d.weekday - 1));
    return _dateKey(monday);
  }

  String _labelForKey(String key, AthletePanelRange range) {
    if (range == AthletePanelRange.week ||
        range == AthletePanelRange.month ||
        range == AthletePanelRange.threeMonths) {
      final parts = key.split('-');
      return '${parts[2]}/${parts[1]}';
    }

    const names = [
      'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez',
    ];

    final month = int.parse(key.split('-')[1]);
    return names[month - 1];
  }

  double _fg(List<TrainingHistoryModel> sessions) {
    double sum = 0;
    int count = 0;

    for (final h in sessions) {
      for (final ex in h.perExercise) {
        if (ex.type != 'reps' || ex.done <= 0) continue;

        sum += (ex.total / ex.done).clamp(0.0, 1.0);
        count++;
      }
    }

    return count == 0 ? 0 : sum / count;
  }

  String _dateKey(DateTime d) {
    final local = d.toLocal();
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
  }

  String _monthKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}';

  DateTime _cutoffDate(DateTime now, AthletePanelRange range) =>
      switch (range) {
        AthletePanelRange.week =>
          now.subtract(const Duration(days: 7)),
        AthletePanelRange.month =>
          now.subtract(const Duration(days: 30)),
        AthletePanelRange.threeMonths =>
          now.subtract(const Duration(days: 90)),
        AthletePanelRange.oneYear =>
          now.subtract(const Duration(days: 365)),
        AthletePanelRange.allTime =>
          DateTime(2000),
      };
}

enum AthletePanelMetric { acerto, duracao, frequencia }

enum AthletePanelRange { week, month, threeMonths, oneYear, allTime }