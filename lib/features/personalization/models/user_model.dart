import 'package:carboneto/utils/formatters/formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String name;
  String profilePicture;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    required this.profilePicture,
  });

  static List<String> nameParts(fullName) => fullName.split(" ");

  // Static function to create an empty user model.
  static UserModel empty() => UserModel(
      id: "",
      username: "",
      email: "",
      profilePicture: "",
      name: "",
  );

  // Convert model to JSON structure for storing data in Firebase.
  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'Username': username,
      'Email': email,
      'ProfilePicture': profilePicture,
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
    );
  }
}