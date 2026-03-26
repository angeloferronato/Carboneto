import 'package:carboneto/features/personalization/controllers/follow_search_controller/follow_search_controller.dart';
import 'package:carboneto/features/personalization/controllers/profile_base_controller.dart/profile_base_controller.dart';
import 'package:carboneto/features/personalization/screens/profile/edit_profile/edit_profile.dart';
import 'package:carboneto/features/personalization/screens/profile/search_user_profile/search_user_profile.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/banner_picture.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/followers_and_following.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/followers_and_following_shimmer.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/highlight_btn.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/profile_info.dart';
import 'package:carboneto/features/personalization/screens/profile/widgets/toggle_follow_button.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.userId,
    required this.isDarkMode,
  });

  final String userId;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileBaseController>(tag: userId);

    return Column(
      children: [
        BannerWithPicture(userId: userId),
        const SizedBox(height: 60),
        ProfileInfo(userId: userId),
        const SizedBox(height: 5),
        Obx(
          () => controller.profileLoading
              ? CbShimmerEffects(width: 200, height: 30)
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: CbSizes.defaultSpace),
                  child: Text(
                    controller.user.value.name,
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CbSizes.defaultSpace * 2.5),
          child: Obx(
            () => !controller.profileLoading
                ? Text(
                    controller.user.value.description,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w300),
                    textAlign: TextAlign.center,
                  )
                : Column(
                    children: [
                      CbShimmerEffects(width: 120, height: 10),
                      const SizedBox(height: 5),
                      CbShimmerEffects(width: 100, height: 10),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 20),
        Obx(
          () => controller.profileLoading
              ? FollowersAndFollowingShimmer()
              : FollowersAndFollowing(
                  followersOnTap: () => Get.to(
                    SearchUserProfile(userId: userId),
                    binding: BindingsBuilder(() {
                      Get.put(
                        FollowSearchController(
                            initialFollowMode: FollowMode.followers,
                            userId: userId),
                        tag: userId,
                      );
                    }),
                  ),
                  followingOnTap: () => Get.to(
                    SearchUserProfile(userId: userId),
                    binding: BindingsBuilder(() {
                      Get.put(
                        FollowSearchController(
                            initialFollowMode: FollowMode.following,
                            userId: userId),
                        tag: userId,
                      );
                    }),
                  ),
                  followers: controller.followersId.length,
                  following: controller.followingId.length,
                  position: controller.user.value.position,
                ),
        ),
        SizedBox(height: CbSizes.xl),
        Obx(
          () => controller.profileLoading
              ? CbShimmerEffects(width: 150, height: 40, radius: 100)
              : controller.isAuthUser
                  ? HighlightBtn(
                      textValue: 'Editar Perfil',
                      labelColor: isDarkMode ? CbColors.white : CbColors.dark,
                      onPressedEdit: () => Get.to(() => EditProfileScreen()),
                    )
                  : ToggleFollowButton(
                      currentUserId:
                          controller.userController.user.value.id,
                      targetUserId: userId,
                      profileUser: controller.user.value,
                    ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}