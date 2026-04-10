import 'package:carboneto/common/widgets/buttons/cb_primary_btn.dart';
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
import 'package:iconsax/iconsax.dart';

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

    final String controllerTag = '${currentUser.id}${user.id}';

    final FollowController followController = Get.put(
        FollowController(currentUserId: currentUser.id, targetUserId: user.id),
        tag: controllerTag);

    final RemoveFollowerController removeFollowerController = Get.put(
        RemoveFollowerController(userId: currentUser.id),
        tag: currentUser.id);

    return InkWell(
      onTap: currentUser.id == user.id
          ? () {
              Get.offAll(() => const HomeMenu());
              final homeMenuController = Get.put(HomeMenuController());
              homeMenuController.selectedIndex.value = 4;
            }
          : () => Get.to(() => ProfileScreen(userId: user.id)),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: CbSizes.defaultSpace,
            vertical: CbSizes.sm + CbSizes.xs),
        child: Row(
          children: [
            // User Info Section
            Flexible(
              child: Row(
                children: [
                  CbRoundedImage(
                    imageUrl: user.profilePicture.isEmpty
                        ? CbImages.userDefault
                        : user.profilePicture,
                    width: 50,
                    height: 50,
                    borderRadius: 50,
                    isNetworkImage: user.profilePicture.isNotEmpty,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: CbSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                user.username,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(fontSize: 15),
                              ),
                            ),
                            if (user.isVerified)
                              const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Icon(Iconsax.verify5,
                                    color: CbColors.primary, size: 12),
                              ),
                          ],
                        ),
                        const SizedBox(height: CbSizes.xs / 2),
                        Text(
                          user.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  fontSize: 13,
                                  color: CbColors.darkGrey,
                                  fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Action Button Section
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(left: CbSizes.sm),
                child: user.id == currentUser.id
                    ? const SizedBox()
                    : Obx(() {
                        if (followController.isLoading.value ||
                            removeFollowerController.isLoading.value) {
                          return HighlightBtn(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 48, vertical: 12),
                            textValue: '',
                            icon: const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: CbColors.primary)),
                            onPressedEdit: () {},
                          );
                        }

                        if (followController.isFollowing.value) {
                          return HighlightBtn(
                            textValue: 'Seguindo',
                            onPressedEdit: () =>
                                followController.stopFollowingUser(),
                          );
                        }

                        if (followController.followRequestId.value.isNotEmpty) {
                          return HighlightBtn(
                            textValue: 'Pedido enviado',
                            onPressedEdit: () =>
                                followController.cancelFollowRequest(),
                          );
                        }

                        return CbPrimaryBtn(
                          label: 'Seguir',
                          paddingV: 0,
                          paddingH: 15,
                          onPressed: () => user.isPrivate
                              ? followController.sendFollowRequest()
                              : followController.startFollowingUser(),
                        );
                      }),
              ),
            ),

            if (isUserFollow)
              IconButton(
                  onPressed: () => removeFollowerController
                      .showConfirmDeleteFollowerMessage(user),
                  icon: Icon(Icons.clear_rounded,
                      color: isDarkMode ? CbColors.grey : CbColors.darkerGrey))
          ],
        ),
      ),
    );
  }
}
