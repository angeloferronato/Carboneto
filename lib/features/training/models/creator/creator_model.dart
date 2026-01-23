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