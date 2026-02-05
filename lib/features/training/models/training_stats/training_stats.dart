class TrainingStats {
  final int completes;
  final int likes;
  final int saves;
  final int starts;
  final int views;

  TrainingStats({
    this.completes = 0,
    this.likes = 0,
    this.saves = 0,
    this.starts = 0,
    this.views = 0,
    
  });
  

  // Create from JSON/Firebase
  factory TrainingStats.fromJson(Map<String, dynamic> json) {
    return TrainingStats(
      completes: json['completes'] ?? 0,
      likes: json['likes'] ?? 0,
      saves: json['saves'] ?? 0,
      starts: json['starts'] ?? 0,
      views: json['views'] ?? 0,
    );
  }

  // Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'completes': completes,
      'likes': likes,
      'saves': saves,
      'starts': starts,
      'views': views,
    };
  }

  // Create empty stats
  static TrainingStats empty() => TrainingStats();

  // Copy with method for updates
  TrainingStats copyWith({
    int? completes,
    int? likes,
    int? saves,
    int? starts,
    int? views,
  }) {
    return TrainingStats(
      completes: completes ?? this.completes,
      likes: likes ?? this.likes,
      saves: saves ?? this.saves,
      starts: starts ?? this.starts,
      views: views ?? this.views,
    );
  }
}