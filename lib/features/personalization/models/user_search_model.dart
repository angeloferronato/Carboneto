import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSearchModel {
  final String id;
  final String? countryCode;
  final int followersCount;
  final String username;
  final String profilePicture;
  final String name;
  final bool isVerified;
  final bool isPrivate;

  /// Resolved locally after fetching the current user's following list.
  bool isFollowing;

  UserSearchModel({
    required this.id,
    this.countryCode,
    required this.followersCount,
    required this.username,
    required this.profilePicture,
    required this.name,
    required this.isPrivate,
    this.isVerified = false,
    this.isFollowing = false,
  });

  factory UserSearchModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserSearchModel(
      id: document.id,
      username: data['Username'] ?? '',
      followersCount: data['FollowersCount'] ?? 0,
      name: data['Name'] ?? '',
      profilePicture: data['ProfilePicture'] ?? '',
      isPrivate: data['IsPrivate'] ?? false,
      isVerified: data['IsVerified'] ?? false,
    );
  }

  factory UserSearchModel.fromMeili(Map<String, dynamic> hit) {
    return UserSearchModel(
      id: (hit['id'] ?? hit['objectID'] ?? '').toString(),
      countryCode: hit['countrycode'] as String?,
      followersCount: (hit['followerscount'] as num?)?.toInt() ?? 0,
      username: (hit['username'] as String?) ?? '',
      profilePicture:
          (hit['profilepicture'] as String?) ?? CbImages.userDefault,
      name: (hit['name'] as String?) ?? '',
      isPrivate: (hit['isprivate'] as bool?) ?? false,
      isVerified: (hit['isverified'] as bool?) ?? false,
    );
  }

  UserSearchModel copyWith({bool? isFollowing}) {
    return UserSearchModel(
      id: id,
      countryCode: countryCode,
      followersCount: followersCount,
      username: username,
      profilePicture: profilePicture,
      name: name,
      isPrivate: isPrivate,
      isVerified: isVerified,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}
