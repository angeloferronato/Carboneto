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
    final dynamic rawName = map['Name'] ?? map['name'];
    final dynamic rawProfilePicture =
        map['ProfilePicture'] ?? map['profilePicture'] ?? map['profilepicture'];
    final dynamic rawIsVerified = map['IsVerified'] ?? map['isVerified'] ?? map['isverified'];

    return CreatorModel(
      name: rawName?.toString() ?? '',
      profilePicture: rawProfilePicture?.toString() ?? '',
      isVerified: rawIsVerified is bool
          ? rawIsVerified
          : rawIsVerified?.toString().toLowerCase() == 'true',
    );
  }
  factory CreatorModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawName = json['Name'] ?? json['name'];
    final dynamic rawProfilePicture =
        json['ProfilePicture'] ?? json['profilePicture'] ?? json['profilepicture'];
    final dynamic rawIsVerified =
        json['IsVerified'] ?? json['isVerified'] ?? json['isverified'];

    return CreatorModel(
      name: rawName?.toString() ?? '',
      profilePicture: rawProfilePicture?.toString() ?? '',
      isVerified: rawIsVerified is bool
          ? rawIsVerified
          : rawIsVerified?.toString().toLowerCase() == 'true',
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
