import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrainingModel {
  final String authorId;
  final List<String> categories;
  final String description;
  final int? duration;
  final List<ExerciseModel> exercises;
  final String id;
  final String level;
  final int people;
  final String thumbnail;
  final String title;

  TrainingModel({
    required this.authorId, required this.categories, required this.description, this.duration,
    required this.exercises, required this.id, required this.level, required this.people, required this.thumbnail, required this.title,
  });

  factory TrainingModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return TrainingModel(
      id: document.id, 
      duration: data['Duration'],
      authorId: data['AuthorId'] ?? '', 
      categories: data["Categories"], 
      description: data["Description"], 
      exercises: data["Exercises"].map((json) => ExerciseModel.fromJson(json)).toList(),
      level: data["Level"], 
      people: data['People'], 
      thumbnail: data['Thumbnail'], 
      title: data['Title'],
    );
  }

  factory TrainingModel.fromJson(Map<String, dynamic> json) {
    return TrainingModel(
      id: json['Id'], 
      duration: json['Duration'],
      authorId: json['AuthorId'] ?? '', 
      categories: json["Categories"], 
      description: json["Description"], 
      exercises: json["Exercises"].map((map) => ExerciseModel.fromJson(map)).toList(),
      level: json["Level"], 
      people: json['People'], 
      thumbnail: json['Thumbnail'], 
      title: json['Title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Duration': duration,
      'AuthorId': authorId,
      'Categories': categories,
      'Description': description,
      'Exercises': exercises.map((exercise) => exercise.toJson()).toList(),
      'Level': level,
      'People': people,
      'Thumbnail': thumbnail,
      'Title': title,
    };
  }

  static TrainingModel empty() => TrainingModel(
    authorId: '', 
    categories: [], 
    description: '', 
    exercises: [], 
    id: '', 
    level: '', 
    people: 0, 
    thumbnail: '', 
    title: ''
  );
}