import 'package:carboneto/features/personalization/models/user_model.dart';
import 'package:carboneto/features/training/models/creator/creator_model.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/features/training/models/training_stats/training_stats.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TrainingModel {
  final String authorId;
  final List<String> categories;
  final String description;
  final int? duration;
  final TrainingVisibility visibility;
  TrainingStats stats;
  List<String>? exercisesId;
  List<ExerciseModel> exercises;
  final String id;
  final DifficultyLevels level;
  final String? textLevel;
  final int people;
  final String thumbnail;
  final String title;
  UserModel? user;
  final CreatorModel creator;
  final Timestamp? postedAt;
  int get likesCount => stats.likes;
  int get viewsCount => stats.views;
  int get startsCount => stats.starts;
  int get completesCount => stats.completes;
  int get savesCount => stats.saves;

  TrainingModel({
    required this.authorId,
    required this.categories,
    required this.description,
    this.duration,
    this.exercisesId,
    required this.exercises,
    required this.id,
    required this.level,
    required this.people,
    required this.thumbnail,
    required this.title,
    this.user,
    this.textLevel,
    required this.creator,
    required this.visibility,
    this.postedAt,
    TrainingStats? stats,
  }) : stats = stats ?? TrainingStats.empty();

  static DifficultyLevels parseStringToLevel(String data) {
    final DifficultyLevels level;
    switch (data) {
      case 'rookie':
        level = DifficultyLevels.rookie;
        break;
      case 'pro':
        level = DifficultyLevels.pro;
        break;
      case 'elite':
        level = DifficultyLevels.elite;
        break;
      default:
        level = DifficultyLevels.allstar;
    }
    return level;
  }

  static String parseLevelToString(DifficultyLevels data) {
    final String level;
    switch (data) {
      case DifficultyLevels.allstar:
        level = 'all-star';
        break;
      case DifficultyLevels.pro:
        level = 'pro';
        break;
      case DifficultyLevels.elite:
        level = 'elite';
        break;
      default:
        level = 'rookie';
        break;
    }
    return level;
  }

  TrainingModel copyWith({
    String? authorId,
    List<String>? categories,
    String? description,
    int? duration,
    TrainingVisibility? visibility,
    TrainingStats? stats,
    List<String>? exercisesId,
    List<ExerciseModel>? exercises,
    String? id,
    DifficultyLevels? level,
    String? textLevel,
    int? people,
    String? thumbnail,
    String? title,
    UserModel? user,
    CreatorModel? creator,
    Timestamp? postedAt,
  }) {
    return TrainingModel(
      authorId: authorId ?? this.authorId,
      categories: categories ?? this.categories,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      visibility: visibility ?? this.visibility,
      stats: stats ?? this.stats,
      exercisesId: exercisesId ?? this.exercisesId,
      exercises: exercises ?? this.exercises,
      id: id ?? this.id,
      level: level ?? this.level,
      textLevel: textLevel ?? this.textLevel,
      people: people ?? this.people,
      thumbnail: thumbnail ?? this.thumbnail,
      title: title ?? this.title,
      user: user ?? this.user,
      creator: creator ?? this.creator,
      postedAt: postedAt ?? this.postedAt,
    );
  }

  factory TrainingModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    return TrainingModel(
      id: data['Id'],
      duration: data['Duration'] ?? 0,
      authorId: data['AuthorID'] ?? '',
      categories: List<String>.from(data['Categories'] ?? []),
      description: data['Description'] ?? '',
      exercises: [],
      level: parseStringToLevel(data['Level'].toString().toLowerCase()),
      people: data['People'] ?? 0,
      thumbnail: data['Thumbnail'] ?? '',
      title: data['Title'] ?? '',
      textLevel: data['Level'].toString().capitalize,
      exercisesId: List<String>.from(data['Exercises'] ?? []),
      creator: CreatorModel.fromMap(
          Map<String, dynamic>.from(data['Creator'] ?? {})),
      postedAt: data['PostedAt'] as Timestamp?,
      stats: data['Stats'] != null
          ? TrainingStats.fromJson(data['Stats'] as Map<String, dynamic>)
          : TrainingStats.empty(),
      visibility: TrainingVisibility.values.firstWhere(
        (e) => e.name == (data['Visibility'] ?? 'public'),
      ),
    );
  }

  factory TrainingModel.fromJson(Map<String, dynamic> json) {
    // support both capitalized (Firestore) and lowercase (Meilisearch) keys
    String? getString(String lower, String upper) =>
        (json[lower] ?? json[upper])?.toString();

    dynamic get(String lower, String upper) => json[lower] ?? json[upper];

    // handle postedAt as Timestamp, Map (_seconds), or String (ISO)
    Timestamp? parsePostedAt() {
      final raw = get('postedat', 'PostedAt');
      if (raw == null) return null;
      if (raw is Timestamp) return raw;
      if (raw is Map) {
        final seconds = raw['_seconds'] ?? raw['seconds'];
        if (seconds != null) return Timestamp(seconds, 0);
      }
      if (raw is String) {
        final dt = DateTime.tryParse(raw);
        if (dt != null) return Timestamp.fromDate(dt);
      }
      return null;
    }

    return TrainingModel(
      id: getString('id', 'Id') ?? '',
      duration: (get('duration', 'Duration') as num?)?.toInt(),
      authorId: getString('authorid', 'AuthorID') ?? '',
      categories: List<String>.from(get('categories', 'Categories') ?? []),
      description: getString('description', 'Description') ?? '',
      exercises: [],
      exercisesId: List<String>.from(get('exercises', 'Exercises') ?? []),
      level: parseStringToLevel(
        (getString('level', 'Level') ?? 'rookie').toLowerCase(),
      ),
      people: (get('people', 'People') as num?)?.toInt() ?? 0,
      thumbnail: getString('thumbnail', 'Thumbnail') ?? '',
      title: getString('title', 'Title') ?? '',
      creator: CreatorModel.fromMap(
        Map<String, dynamic>.from(get('creator', 'Creator') ?? {}),
      ),
      postedAt: parsePostedAt(),
      stats: get('stats', 'Stats') != null
          ? TrainingStats.fromJson(
              Map<String, dynamic>.from(get('stats', 'Stats')))
          : TrainingStats.empty(),
      visibility: TrainingVisibility.values.firstWhere(
        (e) => e.name == (getString('visibility', 'Visibility') ?? 'public'),
        orElse: () => TrainingVisibility.public,
      ),
    );
  }

  Map<String, dynamic> toJson({bool updatePostedAt = true}) {
    final json = {
      'Id': id,
      'Duration': duration,
      'AuthorID': authorId,
      'Categories': categories,
      'Description': description,
      'Exercises': exercises.map((single) => single.id).toList(),
      'Level': parseLevelToString(level),
      'People': people,
      'Thumbnail': thumbnail,
      'Title': title,
      'Creator': creator.toMap(),
      'Stats': stats.toJson(),
      'Visibility': visibility.name,
    };
    if (updatePostedAt) {
      json['PostedAt'] = FieldValue.serverTimestamp();
    }
    return json;
  }

  static TrainingModel empty() => TrainingModel(
        exercisesId: [],
        authorId: '',
        categories: [],
        description: '',
        exercises: [],
        id: '',
        level: DifficultyLevels.rookie,
        people: 0,
        thumbnail: '',
        title: '',
        creator: CreatorModel.empty(),
        postedAt: null,
        stats: TrainingStats.empty(),
        visibility: TrainingVisibility.public,
      );
}
