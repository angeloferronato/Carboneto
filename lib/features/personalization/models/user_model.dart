import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String name;
  final String profilePicture;
  final String description;
  final String position;
  final String countryCode;
  final bool isVerified;
  final List<dynamic>? userTrainings;
  final String? birthDate;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    required this.profilePicture,
    required this.description,
    required this.position,
    required this.countryCode,
    required this.isVerified,
    required this.userTrainings, 
    required this.birthDate,
  });

  static List<String> nameParts(fullName) => fullName.split(" ");

  static String generateUsername(fullName) {
    List<String> nameParts = fullName.split(" ");
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : "";

    String camelCaseUsername = "$firstName$lastName";
    String usernameWithPrefix = "cb_$camelCaseUsername";
    return usernameWithPrefix;
  }

  // Static function to create an empty user model.
  static UserModel empty() => UserModel(
    id: "",
    username: "",
    email: "",
    profilePicture: "",
    name: "",
    description: "",
    position: "",
    countryCode: "",
    isVerified: false, 
    userTrainings: [], 
    birthDate: '',
  );

  // Convert model to JSON structure for storing data in Firebase.
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'Username': username,
      'Email': email,
      'ProfilePicture': profilePicture,
      'Description': description,
      'Position': position,
      'CountryCode': countryCode,
      'IsVerified': isVerified,
      'UserTrainings': userTrainings,
      'BirthDate': birthDate,
    };
  }

  // Factory method to create a UserModel from a Firebase document snapshot.
  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      username: data['Username'] ?? "",
      email: data['Email'] ?? "",
      profilePicture: data['ProfilePicture'] ?? "",
      name: data['Name'] ?? "",
      description: data['Description'] ?? '',
      position: data['Position'] ?? '',
      countryCode: data['CountryCode'] ?? '',
      isVerified: data['IsVerified'] ?? '', 
      userTrainings: data['UserTrainings'] ?? [], 
      birthDate: data['BirthDate'] ?? '',
    );
  }
}
