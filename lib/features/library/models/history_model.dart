import 'package:carboneto/features/training/models/creator/creator_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingHistoryModel {
  final String id;
  final String trainingId;
  final String title;
  final String authorId;
  final String thumbnail;
  final CreatorModel creator;
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
    required this.creator,
    required this.startedAt,
    required this.sessionEndedAt,
    required this.status,
    required this.trainingProgress,
    required this.authorId,
    required this.trainingDuration,
    required this.trainingType,
    required this.level,
    required this.perExercise,
    required this.searchKeywords,
  });

  factory TrainingHistoryModel.fromJson(Map<String, dynamic> json) {
    final stats = Map<String, dynamic>.from(json['TrainingStats'] ?? {});
    final perExerciseMap =
        Map<String, dynamic>.from(stats['PerExercise'] ?? {});

    return TrainingHistoryModel(
      id: json['Id'],
      authorId: json['AuthorID'],
      trainingId: json['TrainingId'],
      title: json['Title'],
      thumbnail: json['Thumbnail'],
      creator: CreatorModel.fromJson(json['Creator'] ?? {}),
      level: json['Level'],
      startedAt: (json['StartedAt'] as Timestamp).toDate(),
      sessionEndedAt: json['SessionEndedAt'] != null
          ? (json['SessionEndedAt'] as Timestamp).toDate()
          : null,
      status: json['Status'],
      trainingProgress: (json['TrainingProgress'] ?? 0).toInt(),
      trainingDuration: (stats['TrainingDuration'] ?? 0).toInt(),
      searchKeywords: List<String>.from(json['SearchKeywords'] ?? []),
      trainingType: (stats['TrainingType'] ?? 'time'),
      perExercise: perExerciseMap.entries
          .map((e) => ExerciseProgress.fromMap(e.key, e.value))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'AuthorID': authorId,
      'TrainingId': trainingId,
      'Title': title,
      'Thumbnail': thumbnail,
      'Creator': creator.toJson(),
      'Level': level,
      'StartedAt': Timestamp.fromDate(startedAt),
      'SessionEndedAt':
          sessionEndedAt != null ? Timestamp.fromDate(sessionEndedAt!) : null,
      'Status': status,
      'TrainingProgress': trainingProgress,
      'SearchKeywords': searchKeywords,
      'TrainingStats': {
        'TrainingDuration': trainingDuration,
        'TrainingType': trainingType,
        'PerExercise': Map.fromEntries(
          perExercise.map((e) => MapEntry(e.index, e.toMap())),
        ),
      },
    };
  }

  factory TrainingHistoryModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final stats = Map<String, dynamic>.from(data['TrainingStats'] ?? {});
    final perExerciseMap =
        Map<String, dynamic>.from(stats['PerExercise'] ?? {});

    return TrainingHistoryModel(
      id: doc.id,
      authorId: data['AuthorID'],
      trainingId: data['TrainingId'],
      title: data['Title'],
      thumbnail: data['Thumbnail'],
      creator: CreatorModel.fromJson(data['Creator'] ?? {}),
      level: data['Level'],
      startedAt: (data['StartedAt'] as Timestamp).toDate(),
      sessionEndedAt: data['SessionEndedAt'] != null
          ? (data['SessionEndedAt'] as Timestamp).toDate()
          : null,
      status: data['Status'],
      trainingProgress: (data['TrainingProgress'] ?? 0).toInt(),
      trainingDuration: (stats['TrainingDuration'] ?? 0).toInt(),
      searchKeywords: List<String>.from(data['SearchKeywords'] ?? []),
      trainingType: (stats['TrainingType'] ?? 'time'),
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
      type: map['Type'],
      total: (map['Total'] ?? 0).toInt(),
      remaining: (map['Remaining'] ?? 0).toInt(),
      done: (map['Done'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Type': type,
      'Total': total,
      'Remaining': remaining,
      'Done': done,
    };
  }

  bool get isCompleted {
    if (type == 'time') return remaining == 0;
    if (type == 'reps') return done >= total;
    return false;
  }
}
