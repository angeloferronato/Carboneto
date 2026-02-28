import 'package:carboneto/common/widgets/user/user_picture.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/screens/profile/profile.dart';
import 'package:carboneto/features/training/models/creator/creator_model.dart';
import 'package:carboneto/home_menu.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ResultCreatorInfo extends StatelessWidget {
  const ResultCreatorInfo(
      {super.key,
      required this.creator,
      required this.creatorId,
      this.showUserPicture = false,
      this.userPictureSize = 23,
      this.textSize = 10,
      this.justProfileInfo = false});

  final double userPictureSize, textSize;
  final bool showUserPicture, justProfileInfo;
  final CreatorModel creator;
  final String creatorId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: UserController.instance.user.value.id == creatorId
            ? () {
                Get.offAll(HomeMenu());
                final homeMenuController = Get.put(HomeMenuController());
                homeMenuController.selectedIndex.value = 4;
              }
            : () => Get.to(ProfileScreen(
                  userId: creatorId,
                )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            showUserPicture
                ? Row(
                    children: [
                      UserPicture(
                        userPicture: creator.profilePicture,
                        size: userPictureSize,
                      ),
                      SizedBox(
                        width: 6,
                      )
                    ],
                  )
                : SizedBox(),
            Text(
              creator.name,
              style: TextStyle(fontSize: textSize, fontWeight: FontWeight.w300),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(width: textSize > 10 ? 5 : 3),
            creator.isVerified
                ? Icon(
                    Iconsax.verify5,
                    color: CbColors.primary,
                    size: textSize,
                  )
                : justProfileInfo
                    ? SizedBox()
                    : Text(
                        '•',
                        style: TextStyle(fontSize: textSize),
                      )
          ],
        ));
  }
}
