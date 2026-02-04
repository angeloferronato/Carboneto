class CreatorModel {
  final String name;
  final String profilePicture;
  final bool isVerified;

  CreatorModel({
    required this.name,
    required this.profilePicture,
    required this.isVerified,
  });

  factory CreatorModel.fromMap(Map<String, dynamic> map) {
    return CreatorModel(
      name: map['Name'] ?? '',
      profilePicture: map['ProfilePicture'],
      isVerified: map['IsVerified'] ?? false,
    );
  }
  factory CreatorModel.fromJson(Map<String, dynamic> json) {
    return CreatorModel(
      name: json['Name'] ?? '',
      profilePicture: json['ProfilePicture'] ?? '',
      isVerified: json['IsVerified'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'ProfilePicture': profilePicture,
      'IsVerified': isVerified,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'ProfilePicture': profilePicture,
      'IsVerified': isVerified,
    };
  }

  factory CreatorModel.empty() {
    return CreatorModel(
      name: '',
      isVerified: false,
      profilePicture: '',
    );
  }
}
