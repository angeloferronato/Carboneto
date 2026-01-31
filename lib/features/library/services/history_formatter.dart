import 'package:carboneto/features/library/models/history_model.dart';

class HistoryFormatter {
  static Map<String, List<TrainingHistoryModel>> groupByDay(
    List<TrainingHistoryModel> items,
  ) {
    final map = <String, List<TrainingHistoryModel>>{};

    for (final item in items) {
      final d = item.startedAt;
      final key = "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

      map.putIfAbsent(key, () => []);
      map[key]!.add(item);
    }

    return map;
  }

  static String formatDayLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(date.year, date.month, date.day);

    final diff = today.difference(that).inDays;

    if (diff == 0) return 'Hoje';
    if (diff == 1) return 'Ontem';

    const months = [
      '',
      'jan',
      'fev',
      'mar',
      'abr',
      'mai',
      'jun',
      'jul',
      'ago',
      'set',
      'out',
      'nov',
      'dez'
    ];

    return "${date.day} de ${months[date.month]} de ${date.year}";
  }
}
