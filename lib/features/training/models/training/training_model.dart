import 'package:carboneto/features/personalization/models/user_model.dart';
import 'package:carboneto/features/training/models/exercise/exercise_model.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TrainingModel {
  final String authorId;
  final List<String> categories;
  final String description;
  final int? duration;
  List<ExerciseModel> exercises;
  final String id;
  final DifficultyLevels level;
  final String? textLevel;
  final int people;
  final String thumbnail;
  final String title;
  UserModel? user;

  TrainingModel({
    required this.authorId, required this.categories, required this.description, this.duration,
    required this.exercises, required this.id, required this.level, required this.people, required this.thumbnail, required this.title,
    this.user, this.textLevel
  });

  factory TrainingModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    final DifficultyLevels level;
    switch (data['Level'].toString().toLowerCase()) {
      case 'allstar' || 'all-star':
        level = DifficultyLevels.allstar;
      case 'pro':
        level = DifficultyLevels.pro;
      case 'elite':
        level = DifficultyLevels.elite;
      default:
        level = DifficultyLevels.rookie;
    }

    return TrainingModel(
      id: document.id,
      duration: data['Duration'] ?? 0,
      authorId: data['AuthorID'] ?? '',
      categories: List<String>.from(data['Categories'] ?? []),
      description: data['Description'] ?? '',
      exercises: [],
      level: level,
      people: data['People'] ?? 0,
      thumbnail: data['Thumbnail'] ?? '',
      title: data['Title'] ?? '',
      textLevel: data['Level'].toString().capitalize,
    );
  }



  factory TrainingModel.fromJson(Map<String, dynamic> json) {
    return TrainingModel(
      id: json['Id'], 
      duration: json['Duration'],
      authorId: json['AuthorId'] ?? '', 
      categories: json["Categories"], 
      description: json["Description"], 
      exercises: json["Exercises"],
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
      'Exercises': exercises,
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
    level: DifficultyLevels.rookie, 
    people: 0, 
    thumbnail: '', 
    title: ''
  );
}