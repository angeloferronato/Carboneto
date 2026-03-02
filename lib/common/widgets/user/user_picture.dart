import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';

class UserPicture extends StatelessWidget {
  const UserPicture({super.key, required this.userPicture, this.size = 13});

  final String userPicture;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CbRoundedImage(
      imageUrl: userPicture.isNotEmpty ? userPicture : CbImages.userDefault,
      borderRadius: size,
      width: size,
      height: size,
      fit: BoxFit.cover,
      isNetworkImage: userPicture.isNotEmpty,
    );
  }
}
