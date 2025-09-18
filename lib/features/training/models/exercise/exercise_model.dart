import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseModel {
  String description, title, video, id;
  int repetitions, duration;

  ExerciseModel({required this.description, required this.title, required this.repetitions, required this.video, required this.id, required this.duration});

  factory ExerciseModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return ExerciseModel(
      duration: snapshot['Duration'],
      description: snapshot['Description'], 
      title: snapshot['Title'], 
      repetitions: snapshot['Repetitions'], 
      video: snapshot['Video'],
      id: snapshot['ID']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Description': description,
      'Title': title,
      'Repetitions': repetitions,
      'Video': video,
      'ID': id,
      'Duration' : duration,
    };
  }

 static ExerciseModel empty() => ExerciseModel(
    description: '', 
    title: '', 
    repetitions: 0, 
    video: '', 
    id: '', 
    duration: 0
  );

}