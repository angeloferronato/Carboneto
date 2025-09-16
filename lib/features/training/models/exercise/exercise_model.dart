class ExerciseModel {
  String description, title, video;
  int repetitions;

  ExerciseModel({required this.description, required this.title, required this.repetitions, required this.video});

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      description: json['Description'], 
      title: json['Title'], 
      repetitions: json['Repetitions'], 
      video: json['Video']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Description': description,
      'Title': title,
      'Repetitions': repetitions,
      'Video': video
    };
  }

}