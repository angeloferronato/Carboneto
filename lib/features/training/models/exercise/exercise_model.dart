import 'package:carboneto/features/training/models/creator/creator_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ExerciseModel {
  String description, title, video, id, thumb, type;
  int repetitions, duration, peopleCount; 
  String authorId;
  List<dynamic>? categories;
  CreatorModel creator;

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
      id: '09575e95-c', // data['Id'] as String? ?? snapshot.id,
      authorId: data['AuthorID'] as String? ?? '',
      categories: data['Categories'] as List<dynamic>? ?? [],
      thumb: data['Thumbnail'] as String? ?? '',
      creator: CreatorModel.fromMap(Map<String, dynamic>.from(data['Creator'])),
      type: data['Type'] as String? ?? '',
      peopleCount: (data['PeopleCount'] as int?) ?? 1, 
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
    };
  }

  static ExerciseModel empty() => ExerciseModel(
    description: '', title: '', repetitions: 0, video: '', id: '',
    duration: 0, authorId: '', categories: [], thumb: '',
    creator: CreatorModel.empty(), type: '', peopleCount: 1,
  );
}