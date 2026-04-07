import 'package:carboneto/common/widgets/images/rounded_image.dart';
import 'package:carboneto/features/personalization/controllers/edit_profile/edit_profile_controller.dart';
import 'package:carboneto/features/personalization/controllers/profile_base_controller.dart/profile_base_controller.dart';
import 'package:carboneto/features/personalization/screens/profile/edit_profile/widgets/confirm_banner_upload_screen.dart';
import 'package:carboneto/features/settings/settings.dart';
import 'package:carboneto/utils/constants/colors.dart';
import 'package:carboneto/utils/constants/enums.dart';
import 'package:carboneto/utils/constants/image_strings.dart';
import 'package:carboneto/utils/constants/sizes.dart';
import 'package:carboneto/utils/helpers/helper_functions.dart';
import 'package:carboneto/utils/loading_effects/shimmer_effects.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class BannerWithPicture extends StatelessWidget {
  const BannerWithPicture({
    super.key,
    required this.userId,
  });
  final String userId;

  @override
  Widget build(BuildContext context) {
    final EditProfileController editProfileController =
        Get.put(EditProfileController());
    final isDarkMode = CbHelperFunctions.isDarkMode(context);

    if (!Get.isRegistered<ProfileBaseController>(tag: userId)) {
      return const SizedBox.shrink();
    }
    final profileBaseController = Get.find<ProfileBaseController>(tag: userId);
    final screenWidth = MediaQuery.of(context).size.width;
    final bannerHeight = screenWidth * 0.6;
    final avatarRadius = screenWidth * 0.21;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.transparent],
                stops: isDarkMode ? [0.1, 0.9] : [0.1, 1.0],
              ).createShader(rect);
            },
            blendMode: BlendMode.dstIn,
            child: Obx(
              () => CbRoundedImage(
                imageUrl: !(profileBaseController.profileLoading) &&
                        profileBaseController.user.value.banner.isNotEmpty
                    ? profileBaseController.user.value.banner
                    : CbImages.bannerDefault,
                isNetworkImage:
                    profileBaseController.user.value.banner.isNotEmpty &&
                        !(profileBaseController.profileLoading),
                width: double.infinity,
                height: bannerHeight,
                fit: BoxFit.cover,
              ),
            )),
        Positioned(
          bottom: -avatarRadius / 2,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CbColors.primary,
            ),
            child: Obx(
              () => !profileBaseController.profileLoading
                  ? (profileBaseController.user.value.profilePicture != ''
                      ? CbRoundedImage(
                          imageUrl:
                              profileBaseController.user.value.profilePicture,
                          isNetworkImage: true,
                          borderRadius: avatarRadius,
                          width: 180,
                          height: 180,
                          fit: BoxFit.cover,
                        )
                      : CbRoundedImage(
                          imageUrl: CbImages.userDefault,
                          borderRadius: avatarRadius,
                          width: 180,
                        ))
                  : CbShimmerEffects(
                      width: 180,
                      height: 180,
                      radius: avatarRadius,
                    ),
            ),
          ),
        ),
        Obx(
          () => profileBaseController.isAuthUser
              ? Positioned(
                  top: 40,
                  right: 16,
                  child: IconButton(
                    icon: Icon(CupertinoIcons.settings,
                        color: Colors.white, size: screenWidth * 0.07),
                    onPressed: () => Get.to(SettingsScreen()),
                  ),
                )
              : SizedBox(),
        ),
        Obx(
          () => profileBaseController.isAuthUser
              ? Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: Icon(Icons.camera_alt_rounded,
                        color: Colors.white, size: screenWidth * 0.06),
                    onPressed: () => editProfileController.sendToConfirmScreen(
                        ConfirmBannerUploadScreen(), UploadImageFormat.banner),
                  ),
                )
              : Positioned(
                  top: 40,
                  left: CbSizes.sm,
                  child: IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Iconsax.arrow_left,
                        color: CbColors.white,
                      )),
                ),
        ),
      ],
    );
  }
}
