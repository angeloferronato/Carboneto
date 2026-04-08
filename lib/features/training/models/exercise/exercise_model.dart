import 'package:carboneto/features/training/models/creator/creator_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carboneto/utils/constants/enums.dart';


class ExerciseModel {
  String description, title, video, id, thumb, type;
  int repetitions, duration, peopleCount; 
  String authorId;
  List<dynamic>? categories;
  CreatorModel creator;
  final TrainingVisibility visibility;

  ExerciseModel({
    required this.description,
    required this.title,
    required this.repetitions,
    required this.video,
    required this.id,
    required this.duration,
    required this.authorId,
    required this.categories,
    required this.thumb,
    required this.creator,
    required this.type,
    required this.visibility,
    this.peopleCount = 1, 
  });

  factory ExerciseModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) return ExerciseModel.empty();
    return ExerciseModel(
      duration: (data['Duration'] as int?) ?? 0,
      description: data['Description'] as String? ?? '',
      title: data['Title'] as String? ?? '',
      repetitions: (data['Repetitions'] as int?) ?? 0,
      video: data['Video'] as String? ?? '',
      id: data['Id'] as String? ?? snapshot.id,
      authorId: data['AuthorID'] as String? ?? '',
      categories: data['Categories'] as List<dynamic>? ?? [],
      thumb: data['Thumbnail'] as String? ?? '',
      creator: CreatorModel.fromMap(Map<String, dynamic>.from(data['Creator'])),
      type: data['Type'] as String? ?? '',
      peopleCount: (data['PeopleCount'] as int?) ?? 1, 
      visibility: TrainingVisibility.values.firstWhere(
        (e) => e.name == (data['Visibility'] ?? 'public'),
        orElse: () => TrainingVisibility.public,
      ),
    );
  }

  factory ExerciseModel.fromJson(Map<String, dynamic> data) {
    return ExerciseModel(
      duration: (data['Duration'] as int?) ?? 0,
      description: data['Description'] as String? ?? '',
      title: data['Title'] as String? ?? '',
      repetitions: (data['Repetitions'] as int?) ?? 0,
      video: data['Video'] as String? ?? '',
      id: data['Id'] as String,
      authorId: data['AuthorID'] as String? ?? '',
      categories: data['Categories'] as List<dynamic>? ?? [],
      thumb: data['Thumbnail'] as String? ?? '',
      creator: CreatorModel.fromMap(Map<String, dynamic>.from(data['Creator'])),
      type: data['Type'] as String? ?? '',
      peopleCount: (data['PeopleCount'] as int?) ?? 1, 
      visibility: TrainingVisibility.values.firstWhere(
        (e) => e.name == (data['Visibility'] ?? 'public'),
        orElse: () => TrainingVisibility.public,
      ),
    );
  }

  factory ExerciseModel.fromMeili(Map<String, dynamic> data) {
    return ExerciseModel(
      id: (data['id'] ?? '').toString(),
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      video: data['video'] as String? ?? '',
      thumb: data['thumbnail'] as String? ?? '',
      type: data['type'] as String? ?? '',
      repetitions: (data['repetitions'] as num?)?.toInt() ?? 0,
      duration: (data['duration'] as num?)?.toInt() ?? 0,
      peopleCount: (data['peoplecount'] as num?)?.toInt() ?? 1,
      authorId: data['authorid'] as String? ?? '',
      categories: data['categories'] as List<dynamic>? ?? [],
      creator: CreatorModel.fromMap(
        Map<String, dynamic>.from(data['creator'] as Map),
      ),
      visibility: TrainingVisibility.values.firstWhere(
        (e) => e.name == ((data['visibility'] ?? 'public') as String),
        orElse: () => TrainingVisibility.public,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Description': description,
      'Title': title,
      'Repetitions': repetitions,
      'Video': video,
      'Id': id,
      'Duration': duration,
      'AuthorID': authorId,
      'Categories': categories,
      'Thumbnail': thumb,
      'Type': type,
      'Creator': creator.toMap(),
      'PeopleCount': peopleCount, 
      'Visibility': visibility.name,
    };
  }

  static ExerciseModel empty() => ExerciseModel(
    description: '', title: '', repetitions: 0, video: '', id: '',
    duration: 0, authorId: '', categories: [], thumb: '',
    creator: CreatorModel.empty(), type: '', peopleCount: 1,
    visibility: TrainingVisibility.public,
  );
}