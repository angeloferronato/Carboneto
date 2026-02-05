import 'package:cloud_firestore/cloud_firestore.dart';

class UserSearchModel {
  String id, username, usernameLower, name, nameLower, profilePicture;
  DateTime? createdAt;

  UserSearchModel({
    required this.id,
    required this.username,
    required this.usernameLower,
    required this.name,
    required this.nameLower,
    required this.profilePicture,
    this.createdAt,
  }); 

  static UserSearchModel empty() => UserSearchModel(
    id: '',
    username: '', 
    usernameLower: '', 
    name: '', 
    nameLower: '',
    profilePicture: '', 
    createdAt: DateTime.now(), 
  );

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Username': username,
      'NameLower': nameLower,
      'ProfilePicture': profilePicture,
      'UsernameLower': usernameLower,
      'CreatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory UserSearchModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
    final data = document.data()!;
    return UserSearchModel(
      id: document.id, 
      username: data['Username'] ?? '', 
      nameLower: data['NameLower'] ?? '',
      usernameLower: data['UsernameLower'] ?? '',
      name: data['Name'] ?? '', 
      profilePicture: data['ProfilePicture'] ?? '', 
      createdAt: (data['CreatedAt'] as Timestamp?)?.toDate(),
    );
  }
}