enum TextSizes { small, medium, large }

enum DifficultyLevels { rookie, allstar, pro, elite }

// enum CbDataSourceType { asset, network, file, contentUri}

enum FollowMode { followers, following }

enum UploadImageFormat { banner, square, normal }

enum NotificationType { followRequest, followAccepted, followNotice, likeTraining }

enum TrainingVisibility {public,followers,private}

enum ChartMetric {
  acerto,
  duracao,
  frequencia;

  bool get isBar => this == ChartMetric.frequencia;
}
