import 'package:carboneto/common/widgets/user/user_picture.dart';
import 'package:carboneto/features/training/models/creator/creator_model.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ResultCreatorInfo extends StatelessWidget {
  const ResultCreatorInfo(
      {super.key, required this.creator, this.showUserPicture = false, this.userPictureSize = 23, this.textSize = 10, this.justProfileInfo = false});

  final double userPictureSize, textSize;
  final bool showUserPicture, justProfileInfo;
  final CreatorModel creator;

  @override
  Widget build(BuildContext context) {
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        showUserPicture ?
          Row(
            children: [
              UserPicture(
                userPicture: creator.profilePicture,
                size: userPictureSize,
              ),
              SizedBox(width: 6,)
            ],
          )
          : SizedBox(),
        Text(
          creator.name,
          style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w300),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(width: 3),
        creator.isVerified
            ? const Icon(
                Iconsax.verify5,
                color: CbColors.primary,
                size: 10,
              )
            : justProfileInfo ? SizedBox() : Text(
                '•',
                style: TextStyle(fontSize: textSize),
              )
      ],
    );
  }
}
