import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/personalization/controllers/remove_follower_controller/remove_follower_controller.dart';
import 'package:carboneto/features/personalization/controllers/user_controller/user_controller.dart';
import 'package:carboneto/features/personalization/models/user_search_model.dart';
import 'package:carboneto/features/personalization/screens/profile/profile.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_btn.dart';
import 'package:carboneto/features/settings/controllers/follow_controller.dart';
import 'package:carboneto/home_menu.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserSearchTile extends StatelessWidget {
  UserSearchTile({
    super.key,
    required this.user, 
    this.isUserFollow = false,
  });

  final UserSearchModel user;
  final bool isUserFollow;
  final currentUser = UserController.instance.user.value;
  @override
  Widget build(BuildContext context) {
    final isDarkMode = CbHelperFunctions.isDarkMode(context);
    final FollowController followController = Get.put(FollowController(currentUserId: currentUser.id, targetUserId: user.id), tag: '${currentUser.id}${user.id}');
    final RemoveFollowerController removeFollowerController = Get.put(RemoveFollowerController(userId: currentUser.id), tag: currentUser.id);
    return InkWell(
      onTap: currentUser.id == user.id 
        ? () {
          Get.offAll(HomeMenu());
          final homeMenuController = Get.put(HomeMenuController());
          homeMenuController.selectedIndex.value = 4; 
        }
        : () => Get.to(ProfileScreen(userId: user.id,)),
      child: Container(    
        padding: const EdgeInsets.symmetric(horizontal: CbSizes.defaultSpace, vertical: CbSizes.sm + CbSizes.xs),
        child: Row(
          children: [
            Flexible(
              child: Row(
                children: [
                  CbRoundedImage(
                    imageUrl: user.profilePicture.isEmpty ? CbImages.userDefault : user.profilePicture,
                    width: 50,
                    height: 50,
                    borderRadius: 50,
                    isNetworkImage: user.profilePicture.isNotEmpty,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: CbSizes.md,),
                
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          user.username,
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 15),
                        ),
                        const SizedBox(height: CbSizes.xs / 2,),
                        Text(
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          user.name,
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 13, color: CbColors.darkGrey, fontWeight: FontWeight.w600)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      
            Align(
              alignment: AlignmentGeometry.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(left: CbSizes.sm),
                child: user.id == currentUser.id ? SizedBox() : Obx(
                    () => removeFollowerController.isLoading.value || followController.isLoading.value 
                    ? HighlightBtn(
                      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                      textValue: '',
                      icon: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 4.0,
                          color: CbColors.primary,
                        )
                      ),
                      onPressedEdit: () {}
                    )
                    : followController.isFollowing.value
                      ? HighlightBtn(
                        textValue: 'Seguindo',  
                        onPressedEdit: () => followController.stopFollowingUser(),
                      ) : followController.followRequestId.value.isNotEmpty 
                        ? HighlightBtn(
                          textValue: 'Pedido enviado', 
                          onPressedEdit: () => followController.cancelFollowRequest()
                        )
                        : ElevatedButton(
                          onPressed: () => user.isPrivate
                            ? followController.sendFollowRequest()
                            : followController.startFollowingUser(),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ), 
                          child: Text(
                            'Seguir', 
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: CbColors.white,
                              fontSize: CbSizes.md,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                  ),
              ),
            ),
            if (isUserFollow) IconButton(
              onPressed: () => removeFollowerController.showConfirmDeleteFollowerMessage(user), 
              icon: Icon(Icons.clear_rounded, color: isDarkMode ? CbColors.grey : CbColors.darkerGrey)
            )
          ],
        ),
      ),
    );
  }
}