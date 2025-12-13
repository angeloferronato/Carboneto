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
        level = 'allstar';
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


  factory TrainingModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
  
    return TrainingModel(
      id: document.id,
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
    );
  }



  factory TrainingModel.fromJson(Map<String, dynamic> json) {
    return TrainingModel(
      id: json['Id'], 
      duration: json['Duration'],
      authorId: json['AuthorID'] ?? '', 
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
      'AuthorID': authorId,
      'Categories': categories,
      'Description': description,
      'Exercises': exercises.map((single) => single.id).toList(),
      'Level': parseLevelToString(level),
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