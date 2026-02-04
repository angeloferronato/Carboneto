import 'package:carboneto/common/widgets/user/user_picture.dart';
import 'package:carboneto/features/training/models/creator/creator_model.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ResultCreatorInfo extends StatelessWidget {
  const ResultCreatorInfo(
      {super.key, required this.creator, this.showUserPicture = false, this.userPictureSize = 23, this.textSize = 10});

  final double userPictureSize, textSize;
  final bool showUserPicture;
  final CreatorModel creator;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // mainAxisSize: MainAxisSize.min,
      children: [
        showUserPicture ?
          UserPicture(
            userPicture: creator.profilePicture,
            size: userPictureSize,
          )
          : SizedBox(),
        const SizedBox(width: 6),
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
            : Text(
                '•',
                style: TextStyle(fontSize: textSize),
              )
      ],
    );
  }
}
