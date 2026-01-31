import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingHistoryModel {
  final String id;
  final String trainingId;
  final String title;
  final String thumbnail;
  final String author;
  final String authorId;
  final String authorPicture;
  final String level;
  final List<String> searchKeywords;

  final DateTime startedAt;
  final DateTime? sessionEndedAt;
  final String status;

  final int trainingProgress;
  final int trainingDuration;
  final String trainingType;

  final List<ExerciseProgress> perExercise;

  TrainingHistoryModel({
    required this.id,
    required this.trainingId,
    required this.title,
    required this.thumbnail,
    required this.author,
    required this.authorId,
    required this.authorPicture,
    required this.startedAt,
    required this.sessionEndedAt,
    required this.status,
    required this.trainingProgress,
    required this.trainingDuration,
    required this.trainingType,
    required this.level,
    required this.perExercise,
    required this.searchKeywords,
  });

  factory TrainingHistoryModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final stats = Map<String, dynamic>.from(data['trainingStats'] ?? {});
    final perExerciseMap =
        Map<String, dynamic>.from(stats['perExercise'] ?? {});

    return TrainingHistoryModel(
      id: doc.id,
      trainingId: data['trainingId'],
      title: data['title'],
      thumbnail: data['thumbnail'],
      author: data['author'],
      authorId: data['authorId'],
      level: data['level'],
      authorPicture: data['authorPicture'],
      startedAt: (data['startedAt'] as Timestamp).toDate(),
      sessionEndedAt: data['sessionEndedAt'] != null
          ? (data['sessionEndedAt'] as Timestamp).toDate()
          : null,
      status: data['status'],
      trainingProgress: (data['trainingProgress'] ?? 0).toInt(),
      trainingDuration: (stats['trainingDuration'] ?? 0).toInt(),
      searchKeywords: List<String>.from(data['searchKeywords'] ?? []),
      trainingType: (stats['trainingType'] ?? 'time'),
      perExercise: perExerciseMap.entries
          .map((e) => ExerciseProgress.fromMap(e.key, e.value))
          .toList(),
    );
  }
}

class ExerciseProgress {
  final String index;
  final String type;
  final int total;
  final int remaining; // time
  final int done; // reps

  ExerciseProgress({
    required this.index,
    required this.type,
    required this.total,
    required this.remaining,
    required this.done,
  });

  factory ExerciseProgress.fromMap(String index, Map<String, dynamic> map) {
    return ExerciseProgress(
      index: index,
      type: map['type'],
      total: (map['total'] ?? 0).toInt(),
      remaining: (map['remaining'] ?? 0).toInt(),
      done: (map['done'] ?? 0).toInt(),
    );
  }

  bool get isCompleted {
    if (type == 'time') return remaining == 0;
    if (type == 'reps') return done >= total;
    return false;
  }
}
